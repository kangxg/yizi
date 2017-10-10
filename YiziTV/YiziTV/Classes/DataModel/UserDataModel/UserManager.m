//
//  UserManager.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/20.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "UserManager.h"
#import "NIMSDK.h"
#import "LoginViewController.h"
#import "AppDelegate.h"


@implementation UserManager
+(instancetype)shareInstaced
{
    static id _s;
    if (_s==nil) {
        _s=[[[self class]alloc]init];
    }
    return _s;
}
-(void)setUserInfo:(UserInfoModel *)userInfo
{
    _userInfo=userInfo;
    [NSKeyedArchiver archiveRootObject:_userInfo toFile:[self getPath]];
    
   
}

-(UserInfoModel*)getUserInfoModel
{
    UserInfoModel * userModel=[NSKeyedUnarchiver unarchiveObjectWithFile:[self getPath]];
    return userModel;

}
-(NSString *)getPath
{
    return [NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"Library/Caches/CurrentUser"];
    
}
-(void)exitLogin
{
    NSString * path=[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"Library/Caches/CurrentUser"];
    NSFileManager * manager=[NSFileManager defaultManager];
    
    
    
    if ([manager fileExistsAtPath:path]) {
        
        [manager removeItemAtPath:path error:nil];
    }
    
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error){
    
    
    }];
    
    
    AppDelegate * delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    LoginViewController * login=[[LoginViewController alloc]init];
    UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:login];
    delegate.window.rootViewController=nav;
    

    
}
-(void)loginYXSDK
{

//    NSLog(@"云信账号%@密码%@",self.userInfo.YXAcount,self.userInfo.YXToken);
    
    [[[NIMSDK sharedSDK]loginManager]login:self.userInfo.YXAcount token:self.userInfo.YXToken completion:^(NSError * _Nullable error) {
        if (error!=nil) {
            
            NSLog(@"登录云信错误信息===%@",error.description);
            
            UIAlertView * aler=[[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"登录出错%ld，请联系客服",error.code] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [aler show];
            
            
            [[UserManager shareInstaced]exitLogin];
            
        }else{
         NSLog(@"登录云信IM成功");
        
        }
        
    }];

}
-(void)autoLoginYXSDK
{
    [[[NIMSDK sharedSDK]loginManager]autoLogin:self.userInfo.YXAcount token:self.userInfo.YXToken];
    
}
@end
