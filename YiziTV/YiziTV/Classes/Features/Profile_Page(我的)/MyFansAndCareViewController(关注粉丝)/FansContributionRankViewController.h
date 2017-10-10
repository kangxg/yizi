//
//  FansContributionRankViewController.h
//  YiziTV
//
//  Created by 梁飞 on 16/7/20.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "SecondLayerViewController.h"

@interface FansContributionRankViewController : SecondLayerViewController

//查询用的 id
@property(copy,nonatomic)NSString * uid;

//收到的礼物数量
@property(copy,nonatomic)NSString * receiveGiftCount;

@end
