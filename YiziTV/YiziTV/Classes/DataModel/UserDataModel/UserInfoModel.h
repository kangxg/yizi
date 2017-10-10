//
//  UserInfoModel.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/20.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject<NSCoding>


@property(copy,nonatomic)NSString * uid;

@property(copy,nonatomic)NSString * deviceId;

@property(copy,nonatomic)NSString * phone_number;

@property(copy,nonatomic)NSString * user_token;

//昵称
@property(copy,nonatomic)NSString * nickName;


//是否实名认证
@property(assign,nonatomic)int isCertification;

//真实姓名
@property(copy,nonatomic)NSString * realName;
//身份证号码
@property(copy,nonatomic)NSString * IDNum;

//云信账号
@property(copy,nonatomic)NSString * YXAcount;

//云信token
@property(copy,nonatomic)NSString * YXToken;


//直播主题
@property(copy,nonatomic)NSString * liveTheme;



//设置的直播封面地址
@property(copy,nonatomic)NSString * setLiveCoverImageUrl;



#pragma mark 不需要储存本地的 用户信息



#pragma mark ------end --------------

@end
