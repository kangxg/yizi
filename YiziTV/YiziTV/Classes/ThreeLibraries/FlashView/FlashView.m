

#import "FlashView.h"


typedef enum : NSUInteger {
    RESOURCE,
    DOCUMENT,
    NONE,
} FileType;


typedef enum : NSUInteger {
    JSON,
    BIN,
    NOTYPE,
} FileDataType;

typedef struct FlashColor{
    float r;
    float g;
    float b;
    float a;
} FlashColor;


static FlashColor FlashColorMake(float r, float g, float b, float a){
    FlashColor c;
    c.r = r;
    c.g = g;
    c.b = b;
    c.a = a;
    return c;
}


#define READ_DATA(type) \
type ret; \
int size = sizeof(ret); \
[mData getBytes:&ret range:NSMakeRange(mIndex, size)]; \
mIndex += size; \
return ret;


@interface FlashDataReader : NSObject

- (instancetype)initWithNSData:(NSData *)data;

-(BOOL) readBool;

-(uint16_t) readUShort;

-(Float32) readFloat;

-(uint8_t) readUChar;

-(NSString *) readNSString;

@end

@implementation FlashDataReader{
   
    int mIndex;
   
    NSData *mData;
}

- (instancetype)initWithNSData:(NSData *)data{
    if (self = [super init]) {
        mData = data;
        mIndex = 0;
    }
    return self;
}

-(BOOL) readBool{
    READ_DATA(BOOL);
}

-(uint8_t) readUChar{
    READ_DATA(uint8_t);
}

-(uint16_t) readUShort{
    READ_DATA(uint16_t);
}

-(Float32) readFloat{
    READ_DATA(Float32);
}


-(NSString *)readNSString{
    uint16_t nameLen = [self readUShort];
    NSData * data = [mData subdataWithRange:NSMakeRange(mIndex, nameLen)];
    mIndex += nameLen;
    return [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
}

@end

@implementation FlashView{
    
    NSString *mFlashName;
    
    NSString *mFlashAnimDir;
    NSFileManager *mFileManager;
    NSBundle *mMainBundle;
    NSString *mWritablePath;
    
    
    FileType mFileType;
    
    FileDataType mFileDataType;
    
    NSDictionary *mJson;
    
    NSData *mData;
    
    
    NSInteger mFrameRate;
    
    
    NSMutableDictionary *mParsedData;
    
    
    NSMutableDictionary *mImages;
    
    
    NSTimer *mTimer;
    
    float mOneFrameTime;
    
    double mStartTime;
    
    double mLastUpdateTime;
    
    NSInteger mCurrFrameIndex;
    
    
    NSInteger mLastFrameIndex;
    
    
    NSInteger mFromIndex;
    NSInteger mToIndex;
    
    
    NSString *mRunningAnimName;
    
    BOOL isStarted;
    
    BOOL isPause;
    
    
    NSUInteger mSetLoopTimes;
    
    NSUInteger mLoopTimes;
    
    
    NSInteger mParseLastIndex;
    BOOL mParseLastIsTween;
    NSDictionary *mParseLastFrame;
    NSInteger mParseFrameMaxIndex;
    
    
    CGSize mDesignResolution;
    
    CGPoint mDesignResolutionScale;
   
    ScaleMode mScaleMode;
    
    
    NSInteger mStopAtFrameIndex;
    NSString *mStopAtAnimName;
}


-(instancetype) initWithFlashName:(NSString *)flashName{
    return [self initWithFlashName:flashName andAnimDir:FLASH_VIEW_DEFAULT_DIR_NAME];
}

-(instancetype) initWithFlashName:(NSString *)flashName andAnimDir:(NSString *)animDir{
    if (self = [super init]) {
        mFlashName = flashName;
        mFlashAnimDir = animDir;
        if (![self innerInit]) {
            return nil;
        }
    }
    return self;
}

-(void) initDesignResolutionScale{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    
    switch (mScaleMode) {
        case ScaleModeWidthFit:
            mDesignResolutionScale = CGPointMake(mDesignResolution.width / screenBound.size.width, mDesignResolution.width / screenBound.size.width);
            break;
        case ScaleModeHeightFit:
            mDesignResolutionScale = CGPointMake(mDesignResolution.height / screenBound.size.height, mDesignResolution.height / screenBound.size.height);
            break;
        case ScaleModeRespective:
            mDesignResolutionScale = CGPointMake(mDesignResolution.width / screenBound.size.width, mDesignResolution.height / screenBound.size.height);
            break;
        default:
            mDesignResolutionScale = CGPointMake(1, 1);
            break;
    }
}

+(BOOL) isAnimExist:(NSString *)flashName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *writablePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString * filePath = [mainBundle pathForResource:[NSString stringWithFormat:@"%@.flajson", flashName] ofType:nil];
    if (!filePath) {
        filePath = [mainBundle pathForResource:[NSString stringWithFormat:@"%@.flabin", flashName] ofType:nil];
        if (!filePath) {
            filePath = [NSString stringWithFormat:@"%@/%@/%@.flajson", writablePath, FLASH_VIEW_DEFAULT_DIR_NAME, flashName];
            if ([fileManager fileExistsAtPath:filePath]) {
                return YES;
            }else{
                filePath = [NSString stringWithFormat:@"%@/%@/%@.flabin", writablePath, FLASH_VIEW_DEFAULT_DIR_NAME, flashName];
                if ([fileManager fileExistsAtPath:filePath]) {
                    return YES;
                }
            }
        }else{
            return YES;
        }
    }else{
        return YES;
    }
    return NO;
}


