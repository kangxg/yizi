//
//  LiveBottomView.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/18.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "LiveBottomView.h"

@implementation LiveBottomView
-(id)initWithFrame:(CGRect)frame
{
    CGRect newReact=CGRectMake(0, kScreenHeight-kTabBarHeight, kScreenWidth, kTabBarHeight);
    self=[super initWithFrame:newReact];
    if (self) {
        
        //聊天按钮
        UIButton * chatBotton=[[UIButton alloc]initWithFrame:CGRectMake(12, 0, 33, kTabBarHeight)];
        [chatBotton setImage:[UIImage imageNamed:@"message_normal"] forState:UIControlStateNormal];
        [chatBotton setImage:[UIImage imageNamed:@"message_press"] forState:UIControlStateHighlighted];
        [chatBotton addTarget:self action:@selector(pressChatButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:chatBotton];
        
        
        //切换摄像头
        UIButton * changeCameraPositionButton=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(chatBotton.frame)+12, 0,33 , kTabBarHeight)];
        [changeCameraPositionButton setImage:[UIImage imageNamed:@"camera_normal"] forState:UIControlStateNormal];
        [changeCameraPositionButton setImage:[UIImage imageNamed:@"camera_press"] forState:UIControlStateHighlighted];
        [changeCameraPositionButton addTarget:self action:@selector(clickChangeCameraPosition) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:changeCameraPositionButton];
        
        

        //分享
        UIButton * sharaButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-12-33, 0, 33, kTabBarHeight)];
        [sharaButton setImage:[UIImage imageNamed:@"share_normal"] forState:UIControlStateNormal];
        [sharaButton setImage:[UIImage imageNamed:@"share_press"] forState:UIControlStateHighlighted];
        [sharaButton addTarget:self action:@selector(clickSharaButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sharaButton];
        
        //名片
        UIButton * cardButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-12-sharaButton.width-12-33, 0, 33, kTabBarHeight)
                               ];
        [cardButton setImage:[UIImage imageNamed:@"black card"] forState:UIControlStateNormal];
        [cardButton setImage:[UIImage imageNamed:@"black card_press"] forState:UIControlStateHighlighted];
        [cardButton addTarget:self action:@selector(clickCardButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cardButton];
        
        
        //礼物
//        UIButton * giftButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-12-sharaButton.width-12-cardButton.width-12-33, 0, 33, kTabBarHeight)];
//        [giftButton setImage:[UIImage imageNamed:@"color_gift_normal"] forState:UIControlStateNormal];
//        [giftButton setImage:[UIImage imageNamed:@"color_gift_press"] forState:UIControlStateHighlighted];
//        [self addSubview:giftButton];
        
        
//        //红包
//        UIButton * redPackageButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-12-sharaButton.width-12-cardButton.width-12-giftButton.width-12-33, 0, 33, kTabBarHeight)];
//        [redPackageButton setImage:[UIImage imageNamed:@"red package"] forState:UIControlStateNormal];
//        [redPackageButton setImage:[UIImage imageNamed:@"red package_press"] forState:UIControlStateHighlighted];
//        [self addSubview:redPackageButton];
//
//        
        
        
        
        
        
        
    }
    return self;

}
-(void)pressChatButton
{

    if ([self.delegate respondsToSelector:@selector(clickLiveBottomViewChatButton)]) {
        [self.delegate clickLiveBottomViewChatButton];
    }
    
}
-(void)clickChangeCameraPosition
{
    if ([self.delegate respondsToSelector:@selector(clickInputViewChangeCamera)]) {
        
        [self.delegate clickInputViewChangeCamera];
        
    }
}
-(void)clickSharaButton
{

    if ([self.delegate respondsToSelector:@selector(clickLiveBottomViewShareButton)]) {
        [self.delegate clickLiveBottomViewShareButton];
    }
    
}
-(void)clickCardButton
{

    if ([self.delegate respondsToSelector:@selector(clickLiveBottomViewCardButton)]) {
        [self.delegate clickLiveBottomViewCardButton];
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
