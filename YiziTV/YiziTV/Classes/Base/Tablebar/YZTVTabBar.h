//
//  YZTVTabBar.h
//  YiziTV
//
//  Created by 井泉 on 16/6/15.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZTVTabBarButton.h"


#pragma mark 因为在UITabBar中已经声明过一个UITabBarDelegate协议，
#pragma mark 新增一个对外的代理函数，可以让我们自定义的协议继承自UITabBarDelegate，添加一个扩展函数。

@class YZTVTabBar;

@protocol YZTVTabBarDelegate <UITabBarDelegate>

//点击直播按钮
- (void)tabBarDidClickPlusButton;
//其他三个选择
-(void)clickTabarItemButton:(YZTVTabBarButton*)YZbtn;
@end

@interface YZTVTabBar : UITabBar

/**
 *  使用特定图片来创建按钮, 这样做的好处就是可扩展性. 拿到别的项目里面去也能换图片直接用
 *
 *  @param image         普通状态下的图片
 *  @param selectedImage 选中状态下的图片
 */
@property (nonatomic, weak) id<YZTVTabBarDelegate> tabBarDelegate;
@end
