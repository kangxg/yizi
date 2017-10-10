//
//  LiveTopView.h
//  YiziTV
//
//  Created by 梁飞 on 16/7/1.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LiveTopViewActionDelegate <NSObject>

@optional
//关闭观看
-(void)closeLiveAction;
//点击观看人数
-(void)clickMemberCountButton;

//点击礼物数
-(void)clickReceiveGiftCountButton:(NSString*)giftCount;

//点击主播头像
-(void)clickHeadImageViewAction:(UIImageView*)headImageView;

@end

@interface LiveTopView : UIView
{
    UIButton * closeButton;
    
    UIImageView * headImageView;
    
    UILabel * nickNameLabel;
    
    UIImageView * personCountImage;
    
    UILabel * personCountLabel;
    
    UILabel * giftCountLabel;
    
    UIImageView * giftCountImage;
    
    
    

}

@property(assign,nonatomic)id<LiveTopViewActionDelegate>liveDelegate;

-(void)refreshPersonCount:(long long)personCount;
-(void)refreshGiftCount:(long long)giftCount;
@end
