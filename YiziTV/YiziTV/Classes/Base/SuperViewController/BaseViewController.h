//
//  BaseViewController.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/17.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property(strong,nonatomic,readwrite)UILabel * topTitleLabel;
-(void)setTitle:(NSString *)title;
@end