-(BOOL) innerInit{
    mFileManager = [NSFileManager defaultManager];
    mMainBundle = [NSBundle mainBundle];
    mWritablePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    mFileType = NONE;
    mSetLoopTimes = 1;
    mLoopTimes = 0;
    
    mParseLastIndex = -1;
    mParseLastIsTween = NO;
    mParseLastFrame = nil;
    mParseFrameMaxIndex = 0;
    
    mStopAtFrameIndex = 0;
    mStopAtAnimName = nil;
    
    mLastUpdateTime = -1;
    
    self.isInitOk = NO;
    
   
    NSString * filePath = [mMainBundle pathForResource:[NSString stringWithFormat:@"%@.flajson", mFlashName] ofType:nil];
    if (!filePath) {
        filePath = [mMainBundle pathForResource:[NSString stringWithFormat:@"%@.flabin", mFlashName] ofType:nil];
        if (!filePath) {
            filePath = [NSString stringWithFormat:@"%@/%@/%@.flajson", mWritablePath, mFlashAnimDir, mFlashName];
            if ([mFileManager fileExistsAtPath:filePath]) {
                mFileType = DOCUMENT;
                mFileDataType = JSON;
            }else{
                filePath = [NSString stringWithFormat:@"%@/%@/%@.flabin", mWritablePath, mFlashAnimDir, mFlashName];
                if ([mFileManager fileExistsAtPath:filePath]) {
                    mFileType = DOCUMENT;
                    mFileDataType = BIN;
                }
            }
        }else{
            mFileType = RESOURCE;
            mFileDataType = BIN;
        }
    }else{
        mFileType = RESOURCE;
        mFileDataType = JSON;
    }
    
    if (mFileType == NONE) {
        NSLog(@"FlashView init error file %@.flajson/.flabin is not exist", mFlashName);
        return NO;
    }
    
    
    if (mFileDataType == JSON) {
        mJson = [self readJson];
        
        if (!mJson) {
            NSLog(@"FlashView init error file %@.flajson is not json format", mFlashName);
            return NO;
        }
        
        [self parseJson];
    }else{
        mData = [self readData];
        if (!mData) {
            NSLog(@"FlashView init error file %@.flabin is not valid", mFlashName);
            return NO;
        }
        [self parseData];
    }
    
    mOneFrameTime = 1.f/mFrameRate;
    isPause = NO;
    
    
    mDesignResolution = CGSizeMake(kScreenWidth*2, kScreenHeight*2);
    mScaleMode = ScaleModeRespective;
    [self initDesignResolutionScale];
    
   
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    self.frame = CGRectMake(0, 0, screenBound.size.width, screenBound.size.height);
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    
    self.isInitOk = YES;
    
    return YES;
}


-(void) setScaleMode:(ScaleMode)mode andDesignResolution:(CGSize)resolution{
    mDesignResolution = resolution;
    mScaleMode = mode;
    [self initDesignResolutionScale];
}


-(void) setScaleWithX:(CGFloat)x y:(CGFloat) y isDesignResolutionEffect:(BOOL)isDREffect{
    if (isDREffect) {
        mDesignResolutionScale = CGPointMake(mDesignResolutionScale.x / x, mDesignResolutionScale.y / y);
    }else{
        mDesignResolutionScale = CGPointMake(1 / x, 1 / y);
    }
}


-(void) setLoopTimes:(NSInteger) times{
    mSetLoopTimes = times;
}


-(void) replaceImage:(NSString *)texName image:(UIImage *)image{
    [mImages setObject:image forKey:texName];
}

