//
//  OAuthView.m
//  YiziTV
//
//  Created by 井泉 on 16/6/21.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "OAuthView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import <ShareSDKExtension/SSEBaseUser.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "UserInfoModel.h"
#import "YZTVTabBarController.h"
#import "UrlRequest.h"
#import "BindingMobilePhoneViewController.h"
#import "AppDelegate.h"

//#import <TencentOpenAPI/TencentOAuth.h>

@interface OAuthView ()
{

    UIButton *appButton;
    
    UIButton *wxbutton;
    UIButton *qqbutton;
}
@end

@implementation OAuthView

- (id)initWithFrame:(CGFloat)height QQ:(BOOL)isQQ WX:(BOOL)isWx
{
   
    CGRect finalFrame = CGRectMake(0, height, kScreenWidth, 142/2);
    self = [super initWithFrame:finalFrame];
    if (self) {
        self.frame = finalFrame;
        self.backgroundColor = [UIColor clearColor];
       
        if (isQQ&&isWx) {
            [self addCommonItem];
            [self QQAndWXLogin];
            
        }
        //安装QQ未安装微信
        else if (isQQ&&!isWx)
        {
             [self addCommonItem];
            [self addQQLogin];
        
        }else if (!isQQ&&isWx)
        {
            [self addCommonItem];
            [self addWXLogin];
            
        
        }
        
    }
    
   
   
    return self;
}

- (void)addCommonItem
{
    //分割线
    CALayer *lineLayer = [[CALayer alloc]init];
    lineLayer.backgroundColor = [[UIColor customColorWithString:@"#c8c8c8"] CGColor];
    //大小
    lineLayer.bounds = CGRectMake(0, 0 ,kScreenWidth - 132, 0.5);
    //墙上的位置
    lineLayer.position = CGPointMake(kScreenWidth / 2, 5);
    
    [self.layer  addSublayer:lineLayer];
    
    //分割线
    CALayer *maskLayer = [[CALayer alloc]init];
    maskLayer.backgroundColor = [[UIColor whiteColor] CGColor];
    //大小
    maskLayer.bounds = CGRectMake(0, 0 ,60, 10);
    //墙上的位置
    maskLayer.position = CGPointMake(kScreenWidth / 2, 5);
    
    [self.layer  addSublayer:maskLayer];

    UILabel *fastLoginLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    fastLoginLable.text = @"快速登录";
    fastLoginLable.font = [UIFont fontWithName:TextFontName size:12];
    fastLoginLable.textColor = [UIColor customColorWithString:@"#b7b6b6"];
    fastLoginLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:fastLoginLable];
    
}
-(void)QQAndWXLogin
{
    wxbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 53)];
    [wxbutton setImage:[UIImage imageNamed:@"share_weixin"] forState:UIControlStateNormal];
    wxbutton.center = CGPointMake(50, (10 + 26 + 106/2.0)/2);
    wxbutton.alpha = 0.0;
    [self addSubview:wxbutton];
    
    qqbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 53)];
    [qqbutton setImage:[UIImage imageNamed:@"share_qq"] forState:UIControlStateNormal];
    qqbutton.center = CGPointMake(self.bounds.size.width - 50, (10 + 26 + 106/2.0)/2);
    qqbutton.alpha = 0.0;
    [qqbutton addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchUpInside];
    [wxbutton addTarget:self action:@selector(wxLogin) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:qqbutton];
    
    [UIView transitionWithView:qqbutton duration:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        wxbutton.center = CGPointMake(self.bounds.size.width/2 - 106/2, (10 + 26 + 106/2.0)/2);
        wxbutton.alpha = 1.0;
        qqbutton.center = CGPointMake(self.bounds.size.width/2 + 106/2, (10 + 26 + 106/2.0)/2);
        qqbutton.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];

}
-(void)addQQLogin
{

    
    
    qqbutton = [[UIButton alloc] initWithFrame:CGRectMake(self.width/2-53/2,self.height-53, 53, 53)];
    [qqbutton setImage:[UIImage imageNamed:@"share_qq"] forState:UIControlStateNormal];   
    [qqbutton addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:qqbutton];
    
    
    

    
}
-(void)addWXLogin
{
    
    wxbutton = [[UIButton alloc] initWithFrame:CGRectMake(self.width/2-53/2,self.height-53, 53, 53)];
    [wxbutton setImage:[UIImage imageNamed:@"share_weixin"] forState:UIControlStateNormal];
    [wxbutton addTarget:self action:@selector(wxLogin) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:wxbutton];

    
    
    

}
#pragma mark 微信登陆
- (void)wxLogin
{
    NSLog(@"微信登陆");
    

    [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeWechat
                                   onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                       
                                       //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
                                       //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
//                                       associateHandler (user.uid, user, user);
                                       NSLog(@"rawData：%@",user.rawData);
                                       NSLog(@"credential：%@",user.credential);
                                       
                                       NSMutableDictionary *thirdLoginInfoDic = [[NSMutableDictionary alloc] init];
                                       thirdLoginInfoDic[@"deviceId"] = kDeviceId;
                                       thirdLoginInfoDic[@"mecheck"] = @"123456";
                                       thirdLoginInfoDic[@"open_id"] = [[user rawData]valueForKey:@"openid"];//QQ的uid就是openId
                                       thirdLoginInfoDic[@"login_type"] = @"wechat";
                                       thirdLoginInfoDic[@"user.head_photo"] = user.icon;
                                       thirdLoginInfoDic[@"user.nickname"] = user.nickname;
                                       thirdLoginInfoDic[@"user.gender"] = [NSNumber numberWithInt:[user gender]];
                                       
                                       NSLog(@"%@", thirdLoginInfoDic);
                                       NSLog(@"uid:%@", user.uid);
                                       
                                       [self threeLoginWithDic:thirdLoginInfoDic];
                                       
                                   }
                                onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                    
                                    NSLog(@"=======%@",error.description);
                                    [self.delegate failure];
                                    if (state == SSDKResponseStateSuccess)
                                    {
                                        
                                    }
                                    
                                }];
}

