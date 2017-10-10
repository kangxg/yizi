//
//  CertificationViewController.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/24.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "CertificationViewController.h"
#import "EditMyCardInfoTableViewCell.h"
#import "iToast.h"

@interface CertificationViewController ()<UITextFieldDelegate>
{
    NSString * realName;
    NSString * IDNum;
    

}

@end

@implementation CertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"实名认证";
    self.view.backgroundColor=[UIColor customColorWithString:@"eeeeee"];
    
    UIButton * rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, KNavBarHeight)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor customColorWithString:@"28904e"] forState:UIControlStateNormal];
    rightButton.titleLabel.font=[UIFont fontWithName:TextFontName size:18];
    rightButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [rightButton addTarget:self action:@selector(finishMyCertification) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    
    UILabel * topLabel=[UILabel setLabelFrame:CGRectMake(16, KNavBarHeight+20, kScreenWidth-32, 15) Text:@"您填写的证件信息将严格保密" TextColor:[UIColor customColorWithString:@"909290"] font:[UIFont fontWithName:TextFontName size:11] textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:topLabel];
    
    
    SelectMyCardInfoTableViewCell * cell0=[[SelectMyCardInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell0.frame=CGRectMake(0, CGRectGetMaxY(topLabel.frame)+10, kScreenWidth, 60);
    cell0.line.hidden=YES;
    cell0.titleLabel.text=@"证件类型";
    cell0.selectLabel.text=@"大陆身份证";
    cell0.selectLabel.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:cell0];
    
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCerType)];
    [cell0.selectLabel addGestureRecognizer:tap];
    
    
    
    EditMyCardInfoTableViewCell * cell1=[[EditMyCardInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell1.frame=CGRectMake(0, CGRectGetMaxY(cell0.frame)+20, kScreenWidth, 60);
    cell1.titleLabel.text=@"真实姓名";
    [cell1.textFiled setPlaceholder:@"请输入真实姓名" withFont:[UIFont fontWithName:TextFontName size:16] color:[UIColor customColorWithString:@"909290"]];
    cell1.textFiled.tag=601;
    cell1.textFiled.delegate=self;
    
    [self.view addSubview:cell1];
    
    
    EditMyCardInfoTableViewCell * cell2=[[EditMyCardInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell2.frame=CGRectMake(0, CGRectGetMaxY(cell1.frame), kScreenWidth, 60);
    cell2.titleLabel.text=@"身份证号";
    [cell2.textFiled setPlaceholder:@"请输入身份证号" withFont:[UIFont fontWithName:TextFontName size:16] color:[UIColor customColorWithString:@"909290"]];
     cell2.textFiled.tag=602;
    cell2.textFiled.delegate=self;
   
    
    [self.view addSubview:cell2];
    
    
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==601) {
        
       
        realName=textField.text;
    }

    else if (textField.tag==602)
    {
        IDNum=textField.text;
    
    }

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
-(void)selectCerType
{


}
-(void)finishMyCertification
{
    [self.view endEditing:YES];
    
    if (realName.length==0) {
        
        [[iToast makeText:@"请输入真实姓名"]show];
        
        return;
    }
    else if (IDNum.length==0)
    
    {
     [[iToast makeText:@"请输入身份证号码"]show];
        return;
    }
    
    
    WKProgressHUD * hud=[WKProgressHUD showInView:self.navigationController.view withText:nil animated:YES];
    
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:realName forKey:@"card_name"];
    [paramDic setValue:IDNum forKey:@"card_no"];
    
    [UrlRequest postRequestWithUrl:kCerIDNumUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        
        NSLog(@"实名认证 返回  %@",jsonDict);
        [hud dismiss:YES];
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            int is_card_auth=[[jsonDict valueForKey:@"is_card_auth"]intValue];
            if (is_card_auth) {
                user.isCertification=is_card_auth;
                user.realName=[jsonDict valueForKey:@"card_name"];
                user.IDNum=[jsonDict valueForKey:@"card_no"];
                
                [[UserManager shareInstaced]setUserInfo:user];
                
                if (self.CerNumCallback!=nil) {
                    self.CerNumCallback();
                }
                
                [self backToLastController];
            }
            
            
        }
        
    } fail:^(NSError *error) {
        
    }];

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