-(NSArray *)animNames{
    return mParsedData.allKeys;
}

-(NSDictionary *)images{
    return mImages;
}


-(void) play:(NSString *)animName loopTimes:(NSUInteger) times{
    [self play:animName loopTimes:times fromIndex:0];
}

-(void)play:(NSString *)animName loopTimes:(NSUInteger)times fromIndex:(NSInteger)from{
    [self play:animName loopTimes:times fromIndex:from toIndex:mParseFrameMaxIndex];
}

-(void)play:(NSString *)animName loopTimes:(NSUInteger)times fromIndex:(NSInteger)from toIndex:(NSInteger)to{
    if (![mParsedData objectForKey:animName]) {
        NSLog(@"error 找不到对应的动画名：%@", animName);
        return;
    }
    [self stop];
    mStartTime = 0;
    mCurrFrameIndex = from;
    [self startTimer];
    mRunningAnimName = animName;
    mSetLoopTimes = times;
    mLoopTimes = 0;
    mFromIndex = from;
    mToIndex = to;
    if (self.delegate) {
        [self.delegate onEvent:FlashViewEventStart data:nil];
    }
    if (self.onEventBlock) {
        [self performSelectorOnMainThread:@selector(onEventOnMainThread:) withObject:@{@"event": @(FlashViewEventStart)} waitUntilDone:NO];
    }
}

-(void) stopAtFrameIndex:(NSInteger) frameIndex animName:(NSString *) animName{
    [self stop];
    mStopAtFrameIndex = frameIndex;
    mStopAtAnimName = animName;
    [self setNeedsDisplay];
}


-(void) startTimer{
    [self stopTimer];
    isStarted = YES;
    if (self.runMode == FlashViewRunModeMainThread) {
        mTimer = [NSTimer scheduledTimerWithTimeInterval:mOneFrameTime target:self selector:@selector(runTask) userInfo:nil repeats:YES];
    }else{
        NSThread *timerThread = [[NSThread alloc] initWithTarget:self selector:@selector(runThread) object:nil];
        [timerThread start];
    }
}

-(void) stopTimer{
    [mTimer invalidate];
    isStarted = NO;
}

-(void) runThread{
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    if (self.updateMode == FlashViewUpdateModeRealtimeTime) {
        mTimer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(runTask) userInfo:nil repeats:YES];
    }else{
        mTimer = [NSTimer scheduledTimerWithTimeInterval:mOneFrameTime target:self selector:@selector(runTask) userInfo:nil repeats:YES];
    }
    [runLoop run];
}

-(NSTimeInterval)currentTime{
    return [[NSDate date]timeIntervalSince1970];
}

-(void) runTask{
    if (self.updateMode == FlashViewUpdateModeRealtimeTime) {
        double currentTime = self.currentTime;
        if (mStartTime <= 0) {
            mStartTime = currentTime;
        }
        if (mLastUpdateTime < 0) {
            mLastUpdateTime = currentTime;
        }else{
            double delayTime = mOneFrameTime - (currentTime - mLastUpdateTime);
            if (delayTime > 0) {
                usleep(delayTime * 1000000);
            }
            mLastUpdateTime = self.currentTime;
        }
    }
    [self update];
}

-(BOOL)reload:(NSString *)flashName andAnimDir:(NSString *)animDir{
    [self cleanData];
    mFlashName = flashName;
    mFlashAnimDir = animDir;
    return [self innerInit];
}

-(void)cleanData{
    [self stop];
    mFlashName = nil;
    mFlashAnimDir = nil;
    mFileDataType = NOTYPE;
    mFileType = NONE;
    mJson = nil;
    mData = nil;
    mRunningAnimName = nil;
    mParsedData = nil;
    mImages = nil;
    
    mParseFrameMaxIndex = 0;
    mParseLastIndex = -1;
    mParseLastIsTween = false;
    mParseLastFrame = nil;
    
    mRunningAnimName = nil;
    mStartTime = 0;
    mCurrFrameIndex = 0;
    
    mSetLoopTimes = 1;
    mLoopTimes = 0;
    
    mStopAtFrameIndex = 0;
    mStopAtAnimName = nil;
    
    mLastFrameIndex = -1;
    mLastUpdateTime = -1;
}

-(void) stop{
    [self stopTimer];
    mRunningAnimName = nil;
    mSetLoopTimes = 1;
    mStartTime = 0;
    mCurrFrameIndex = 0;
    mLoopTimes = 0;
    
    mStopAtFrameIndex = 0;
    mStopAtAnimName = nil;
    
    mLastFrameIndex = -1;
    
    mLastUpdateTime = -1;
}