#pragma mark qq登陆
- (void)qqLogin
{
    NSLog(@"QQ登陆");
    [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeQQ
                                   onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                       
                                       //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
                                       //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
//                                       associateHandler (user.uid, user, user);
                                       NSLog(@"dd%@",user.rawData);
                                       NSLog(@"dd%@",user.credential);
                                       NSMutableDictionary *thirdLoginInfoDic = [[NSMutableDictionary alloc] init];
                                       thirdLoginInfoDic[@"deviceId"] = kDeviceId;
                                       thirdLoginInfoDic[@"mecheck"] = @"123456";
                                       thirdLoginInfoDic[@"open_id"] = user.uid;//QQ的uid就是openId
                                       thirdLoginInfoDic[@"login_type"] = @"qq";
                                       thirdLoginInfoDic[@"user.head_photo"] = user.icon;
                                       thirdLoginInfoDic[@"user.nickname"] = user.nickname;
                                       thirdLoginInfoDic[@"user.gender"] = [NSNumber numberWithInt:[user gender]];

                                       NSLog(@"%@", thirdLoginInfoDic);
                                       
                                       
                                       
                                      [self threeLoginWithDic:thirdLoginInfoDic];

                                   }
                                onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                    
                                    NSLog(@"=======%@",error.description);
                                    [self.delegate failure];

                                    if (state == SSDKResponseStateSuccess)
                                    {
                                        
                                    }
                                    
                                }];
}

#pragma mark 第三方登录调用服务器
-(void)threeLoginWithDic:(NSMutableDictionary*)thirdLoginInfoDic
{

    AppDelegate * delegate=[[UIApplication sharedApplication]delegate];
    
    
      WKProgressHUD * hud  = [WKProgressHUD showInView:delegate.window withText:@"" animated:YES];
    
    
    [UrlRequest postRequestWithUrl:kJointLoginActionUrl parameters:thirdLoginInfoDic success:^(NSDictionary * jsonDict) {
        NSLog(@"第三方登录请求返回数据:%@", jsonDict);
        [hud dismiss:YES];
        if([jsonDict[@"code"] intValue] == 0)
        {
            /*
             *存储登陆数据到本地
             *
             ***/
            UserInfoModel *userInfoModel = [[UserInfoModel alloc] init];
            userInfoModel.deviceId = kDeviceId;
            userInfoModel.user_token = jsonDict[@"user_token"];
            long long  uid=[[jsonDict valueForKey:@"user_id"]longLongValue];
            userInfoModel.uid=[NSString stringWithFormat:@"%lld",uid];
            userInfoModel.YXAcount=jsonDict[@"vcloud_id"];
            userInfoModel.YXToken=jsonDict[@"vcloud_token"];
            [[UserManager shareInstaced] setUserInfo:userInfoModel];
            [[UserManager shareInstaced]loginYXSDK];
            
            if ([self.delegate respondsToSelector:@selector(success:)]) {
                [self.delegate success:[jsonDict[@"need_phone"] intValue]];
            }
        }
        
    } fail:^(NSError *error) {
        
    }];




}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
