//
//  UIView+Extension.h
//  kangxiaobai
//
//  Created by 小白科技 on 15/8/27.
//  Copyright (c) 2015年 kangxiaobai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

//截取界面转化成图片
-(UIImage *)convertViewToImage;

@end
