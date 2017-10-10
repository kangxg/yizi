//
//  AudienceInputView.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/1.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "AudienceInputView.h"

@interface AudienceInputView ()
{
   
   
}
@end


@implementation AudienceInputView
-(instancetype)initWithFrame:(CGRect)frame
{
    
    self=[super initWithFrame:frame];
    if (self) {
        
        //名片
        UIButton * cardButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 57, kTabBarHeight)];
        [cardButton setImage:[UIImage imageNamed:@"send-card_normal"] forState:UIControlStateNormal];
        [cardButton setImage:[UIImage imageNamed:@"send-card_press"] forState:UIControlStateHighlighted];
        [cardButton addTarget:self action:@selector(clickCardButton) forControlEvents:UIControlEventTouchUpInside];
        [cardButton setImageEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 12)];
        [self addSubview:cardButton];
        
        UIView * inputBackView=[[UIView alloc]initWithFrame:CGRectMake(57, kTabBarHeight-33-8, kScreenWidth-102-57, 33)];
        inputBackView.layer.masksToBounds=YES;
        inputBackView.layer.borderWidth=0.5;
        inputBackView.layer.borderColor=[[[UIColor blackColor]colorWithAlphaComponent:0.2]CGColor];
        inputBackView.layer.cornerRadius=33.0/2;
        [self insertSubview:inputBackView belowSubview:self.inputView];
        
        
        
        
        self.inputView.frame=CGRectMake(57.5, kTabBarHeight-32-8.5, kScreenWidth-102-58, 32);
        self.inputView.layer.cornerRadius=self.inputView.height/2;
        self.inputView.layer.borderWidth=0.0;
        [self.inputView setPlaceHolder:@"说点什么吧"];
        
       
        
        
        UIButton * sharaButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-96, 0, 45, kTabBarHeight)];
        [sharaButton setImage:[UIImage imageNamed:@"share_normal"] forState:UIControlStateNormal];
        [sharaButton setImage:[UIImage imageNamed:@"share_press"] forState:UIControlStateHighlighted];
        [sharaButton addTarget:self action:@selector(clickShareButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sharaButton];
        
        
        //礼物
        UIButton * giftButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-45-6, 0, 45, kTabBarHeight)];
        [giftButton setImage:[UIImage imageNamed:@"send_gift_normal"] forState:UIControlStateNormal];
        [giftButton setImage:[UIImage imageNamed:@"send_gift_press"] forState:UIControlStateHighlighted];
        [giftButton addTarget:self action:@selector(clickGiftButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:giftButton];
        
        
                
        
        
    }
    
    return self;
    
    
}

-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    
}

#pragma mark  click  ACtion
-(void)clickCardButton
{
    
    
    if ([self.inputDelegate respondsToSelector:@selector(clickInputViewCardButton)]) {
        [self.inputDelegate clickInputViewCardButton];
        
    }
   
    
}

-(void)clickShareButton
{

    if ([self.inputDelegate respondsToSelector:@selector(clickInputViewShareButton)]) {
        [self.inputDelegate clickInputViewShareButton];
        
    }


}
-(void)clickGiftButton
{
    
   
    if ([self.inputDelegate respondsToSelector:@selector(clickInputViewGiftButton)]) {
        
        [self.inputDelegate clickInputViewGiftButton];
        
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
