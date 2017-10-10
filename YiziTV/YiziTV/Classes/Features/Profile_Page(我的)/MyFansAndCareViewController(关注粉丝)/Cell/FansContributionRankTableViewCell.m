//
//  FansContributionRankTableViewCell.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/20.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "FansContributionRankTableViewCell.h"


@interface FansContributionRankTableViewCell ()
{

    //标注
    UIImageView * signImageView;
    
    
    UIImageView * headImageView;
    
    
    //线框
    UIImageView * boxImageView;
    
    UILabel * nickNameLabel;
    
    UILabel * contributionLabel;
    
    
    UIView * line;
}
@end

@implementation FansContributionRankTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        signImageView=[[UIImageView alloc]initWithFrame:CGRectMake(16, 75.0/2-29/2, 24.5, 29)];
        [self addSubview:signImageView];
        
        
        headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(signImageView.frame)+20+3 , (75.0/2-53/2)+3, 47, 47)];
        
        [self setHeadImageBoxColor:[UIColor whiteColor]];
        [self addSubview:headImageView];
        
        
        boxImageView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(signImageView.frame)+20 , 75.0/2-53/2, 53, 53)];
        [self addSubview:boxImageView];
        
        nickNameLabel=[UILabel setLabelFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+10, signImageView.y-5, kScreenWidth-CGRectGetMaxX(headImageView.frame)-10-20, 15) Text:nil TextColor:[UIColor customColorWithString:@"0d0e0d"] font:[UIFont fontWithName:TextFontName size:14] textAlignment:NSTextAlignmentLeft];
        [self addSubview:nickNameLabel];
        
        contributionLabel=[UILabel setLabelFrame:CGRectMake(nickNameLabel.x, CGRectGetMaxY(nickNameLabel.frame)+8, nickNameLabel.width, 15) Text:nil TextColor:[UIColor customColorWithString:@"bab9b9"] font:[UIFont fontWithName:TextFontName size:12] textAlignment:NSTextAlignmentLeft];
        [self addSubview:contributionLabel];
        
        
        line=[[UIView alloc]initWithFrame:CGRectMake(0, 75.0-0.5, kScreenWidth, 0.5)];
        line.backgroundColor=[UIColor customColorWithString:@"e5e5e5"];
        [self addSubview:line];
        
    }
    return self;
    
}
-(void)setHeadImageBoxColor:(UIColor *)color
{
    CGFloat lineWith=0.5;
    float viewWidth=headImageView.width-0.5;
    UIBezierPath * path = [UIBezierPath bezierPath];
    path.lineWidth = lineWith;
    [color setStroke];
    
    
    
    [path moveToPoint:CGPointMake((sin(M_1_PI / 180 * 60)) * (viewWidth / 2), (viewWidth / 4))];
    [path addLineToPoint:CGPointMake((viewWidth / 2), 0)];
    [path addLineToPoint:CGPointMake(viewWidth - ((sin(M_1_PI / 180 * 60)) * (viewWidth / 2)), (viewWidth / 4))];
    [path addLineToPoint:CGPointMake(viewWidth - ((sin(M_1_PI / 180 * 60)) * (viewWidth / 2)), (viewWidth / 2) + (viewWidth / 4))];
    [path addLineToPoint:CGPointMake((viewWidth / 2), viewWidth)];
    [path addLineToPoint:CGPointMake((sin(M_1_PI / 180 * 60)) * (viewWidth / 2), (viewWidth / 2) + (viewWidth / 4))];
    [path closePath];
    
    CAShapeLayer * shapLayer = [CAShapeLayer layer];
    shapLayer.lineWidth = lineWith;
    shapLayer.strokeColor = color.CGColor;
    shapLayer.path = path.CGPath;

    headImageView.layer.mask=shapLayer;
    

    
    
    
    

}
-(void)setFansModel:(FansModel *)fansModel
{
    _fansModel=fansModel;
    nickNameLabel.text=fansModel.nickName;
    contributionLabel.text=[NSString stringWithFormat:@"贡献：%@",fansModel.contributionCount];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:fansModel.headImageUrl] placeholderImage:nil];
    
    
    

}
-(void)setSingImageView:(NSString *)imageName
{
    signImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"icon_no%@",imageName]];
    boxImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"user_no%@",imageName]];
    
    
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




@interface FansContributionTableViewCell ()
{
    
    UILabel * signRankLabel;
    
    UIImageView * headImageView;
    
    UILabel * nickNameLabel;
    
    UILabel * contributionLabel;
    
    
    UIView * line;


}
@end

@implementation FansContributionTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        signRankLabel=[UILabel setLabelFrame:CGRectMake(0, 0, 60.5, 63) Text:nil TextColor:[UIColor customColorWithString:@"0d0e0d"] font:[UIFont fontWithName:TextFontName size:14] textAlignment:NSTextAlignmentCenter];
        [self addSubview:signRankLabel];
        
        headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(69 , 63.0/2-36/2, 36, 36)];
        headImageView.layer.masksToBounds=YES;
        headImageView.layer.cornerRadius=headImageView.width/2;
        [self addSubview:headImageView];
        
        
        nickNameLabel=[UILabel setLabelFrame:CGRectMake(120.5, headImageView.y, kScreenWidth-CGRectGetMaxX(headImageView.frame)-10-20, 16) Text:nil TextColor:[UIColor customColorWithString:@"0d0e0d"] font:[UIFont fontWithName:TextFontName size:14] textAlignment:NSTextAlignmentLeft];
        [self addSubview:nickNameLabel];
        
        contributionLabel=[UILabel setLabelFrame:CGRectMake(nickNameLabel.x, CGRectGetMaxY(nickNameLabel.frame)+4, nickNameLabel.width, 15) Text:nil TextColor:[UIColor customColorWithString:@"bab9b9"] font:[UIFont fontWithName:TextFontName size:12] textAlignment:NSTextAlignmentLeft];
        [self addSubview:contributionLabel];
        
        
        line=[[UIView alloc]initWithFrame:CGRectMake(0, 63.0-0.5, kScreenWidth, 0.5)];
        line.backgroundColor=[UIColor customColorWithString:@"e5e5e5"];
        [self addSubview:line];
        
    }
    return self;
    
}

-(void)setFansModel:(FansModel *)fansModel
{
    _fansModel=fansModel;
    nickNameLabel.text=fansModel.nickName;
    contributionLabel.text=[NSString stringWithFormat:@"贡献：%@",fansModel.contributionCount];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:fansModel.headImageUrl] placeholderImage:nil];
    
    
    
    
}
-(void)setRankName:(NSString *)rank
{
    signRankLabel.text=rank;
}

@end
