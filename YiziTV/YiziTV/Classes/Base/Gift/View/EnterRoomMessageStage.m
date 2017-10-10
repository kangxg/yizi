//
//  EnterRoomMessageStage.m
//  YiziTV
//
//  Created by 井泉 on 16/7/17.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "EnterRoomMessageStage.h"

@interface EnterRoomMessageStage ()
{
    NSMutableArray *InitRoomQueue;
    EnterRoomMessageView *enterRoomMessage;
    CardInfoModel * enterSomeone;
    CGPoint startPos;
    CGPoint endPos;
    UIImageView *flyHeadView;
    
    float flyDuration;
    UIView *targetView;
    BOOL isEnptyStage;
    
   
}
@end

@implementation EnterRoomMessageStage
- (id)initWithView:(UIView*)view
{
    self = [super init];
    if (self) {
        targetView = view;
        
        _messageY = kScreenHeight - ChatScreenHeight-kTabBarHeight;
                
        isEnptyStage = YES;
        
        InitRoomQueue = [[NSMutableArray alloc] init];
        
        endPos = CGPointMake(158 / 2.0, 102 / 2.0);
        
        flyHeadView = [[UIImageView alloc] init];
        
        flyDuration = 2.5;
    }
    
    return self;
}

- (void)play
{
    NSInteger countMessage = InitRoomQueue.count;
    switch (countMessage) {
        case 5:
            flyDuration = 2;
            break;
        case 10:
            flyDuration = 1.3;
            break;
        case 20:
            flyDuration = 0.5;
            break;
        default:
            break;
    }
    
    if ((countMessage != 0) && isEnptyStage) {
        isEnptyStage = NO;
        
        enterSomeone = InitRoomQueue[0];
        enterRoomMessage = [[EnterRoomMessageView alloc] initFormName:enterSomeone.nickName withImageUrl:enterSomeone.headImageUrl];
//        enterRoomMessage = [enterRoomMessage initFormName:enterSomeone.nickName withImageUrl:enterSomeone.headImageUrl];
        
        [targetView addSubview:enterRoomMessage];
        enterRoomMessage.center = CGPointMake(enterRoomMessage.center.x + targetView.size.width, _messageY-enterRoomMessage.height);
        [self animation:enterRoomMessage];
    }
    
}

- (void)setMessageY:(NSInteger)messageY
{
    _messageY = messageY;
    enterRoomMessage.center = CGPointMake(enterRoomMessage.center.x + targetView.size.width, _messageY-enterRoomMessage.height);

}

- (void)addOne2QueueWithModel:(CardInfoModel*)list
{
    [InitRoomQueue addObject:list];
    [self play];
    NSLog(@"InitRoomQueue:%ld", InitRoomQueue.count);
}

- (void)animation:(EnterRoomMessageView*)view
{
    //开始从屏幕外划入
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        enterRoomMessage.center = CGPointMake(enterRoomMessage.center.x - targetView.size.width * 0.95, _messageY-enterRoomMessage.height);
    } completion:^(BOOL finished) {
        startPos = [enterRoomMessage convertPoint:enterRoomMessage.headIconImageView.center toView:targetView];
        CGRect rect =  CGRectMake(0, 0, enterRoomMessage.headIconImageView.size.width, enterRoomMessage.headIconImageView.size.height);
        NSLog(@"startPos:%@", NSStringFromCGRect(rect));

        flyHeadView.transform = CGAffineTransformMakeScale(1, 1);
        flyHeadView.frame = rect;
        [flyHeadView setImage:enterRoomMessage.headIconImageView.image];
        flyHeadView.layer.masksToBounds= enterRoomMessage.headIconImageView.layer.masksToBounds;
        flyHeadView.layer.cornerRadius = enterRoomMessage.headIconImageView.layer.cornerRadius;
        flyHeadView.layer.borderWidth = enterRoomMessage.headIconImageView.layer.borderWidth;
        flyHeadView.layer.borderColor = enterRoomMessage.headIconImageView.layer.borderColor;
        
        flyHeadView.center = startPos;
        [targetView addSubview:flyHeadView];
        NSLog(@"1:%@", flyHeadView);
        NSLog(@"2:%@", enterRoomMessage.headIconImageView);

        //头像飞上去
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            flyHeadView.center = endPos;
            flyHeadView.transform = CGAffineTransformMakeScale(0.2, 0.2);

        } completion:^(BOOL finished) {
            [flyHeadView removeFromSuperview];
        }];

        //开始微动
        [UIView animateWithDuration:flyDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            enterRoomMessage.center = CGPointMake(enterRoomMessage.center.x - 10, _messageY-enterRoomMessage.height);

        } completion:^(BOOL finished) {
            //开始划出屏幕
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                enterRoomMessage.center = CGPointMake(-enterRoomMessage.center.x, _messageY-enterRoomMessage.height);
                
            } completion:^(BOOL finished) {
                //一个人物加入房间动画完成
                [enterRoomMessage removeFromSuperview];
                isEnptyStage = YES;
                [enterRoomMessage removeFromSuperview];
                [InitRoomQueue removeObjectAtIndex:0];
                [self play];
            }];
        }];
    }];
}
@end
