//
//  FansTableViewCell.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/28.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "FansTableViewCell.h"

@interface FansTableViewCell ()
{
    UIImageView * _headImageView;
    
    UILabel * _nameLabel;
    
    UIButton * _addButton;
    
}

@end

@implementation FansTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor clearColor];
        self.headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(16, 10.5, 45, 45)];
        self.headImageView.layer.masksToBounds=YES;
        self.headImageView.layer.cornerRadius=45/2;
        [self addSubview:self.headImageView];
        
        self.nameLabel=[UILabel setLabelFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame)+8, 25.5, kScreenWidth/2, 15) Text:nil TextColor:[UIColor customColorWithString:@"0d0e0d"] font:[UIFont fontWithName:TextFontName size:14] textAlignment:NSTextAlignmentLeft];
        [self addSubview:self.nameLabel];
        
        self.addButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-2-66-20, 0, 66+20, 66)];
        [self.addButton setImageEdgeInsets:UIEdgeInsetsMake(23, 46, 23, 20)];
        [self addSubview:self.addButton];
        
        self.line=[[UIView alloc]initWithFrame:CGRectMake(16, 66-0.5, kScreenWidth-16, 0.5)];
        self.line.backgroundColor=[UIColor customColorWithString:@"d9d9d9"];
        [self addSubview:self.line];
        
        
        [self.addButton addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
    
}
-(void)setModel:(CardInfoModel *)model
{
    _model=model;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl] placeholderImage:nil];
    self.nameLabel.text=model.nickName;
    
 
   
    if (model.isCared) {
        
        
        
    [self.addButton setImage:[UIImage imageNamed:@"btn_follow_press1.0"] forState:UIControlStateNormal];
        

    }else
    {
        
        
    [self.addButton setImage:[UIImage imageNamed:@"btn_follow_normal1.0"] forState:UIControlStateNormal];
    }

    
    
}
-(void)clickAddButton:(UIButton*)btn
{
   
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:_model.ID forKey:@"to_user_id"];

    //取消关注
    if ([btn.currentImage isEqual:[UIImage imageNamed:@"btn_follow_press1.0"]]) {
        
        [UrlRequest postRequestWithUrl:kCancleFocusActionUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
            int code=[[jsonDict valueForKey:@"code"]intValue];
            if (code==0) {
                
                [self.addButton setImage:[UIImage imageNamed:@"btn_follow_normal1.0"] forState:UIControlStateNormal];
            }
            
        } fail:^(NSError *error) {
            
        }];
        
    }
    
    //加关注
    else if ([btn.currentImage isEqual:[UIImage imageNamed:@"btn_follow_normal1.0"]])
    {
        [UrlRequest postRequestWithUrl:kFocusActionUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
            int code=[[jsonDict valueForKey:@"code"]intValue];
            if (code==0) {
                
                [btn setImage:[UIImage imageNamed:@"btn_follow_press1.0"] forState:UIControlStateNormal];
            }
            
        } fail:^(NSError *error) {
            
        }];
        
            }

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
