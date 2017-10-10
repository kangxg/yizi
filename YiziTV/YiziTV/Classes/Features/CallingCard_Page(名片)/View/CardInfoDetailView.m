//
//  CardInfoDetailView.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/21.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "CardInfoDetailView.h"
/*
 
 显示查看名片详情UI
 
 
 
 */

@interface CardInfoDetailView ()<UIAlertViewDelegate>

{
    UIView * backView;
    
    UILabel * nameLabel;
    
    UIImageView * headImageView;
    
    UIImageView * grandImageView;
    
    UILabel * grandLabel;
    
    UIImageView * locationImageIcon;
    
    UILabel * locatinLabel;
    
}

@end
@implementation CardInfoDetailView

-(instancetype)init
{
    CGRect newframe=CGRectMake(kScreenWidth/2-280/2, kScreenHeight/2-428/2, 280, 458);
    self=[super initWithFrame:newframe];
    if (self) {
    
        
        self.frame=newframe;
        [self createUI];
    }
    
    return self;
    
}
-(void)createUI
{
    
    backView=[[UIView alloc]initWithFrame:CGRectMake(0, 75.0/2, self.width, self.height-75.0/2-25-30)];
    backView.backgroundColor=[UIColor whiteColor];
    [self addSubview:backView];
    backView.layer.masksToBounds=YES;
    backView.layer.cornerRadius=5.0;
    
    
    UIView * topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, backView.width, 117)];
    topView.backgroundColor=[UIColor customColorWithString:@"ea8b5e"];
    [backView addSubview:topView];
    
    
    
    
    headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.width/2-75.0/2, 0, 75, 75)];
    headImageView.layer.masksToBounds=YES;
    headImageView.layer.cornerRadius=75.0/2;
    headImageView.layer.borderWidth=1;
    headImageView.layer.borderColor=[[UIColor whiteColor]CGColor];
    [self addSubview:headImageView];
    
    
    nameLabel=[UILabel setLabelFrame:CGRectMake(self.width/2-80/2, 75.0/2+15, 80, 20) Text:@"" TextColor:[UIColor whiteColor] font:[UIFont fontWithName:TextFontName size:18] textAlignment:NSTextAlignmentCenter];
    [backView addSubview:nameLabel];
    
    
    
    grandImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.width/4-14-2, CGRectGetMaxY(nameLabel.frame)+15, 14, 14)];
    grandImageView.image=[UIImage imageNamed:@"white_gril"];
    [backView addSubview:grandImageView];
    
    grandLabel=[UILabel setLabelFrame:CGRectMake(self.width/4+2, grandImageView.y, 20, 15) Text:@"" TextColor:[UIColor whiteColor] font:[UIFont fontWithName:TextFontName size:13] textAlignment:NSTextAlignmentLeft];
    [backView  addSubview:grandLabel];
    
    
    locationImageIcon=[[UIImageView alloc]initWithFrame:CGRectMake(self.width/2+self.width/4-11-2, grandImageView.y, 11, 14)];
    locationImageIcon.image=[UIImage imageNamed:@"white_location"];
    [backView addSubview:locationImageIcon];
    
    locatinLabel=[UILabel setLabelFrame:CGRectMake(CGRectGetMaxX(locationImageIcon.frame)+4, grandImageView.y, self.width/4-6, 15) Text:@"" TextColor:[UIColor whiteColor] font:[UIFont fontWithName:TextFontName size:13] textAlignment:NSTextAlignmentLeft];
    [backView addSubview:locatinLabel];
    
    
    UIView * verLine=[[UIView alloc]initWithFrame:CGRectMake(self.width/2, grandImageView.y, 0.5, 16)];
    verLine.backgroundColor=[UIColor whiteColor];
    verLine.alpha=0.2;
    [backView addSubview:verLine];
    
    CGFloat titleWidth=[UILabel getLabelWidthWithText:@"真实姓名" wordSize:14 height:15];

    NSArray * titlrArray=@[@"手机号码",@"毕业院校",@"所学专业",@"毕业时间",@"目标岗位"];
    for(int i=0;i<titlrArray.count;i++)
    {
        UILabel * titleLabel=[UILabel setLabelFrame:CGRectMake(30, CGRectGetMaxY(topView.frame)+30+43*i, titleWidth, 15) Text:[titlrArray objectAtIndex:i] TextColor:[UIColor customColorWithString:@"0d0e0d"] font:[UIFont fontWithName:TextFontName size:14] textAlignment:NSTextAlignmentLeft];
        [backView addSubview:titleLabel];
        
        UILabel * contentLabel=[UILabel setLabelFrame:CGRectMake(30+titleWidth+15, CGRectGetMaxY(topView.frame)+30+43*i, self.width-30-15-titleWidth-30, 15) Text:@"未填写" TextColor:[UIColor customColorWithString:@"c8c8c8"] font:[UIFont fontWithName:TextFontName size:14] textAlignment:NSTextAlignmentLeft];
        contentLabel.tag=101+i;
        [backView addSubview:contentLabel];
        
        if (i==0) {
            
            UIView * callTelephoneView=[[UIView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(topView.frame)+30, backView.width, 15)];
            UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCallTelephone)];
            [callTelephoneView addGestureRecognizer:tap];
            [backView addSubview:callTelephoneView];
        }
        
        
    
    }
    
    
    
    UIButton * closeButton=[[UIButton alloc]initWithFrame:CGRectMake(self.width/2-80/2, CGRectGetMaxY(backView.frame), 80, 80)];
    [closeButton setImage:[UIImage imageNamed:@"btn_close_normal"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"btn_close_press"] forState:UIControlStateHighlighted];
    
    [self addSubview:closeButton];
    
    [closeButton addTarget:self action:@selector(pressCloseButton) forControlEvents:UIControlEventTouchUpInside];
    


}
-(void)pressCloseButton
{
    if (self.closeShowView!=nil) {
        self.closeShowView();
    }
    
    

}
-(void)tapCallTelephone
{
    if (_model.phoneNum.length) {
        
        UIAlertView * alertTelephone=[[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"确定要拨打电话号码:%@?",_model.phoneNum] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertTelephone show];
        
       
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
        NSString * telePhoneStr=[NSString stringWithFormat:@"tel://%@",_model.phoneNum];
        NSURL * telePhoneUrl=[NSURL URLWithString:telePhoneStr];
        [[UIApplication sharedApplication]openURL:telePhoneUrl];
    }
}

