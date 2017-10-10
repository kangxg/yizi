//
//  GiftShow.m
//  YiziTV
//
//  Created by 井泉 on 16/7/1.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "GiftShow.h"
#import "GiftInfoModel.h"
#import "FlashView.h"

@interface GiftShow () <GiftDelegate>
{
    NSInteger downerTag;
    GiftInfoModel *presentInfo;
    
    NSMutableArray *giftQueue;
    NSMutableArray *giftFlashQueue;

    UIView *targetView;
    MeetGiftView *giftView;
    NSInteger showOf;
    
    UIView *giftOne;
    UIView *giftTwo;
    UIView *fullSceenAnim;
    
    FlashView *flashView;
    
    BOOL giftOnePos;
    BOOL giftTwoPos;
    BOOL isEnptyGiftFullScreen;

}
@end

@implementation GiftShow

- (id)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        giftQueue = [[NSMutableArray alloc] init];
        giftFlashQueue = [[NSMutableArray alloc] init];

        targetView = view;
        
        giftOnePos = YES;
        giftTwoPos  = YES;
        giftOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        [giftOne setBackgroundColor:[UIColor clearColor]];
        giftOne.tag = 500;
        
        giftTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        [giftTwo setBackgroundColor:[UIColor clearColor]];
        giftTwo.tag = 501;
        
        fullSceenAnim = [[UIView alloc] initWithFrame:targetView.frame];
        [fullSceenAnim setBackgroundColor:[UIColor clearColor]];
        fullSceenAnim.tag = 502;
        
        [targetView addSubview:giftOne];
        [targetView addSubview:giftTwo];
        [targetView addSubview:fullSceenAnim];

        isEnptyGiftFullScreen = YES;
    }


    return self;
}
-(void)setShowViewFrameY:(CGFloat)originalY
{
    giftOne.center = CGPointMake(kScreenWidth/2.0, originalY-60/2);
    giftTwo.center = CGPointMake(kScreenWidth/2.0, CGRectGetMaxY(giftOne.frame) - 100);
}

- (void)play
{
    NSLog(@"开始play");

    /*
     *如果消息过多就缩短消失的时间
     */
    NSInteger duration = 1;
    if(giftQueue.count > 3)
    {
        duration = 1;
    }else if (giftQueue.count > 10)
    {
        duration = 0;
    }
    
    if (giftQueue.count != 0) {
        if (giftQueue.count > 2) {
            
            presentInfo = giftQueue[0];
            presentInfo.duration = duration;
            [self sendGift:presentInfo];
            
            presentInfo = giftQueue[0];
            presentInfo.duration = duration;

            [self sendGift:presentInfo];

        }
        else{
            presentInfo = giftQueue[0];
            presentInfo.duration = duration;

            [self sendGift:presentInfo];
        }
    }
    

    [self showFlash];
}

- (void)finished:(NSInteger)pos{
    showOf = pos;
    NSLog(@"运行完成：%ld", showOf);
    if(pos == 0)
    {
        giftOnePos = YES;
        [self play];
    }
    else{
        giftTwoPos = YES;
        [self play];
    }
}

- (void)sendGift:(GiftInfoModel*)giftInfo
{
    giftView = [[MeetGiftView alloc] initWithPresent:giftInfo];
    
    if (giftOnePos) {
        giftView.showPosition = 0;
        giftView.delegate = self;
        [giftOne addSubview:giftView];
        [giftView showPresent];
        NSLog(@"showOf1:%ld", showOf);
        [giftQueue removeObjectAtIndex:0];
        giftOnePos = NO;
    }
    else if (giftTwoPos){
        giftView.showPosition = 1;
        giftView.delegate = self;
        [giftTwo addSubview:giftView];
        [giftView showPresent];
        [giftQueue removeObjectAtIndex:0];
        giftTwoPos = NO;
        NSLog(@"showOf2:%ld", showOf);
    }
    
    
}

- (void)showFlash
{
    NSLog(@"flashView:%@" , flashView);
    if(isEnptyGiftFullScreen && (giftFlashQueue.count != 0))
    {
        isEnptyGiftFullScreen = NO;
//
//        //放置Flash动画
        flashView = [[FlashView alloc] initWithFlashName:giftFlashQueue[0] andAnimDir:nil];
        NSLog(@"flashView:%@" , flashView);

        flashView.frame = targetView.frame;// CGRectMake(100, 100, 200, 500);
        flashView.backgroundColor = [UIColor clearColor];
        //    [flashView play:@"anim" loopTimes:FlashLoopTimeForever];
        
        [targetView addSubview:flashView];
//        [flashView setScaleWithX:1.8 y:1.8 isDesignResolutionEffect:YES];
        [flashView setScaleWithX:1 y:1 isDesignResolutionEffect:YES];

//        flashView.center = CGPointMake(flashView.center.x, flashView.center.y * 1.2);
        flashView.center = CGPointMake(flashView.center.x, flashView.center.y);

        
        [flashView play:@"anim" loopTimes:FlashLoopTimeOnce fromIndex:0 toIndex:60];
//        flashView = [[FlashView alloc] initWithFlashName:giftFlashQueue[0] andAnimDir:nil];


        [giftFlashQueue removeObjectAtIndex:0];
        NSLog(@"执行到这里6");

        NSLog(@"--------------giftFlashQueue.count:%@", giftFlashQueue);
//        NSLog(@"执行到这里4");
//
        __weak typeof(flashView) wflashView=flashView;
        __weak typeof(self) wself=self;
        __weak typeof(giftFlashQueue) wgiftFlashQueue = giftFlashQueue;

        flashView.onEventBlock = ^(FlashViewEvent event, id i){
            if(event == FlashViewEventOneLoopEnd)
            {
                isEnptyGiftFullScreen = YES;
                [wflashView removeFromSuperview];//把自己从父对象中移除
                if(giftFlashQueue.count != 0)
                {
                    [wself showFlash];
                }
            }
        };
 
    }

}

- (void)addGift2QueueWithModelArray:(NSMutableArray*)list
{

        [giftQueue addObjectsFromArray:list];

}

- (void)addGift2QueueWithModel:(GiftInfoModel*)list
{
    
    NSLog(@"======%ld======%@",list.animationType,list.giftId);
    switch (list.animationType) {
        case YZTVGiftAnimationNomal:
        {
             [giftQueue addObject:list];
        
        }
            break;
        case YZTVGiftAnimationBox:
        {
        
            [giftFlashQueue addObject:@"box"];
            
        }break;
        case YZGiftAnimationMiniCooper:
        {
            
            [giftFlashQueue addObject:@"MiniCooper"];

        
        }break;
            
        default:
            break;
    }
    
        NSLog(@"礼物：%@", list.giftname);
    NSLog(@"数组总数：%lu", [giftQueue count]);
}


@end
