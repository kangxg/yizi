//
//  BaseGiftView.h
//  YiziTV
//
//  Created by 井泉 on 16/7/1.
//  Copyright © 2016年 JQ. All rights reserved.
/*
 *基本用法
 *   giftView = [[MeetGiftView alloc] initWithPresent:giftInfo];//giftInfo为消息模型
 *   giftView.delegate = self;
 *   [TargetView addSubview:giftView];
 *   [giftView showPresent];
 *
 *
 *
 */


#import <UIKit/UIKit.h>
#import "BaseGift.h"
#import "GiftInfoModel.h"

@interface MeetGiftView : BaseGift
{
}



@property (nonatomic, weak) id<GiftDelegate> delegate;


- (id)initWithPresent:(GiftInfoModel*)present;


@end
