//
//  LiveShareView.m
//  YZJOB-2
//
//  Created by 梁飞 on 16/3/2.
//  Copyright © 2016年 lfh. All rights reserved.
//

#import "LiveShareView.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>



@implementation LiveShareView
- (instancetype)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    //初始化UI
    if (self)
    {
        //间隔
        //判断是否安装微信
        BOOL isHand = [WXApi isWXAppInstalled];
        //判断是否安装QQ
        BOOL isQQHand=[QQApiInterface isQQInstalled];
        
        distance=15;
        
        NSArray * imageArr;
        NSArray * imageHeightArr;
        NSArray * shareTypeArr;
        if (isHand&&isQQHand) {
          
            isShare=YES;
            imageArr=@[@"white_pengyouquan",@"white_QQkongjian"];
            
            imageHeightArr=@[@"white_pengyouquan_select",@"white_QQkongjian_select"];
            shareTypeArr=@[[NSNumber numberWithInteger:YZShareWXFriendType],[NSNumber numberWithInteger:YZShareTypeQQZoneType]];
        }else if (isHand&&!isQQHand)
        {
             isShare=YES;
            imageArr=@[@"white_pengyouquan"];
            
            imageHeightArr=@[@"white_pengyouquan_select"];
            shareTypeArr=@[[NSNumber numberWithInteger:YZShareWXFriendType]];

        }else if (isQQHand&&!isHand)
        {
             isShare=YES;
            imageArr=@[@"white_QQkongjian"];
            
            imageHeightArr=@[@"white_QQkongjian_select"];
            shareTypeArr=@[[NSNumber numberWithInteger:YZShareTypeQQZoneType]];

        
        }else
        {
             isShare=NO;
        }
       
        
        for (int i=0; i<imageArr.count; i++) {
           
        
            UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(25*i+distance*i, 0, 25, 25)];
            imageView.image=[UIImage imageNamed:[imageArr objectAtIndex:i]];
            imageView.highlightedImage=[UIImage imageNamed:[imageHeightArr objectAtIndex:i]];
            imageView.tag=[[shareTypeArr objectAtIndex:i]integerValue];
            [self addSubview:imageView];
            
            
            
        }
        
        
    }
    return self;
    
}
-(BOOL)isshareShow
{
    return isShare;

}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Establish touch down event
    CGPoint touchPoint = [touch locationInView:self];
    [self sendActionsForControlEvents:UIControlEventTouchDown];
    
    // Calcluate value
    [self updateValueAtPoint:touchPoint];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Test if drag is currently inside or outside
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.frame, touchPoint))
        [self sendActionsForControlEvents:UIControlEventTouchDragInside];
    else
        [self sendActionsForControlEvents:UIControlEventTouchDragOutside];
    
    // Calculate value
    [self updateValueAtPoint:[touch locationInView:self]];
    return YES;
}
- (void)updateValueAtPoint:(CGPoint) p
{
    for (UIImageView *eachItem in [self subviews])
        if (p.x > eachItem.frame.origin.x&&p.x< eachItem.frame.origin.x+eachItem.width+distance)
        {
            NSLog(@"------");
            eachItem.highlighted=!eachItem.highlighted;
            
            if (eachItem.highlighted) {
                self.tag=eachItem.tag;
            }else
            {
                self.tag=-1;
            }
                                
            
            
        }
        else
        {
            NSLog(@"+++++");
            eachItem.highlighted=NO;
        
        }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];


}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Test if touch ended inside or outside
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, touchPoint))
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    else
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
}


- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [self sendActionsForControlEvents:UIControlEventTouchCancel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
