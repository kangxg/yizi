//
//  LiveMediaCaptureManager.h
//  YiziTV
//
//  Created by 梁飞 on 16/7/1.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "LSMediaCapture.h"
#import "nMediaLiveStreamingDefs.h"

@interface LiveMediaCaptureManager : NSObject


@property (nonatomic,strong) LSMediaCapture *mediaCapture;

@property (nonatomic,copy) void(^liveErrorCallback)(NSError *error);

+(instancetype)shareInstance;

-(void)createCapatureWithSuperView:(UIView*)superview andpreView:(UIView*)preview;

//开始推流
-(void)startLiveStreamingWithLiveUrl:(NSString*)streamUrl;

//更改摄像头前-后
-(void)changeCameraPosition;

//结束推流
-(void)stopPushLiving:(void(^)(NSError *))completionBlock;

//关闭预览
-(void)closeLivePreview;
@end
