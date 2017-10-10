//
//  ReceiveCardModel.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/21.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "ReceiveCardModel.h"

@implementation ReceiveCardModel
-(id)init
{
    self=[super init];
    if (self) {
        self.cardArray=[NSMutableArray array];
    }
    return self;
}
@end