-(void)setModel:(CardInfoModel *)model
{
    _model=model;
    [headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl] placeholderImage:nil];
    CGFloat nameWidth=[UILabel getLabelWidthWithText:model.name wordSize:18 height:20];
    if (nameWidth>80) {
        nameLabel.frame=CGRectMake(self.width/2-nameWidth/2, nameLabel.y, nameWidth, nameLabel.height);
        
    }
    nameLabel.text=model.name;
    
    if (model.grand==0) {
        grandImageView.image=[UIImage imageNamed:@"white_boy"];
        grandLabel.text=@"男";
    }else{
        grandImageView.image=[UIImage imageNamed:@"white_girl"];
        grandLabel.text=@"女";

    }
    
    locatinLabel.text=model.locationCity;
    
    
    for (int i =0; i<5; i++) {
        UILabel * label=[backView viewWithTag:101+i];
        if (i==0&&model.phoneNum.length) {
            label.text=model.phoneNum;
            label.textColor=[UIColor customColorWithString:@"ea8b5e"];
            
        }
        else if (i==1&&model.shcool.length)
        {
            label.text=model.shcool;
            label.textColor=[UIColor customColorWithString:@"ea8b5e"];
            
        }else if (i==2&&model.professional.length)
        {
            label.text=model.professional;
            label.textColor=[UIColor customColorWithString:@"ea8b5e"];
            
        }else if (i==3&&model.graduateTime.length)
        {
            label.text=model.graduateTime;
            label.textColor=[UIColor customColorWithString:@"ea8b5e"];
            
        }
        else if (i==4&&model.wantJobName.length)
        {
            label.text=model.wantJobName;
            label.textColor=[UIColor customColorWithString:@"ea8b5e"];
        }
                
    }
    

    
    

}
@end
