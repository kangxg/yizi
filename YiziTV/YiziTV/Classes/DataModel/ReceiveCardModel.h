//
//  ReceiveCardModel.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/21.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "BaseDataModel.h"

@interface ReceiveCardModel : BaseDataModel

//日期
@property(copy,nonatomic)NSString * dateTime;

//名片
@property(strong,nonatomic)NSMutableArray * cardArray;


@end
