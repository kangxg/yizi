//
//  AppDelegate.m
//  YiziTV
//
//  Created by 井泉 on 16/6/14.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "YZTVTabBarController.h"
#import "HomeViewController.h"
#import "RequestPublicKey.h"
#import "LoginViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"
#import "EditMyPersonInfoViewController.h"
#import "BindingMobilePhoneViewController.h"
#import "NIMSDK.h"
#import "NIMCustomObject.h"
#import "AttachmentDecoder.h"

#import "GiftTestViewController.h"
#import "UMMobClick/MobClick.h"

#import "YZLocationManager.h"

@interface AppDelegate ()<UIScrollViewDelegate,UIAlertViewDelegate>
{
    UIScrollView *  scroll;
}
@end

@implementation AppDelegate
-(void)registerUmeng
{
    UMConfigInstance.appKey = @"57628ba4e0f55adc1000117f";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];

}
-(void)registerNIMSDK
{
    [[NIMSDK sharedSDK]registerWithAppID:@"2a467f4e50edbc30a6255513b5847742" cerName:@"yzjobproduction"];
    


}
-(void)requestLocation
{
    [[YZLocationManager shareManagerInstance]startLocation];

}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    [NIMCustomObject registerCustomDecoder:[[AttachmentDecoder alloc]init]];
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [self registerNIMSDK];
    [self shareSDKInit];
    [self registerUmeng];
    [self requestLocation];

    [self makeRootViewController];
    
    [self makGuideView];
    
    return YES;
}
#pragma mark 创建试图控制器和跟视图
-(void)makeRootViewController
{
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    if (user.user_token.length) {
        
        YZTVTabBarController *tb = [[YZTVTabBarController alloc] init];
        self.window.rootViewController = tb;
        NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
        [paramDic setValue:user.user_token forKey:@"user_token"];
        [paramDic setValue:[DeviceInfo getDeviceId] forKey:@"deviceId"];
        [paramDic setValue:[NSNumber numberWithInt:1] forKey:@"refresh_token"];
        [paramDic setObject:@"mcheck" forKey:@"mcheck"];
    
        NSLog(@"userToken++++++%@",user.user_token);
        [UrlRequest postRequestWithUrl:kShowInfoUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
            
            NSLog(@"showInfo===%@",jsonDict);
            UserManager * manager=[UserManager shareInstaced];
            UserInfoModel * user=[manager getUserInfoModel];
            user.user_token=[jsonDict valueForKey:@"user_token"];
            user.YXAcount=jsonDict[@"vcloud_id"];
            user.YXToken=jsonDict[@"vcloud_token"];
            [manager setUserInfo:user];
            
            int isiphone=[[jsonDict valueForKey:@"need_phone"]intValue];
            if (isiphone) {
                BindingMobilePhoneViewController * bingdingVC=[[BindingMobilePhoneViewController alloc]init];
                UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:bingdingVC];
                self.window.rootViewController=nav;
                
                
            }
            else{
            
            int isFinishInfo=[[jsonDict valueForKey:@"need_evpi"]intValue];
                if (isFinishInfo) {
                    
                    EditMyPersonInfoViewController * editVC=[[EditMyPersonInfoViewController alloc]init];
                    editVC.isHiddenBackButton=YES;
                    editVC.isChangeRootVC=YES;
                    editVC.titleString=@"完善个人信息";
                    UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:editVC];
                    
                    self.window.rootViewController=nav;
                    
                }
            
            
                
                
                
            }
            
            

            
          [[UserManager shareInstaced]loginYXSDK];
            
            
            [self checkUpdateVison];
            
            
        } fail:^(NSError *error) {
            
        }];
        
        
        

        
    }else
    {
        LoginViewController *loginView = [[LoginViewController alloc] init];
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:loginView];
        self.window.rootViewController = nav;

    }
    
    /*
     *测试礼物
     */
