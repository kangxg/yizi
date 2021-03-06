//
//  UIImageView+Category.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/21.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Category)

//模糊加黑色蒙层在window 上
+(UIImageView*)blurImageWithView:(UIView*)view;
//生成gif图       名字  帧数
+(UIImageView*)imageViewWithGifFileName:(NSString*)name gifCount:(NSInteger)giftCount frame:(CGRect)frame;

@end
