//
//  CityTableViewCell.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/26.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "CityTableViewCell.h"

@interface CityTableViewCell ()
{
    UILabel * nameLabel;
    UIImageView * selectButton;
    UIView * line;
    

}

@end

@implementation CityTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        nameLabel=[UILabel setLabelFrame:CGRectMake(16, 0, 100, 59) Text:nil TextColor:[UIColor customColorWithString:@"0d0e0d"] font:[UIFont fontWithName:TextFontName size:17] textAlignment:NSTextAlignmentLeft];
        [self addSubview:nameLabel];
        
        
        selectButton=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-20-16, 59/2-20/2, 20, 20)];
        selectButton.image=[UIImage imageNamed:@"circle"];
        selectButton.highlightedImage=[UIImage imageNamed:@"circle_select"];
        selectButton.userInteractionEnabled=YES;
        [self addSubview:selectButton];
        
        
        line=[[UIView alloc]initWithFrame:CGRectMake(16, 58.5, kScreenWidth-16, 0.5)];
        line.backgroundColor=[UIColor customColorWithString:@"d9d9d9"];
        [self addSubview:line];
        
        
        
        
        
    }
    return self;
    
}
-(void)setSelectStatus:(BOOL)selectStatus
{
    [UIView animateWithDuration:0.25 animations:^{
        selectButton.highlighted=selectStatus;
    }];
   
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
