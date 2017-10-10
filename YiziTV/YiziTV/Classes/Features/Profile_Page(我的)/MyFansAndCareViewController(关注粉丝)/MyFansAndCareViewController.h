//
//  MyFansAndCareViewController.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/28.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "SecondLayerViewController.h"

@interface MyFansAndCareViewController : SecondLayerViewController

//来源粉丝
@property(assign,nonatomic)BOOL isComeFans;

@property(copy,nonatomic)void(^returnCallback)(void);


@end
