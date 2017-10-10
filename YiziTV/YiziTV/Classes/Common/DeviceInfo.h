//
//  DeviceInfo.h
//  YiziTV
//
//  Created by 井泉 on 16/6/18.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject

//获取DeviceId
+(NSString *)getDeviceId;
+(NSString *)getUser_agent;
//获取网络状态
+(NSString *)networkingStatesFromStatebar;
//获取当前时间
+(NSString *)getDusturbTime;
//获取设备名称
+(NSString *)getDeviceName;
//获取设备型号
+(NSString *)getCurrentModel;
//获取系统版本
+(NSString *)getSystemVersion;
//获取客户端语言
+(NSString *)getCurrentLanguage;
//获取分辨率
+(NSString *)getScreenScale;

//获取当前应用版本号
+(NSString*)getCurrentAPPVision;

//获取pan 滑动方向




@end
