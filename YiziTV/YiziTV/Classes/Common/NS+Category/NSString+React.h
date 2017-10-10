//
//  NSString+React.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/30.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (React)
-(CGFloat)getWidthWithAttributeString:(NSMutableAttributedString*)attributeString labelheight:(CGFloat)height;


-(CGFloat)getHeightWithAttributeString:(NSMutableAttributedString*)attributeString labelwidth:(CGFloat)width;

@end
