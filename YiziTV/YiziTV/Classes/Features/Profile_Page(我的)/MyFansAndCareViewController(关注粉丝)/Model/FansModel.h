//
//  FansModel.h
//  YiziTV
//
//  Created by 梁飞 on 16/7/20.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "BaseDataModel.h"

@interface FansModel : BaseDataModel

//头像
@property(copy,nonatomic)NSString * headImageUrl;

//昵称
@property(copy,nonatomic)NSString * nickName;

//用户id
@property(copy,nonatomic)NSString * uid;

//贡献值
@property(copy,nonatomic)NSString * contributionCount;


@end
