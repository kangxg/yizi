//
//  YZLocationManager.h
//  YiziTV
//
//  Created by 梁飞 on 16/7/11.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZLocationManager : NSObject
+(instancetype)shareManagerInstance;

//开始定位
-(void)startLocation;

//获取定位城市
-(NSString*)getLocationCityName;

@end
