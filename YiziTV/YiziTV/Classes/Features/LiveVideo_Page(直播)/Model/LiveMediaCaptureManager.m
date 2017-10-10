//
//  LiveMediaCaptureManager.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/1.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "LiveMediaCaptureManager.h"

@interface LiveMediaCaptureManager ()
{
    UIView * _superView;
    
    UIView * _preView;
    
    
    //推流地址
    NSString * _streamUrl;
    
    LSVideoParaCtx _sVideoParaCtx;//推流视频参数设置
    
    
    LSStatistics* _pStatistics;//统计参数
    
    dispatch_source_t _timer;//打开一个计时线程,更新直播过程中视频流参数
    
    BOOL _isLiving;
    
    
    
    NSTimer * timer;
    
    
    
    AVAudioSession  * _avaudioSession;
    
    BOOL isFrontCamera;
    
    int _badNetWorkingNumber;

}
@end

@implementation LiveMediaCaptureManager

+(instancetype)shareInstance
{
    static id _s;
    if (_s==nil) {
        
        _s=[[[self class]alloc]init];
        
        
        
    }
    
    return _s;
    
}
-(id)init
{
    self=[super init];
    if (self) {
        isFrontCamera=YES;
    }
    return self;
}

-(void)createCapatureWithSuperView:(UIView *)superview andpreView:(UIView *)preview
{
    
    
    _superView=superview;
    _preView=preview;
    [_superView addSubview:_preView];
    [superview bringSubviewToFront:preview];
    [_superView bringSubviewToFront:_preView];
    
    
    [self initCapature];
    
    
    
    
    
    
}

-(void)initCapature
{
    
    //初始化直播参数，并创建音视频直播
    /* 视频设置 */
    
    _sVideoParaCtx.interfaceOrientation = LS_CAMERA_ORIENTATION_PORTRAIT;//
    if (isFrontCamera==YES) {
        _sVideoParaCtx.cameraPosition =LS_CAMERA_POSITION_FRONT ;
        
    }else
    {
        _sVideoParaCtx.cameraPosition =LS_CAMERA_POSITION_BACK;
    }
    

    _sVideoParaCtx.bitrate = 600000;
    _sVideoParaCtx.fps = 15;
    _sVideoParaCtx.videoStreamingQuality = LS_VIDEO_QUALITY_HIGH;

    _sVideoParaCtx.filterType =LS_GPUIMAGE_MEIYAN1;
    
    //    releaseSemaphore = dispatch_semaphore_create(1);
    
    _sVideoParaCtx.isVideoFilterOn=YES;
    NSError* error = nil;
    
    LSLiveStreamingParaCtx paraCtx;
    paraCtx.eHaraWareEncType =LS_HRD_NO;
    paraCtx.eOutFormatType = LS_OUT_FMT_RTMP;
    paraCtx.eOutStreamType = LS_HAVE_AV;
    
    memcpy(&paraCtx.sLSVideoParaCtx, &_sVideoParaCtx, sizeof(LSVideoParaCtx));
    
    
    /* 音频设置 */
    paraCtx.sLSAudioParaCtx.bitrate = 64000;
    paraCtx.sLSAudioParaCtx.codec = LS_AUDIO_CODEC_AAC;
    paraCtx.sLSAudioParaCtx.frameSize = 2048;
    paraCtx.sLSAudioParaCtx.numOfChannels = 1;
    paraCtx.sLSAudioParaCtx.samplerate = 44100;
    
    
    _mediaCapture = [[LSMediaCapture alloc]initLiveStream:nil withLivestreamParaCtx:paraCtx];
    
    [_mediaCapture setTraceLevel:LS_LOG_QUIET];
    
    if (error != nil) {
        return;
    }
    
    //打开摄像头预览
    [_mediaCapture startVideoPreview:_preView];
    _mediaCapture.filterType=LS_GPUIMAGE_MEIYAN1;
    
    
    NSString* sdkVersion = [_mediaCapture getSDKVersionID];
    NSLog(@"sdk version:%@",sdkVersion);
    
    [self installLSNotificationObservers];
    
    
    
}
-(void)installLSNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(liveStreamStarted:)
                                                 name:LS_LiveStreaming_Started
                                               object:_mediaCapture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(liveStreamFinished:)
                                                 name:LS_LiveStreaming_Finished
                                               object:_mediaCapture];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onBadNetworking:) name:LS_LiveStreaming_Bad object:_mediaCapture];
    
}
-(void)liveStreamStarted:(NSNotification*)notification
{
    NSLog(@"live stream started");
    
}

