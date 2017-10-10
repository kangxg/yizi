//
//  AcountSecurityViewController.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/24.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "AcountSecurityViewController.h"

@interface AcountSecurityViewController ()

@end

@implementation AcountSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"账号安全";
    
    self.view.backgroundColor=[UIColor customColorWithString:@"eeeeee"];
    UIView * backView=[[UIView alloc]initWithFrame:CGRectMake(0, KNavBarHeight+20, kScreenWidth, 54)];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    UIImageView * iphoneIcon=[[UIImageView alloc]initWithFrame:CGRectMake(16, 16, 12, 22)];
    iphoneIcon.image=[UIImage imageNamed:@"icon_phone"];
    [backView addSubview:iphoneIcon];
    
    UILabel * label=[UILabel setLabelFrame:CGRectMake(CGRectGetMaxX(iphoneIcon.frame)+7, 18.5, 100, 20) Text:@"手机绑定" TextColor:[UIColor customColorWithString:@"0d0e0d"] font:[UIFont fontWithName:TextFontName size:16] textAlignment:NSTextAlignmentLeft];
    [backView addSubview:label];
    
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    
    UILabel * iponeNum=[UILabel setLabelFrame:CGRectMake(kScreenWidth-16-100, 18.5, 100, 20) Text:user.phone_number TextColor:[UIColor customColorWithString:@"909290"] font:[UIFont fontWithName:TextFontName size:16] textAlignment:NSTextAlignmentRight];
    [backView addSubview:iponeNum];
    
    
    
    
}
-(void)backToLastController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
