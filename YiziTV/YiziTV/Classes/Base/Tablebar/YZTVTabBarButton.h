//
//  YZTVTabBarButton.h
//  YiziTV
//
//  Created by 井泉 on 16/6/15.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZTVTabBarButton : UIButton
@property(strong,nonatomic) UIImageView * iconImage;
@property(strong,nonatomic) UILabel * iconTitle;
-(void)setIconTitleHighlightColor:(BOOL)highlight;

@end
