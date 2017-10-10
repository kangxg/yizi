//
//  FontTools.h
//  YiziTV
//
//  Created by 井泉 on 16/7/14.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FontTools : NSObject

+ (CGRect)getTextSizeWithSize:(CGFloat)size font:(NSString*)font string:(NSString*)str;
+ (CGRect)getTextSizeWithSize:(CGFloat)size font:(NSString*)font string:(NSString*)str maxWidth:(NSInteger)width;

@end
