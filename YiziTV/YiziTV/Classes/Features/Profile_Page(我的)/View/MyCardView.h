//
//  MyCardView.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/21.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardInfoModel.h"

@protocol MyCardViewDelegateProtocol <NSObject>
//编辑我的信息
-(void)beginEditMyInfo:(CardInfoModel*)cardModel;

@end

@interface MyCardView : UIView

@property(strong,nonatomic)CardInfoModel * model;

@property(assign,nonatomic)id<MyCardViewDelegateProtocol>delegate;
-(instancetype)initWithHeight:(CGFloat)height;

-(void)setModel:(CardInfoModel *)model;
@end
