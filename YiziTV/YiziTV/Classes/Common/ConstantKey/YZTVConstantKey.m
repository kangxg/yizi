//
//  YZTVConstantKey.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/27.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "YZTVConstantKey.h"

@implementation YZTVConstantKey


//关注主播消息内容
NSString * const kFocusContentKey=@"关注了主播";

//进入房间显示
NSString * const kEnterRoomContentKey=@"进入房间";


//发送名片显示的内容
NSString * const kSendCardContentKey=@"刚刚发送了名片";

//发礼物显示
NSString * const kSendGiftContentKey=@"送了";

//禁言显示
NSString * const kAddMuteContentkey=@"被主播禁言";

//解除禁言显示
NSString * const kRemoveMuteContentkey=@"被主播解除禁言";
//登录手机号账号的 key

NSString * const kAcountKey=@"ACOUNT";

#pragma mark 聊天室消息的扩展值
//名称
NSString * const kNickNameKey=@"nickName";

//消息类型
NSString * const kMessageTypeKey=@"MessageType";

//用户id
NSString * const kUserIdKey=@"uid";
//云信ID
NSString * const kYXIDKey=@"yxuid";

//#pragma mark 自定义消息 ------卡片的key-----
//NSString * const kCardInfoID=@"cardID";
//NSString * const kHeadImageUrl=@"headImage";
//NSString * const kName=@"name";
//NSString * const kNickName=@"nickName";
//NSString * const kGrand=@"grand";
//NSString * const kCity=@"city";
//NSString * const kPhoneNum=@"phoneNum";
//NSString * const kSchool=@"school";
//NSString * const kProfessional=@"professional";
//NSString * const kGraduateTime=@"graduateTime";
//NSString * const kWantJob=@"wantJob";

#pragma mark end
//自定义消息类型 key
NSString * const kCustomMessageType=@"custom_type";


//钻石gif文件名字
NSString * const kGifDiamondName=@"diamond";

//钻石Gif 帧数
NSInteger const kGifDiamondCount=25;

@end
