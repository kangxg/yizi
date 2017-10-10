//
//  ReceiveCardTableViewCell.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/21.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "ReceiveCardTableViewCell.h"

@interface ReceiveCardTableViewCell ()
{
    //头像
    UIImageView * headImageView;
    
    //名字
    UILabel * nameLabel;
    
    //所在城市
    UILabel * locationCityLabel;
    
    //毕业院校和专业
    UILabel * schoolLabel;
    
    //目标岗位
    UILabel * wantJobLabel;
    
    //所在地image
    UIImageView * locationCityIcon;
    //学校image
    UIImageView * schoolIcon;
    //wantJob Icon
    UIImageView * wantJobIcon;
    
    //收到名片的时间
    UILabel * receiveTimeLabel;
    
    
    UIView * verLine;
    
    

}
@end

@implementation ReceiveCardTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        self.backgroundColor=[UIColor customColorWithString:@"#eeeeee"];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        verLine=[[UIView alloc]initWithFrame:CGRectMake(20, 0, 0.5, 120)];
        verLine.backgroundColor=[UIColor customColorWithString:@"#c8c8c8"];
        [self addSubview:verLine];
        
        UIView * backView=[[UIView alloc]initWithFrame:CGRectMake(40, 0, kScreenWidth-40-20, 110)];
        backView.backgroundColor=[UIColor whiteColor];
        
        [self addSubview:backView];
        
        
        UIView * topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, backView.frame.size.width, 28)];
        topView.backgroundColor=[UIColor customColorWithString:@"#f2b69a"];
        [backView addSubview:topView];
        
        headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 45, 45)];
        headImageView.layer.masksToBounds=YES;
        headImageView.layer.cornerRadius=45/2;
        [backView addSubview:headImageView];
        
        nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+7, 7, backView.frame.size.width/2-CGRectGetMaxX(headImageView.frame)-7, 20)];
        nameLabel.font=[UIFont fontWithName:TextFontName size:14];
        nameLabel.textColor=[UIColor whiteColor];
        [backView addSubview:nameLabel];
        
        
        receiveTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), 7, backView.frame.size.width-10-CGRectGetMaxX(nameLabel.frame), 15)];
        receiveTimeLabel.textAlignment=NSTextAlignmentRight;
        receiveTimeLabel.font=[UIFont fontWithName:TextFontName size:11];
        receiveTimeLabel.textColor=[UIColor whiteColor];
        [backView addSubview:receiveTimeLabel];
        
        locationCityIcon=[[UIImageView alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(topView.frame)+11, 11, 11)];
        locationCityIcon.image=[UIImage imageNamed:@"location"];
        [backView addSubview:locationCityIcon];
        
        locationCityLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(locationCityIcon.frame)+8, locationCityIcon.y, backView.frame.size.width-CGRectGetMaxX(locationCityIcon.frame)-8-10, 15)];
        locationCityLabel.font=[UIFont fontWithName:TextFontName size:13];
        locationCityLabel.textColor=[UIColor customColorWithString:@"909290"];
        [backView addSubview:locationCityLabel];
        
        schoolIcon=[[UIImageView alloc]initWithFrame:CGRectMake(locationCityIcon.x, CGRectGetMaxY(locationCityIcon.frame)+11, 11, 11)];
        schoolIcon.image=[UIImage imageNamed:@"user"];
        [backView addSubview:schoolIcon];
        
        schoolLabel=[[UILabel alloc]initWithFrame:CGRectMake(locationCityLabel.x, schoolIcon.y, locationCityLabel.width, locationCityLabel.height)];
        schoolLabel.textColor=locationCityLabel.textColor;
        schoolLabel.font=locationCityLabel.font;
        [backView addSubview:schoolLabel];
        
        wantJobIcon=[[UIImageView alloc]initWithFrame:CGRectMake(schoolIcon.x, CGRectGetMaxY(schoolIcon.frame)+11, 11, 11)];
        wantJobIcon.image=[UIImage imageNamed:@"work"];
        [backView addSubview:wantJobIcon];
        
        
        wantJobLabel=[[UILabel alloc]initWithFrame:CGRectMake(schoolLabel.x, wantJobIcon.y, schoolLabel.width, schoolLabel.height)];
        wantJobLabel.textColor=schoolLabel.textColor;
        wantJobLabel.font=schoolLabel.font;
        [backView addSubview:wantJobLabel];
        
        
        
        
        
    }
    
    return self;

}
-(void)setCardModel:(CardInfoModel *)cardModel
{
    [headImageView sd_setImageWithURL:[NSURL URLWithString:cardModel.headImageUrl] placeholderImage:nil];
    
    nameLabel.text=cardModel.name;
    
    receiveTimeLabel.text=cardModel.cardTime;
    
    locationCityLabel.text=cardModel.locationCity;
    
    schoolLabel.text=[NSString stringWithFormat:@"%@ %@",cardModel.shcool,cardModel.professional];
    
    wantJobLabel.text=cardModel.wantJobName;

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
