//
//  GiftKeyboardView.h
//  YiziTV
//
//  Created by 井泉 on 16/6/29.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardInfoModel.h"

@protocol GiftKeyboardDelegate <NSObject>

@optional
- (void)sendGiftsArray:(NSMutableArray*)giftArrary;

-(void)clickGoldCionWithMyCardInfo:(CardInfoModel *)myCardInfo;
@end

@interface GiftKeyboardView : UIView
@property (nonatomic, assign) id <GiftKeyboardDelegate> delegate;
@property (strong,nonatomic) CardInfoModel * myCardInfo;

//刷新金币
-(void)refreshGoldCoin;
//刷新礼物
-(void)refreshGift;

@end