-(void)pause{
    isPause = YES;
}


-(void) resume{
    isPause = NO;
}


-(void) update{
    if (!isPause && !self.hidden && self.window) {
        [self setNeedsDisplay];
        if (self.updateMode != FlashViewUpdateModeRealtimeTime) {
            mCurrFrameIndex++;
            if (mCurrFrameIndex > mParseFrameMaxIndex) {
                mCurrFrameIndex = mParseFrameMaxIndex;
            }
        }
    }
}

-(UIImage *)readImage:(NSString *)path{
    switch (mFileType) {
        case DOCUMENT:
            return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@/%@", mWritablePath, mFlashAnimDir, mFlashName, path]];
        case RESOURCE:
            return [UIImage imageWithContentsOfFile:[mMainBundle pathForResource:path ofType:nil]];
        default:
            break;
    }
    return nil;
}

-(NSData *)readData{
    NSData *data = nil;
    switch (mFileType) {
        case DOCUMENT:
            data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/%@%@", mWritablePath, mFlashAnimDir, mFlashName, mFileDataType == JSON ? @".flajson" : @".flabin"]];
            break;
        case RESOURCE:
            data = [NSData dataWithContentsOfFile:[mMainBundle pathForResource:[NSString stringWithFormat:@"%@%@", mFlashName, mFileDataType == JSON ? @".flajson" : @".flabin"] ofType:nil]];
            break;
        default:
            break;
    }
    return data;
}

-(NSDictionary *)readJson{
    NSDictionary *ret = nil;
    NSData *data = [self readData];
    if(data){
        NSError *jsonErr;
        ret = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonErr];
        if (jsonErr) {
            NSLog(@"json 解析失败！%@", jsonErr);
            return nil;
        }
        return ret;
    }
    return nil;
}

#define calcPerValue(x) \
[self getPerValue: oneFrame old:mParseLastFrame key: x per:per] \

#define calcPerValueColor(x) \
[self getPerValue: oneFrameColor old:lastFrameColor key: x per:per] \


-(NSNumber *)getPerValue: (NSDictionary *)new old:(NSDictionary*)old key:(NSString *)key per:(float) per{
    float oldValue = [[old objectForKey:key] floatValue];
    float newValue = [[new objectForKey:key] floatValue];
    float ret = -1;
    float span = fabsf(newValue - oldValue);
    if (span > 180 && ([key isEqualToString:@"skewX"] || [key isEqualToString:@"skewY"])) {
        float realSpan = 360 - span;
        float mark = (oldValue < 0) ? -1 : 1;
        float mid = 180 * mark;
        float newStart = -mid;
        float midPer = (mid - oldValue) / realSpan;
        if (per < midPer) {
            ret = oldValue + per * realSpan * mark;
        }else{
            ret = newStart + (per - midPer) * realSpan * mark;
        }
    }else{
        ret = oldValue + per * (newValue - oldValue);
    }
    
    return @(ret);
}

-(NSMutableArray *) getParsedAnimWithIndex:(NSInteger) idx andParent:(NSMutableDictionary *)parent {
    NSMutableArray *arr = [parent objectForKey:@(idx)];
    if (!arr) {
        arr = [[NSMutableArray alloc] init];
        [parent setObject:arr forKey:@(idx)];
    }
    return arr;
}

-(void) addOneFrameToParsedAnimWithArr:(NSMutableArray *)arr frame:(NSDictionary *)oneFrame{
    if (!oneFrame) {
        return;
    }
    float x = [[oneFrame objectForKey:@"x"] floatValue];
    float y = [[oneFrame objectForKey:@"y"] floatValue];
    NSDictionary *color = [oneFrame objectForKey:@"color"];
    [arr addObject:@{
                     @"texName": [oneFrame objectForKey:@"texName"],
                     @"x": @(x),
                     @"y": @(y),
                     @"sx": [oneFrame objectForKey:@"scaleX"],
                     @"sy": [oneFrame objectForKey:@"scaleY"],
                     @"skewX": [oneFrame objectForKey:@"skewX"],
                     @"skewY": [oneFrame objectForKey:@"skewY"],
                     @"mark":[oneFrame objectForKey:@"mark"],
                     @"alpha": [oneFrame objectForKey:@"alpha"],
                     @"r": [color objectForKey:@"r"],
                     @"g": [color objectForKey:@"g"],
                     @"b": [color objectForKey:@"b"],
                     @"a": [color objectForKey:@"a"],
                     }];
}


