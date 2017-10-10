//
//  ChatSessionModel.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/30.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMMessage.h"
#import "LiveInfoModel.h"
#import "CardInfoModel.h"
#import "GiftInfoModel.h"

@interface ChatSessionModel : NIMMessage

@property(copy,nonatomic)NSString * messageID;

@property(assign,nonatomic)YZTVChatMessageType yztvMessageType;

@property(strong,nonatomic)LiveInfoModel * liveInfoModel;

@property(strong,nonatomic)CardInfoModel * cardInfoModel;

@property(strong,nonatomic)GiftInfoModel * giftModel;

//云信id
@property(copy,nonatomic)NSString * yxID;
//用户id
@property(copy,nonatomic)NSString * uid;
@end
