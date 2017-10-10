//
//  CardInfoModel.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/21.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "BaseDataModel.h"

/*  收到的名片   */
@interface CardInfoModel : BaseDataModel

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

//粉丝数
@property(copy,nonatomic)NSString * fansCount;

//关注数
@property(copy,nonatomic)NSString * focusCount;

//金币
@property(copy,nonatomic)NSString * goldCoinCount;

//直播封面图地址
@property(copy,nonatomic)NSString * coverImageUrl;

//是否被我关注
@property(assign,nonatomic)BOOL isCared;

//收到的礼物数
@property(copy,nonatomic)NSString * receiveGiftCount;


//用户id
@property(copy,nonatomic)NSString * uid;
//云信id
@property(copy,nonatomic)NSString * yxID;





//解析我的名片接口
-(void)analysisCardRequestWithDic:(NSDictionary*)cardDic;

//解析我收到的名片接口
-(void)analysisMyReceiveCardsRequestWithDic:(NSDictionary*)cardDic;

//解析我的粉丝、关注接口
-(void)analysisMyFansFocusRequestWithDic:(NSDictionary*)fansDic;

//解析自定义消息
-(void)analysisCustomMessageWithDic:(NSDictionary*)messageDic;

//解析根据id查看用户信息接口
-(void)analysisGetUserInfoWithUidDic:(NSDictionary*)infoDic;

@end
