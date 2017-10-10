//
//  EnterRoomView.m
//  YiziTV
//
//  Created by 井泉 on 16/7/14.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "EnterRoomMessageView.h"
#import "FontTools.h"

@interface EnterRoomMessageView ()
{
    NSString *nikename;
}

@end

@implementation EnterRoomMessageView


- (id)initFormName:(NSString*)nickname withImageUrl:(NSString *)imageUrl
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        NSString *str = @"进入了房间";
        _headIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        _headIconImageView.contentMode = UIViewContentModeScaleAspectFit;
        CGRect nicknameLableRect = [FontTools getTextSizeWithSize:28 / 2.0 font:TextFontName string:nickname maxWidth:100];
        NSLog(@"%@", NSStringFromCGRect(nicknameLableRect));
        CGRect enterRoomLableRect = [FontTools getTextSizeWithSize:28 / 2.0 font:TextFontName string:str maxWidth:100];
    
        _headIconImageView.image = [UIImage imageNamed:@"head"];
        
        [_headIconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"head"]];
        //头像圆角
        _headIconImageView.layer.masksToBounds=YES;
        _headIconImageView.layer.cornerRadius = _headIconImageView.size.height / 2.0;
        //边框
        _headIconImageView.layer.borderWidth = 2.0f;
        _headIconImageView.layer.borderColor = [UIColor customColorWithString:@"#ffd200"].CGColor;
        
        UIView *sideWordsContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, nicknameLableRect.size.width + enterRoomLableRect.size.width + _headIconImageView.size.width / 2.0 + 10 + 11, 48 / 2.0)];
        sideWordsContainerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
        //圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sideWordsContainerView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(24, 24)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = sideWordsContainerView.bounds;
        maskLayer.path = maskPath.CGPath;
//        sideWordsContainerView.layer.masksToBounds=YES;
//        sideWordsContainerView.layer.mask = maskLayer;
        sideWordsContainerView.layer.masksToBounds=YES;
        sideWordsContainerView.layer.cornerRadius = sideWordsContainerView.size.height / 2.0;
        sideWordsContainerView.layer.borderWidth = 2.0f;
        sideWordsContainerView.layer.borderColor = [UIColor customColorWithString:@"#ffd200"].CGColor;
        sideWordsContainerView.center = CGPointMake(sideWordsContainerView.size.width / 2.0 + _headIconImageView.size.width / 2.0, _headIconImageView.center.y);

        [self addSubview:sideWordsContainerView];
        
        UILabel *nikenameLable = [[UILabel alloc] initWithFrame:nicknameLableRect];
        nikenameLable.font = [UIFont fontWithName:TextFontName size:28 / 2.0];
        nikenameLable.backgroundColor = [UIColor clearColor];
        nikenameLable.textColor = [UIColor customColorWithString:@"#ffd200"];
        nikenameLable.text = nickname;
        nikenameLable.center = CGPointMake(_headIconImageView.size.width / 2.0 + nikenameLable.size.width / 2.0 + 5, sideWordsContainerView.size.height / 2.0 - 0.5);
        [sideWordsContainerView addSubview:nikenameLable];
        NSLog(@"%@", NSStringFromCGRect(nikenameLable.frame));

        //”进入了房间“
        UILabel *enterStrLable = [[UILabel alloc] initWithFrame:enterRoomLableRect];
        enterStrLable.font = [UIFont fontWithName:TextFontName size:28 / 2.0];
        enterStrLable.backgroundColor = [UIColor clearColor];
        enterStrLable.textColor = [UIColor whiteColor];
        enterStrLable.text = @"进入了房间";
        enterStrLable.center = CGPointMake(CGRectGetMaxX(nikenameLable.frame) + 5 + enterStrLable.size.width / 2.0, nikenameLable.center.y);
        [sideWordsContainerView addSubview:enterStrLable];
        
        [self addSubview:_headIconImageView];
        self.frame = CGRectMake(0, 0, CGRectGetMaxX(sideWordsContainerView.frame), CGRectGetMaxY(_headIconImageView.frame));

    }
    
    return self;
}


@end
