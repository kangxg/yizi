//
//  SettingTableViewCell.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/24.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        CGFloat labelWidth=[UILabel getLabelWidthWithText:@"账号安全" wordSize:16 height:20];
        self.leftTitleLabel=[UILabel setLabelFrame:CGRectMake(16, 19, labelWidth, 20) Text:@"" TextColor:[UIColor customColorWithString:@"0d0e0d"] font:[UIFont fontWithName:TextFontName size:16] textAlignment:NSTextAlignmentLeft];
        [self addSubview:self.leftTitleLabel];
        
        
        self.line=[[UIView alloc]initWithFrame:CGRectMake(16, 58.5, kScreenWidth-16, 0.5)];
        self.line.backgroundColor=[UIColor customColorWithString:@"d9d9d9"];
        [self addSubview:self.line];
        
        
        self.rightImage=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-16-7.5, 23, 7.5, 13)];
        
        self.rightImage.image=[UIImage imageNamed:@"set_arrow"];
        [self addSubview:self.rightImage];
        
        
    }
    return self;
}
@end
