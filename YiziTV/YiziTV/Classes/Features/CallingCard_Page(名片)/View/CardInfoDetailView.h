//
//  CardInfoDetailView.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/21.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardInfoModel.h"

@interface CardInfoDetailView : UIView
@property(strong,nonatomic)CardInfoModel * model;
@property(copy,nonatomic)void(^closeShowView)(void);
-(void)setModel:(CardInfoModel *)model;
@end