//    GiftTestViewController * bingdingVC=[[GiftTestViewController alloc]init];
//    UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:bingdingVC];
//    [nav setNavigationBarHidden:YES];
//    self.window.rootViewController=nav;

}
#pragma mark 检查版本更新
-(void)checkUpdateVison
{
    
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:[DeviceInfo getCurrentAPPVision] forKey:@"cur_version"];
    
    NSLog(@"paramDicparamDicparamDicparamDic%@",paramDic);
    [UrlRequest postRequestWithUrl:kUpdateVision parameters:paramDic success:^(NSDictionary *jsonDict) {
        NSLog(@"++++++++++++++++++kUpdateVision%@",jsonDict);
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            //YZUpdateVisionNullType,
//            YZUpdateVisionNeedType,
//            YZUpdateVisionMustType,
            NSInteger status=[[jsonDict valueForKey:@"update_state"]integerValue];
    
            switch (status) {
            case YZUpdateVisionNeedType:
                {
                    
                    UIAlertView * aler=[[UIAlertView alloc]initWithTitle:nil message:@"发现新版本" delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"马上更新", nil];
                    aler.tag=YZUpdateVisionNeedType;
                    
                    [aler show];
                
                }
                    break;
            case YZUpdateVisionMustType:
                {
                
                   
                    UIAlertView * aler=[[UIAlertView alloc]initWithTitle:nil message:@"发现新版本" delegate:self cancelButtonTitle:nil otherButtonTitles:@"马上更新", nil];
                    aler.tag=YZUpdateVisionMustType;
                    
                    [aler show];
                
                }
                    break;
                    
                    
                default:
                    break;
            }
            
            
            
        }
        
    } fail:^(NSError *error) {
        
    }];


}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case YZUpdateVisionNeedType:
        {
            if (buttonIndex==1) {
                
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/jie-zou-da-shi/id1123876466?mt=8"]];
                
            }
        }
            break;
        case YZUpdateVisionMustType:
        {
        
            if (buttonIndex==0) {
                
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/jie-zou-da-shi/id1123876466?mt=8"]];

            }
        }
            break;
            
        default:
            break;
    }
   
}
#pragma mark 创建引导页
-(void)makGuideView
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaults objectForKey:@"versions"];
    NSLog(@"+++++++%@",string);
    //这里的string是versions键的值，肯定是空的，没有设置过，判断是否是首次使用
    NSString *app_Version = [DeviceInfo getCurrentAPPVision];
    if (string == nil||(![string isEqualToString:app_Version])) {
        [self createNavGuideView];
    }else{
    
    
    }

}

-(void)createNavGuideView
{

    
    
    scroll=[[UIScrollView alloc]init];
    scroll.frame=CGRectMake(0, 0,kScreenWidth, kScreenHeight);
    scroll.delegate=self;
    scroll.pagingEnabled=YES;
    scroll.contentSize=CGSizeMake(kScreenWidth*GuideCount , kScreenHeight);
    scroll.showsHorizontalScrollIndicator=YES;
    scroll.showsVerticalScrollIndicator=NO;
    scroll.bounces=NO;
    scroll.directionalLockEnabled=YES;
    
    for (int i =0; i<GuideCount; i++) {
        
        UIImageView * iView=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight)];
        iView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d_%d_%d",(int)kScreenWidth,(int)kScreenHeight,i]];
        [scroll addSubview:iView];
        
        if (i==GuideCount-1) {
          
            iView.userInteractionEnabled=YES;
            UIButton * beginButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2-155/2, kScreenHeight/2+kScreenHeight/4, 155, kScreenHeight/5)];
            [iView addSubview:beginButton];
            [beginButton addTarget:self action:@selector(beginAPP) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
    }
     [self.window addSubview:scroll];

}
-(void)beginAPP
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        scroll.alpha=0;
        
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [scroll removeFromSuperview];
        });


    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *app_Version = [DeviceInfo getCurrentAPPVision];
    [userDefaults setObject:app_Version forKey:@"versions"];
    [userDefaults synchronize];
  }];

}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)shareSDKInit
{
    [ShareSDK registerApp:@"14223c96757da"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxd387dab8311a12e1"
                                       appSecret:@"df50a3b2fb55ea2e4adbd2721803fbff"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105394444"
                                      appKey:@"0tidtj9CqOEYb0KQ"
                                    authType:SSDKAuthTypeBoth];
                 break;
                          default:
                 break;
         }
     }];
}
@end
