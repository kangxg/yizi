//
//  DeviceInfo.m
//  YiziTV
//
//  Created by 井泉 on 16/6/18.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "DeviceInfo.h"

CGFloat const gestureMinimumTranslation = 20.0;

@implementation DeviceInfo

//获取DeviceId
+(NSString *)getDeviceId
{
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}


#pragma mark 获取机器信息
+(NSString *)getUser_agent
{
    NSString * agentStr  = [NSString stringWithFormat:@"[%@;%@;%@;%@;%@;%@;%@]",[self networkingStatesFromStatebar],[self getCurrentModel],@"iOS",[self getSystemVersion],[self getScreenScale],@"10001",[self getCurrentLanguage]];
    return agentStr;
}

//获取网络状态
+(NSString *)networkingStatesFromStatebar {
    // 状态栏是由当前app控制的，首先获取当前app
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    int type = 0;
    for (id child in children) {
        if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    
    NSString *stateString = @"wifi";
    switch (type) {
        case 0:
            stateString = @"notReachable";
            break;
            
        case 1:
            stateString = @"2G";
            break;
            
        case 2:
            stateString = @"3G";
            break;
            
        case 3:
            stateString = @"4G";
            break;
            
        case 4:
            stateString = @"LTE";
            break;
            
        case 5:
            stateString = @"wifi";
            break;
            
        default:
            break;
    }
    return stateString;
}

//获取当前时间
+(NSString *)getDusturbTime
{
    NSDate * date =[NSDate date];
    NSTimeInterval sec = [date timeIntervalSince1970];
    return  [NSString stringWithFormat:@"%.0lf",sec*1000];
}
//获取设备名称
+(NSString *)getDeviceName
{
    UIDevice *device_=[[UIDevice alloc] init];
    return device_.name;
}
//获取设备型号
+(NSString *)getCurrentModel
{
    return  [UIDevice currentDevice].model;
}
//获取系统版本
+(NSString *)getSystemVersion
{
    UIDevice *device_=[[UIDevice alloc] init];
    return device_.systemVersion;
}
//获取客户端语言
+(NSString *)getCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}
//获取分辨率
+(NSString *)getScreenScale
{
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    return [NSString stringWithFormat:@"%.0f*%.0f",kScreenWidth*scale_screen,kScreenHeight*scale_screen];
}

+(NSString*)getCurrentAPPVision
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    return app_Version;
}


@end
