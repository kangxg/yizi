//
//  UITextField+Category.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/21.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "UITextField+Category.h"

@implementation UITextField (Category)
-(void)setPlaceholder:(NSString *)placeholder withFont:(UIFont *)font color:(UIColor *)color
{
    
    NSMutableParagraphStyle *style =[[self.defaultTextAttributes objectForKey:NSParagraphStyleAttributeName] mutableCopy];
    
    style.minimumLineHeight =self.font.lineHeight - (self.font.lineHeight -font.lineHeight)/2;
    
    NSMutableAttributedString * attString=[[NSMutableAttributedString alloc]initWithString:placeholder];
    
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,color,NSForegroundColorAttributeName,style,NSParagraphStyleAttributeName, nil];
    
    
    [attString addAttributes:attrsDictionary range:NSMakeRange(0, placeholder.length)];
    
    self.attributedPlaceholder=attString;
    
    self.keyboardAppearance=UIKeyboardAppearanceDark;
    
    


}
@end
