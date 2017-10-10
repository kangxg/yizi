//
//  SendMyCardView.h
//  YiziTV
//
//  Created by 梁飞 on 16/7/4.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardInfoModel.h"

@protocol SendMyCardViewDelegate <NSObject>

@optional
-(void)editMyCardInfoWithCardInfoModel:(CardInfoModel*)cardInfoModel backgroundImage:(UIImageView*)backImageView;

//发送名片选择的付费类型
-(void)senCardWithPayType:(YZTVPayType)payType CardInfo:(CardInfoModel*)cardInfoModel;


@end


@interface SendMyCardView : UIView
@property(assign,nonatomic)id<SendMyCardViewDelegate>deleaget;

-(instancetype)initWithBackImage:(UIImageView*)backImageView;

-(void)refreshCardInfoView:(CardInfoModel*)cardInfoModel;
@end