-(void)liveStreamFinished:(NSNotification*)notification
{
    
    NSLog(@"live stream finished");
    
}
-(void)onBadNetworking:(NSNotification*)notification
{
    NSLog(@"live streaming on bad networking");
    if (_badNetWorkingNumber==0) {
        dispatch_async ( dispatch_get_main_queue (), ^{
            [self performSelector:@selector(setBadNetWorkingNumberToZero) withObject:nil afterDelay:15.0];
        });
    }
    _badNetWorkingNumber ++;
    if (_badNetWorkingNumber==30) {
        
        dispatch_async ( dispatch_get_main_queue (), ^{
            
            
        
            [[self class]cancelPreviousPerformRequestsWithTarget:self selector:@selector(setBadNetWorkingNumberToZero) object:nil];
            
            if (self.liveErrorCallback!=nil) {
                NSString *errMsg = NSLocalizedString(@"您的网络状况暂时不适合当网红，请稍后再试", @"您的网络状况暂时不适合当网红，请稍后再试");
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey:errMsg};
                NSError *error = [NSError errorWithDomain:@"网络不佳" code:404 userInfo:userInfo];
                
                self.liveErrorCallback(error);
            }
            
            
        });
        
        
    }
    
    
    
}
-(void)setBadNetWorkingNumberToZero
{
    NSLog(@"————————————————归零——————————————————————————");
    _badNetWorkingNumber=0;
    
}
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:LS_LiveStreaming_Finished object:_mediaCapture];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:LS_LiveStreaming_Started object:_mediaCapture];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:LS_LiveStreaming_Bad object:_mediaCapture];
    
}


#pragma mark 开始直播
-(void)startLiveStreamingWithLiveUrl:(NSString *)streamUrl
{
    
    NSLog(@"推流地址---%@",streamUrl);
    _streamUrl=streamUrl;
    //开启新的推流地址
    _mediaCapture.pushUrl=_streamUrl;
    _isLiving = YES;
    
    
    //直播开始之前，需要设置直播出错反馈回调，当然也可以不设置---demo中写
    __weak LiveMediaCaptureManager *weakSelf = self;
    //直播过程中发生错误
    _mediaCapture.onLiveStreamError = ^(NSError* liverEror)
    {
        if (liverEror != nil) {
            [weakSelf liveStreamErrorInterrup];//其实要仔细考虑，当直播不是音视频的时候到底关闭么，但是错误导致的，大都需要重新连接start了
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                NSLog(@"/直播过程中发生错误");
                [weakSelf showErrorInfo:liverEror];
                
                
            });
            
        }
    };
    
    
    //开始直播
    NSError* error =nil;
    [_mediaCapture startLiveStreamWithError:&error];
    
    if (error) {
        
        NSLog(@"开始直播前发生错误");
        [self liveStreamErrorInterrup];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self showErrorInfo:error];
        });
        
        
        
        return;
    }
    

    //直播统计输出过程
    
    
    
    
    
}

-(void)showErrorInfo:(NSError*)error
{
    //  NSString *errMsg = NSLocalizedString(error,error);
    NSString *errMsg = [error localizedDescription];
    NSLog(@"直播错误信息错误信息:%@",errMsg);
    
    if (self.liveErrorCallback!=nil) {
        self.liveErrorCallback(error);
    }
    

}
//====================直播操作
dispatch_source_t CreateDispatchTimer(double interval, dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, (1ull * NSEC_PER_SEC) / 10);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}

-(void)liveStreamErrorInterrup
{
    
    [self stopPushLiving:^(NSError * error) {
        
    }];
    
}
-(void)stopPushLiving:(void (^)(NSError * error))completionBlock
{
    [_mediaCapture stopLiveStream:^(NSError * error) {
       
        completionBlock(error);
        if (error==nil) {
             _mediaCapture=nil;
        }
        
    }];
   
    //    //释放timer
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }

}

-(void)changeCameraPosition
{
    [_mediaCapture switchCamera];
    if (_sVideoParaCtx.cameraPosition ==LS_CAMERA_POSITION_BACK) {
        
        _sVideoParaCtx.cameraPosition = LS_CAMERA_POSITION_FRONT;
        isFrontCamera=YES;
        
    }else
    {
        _sVideoParaCtx.cameraPosition = LS_CAMERA_POSITION_BACK;
        isFrontCamera=NO;
        
        
    }
    
}

-(void)closeLivePreview
{
    [_mediaCapture pauseVideoPreview];
}
@end
