//
//  EditMyCardInfoViewController.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/22.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "SecondLayerViewController.h"
#import "CardInfoModel.h"

@interface EditMyCardInfoViewController : SecondLayerViewController

@property(strong,nonatomic)CardInfoModel * cardModel;

@property(copy,nonatomic)void(^saveSuccess)(CardInfoModel * cardModel);

@end
