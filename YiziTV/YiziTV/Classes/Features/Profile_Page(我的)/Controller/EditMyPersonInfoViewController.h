//
//  EditMyPersonInfoViewController.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/23.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "SecondLayerViewController.h"
#import "CardInfoModel.h"

@interface EditMyPersonInfoViewController : SecondLayerViewController

//标题名字
@property(copy,nonatomic)NSString * titleString;
//是否隐藏返回按钮
@property(assign,nonatomic)BOOL isHiddenBackButton;
//是否更换根视图
@property(assign,nonatomic)BOOL isChangeRootVC;

//信息数据模型
@property(strong,nonatomic)CardInfoModel * infoModel;
@end
