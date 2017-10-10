//
//  MyCardView.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/21.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "MyCardView.h"

@interface MyCardView ()
{
    UIView * backView;

}

@end

@implementation MyCardView
-(instancetype)initWithHeight:(CGFloat)height
{
    CGRect frame=CGRectMake(20, height, kScreenWidth-40, 325);
    self=[super initWithFrame:frame];
    if (self) {
         self.frame=CGRectMake(20, height, kScreenWidth-40, 325);
        [self createUI];
    }
    
   
    return self;
}
-(void)createUI
{
    backView=[[UIView alloc]initWithFrame:self.bounds];
    backView.backgroundColor=[UIColor whiteColor];
    backView.layer.masksToBounds=YES;
    backView.layer.cornerRadius=5.f;
    [self addSubview:backView];
    
    UIView * topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 50)];
    topView.backgroundColor=[UIColor customColorWithString:@"ea8b5e"];
    [backView addSubview:topView];
    
    
    UILabel * myCardLabel=[UILabel setLabelFrame:CGRectMake(20, 15, 200, 20) Text:@"我的名片" TextColor:[UIColor whiteColor] font:[UIFont fontWithName:TextFontName size:17] textAlignment:NSTextAlignmentLeft];
    [topView addSubview:myCardLabel];
    
    UIButton * editButton=[[UIButton alloc]initWithFrame:CGRectMake(self.width-15-50, 0, 50, 50)];
    [editButton setImage:[UIImage imageNamed:@"btn_edit_normal"] forState:UIControlStateNormal];
    [editButton setImage:[UIImage imageNamed:@"btn_edit_press"] forState:UIControlStateHighlighted];
    [editButton setImageEdgeInsets:UIEdgeInsetsMake(9, 18, 9, 0)];
    [topView addSubview:editButton];
    
    [editButton addTarget:self action:@selector(pressEditButton) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat titleWidth=[UILabel getLabelWidthWithText:@"真实姓名" wordSize:14 height:15];
    NSArray * titleArr=@[@"真实姓名",@"手机号码",@"所在城市",@"毕业院校",@"所学专业",@"毕业时间",@"目标岗位"];
    
    for (int i=0; i<titleArr.count; i++) {
        
        UILabel * titleLabel=[UILabel setLabelFrame:CGRectMake(20, CGRectGetMaxY(topView.frame)+25+35*i, titleWidth, 15) Text:[titleArr objectAtIndex:i] TextColor:[UIColor customColorWithString:@"0d0e0d"] font:[UIFont fontWithName:TextFontName size:14] textAlignment:NSTextAlignmentLeft];
        [backView addSubview:titleLabel];
        
        
        UILabel * contentLabel=[UILabel setLabelFrame:CGRectMake(20+titleWidth+20, CGRectGetMaxY(topView.frame)+25+35*i, self.width-60-titleWidth, 15) Text:@"未填写" TextColor:[UIColor customColorWithString:@"c8c8c8"] font:[UIFont fontWithName:TextFontName size:14] textAlignment:NSTextAlignmentLeft];
        contentLabel.tag=101+i;
        [backView addSubview:contentLabel];
        
        
        
    }
    
    

}
-(void)setModel:(CardInfoModel *)model
{

    _model=model;
    
    for (int i =0; i<7; i++) {
        UILabel * label=[backView viewWithTag:101+i];
        if (i==0&&model.name.length) {
            label.text=model.name;
            label.textColor=[UIColor customColorWithString:@"ea8b5e"];
            
        }
        else if (i==1&&model.phoneNum.length)
        {
            label.text=model.phoneNum;
            label.textColor=[UIColor customColorWithString:@"ea8b5e"];
        
        }else if (i==2&&model.locationCity.length)
        {
            label.text=model.locationCity;
            label.textColor=[UIColor customColorWithString:@"ea8b5e"];
            
        }else if (i==3&&model.shcool.length)
        {
            label.text=model.shcool;
            label.textColor=[UIColor customColorWithString:@"ea8b5e"];

        }
        else if (i==4&&model.professional.length)
        {
            label.text=model.professional;
            label.textColor=[UIColor customColorWithString:@"ea8b5e"];
        }
        else if (i==5&&model.graduateTime.length)
        {
            label.text=model.graduateTime;
            label.textColor=[UIColor customColorWithString:@"ea8b5e"];
        
        }else if (i==6&&model.wantJobName.length)
        {
            label.text=model.wantJobName;
            label.textColor=[UIColor customColorWithString:@"ea8b5e"];

        
        }
        
    }



}
-(void)pressEditButton
{
    if ([self.delegate respondsToSelector:@selector(beginEditMyInfo:)]) {
        [self.delegate beginEditMyInfo:self.model];
    }

}
@end