-(NSMutableDictionary *) readKeyFrame:(FlashDataReader *)reader imageArr:(NSMutableArray *)imageArr{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    BOOL isEmpty = [reader readBool];
    [dict setObject:@(isEmpty) forKey:@"isEmpty"];
    [dict setObject:@([reader readUShort]) forKey:@"frameIndex"];
    if (!isEmpty) {
        [dict setObject:@([reader readUShort]) forKey:@"duration"];
        [dict setObject:@([reader readBool]) forKey:@"isTween"];
        [dict setObject:[imageArr objectAtIndex: [reader readUShort]] forKey:@"texName"];
        [dict setObject:[reader readNSString] forKey:@"mark"];
        [dict setObject:@([reader readUChar]) forKey:@"alpha"];
        [dict setObject: @{
                           @"r": @([reader readUChar]),
                           @"g": @([reader readUChar]),
                           @"b": @([reader readUChar]),
                           @"a": @([reader readUChar]),
                           }
                 forKey:@"color"];
        [dict setObject:@([reader readFloat]) forKey:@"scaleX"];
        [dict setObject:@([reader readFloat]) forKey:@"scaleY"];
        [dict setObject:@([reader readFloat]) forKey:@"skewX"];
        [dict setObject:@([reader readFloat]) forKey:@"skewY"];
        [dict setObject:@([reader readFloat]) forKey:@"x"];
        [dict setObject:@([reader readFloat]) forKey:@"y"];
    }
    
    return dict;
}


-(void) parseKeyFrame:(NSDictionary *)oneFrame parsedAnim:(NSMutableDictionary *)parsedAnim{
    NSInteger index = [[oneFrame objectForKey:@"frameIndex"] integerValue];
    BOOL isEmpty = [[oneFrame objectForKey:@"isEmpty"] boolValue];
    if (isEmpty) {
        return;
    }
    
    NSInteger duration = [[oneFrame objectForKey:@"duration"] integerValue];
    
    BOOL isTween = [[oneFrame objectForKey:@"isTween"] boolValue];
    
    NSInteger fromIdx = mParseLastIndex + 1;
    NSInteger toIdx = index;
    
    NSInteger len = toIdx - fromIdx + 1;
    
    for (NSInteger l = fromIdx; l <= toIdx; l++) {
        NSMutableArray *arr = [self getParsedAnimWithIndex:l andParent:parsedAnim];
        if (!mParseLastIsTween) {
            if (l == toIdx) {
                [self addOneFrameToParsedAnimWithArr:arr frame:oneFrame];
            }else{
                [self addOneFrameToParsedAnimWithArr:arr frame:mParseLastFrame];
            }
        }else{
            float per = (float)(l - fromIdx + 1) / len;
            NSDictionary *oneFrameColor = [oneFrame objectForKey:@"color"];
            NSDictionary *lastFrameColor = [mParseLastFrame objectForKey:@"color"];
            NSString *mark = @"";
            if (l == toIdx) {
                mark = [oneFrame objectForKey:@"mark"];
            }
            NSDictionary *onePerFrame = @{
                                          @"texName": [mParseLastFrame objectForKey:@"texName"],
                                          @"x": calcPerValue(@"x"),
                                          @"y": calcPerValue(@"y"),
                                          @"sx": calcPerValue(@"scaleX"),
                                          @"sy": calcPerValue(@"scaleY"),
                                          @"skewX": calcPerValue(@"skewX"),
                                          @"skewY": calcPerValue(@"skewY"),
                                          @"alpha": calcPerValue(@"alpha"),
                                          @"r": calcPerValueColor(@"r"),
                                          @"g": calcPerValueColor(@"g"),
                                          @"b": calcPerValueColor(@"b"),
                                          @"a": calcPerValueColor(@"a"),
                                          @"mark": mark
                                          };
            [arr addObject:onePerFrame];
        }
    }
    
    
    if(duration > 1 && index + duration >= mParseFrameMaxIndex + 1){
        for (NSInteger m = index; m <= mParseFrameMaxIndex; m++) {
            NSMutableArray *arr = [self getParsedAnimWithIndex:m andParent:parsedAnim];
            [self addOneFrameToParsedAnimWithArr:arr frame:oneFrame];
        }
    }
    
    
    mParseLastIndex = index;
    mParseLastIsTween = isTween;
    mParseLastFrame = oneFrame;
}

