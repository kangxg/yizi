//
//  UserManager.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/20.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"

@interface UserManager : NSObject
@property(strong,nonatomic) UserInfoModel * userInfo;
+(instancetype)shareInstaced;
-(void)setUserInfo:(UserInfoModel *)userInfo;
-(UserInfoModel*)getUserInfoModel;

//登录云信
-(void)loginYXSDK;

-(void)autoLoginYXSDK;

//退出登录
-(void)exitLogin;
@end
