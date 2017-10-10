//
//  ShowCardViewManager.h
//  YiziTV
//
//  Created by 梁飞 on 16/7/25.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CardInfoModel.h"

@interface ShowCardViewManager : NSObject

-(id)initWithSuperView:(UIView *)superView;

-(void)receiveCardInfo:(CardInfoModel*)cardInfoModel;

//显示
@property(copy,nonatomic)void(^tapCardViewCallback)(UIImageView*showImageVew);

//消失
@property(copy,nonatomic)void(^closeCardDetailView)();


@end
