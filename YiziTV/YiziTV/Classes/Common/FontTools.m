//
//  FontTools.m
//  YiziTV
//
//  Created by 井泉 on 16/7/14.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "FontTools.h"

@implementation FontTools

+ (CGRect)getTextSizeWithSize:(CGFloat)size font:(NSString*)font string:(NSString*)str
{
    //设置字体的大小
    UIFont *myFont = [UIFont fontWithName:font size:size];
    NSDictionary *dict = @{NSFontAttributeName:myFont};
    //设置文本能占用的最大宽高
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    
    CGRect rect =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    return rect;
}

+ (CGRect)getTextSizeWithSize:(CGFloat)size font:(NSString*)font string:(NSString*)str maxWidth:(NSInteger)width
{
    CGRect rect = [self getTextSizeWithSize:size font:font string:str];
    CGRect Result;
    if(rect.size.width > width)
    {
        Result = CGRectMake(0, 0, width, rect.size.height);
    }
    else{
        Result = rect;
    }
    
    return Result;
}

@end
