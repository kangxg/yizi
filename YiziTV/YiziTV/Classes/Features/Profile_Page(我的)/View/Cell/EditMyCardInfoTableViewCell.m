//
//  EditMyCardInfoTableViewCell.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/22.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "EditMyCardInfoTableViewCell.h"

@implementation EditMyCardInfoTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        self.backgroundColor=[UIColor whiteColor];
        self.titleLabel=[UILabel setLabelFrame:CGRectMake(16, 60/2-44/2, 100, 44) Text:nil TextColor:[UIColor customColorWithString:@"909290"] font:[UIFont fontWithName:TextFontName size:16] textAlignment:NSTextAlignmentLeft];
        [self addSubview:self.titleLabel];
        
        self.textFiled=[[UITextField alloc]initWithFrame:CGRectMake(100, 60/2-44/2, kScreenWidth-32-100, 44)];
        self.textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textFiled.textColor=[UIColor customColorWithString:@"0d0e0d"];
        self.textFiled.returnKeyType=UIReturnKeyDone;
        self.textFiled.font=[UIFont fontWithName:TextFontName size:16];
        self.textFiled.keyboardAppearance=UIKeyboardAppearanceDark;
        [self addSubview:self.textFiled];
        
        
        self.line=[[UIView alloc]initWithFrame:CGRectMake(16, 60-0.5, kScreenWidth-16, 0.5)];
        self.line.backgroundColor=[UIColor customColorWithString:@"d9d9d9"];
        [self addSubview:self.line];
        
        
        
    }
    return self;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation SelectMyCardInfoTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        self.backgroundColor=[UIColor whiteColor];
        self.titleLabel=[UILabel setLabelFrame:CGRectMake(16, 60/2-44/2, 100, 44) Text:nil TextColor:[UIColor customColorWithString:@"909290"] font:[UIFont fontWithName:TextFontName size:16] textAlignment:NSTextAlignmentLeft];
        [self addSubview:self.titleLabel];
        
        self.selectLabel=[UILabel setLabelFrame:CGRectMake(100, 60/2-44/2, kScreenWidth-32-100, 44)Text:nil TextColor:[UIColor customColorWithString:@"0d0e0d"] font:[UIFont fontWithName:TextFontName size:16] textAlignment:NSTextAlignmentLeft];
        self.selectLabel.userInteractionEnabled=YES;
        [self addSubview:self.selectLabel];
        
        
        self.line=[[UIView alloc]initWithFrame:CGRectMake(16, 60-0.5, kScreenWidth-16, 0.5)];
        self.line.backgroundColor=[UIColor customColorWithString:@"d9d9d9"];
        [self addSubview:self.line];
        
        
        
    }
    return self;
    
}


@end




@implementation EditHeadImageViewTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor whiteColor];
        self.titleLabel=[UILabel setLabelFrame:CGRectMake(16, 75/2-44/2, 100, 44) Text:nil TextColor:[UIColor customColorWithString:@"909290"] font:[UIFont fontWithName:TextFontName size:16] textAlignment:NSTextAlignmentLeft];
        [self addSubview:self.titleLabel];
        
        
        self.headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-16-45, 15, 45, 45)];
        self.headImageView.layer.masksToBounds=YES;
        self.headImageView.layer.cornerRadius=45/2;
        self.headImageView.userInteractionEnabled=YES;
        [self addSubview:self.headImageView];
  
        
        
    }
    return self;

}

@end