-(void) parseData{
    mParsedData = [[NSMutableDictionary alloc] init];
    mImages = [[NSMutableDictionary alloc] init];
    NSMutableArray *imagesArr = [[NSMutableArray alloc] init];
    
    FlashDataReader *reader = [[FlashDataReader alloc] initWithNSData:mData];
    
    mFrameRate = [reader readUShort];
    NSInteger imageNum = [reader readUShort];
    for (int i = 0; i < imageNum; i++) {
        NSString *texName = [reader readNSString];
        [mImages setObject:[self readImage:texName] forKey:texName];
        [imagesArr addObject:texName];
    }
    NSInteger animNum = [reader readUShort];
    for (int j = 0; j < animNum; j++) {
        NSMutableDictionary *parsedAnim = [[NSMutableDictionary alloc] init];
        NSString *animName = [reader readNSString];
        mParseFrameMaxIndex = [reader readUShort] - 1;
        NSInteger layerNum = [reader readUShort];
        for (int k = 0; k < layerNum; k++) {
            NSInteger keyFrameNum = [reader readUShort];
            mParseLastIndex = -1;
            mParseLastIsTween = NO;
            mParseLastFrame = nil;
            for (int l = 0; l < keyFrameNum; l++) {
                NSMutableDictionary *oneFrame = [self readKeyFrame:reader imageArr:imagesArr];
                [self parseKeyFrame:oneFrame parsedAnim:parsedAnim];
            }
        }
        [mParsedData setObject:parsedAnim forKey:animName];
    }
}

-(void) parseJson{
    mParsedData = [[NSMutableDictionary alloc] init];
    mImages = [[NSMutableDictionary alloc] init];
    
    mFrameRate = [[mJson objectForKey:@"frameRate"] integerValue];
    
    NSArray *textures = [mJson objectForKey:@"textures"];
    for (int n = 0; n < textures.count; n++) {
        NSString *texName = [textures objectAtIndex:n];
        [mImages setObject:[self readImage:texName] forKey:texName];
    }
    NSArray *anims = [mJson objectForKey:@"anims"];
    for (int i = 0; i < anims.count; i++) {
        NSMutableDictionary *parsedAnim = [[NSMutableDictionary alloc] init];
        NSDictionary *oneAnim = [anims objectAtIndex:i];
        NSString *animName = [oneAnim objectForKey:@"animName"];
        mParseFrameMaxIndex = [[oneAnim objectForKey:@"frameMaxNum"] integerValue] - 1;
        
        NSArray *layers = [oneAnim objectForKey:@"layers"];
        for (int j = 0; j < layers.count; j++) {
            NSDictionary *oneLayer = [layers objectAtIndex: j];
            NSArray *frames = [oneLayer objectForKey:@"frames"];
            mParseLastIndex = -1;
            mParseLastIsTween = NO;
            mParseLastFrame = nil;
            for (int k = 0; k < frames.count; k++) {
                NSDictionary *oneFrame = [frames objectAtIndex: k];
                [self parseKeyFrame:oneFrame parsedAnim:parsedAnim];
            }
        }
        
        [mParsedData setObject:parsedAnim forKey:animName];
    }
}

-(void) onEventOnMainThread:(id)data{
    if (self.onEventBlock) {
        self.onEventBlock((FlashViewEvent)[[data objectForKey:@"event"] unsignedIntegerValue], [data objectForKey:@"data"]);
    }
}


