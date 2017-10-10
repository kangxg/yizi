//
//  GiftButtonView.h
//  YiziTV
//
//  Created by 井泉 on 16/6/29.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftInfoModel.h"

@protocol GiftButtonDelegate <NSObject>

@optional
- (void)selectedGift:(GiftInfoModel*)giftModel;
- (void)removeGift:(GiftInfoModel*)giftModel;


@end

@interface GiftButtonView : UIView

@property(strong,nonatomic)GiftInfoModel * giftModel;

@property (nonatomic, assign) id <GiftButtonDelegate> delegate;
-(void)setGiftModel:(GiftInfoModel *)giftModel;
-(void)setSelectButtonNomal;
@end
