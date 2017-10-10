//
//  YZChatRoomCustomAttachment.h
//  YiziTV
//
//  Created by 梁飞 on 16/7/4.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMCustomObject.h"

/*发送自定义消息*/
@interface YZChatRoomCustomAttachment :NSObject<NIMCustomAttachment>

//ID
@property(copy,nonatomic)NSString * ID;

//头像地址
@property(copy,nonatomic)NSString * headImageUrl;

//昵称
@property(copy,nonatomic)NSString * nickName;

//真实名字
@property(copy,nonatomic)NSString * name;

//所在地
@property(copy,nonatomic)NSString * locationCity;

//毕业院校
@property(copy,nonatomic)NSString * shcool;
//专业
@property(copy,nonatomic)NSString * professional;

//目标职位
@property(copy,nonatomic)NSString * wantJobName;

//时间
@property(copy,nonatomic)NSString * cardTime;

//手机号
@property(copy,nonatomic)NSString * phoneNum;

//毕业时间
@property(copy,nonatomic)NSString * graduateTime;


//性别
@property(assign,nonatomic)int grand;

@property(assign,nonatomic)YZTVCustomMessageType customMessageType;


@end