-(void) drawRectForFrameIndex:(NSInteger) frameIndex animName:(NSString *)animName isTriggerEvent:(BOOL) isTriggerEvent{
    if (isTriggerEvent) {
        if (self.delegate) {
            [self.delegate onEvent:FlashViewEventFrame data:@(frameIndex)];
        }
        if (self.onEventBlock) {
            [self performSelectorOnMainThread:@selector(onEventOnMainThread:) withObject:@{@"event": @(FlashViewEventFrame), @"data":@(frameIndex)} waitUntilDone:NO];
        }
    }
    
    
    if (mSetLoopTimes == FlashLoopTimeForever || (mLoopTimes == mSetLoopTimes - 1 && mLastFrameIndex <= frameIndex)) {
        NSDictionary *animDict = [mParsedData objectForKey:animName];
        
        NSArray *frameArray = [animDict objectForKey:@(frameIndex)];
        for (NSInteger i = frameArray.count - 1; i >= 0; i--) {
            NSDictionary *oneImageDict = [frameArray objectAtIndex:i];
            NSString *imagePath = [oneImageDict objectForKey:@"texName"];
            CGPoint drawPoint = CGPointMake([[oneImageDict objectForKey:@"x"] floatValue] / mDesignResolutionScale.x, [[oneImageDict objectForKey:@"y"] floatValue] / mDesignResolutionScale.y);
            CGPoint anchorPoint = CGPointMake(0.5f, 0.5f);
            CGPoint scale = CGPointMake([[oneImageDict objectForKey:@"sx"] floatValue], [[oneImageDict objectForKey:@"sy"] floatValue]);
            CGPoint rotation = CGPointMake([[oneImageDict objectForKey:@"skewX"] floatValue], [[oneImageDict objectForKey:@"skewY"] floatValue]);
            FlashColor color = FlashColorMake([[oneImageDict objectForKey:@"r"] floatValue] / 255,
                                              [[oneImageDict objectForKey:@"g"] floatValue] / 255,
                                              [[oneImageDict objectForKey:@"b"] floatValue] / 255,
                                              [[oneImageDict objectForKey:@"a"] floatValue] / 255
                                              );
            
            CGFloat alpha = [[oneImageDict objectForKey:@"alpha"] floatValue] / 255;
            
            //居中
            drawPoint = CGPointMake(drawPoint.x + self.frame.size.width / 2, drawPoint.y + self.frame.size.height / 2);
            
            //        YYLog(@"draw image %@ for index = %ld", imagePath, frameIndex);
            [self drawImage:imagePath atPoint:drawPoint anchor:anchorPoint scale:scale rotation:rotation color: color alpha:alpha];
            
            if (isTriggerEvent) {
                NSString *mark = [oneImageDict objectForKey:@"mark"];
                if (mark && mark.length > 0) {
                    NSLog(@"遇到事件！currIndex = %ld, dict = %@", (long)frameIndex, oneImageDict);
                    if (self.delegate) {
                        [self.delegate onEvent:FlashViewEventMark data:@{@"index": @(frameIndex), @"mark": mark, @"data": oneImageDict}];
                    }
                    if (self.onEventBlock) {
                        [self performSelectorOnMainThread:@selector(onEventOnMainThread:) withObject:@{@"event": @(FlashViewEventMark), @"data":@{@"index": @(frameIndex), @"mark": mark, @"data": oneImageDict}} waitUntilDone:NO];
                    }
                }
            }
        }
    }
    if (isTriggerEvent) {
        NSInteger animLen = mToIndex - mFromIndex;
        if (frameIndex == animLen - 1 || mLastFrameIndex > frameIndex) {
            if (self.delegate) {
                [self.delegate onEvent:FlashViewEventOneLoopEnd data:nil];
            }
            if (self.onEventBlock) {
                [self performSelectorOnMainThread:@selector(onEventOnMainThread:) withObject:@{@"event": @(FlashViewEventOneLoopEnd)} waitUntilDone:NO];
            }
            if (mSetLoopTimes >= FlashLoopTimeOnce) {
                if (++mLoopTimes >= mSetLoopTimes) {
                    if (self.delegate) {
                        [self.delegate onEvent:FlashViewEventStop data:nil];
                    }
                    if (self.onEventBlock) {
                        [self performSelectorOnMainThread:@selector(onEventOnMainThread:) withObject:@{@"event": @(FlashViewEventStop)} waitUntilDone:NO];
                    }
                    [self stop];
                    
                }
            }
            mCurrFrameIndex = mFromIndex;
        }
        mLastFrameIndex = frameIndex;
    }
}


-(void) checkMark:(NSString *)animName frameIndex:(NSInteger) frameIndex{
    NSDictionary *animDict = [mParsedData objectForKey:animName];
    if (animDict[@(frameIndex)]) {
        NSArray *frameArray = [animDict objectForKey:@(frameIndex)];
        for (NSDictionary *dict in frameArray) {
            NSString *mark = dict[@"mark"];
            if (mark && mark.length > 0) {
                NSLog(@"又遇到事件！currIndex = %ld, dict = %@", (long)frameIndex, dict);
                if (self.delegate) {
                    [self.delegate onEvent:FlashViewEventMark data:@{@"index": @(frameIndex), @"mark": mark, @"data": dict}];
                }
                if (self.onEventBlock) {
                    [self performSelectorOnMainThread:@selector(onEventOnMainThread:) withObject:@{@"event": @(FlashViewEventMark), @"data":@{@"index": @(frameIndex), @"mark": mark, @"data": dict}} waitUntilDone:NO];
                }
            }
        }
    }
}


