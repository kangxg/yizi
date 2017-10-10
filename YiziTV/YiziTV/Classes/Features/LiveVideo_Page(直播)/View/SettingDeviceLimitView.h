//
//  SettingDeviceLimitView.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/27.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>

//设置直播前硬件权限问题
@interface SettingDeviceLimitView : UIView

@property(copy,nonatomic)void(^closeSettingDeviceLimitView)(void);
-(void)setButtonStatus:(YZDeviceErrorStatus)status;

@end
