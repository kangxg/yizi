//
//  NSString+React.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/30.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "NSString+React.h"

@implementation NSString (React)
-(CGFloat)getWidthWithAttributeString:(NSMutableAttributedString *)attributeString labelheight:(CGFloat)height
{

    NSRange range = NSMakeRange(0, attributeString.length);
   NSDictionary *dic = [attributeString attributesAtIndex:0 effectiveRange:&range];
    
    CGRect tmpRect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
    
    return tmpRect.size.width;
}
-(CGFloat)getHeightWithAttributeString:(NSMutableAttributedString *)attributeString labelwidth:(CGFloat)width
{
    
    NSRange range = NSMakeRange(0, attributeString.length);
    NSDictionary *dic = [attributeString attributesAtIndex:0 effectiveRange:&range];
    
    CGRect tmpRect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil];
    
    return tmpRect.size.height;
}
@end