-(void) drawRectForAnim:(CGRect) rect{
    if (!mRunningAnimName) {
        return;
    }
    
    NSInteger currFrameIndex = -1;
    if (self.updateMode == FlashViewUpdateModeRealtimeTime) {
        if (mStartTime == 0) {
            return;
        }
        currFrameIndex = mFromIndex + (NSInteger)((self.currentTime - mStartTime) / mOneFrameTime) % (mToIndex - mFromIndex + 1);
        if (mLastFrameIndex >= 0) {
            NSInteger mid = -1;
            if (mLastFrameIndex > currFrameIndex) {
                mid = mParseFrameMaxIndex;
            }
            if (mid != -1) {
                for (NSInteger i = mLastFrameIndex; i <= mid; i++) {
                    [self checkMark: mRunningAnimName frameIndex:i];
                }
                for (NSInteger i = 0; i < currFrameIndex; i++) {
                    [self checkMark: mRunningAnimName frameIndex:i];
                }
            } else {
                for (NSInteger i = mLastFrameIndex; i < currFrameIndex; i++) {
                    [self checkMark: mRunningAnimName frameIndex:i];
                }
            }
        }
    }else{
        currFrameIndex = mCurrFrameIndex;
    }
    
    //    YYLog(@"---------currentFrameIndex=%ld animLen=%ld", currFrameIndex, mToIndex - mFromIndex + 1);
    
    [self drawRectForFrameIndex:currFrameIndex animName:mRunningAnimName isTriggerEvent:YES];
}


#define ANGLE_TO_RADIUS(angle) (0.01745329252f * (angle))


-(void) drawImage:(NSString *)imagePath atPoint: (CGPoint)drawPoint anchor:(CGPoint) anchorPoint scale:(CGPoint) scale rotation:(CGPoint)rotation color:(FlashColor)color alpha:(CGFloat)alpha{
    UIImage *uiImage = [mImages objectForKey:imagePath];
    CGImageRef imageRef = uiImage.CGImage;
    CGSize imageSize = CGSizeMake(uiImage.size.width / mDesignResolutionScale.x, uiImage.size.height / mDesignResolutionScale.y);
    
    CGRect drawRect = CGRectMake(drawPoint.x - imageSize.width * anchorPoint.x, drawPoint.y - imageSize.height * anchorPoint.y, imageSize.width, imageSize.height);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    
    CGContextTranslateCTM(context, drawRect.origin.x, self.frame.size.height - drawRect.origin.y);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextTranslateCTM(context, drawRect.size.width * anchorPoint.x, drawRect.size.height * anchorPoint.y);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    if(rotation.x == rotation.y){
        float radius = -ANGLE_TO_RADIUS(rotation.x);
        transform = CGAffineTransformMake(cosf(radius), sinf(radius), -sinf(radius), cosf(radius), 0, 0);
    } else {
        float radiusX = -ANGLE_TO_RADIUS(rotation.x);
        float radiusY = -ANGLE_TO_RADIUS(rotation.y);
        float cx = cosf(radiusX);
        float sx = sinf(radiusX);
        float cy = cosf(radiusY);
        float sy = sinf(radiusY);
        
        float a = cy * transform.a - sx * transform.b;
        float b = sy * transform.a + cx * transform.b;
        float c = cy * transform.c - sx * transform.d;
        float d = sy * transform.c + cx * transform.d;
        float tx = cy * transform.tx - sx * transform.ty;
        float ty = sy * transform.tx + cx * transform.ty;
        
        transform = CGAffineTransformMake(a, b, c, d, tx, ty);
    }
    
    transform = CGAffineTransformScale(transform, scale.x, scale.y);
    
    CGContextConcatCTM(context, transform);
    
    CGContextTranslateCTM(context, -drawRect.size.width * anchorPoint.x, -drawRect.size.height * anchorPoint.y);//-
    CGContextTranslateCTM(context, -drawRect.origin.x, -drawRect.origin.y);
    
    CGContextSetAlpha(context, alpha);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, drawRect, imageRef);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceAtop);
    CGContextSetRGBFillColor(context, color.r, color.g, color.b, color.a);
    CGContextFillRect(context, drawRect);
    
    CGContextRestoreGState(context);
}

-(void)drawRect:(CGRect)rect{
    BOOL isMainThread = [[NSThread currentThread] isMainThread];
    if((self.runMode == FlashViewRunModeMainThread && !isMainThread) ||
       (self.runMode == FlashViewRunModeBackgroundThread && isMainThread)
       ){
        return;
    }
    if (mRunningAnimName) {
        [self drawRectForAnim:rect];
    }else if(mStopAtAnimName){
        [self drawRectForFrameIndex:mStopAtFrameIndex animName:mStopAtAnimName isTriggerEvent:NO];
    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    if(!newSuperview){
        [self cleanData];
    }
}

@end
