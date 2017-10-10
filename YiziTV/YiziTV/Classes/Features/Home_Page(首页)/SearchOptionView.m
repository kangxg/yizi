//
//  SearchOptionView.m
//  Lightning
//
//  Created by 武春鹏 on 16/7/25.
//  Copyright © 2016年 武春鹏. All rights reserved.
//

#import "SearchOptionView.h"

CGFloat const edge = 16.f;//边距

@interface SearchOptionView()

@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation SearchOptionView

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        CGFloat labelHeight = 15.f + 14.f + 15.f;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(edge, 0, kScreenWidth - 2.f * edge, labelHeight)];
        self.titleLabel.textColor = [UIColor customColorWithString:@"818381"];
        self.titleLabel.font = [UIFont systemFontOfSize:14.f];
        self.titleLabel.text = title;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.titleLabel];
        
        
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), kScreenWidth, 0.f)];
        [self addSubview:self.backView];
        
    }
    return self;
}

- (void)updateViewWithDataArray:(NSArray *)dataArray Color:(UIColor *)color
{
    if (!dataArray.count)
    {
        return;
    }
    
    
    UIButton * lastButton = nil;
    
    for (NSInteger i=0;i<dataArray.count;i++)
    {
        NSString * title = [dataArray objectAtIndex:i];
        
        UIButton * button = [self getItemButtonWithTitle:title Color:color];
        
        button.tag = i;
        
        if (lastButton)
        {
            button.x = lastButton.x + lastButton.width + 10.f;
            button.y = lastButton.y;
        }
        else
        {
            button.x = edge;
            button.y = 0.f;
        }
        
        if (button.x + button.width > self.backView.width - 10.f)
        {
            button.x = edge;
            button.y = lastButton.y + lastButton.height + 13.f;
        }
        [self.backView addSubview:button];
        
        [button addTarget:self action:@selector(buttonMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        lastButton = button;
        
        [self updateItemButtonBackViewWithLastButton:lastButton];
    }
}

/*** 调整backView的高度 最后要根据backView的高度 确定整个view的高度 ***/
- (void)updateItemButtonBackViewWithLastButton:(UIButton *)lastButton
{
    self.backView.height = lastButton.y + lastButton.height + 40.f-15.f;
}

- (UIButton *)getItemButtonWithTitle:(NSString *)title Color:(UIColor *)color
{
    CGFloat maxWidth = kScreenWidth - 2.f * edge;//最大宽度不能超过屏幕宽度减去左右距离
    
    CGFloat fnt = 13.f;//字号
    
    CGFloat buttonHeight = fnt + 10.f;//文字上下各留5的距离

    CGFloat titleWidth = [UILabel getLabelWidthWithText:title wordSize:fnt height:buttonHeight];
    CGFloat buttonWidth = titleWidth + 20.f;//文字左右各留10的距离
    
    if (buttonWidth > maxWidth)
    {
        buttonWidth = maxWidth;
    }
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = buttonHeight/2.f;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor customColorWithString:@"ffffff"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:fnt];
    button.backgroundColor = color;
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;//文字太长 结尾...
    
    return button;
}

- (void)buttonMethod:(UIButton *)button
{
    if (self.itemBlock)
    {
        self.itemBlock(button.tag);
    }
}

@end
