//
//  SearchOptionView.h
//  Lightning
//
//  Created by 武春鹏 on 16/7/25.
//  Copyright © 2016年 武春鹏. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchOptionView : UIView

@property(nonatomic, strong) UIView * backView;

@property (nonatomic, copy) void (^itemBlock)(NSInteger tag);

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title;

//这里应该是传进一个model 或者 modeArray  具体传什么 你自己改一下
- (void)updateViewWithDataArray:(NSArray *)dataArray Color:(UIColor *)color;



@end
