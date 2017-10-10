


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define FLASH_VIEW_DEFAULT_DIR_NAME @"GiftFlash"

#define FLASH_VIEW_DEFAULT_ZIP_NAME @"flashAnimZip"


typedef enum : NSUInteger {
    FlashViewUpdateModeRealtimeTime,
    FlashViewUpdateModeEveryFrame,
} FlashViewUpdateMode;

typedef enum : NSUInteger {
    FlashLoopTimeOnce = 1,
    FlashLoopTimeForever = 0,
} FlashLoopTime;

typedef enum NSUInteger{
    FlashViewEventStart,
    FlashViewEventFrame,
    FlashViewEventOneLoopEnd,
    FlashViewEventStop,
    FlashViewEventMark,
} FlashViewEvent;

typedef enum : NSUInteger {
    ScaleModeWidthFit,
    ScaleModeHeightFit,
    ScaleModeRespective,
    ScaleModeDefault,
} ScaleMode;


typedef enum : NSUInteger {
    FlashViewRunModeBackgroundThread,   FlashViewRunModeMainThread,
} FlashViewRunMode;


@protocol FlashViewDelegate <NSObject>

-(void)onEvent:(FlashViewEvent) evt data:(id)d;

@end


typedef void (^FlashUIntCallback)(FlashViewEvent, id);

@interface FlashView : UIView


+(BOOL) isAnimExist:(NSString *)flashName;

@property (nonatomic, weak) id<FlashViewDelegate> delegate;
@property (nonatomic, copy) FlashUIntCallback onEventBlock;
@property (nonatomic, unsafe_unretained) FlashViewRunMode runMode;
@property (nonatomic, unsafe_unretained) BOOL isInitOk;

@property (nonatomic, unsafe_unretained) FlashViewUpdateMode updateMode;

-(instancetype) initWithFlashName:(NSString *)flashName andAnimDir:(NSString *)animDir;

-(instancetype) initWithFlashName:(NSString *)flashName;


-(void) setScaleMode:(ScaleMode)mode andDesignResolution:(CGSize)resolution;


-(void) setScaleWithX:(CGFloat)x y:(CGFloat) y isDesignResolutionEffect:(BOOL)isDREffect;


-(NSArray *)animNames;

-(NSDictionary *)images;


-(void) play:(NSString *)animName loopTimes:(NSUInteger) times;

-(void) play:(NSString *)animName loopTimes:(NSUInteger)times fromIndex:(NSInteger) from;

-(void) play:(NSString *)animName loopTimes:(NSUInteger)times fromIndex:(NSInteger) from toIndex:(NSInteger) to;


-(void) stopAtFrameIndex:(NSInteger) frameIndex animName:(NSString *) animName;


-(void) setLoopTimes:(NSInteger) times;


-(void) stop;


-(void) pause;


-(void) resume;


-(void) replaceImage:(NSString *)texName image:(UIImage *)image;

-(BOOL) reload:(NSString *)flashName andAnimDir:(NSString *)animDir;

@end

