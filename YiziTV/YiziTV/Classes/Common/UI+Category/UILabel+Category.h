//
//  UILabel+Category.h
//  kangxiaobai
//
//  Created by 武春鹏 on 15/9/6.
//  Copyright (c) 2015年 kangxiaobai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Category)

//获取label的宽度
+ (CGFloat)getLabelWidthWithText:(NSString *)text wordSize:(CGFloat)wordSize height:(CGFloat)height;

//获取label的高度
+ (CGFloat)getLabelHeightWithText:(NSString *)text wordSize:(CGFloat)wordSize width:(CGFloat)width;


//创建label
+(UILabel*)setLabelFrame:(CGRect)frame Text:(NSString*)text TextColor:(UIColor*)color font:(UIFont*)font textAlignment:(NSTextAlignment)textAlignment;

@end
