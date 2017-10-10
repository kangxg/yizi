//
//  LoginViewController.m
//  YiziTV
//
//  Created by 井泉 on 16/6/21.
//  Copyright © 2016年 JQ. All rights reserved.
//
#define kAlphaNum @"0123456789"


#import "LoginViewController.h"
#import "OAuthView.h"
#import "DeviceInfo.h"
#import "UrlRequest.h"
#import "PhoneCodeResponseModel.h"
#import "UserInfoModel.h"
#import "UserManager.h"
#import "YZTVTabBarController.h"
#import "BindingMobilePhoneViewController.h"
#import "EditMyPersonInfoViewController.h"
#import "iToast.h"
#import "YZTVProtocolViewController.h"
#import "NIMSDK.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>

@interface LoginViewController () <UITextFieldDelegate, OAuthViewDelegate>
{
    
    //大背景
    UIView * backView;
    UIButton *getVerificationCodeButton;
    UIView *phoneNumberView;
    UITextField *verificationCodeTextField;
    UITextField *iphoneTextField;
    float screenHeightRatio;
    CGFloat pushUpY;
    NSString *phone_number;
    NSInteger phone_code;
    PhoneCodeResponseModel *codeResponseModel;
}

@end


@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    screenHeightRatio = 1;

    pushUpY = 0;
    //适配
    if (kScreenHeight<568) {
        screenHeightRatio = 0.3;
        pushUpY = 50;
        NSLog(@"iPhone4");
    }else if (kScreenHeight<667&&kScreenHeight>480){
        screenHeightRatio = 0.7;
        pushUpY = 90;
        NSLog(@"iPhone5");
    }else if (kScreenHeight<736&&kScreenHeight>568) {
        screenHeightRatio = 1;
        pushUpY = 20;
        NSLog(@"iPhone6");
    }else if (kScreenHeight>667){
        screenHeightRatio = 1.2;
        pushUpY = 20;
        NSLog(@"iPhone6plus");
    }else
    {
         screenHeightRatio = 0.3 ;
    }
    
    NSLog(@"screenHeightRatio:%f", screenHeightRatio);
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden=YES;
    
    backView = [[UIView alloc]initWithFrame:self.view.bounds];
    backView.backgroundColor=[UIColor whiteColor];
//    [backView setUserInteractionEnabled:YES];
    [self.view addSubview:backView];
    
    //椅子tvlogo图标
    UIView *logoGlowView = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"logo_highlight_1"]];

    UIView *logoView = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"logo"]];
//    logoView.frame=CGRectMake(290/2, 124, 121, 138) ;
    

    [backView addSubview:logoView];
    
    [backView addSubview:logoGlowView];
    logoGlowView.alpha = 0.0;
    logoView.center = CGPointMake(logoView.frame.size.width*0.3471/2 + kScreenWidth/2, 124 * screenHeightRatio + logoView.frame.size.height / 2);
    logoGlowView.center = CGPointMake(logoGlowView.frame.size.width*0.3471/2 + kScreenWidth/2, 124 * screenHeightRatio + logoGlowView.frame.size.height / 2);
    
    //logo发光动画
    [UIView transitionWithView:logoGlowView duration:3.0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        logoGlowView.alpha = 0.8;
    } completion:^(BOOL finished) {
        [UIView transitionWithView:logoGlowView duration:5.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            logoGlowView.alpha = 0.0;
        } completion:^(BOOL finished) {
            
        }];
    }];
     /*
     *输入电话号码lable和短信验证码框
     *
     */
    phoneNumberView = [[UIView alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(logoView.frame) + 120/2 * screenHeightRatio, self.view.bounds.size.width - 50 , 101)];
    phoneNumberView.backgroundColor = [UIColor customColorWithString:@"#f1f1f1"];
//    [phoneNumberView.layer setBorderWidth:2.0];//画线的宽度
//    [phoneNumberView.layer setBorderColor:[UIColor blackColor].CGColor];//颜色
    [phoneNumberView.layer setCornerRadius:4.0];//圆角
    [phoneNumberView.layer setMasksToBounds:YES];
    
    [backView addSubview:phoneNumberView];

    
    //登陆按钮
    UIButton *logoinButton = [[UIButton alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(phoneNumberView.frame) + 36/2 * screenHeightRatio, self.view.bounds.size.width - 50, 50)];
    [logoinButton setTitle:@"登录" forState:UIControlStateNormal];//button title
    logoinButton.titleLabel.font = [UIFont fontWithName:TextFontName size:17];
    
    [logoinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//title color
    
    [logoinButton addTarget:self action:@selector(logoin:) forControlEvents:UIControlEventTouchUpInside];//button 点击回调方法
    
//    logoinButton.backgroundColor = [UIColor customColorWithString:@"#28904e"];
    [logoinButton setBackgroundImage:[self imageWithColor:[UIColor customColorWithString:@"#28904e"]] forState:UIControlStateNormal];
    [logoinButton setBackgroundImage:[self imageWithColor:[UIColor customColorWithString:@"#3abf6b"]] forState:UIControlStateHighlighted];

    [logoinButton.layer  setCornerRadius:4.0];//圆角
    [logoinButton.layer setMasksToBounds:YES];
    [backView addSubview:logoinButton];
    
    
    //判断是否安装微信
    BOOL isHand = [WXApi isWXAppInstalled];
    //判断是否安装QQ
    BOOL isQQHand=[QQApiInterface isQQInstalled];

        
    //第三方登陆View
    OAuthView *oauthView = [[OAuthView alloc] initWithFrame:CGRectGetMaxY(logoinButton.frame) + 50 * screenHeightRatio QQ:isQQHand WX:isHand];
    oauthView.delegate = self;
    [backView addSubview:oauthView];
        
   
    
    
    //添加手机输入框
    iphoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(11, 6, CGRectGetMaxX(phoneNumberView.frame) - 11 - 120, 40)];
    // 设置输入框提示
//    iphoneTextField.placeholder = @"输入手机号码";
    [iphoneTextField setPlaceholder:@"输入手机号码" withFont:[UIFont fontWithName:TextFontName size:15] color:[UIColor customColorWithString:@"#d4d4d4"]];
    NSUserDefaults * userdefaults=[NSUserDefaults standardUserDefaults];
    NSString * acount=[userdefaults valueForKey:kAcountKey];
    if (acount) {
        iphoneTextField.text =acount;
  
    }
    // 输入框中预先输入的文字
       // 设置输入框文本的字体
    iphoneTextField.font = [UIFont fontWithName:TextFontName size:15];
    // 设置输入框字体颜色
    iphoneTextField.textColor = [UIColor blackColor];
    // 设置输入框的背景颜色
//    iphoneTextField.backgroundColor = [UIColor redColor];//customColorWithString:@"#f1f1f1"];
    iphoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

    // 设置输入框边框样式
    iphoneTextField.borderStyle = UITextBorderStyleNone;
    iphoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    iphoneTextField.delegate = self;
    [phoneNumberView addSubview:iphoneTextField];
    
    //添加验证码输入框
    verificationCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(11, 10 + 40 + 5, CGRectGetMaxX(phoneNumberView.frame) - 11 - 120, 40)];
    // 设置输入框提示
//    verificationCodeTextField.placeholder = @"输入验证码";
    [verificationCodeTextField setPlaceholder:@"输入验证码" withFont:[UIFont fontWithName:TextFontName size:15] color:[UIColor customColorWithString:@"#d4d4d4"]];
    // 输入框中预先输入的文字
    verificationCodeTextField.text = @"";
    // 设置输入框文本的字体
    verificationCodeTextField.font = [UIFont fontWithName:TextFontName size:15];
    // 设置输入框字体颜色
    verificationCodeTextField.textColor = [UIColor blackColor];
    // 设置输入框的背景颜色
//    verificationCodeTextField.backgroundColor = [UIColor redColor];//customColorWithString:@"#f1f1f1"];
    verificationCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

    // 设置输入框边框样式
    verificationCodeTextField.borderStyle = UITextBorderStyleNone;
    verificationCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    verificationCodeTextField.delegate = self;
    
    [phoneNumberView addSubview:verificationCodeTextField];
    
    //分割线
    CALayer *lineLayer = [[CALayer alloc]init];
    lineLayer.backgroundColor = [[UIColor customColorWithString:@"#cfcfcf"] CGColor];
    //大小
    lineLayer.bounds = CGRectMake(0, 0 ,phoneNumberView.frame.size.width - 23, 0.5);
    //墙上的位置
    lineLayer.position = CGPointMake(phoneNumberView.frame.size.width / 2, phoneNumberView.frame.size.height / 2);
    
    [phoneNumberView.layer  addSublayer:lineLayer];
    
    //获取验证码button
    getVerificationCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(phoneNumberView.frame.size.width - 11 - 144 / 2.0, 11, 72, 30)];
    [getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];//button title
    getVerificationCodeButton.titleLabel.font = [UIFont fontWithName:TextFontName size:12];
    [getVerificationCodeButton setTitleColor:[UIColor customColorWithString:@"#28904e"] forState:UIControlStateNormal];//title color
//    getVerificationCodeButton.backgroundColor = [UIColor lightGrayColor];
    
    [getVerificationCodeButton addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];//button 点击回调方法
    
    //    logoinButton.backgroundColor = [UIColor customColorWithString:@"#28904e"];
    [getVerificationCodeButton setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
//    [getVerificationCodeButton setBackgroundImage:[self imageWithColor:[UIColor customColorWithString:@"#3abf6b"]] forState:UIControlStateHighlighted];
    
    [getVerificationCodeButton.layer  setCornerRadius:4.0];//圆角
    [getVerificationCodeButton.layer setMasksToBounds:YES];
    
    //是否设置边框以及是否可见
    [getVerificationCodeButton.layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [getVerificationCodeButton.layer setCornerRadius:4.0];
    //设置边框线的宽
    //
    [getVerificationCodeButton.layer setBorderWidth:0.5];
    //设置边框线的颜色
    [getVerificationCodeButton.layer setBorderColor:[[UIColor customColorWithString:@"#28904e"] CGColor]];

    [phoneNumberView  addSubview:getVerificationCodeButton];
    
    
    /*
     *用户协议
     */
    NSString * agreeText= @"登录即表明同意";
    NSString * agreePro=@"《用户协议》";
    NSMutableAttributedString * agreeString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",agreeText,agreePro]];
    
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:TextFontName size:10],NSFontAttributeName,[UIColor customColorWithString:@"28904e"],NSForegroundColorAttributeName, nil];
    
    [agreeString addAttributes:attrsDictionary range:NSMakeRange(agreeText.length,agreePro.length)];
    
    
    UILabel *loginAgreementLable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.height-30, self.view.bounds.size.width, 30)];
    loginAgreementLable.userInteractionEnabled=YES;
    loginAgreementLable.font = [UIFont fontWithName:TextFontName size:10];
    loginAgreementLable.textColor = [UIColor customColorWithString:@"#b7b6b6"];
    loginAgreementLable.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:loginAgreementLable];
    
    loginAgreementLable.attributedText=agreeString;
    
    UITapGestureRecognizer * tapAgreeLabel=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(usersAgreement)];
    [loginAgreementLable addGestureRecognizer:tapAgreeLabel];
    

    
}

#pragma mark 登陆
- (void)logoin:(id)sender
{
//        NSString *sign = @"";
    
    WKProgressHUD * hud  = [WKProgressHUD showInView:self.navigationController.view withText:@"" animated:YES];
    

    NSMutableDictionary *LoginInfoDic = [[NSMutableDictionary alloc] init];
    LoginInfoDic[@"deviceId"] = [DeviceInfo getDeviceId];
    LoginInfoDic[@"mecheck"] = @"";
    LoginInfoDic[@"phone_number"] = iphoneTextField.text;
    LoginInfoDic[@"phone_code"] = verificationCodeTextField.text;
    LoginInfoDic[@"sign"] = codeResponseModel.sign;
    
    [UrlRequest postRequestWithUrl:kPhoneLoginActionUrl parameters:LoginInfoDic success:^(NSDictionary *jsonDict) {

        [hud dismiss:YES];
        switch ([jsonDict[@"code"] intValue]) {
            case 0:{
                NSLog(@"成功+++++++%@",jsonDict);
                
                UserInfoModel *userInfoModel = [[UserInfoModel alloc] init];
                userInfoModel.phone_number = iphoneTextField.text;
                userInfoModel.deviceId = [DeviceInfo getDeviceId];
                userInfoModel.user_token = jsonDict[@"user_token"];
                long long uid=[[jsonDict valueForKey:@"user_id"]longLongValue];
                userInfoModel.uid=[NSString stringWithFormat:@"%lld",uid];
                userInfoModel.YXAcount=jsonDict[@"vcloud_id"];
                userInfoModel.YXToken=jsonDict[@"vcloud_token"];
                [[UserManager shareInstaced] setUserInfo:userInfoModel];
               
                
               
                
                if([jsonDict[@"need_evpi"] intValue] == 1)
                {
                    EditMyPersonInfoViewController *editMyPersonInfo = [[EditMyPersonInfoViewController alloc] init];
                    editMyPersonInfo.isHiddenBackButton=YES;
                    editMyPersonInfo.isChangeRootVC=YES;
                    editMyPersonInfo.titleString=@"完善个人信息";
                    [self.navigationController pushViewController:editMyPersonInfo animated:YES];
                }
                else{
                    YZTVTabBarController *tb = [[YZTVTabBarController alloc] init];
                    [UIApplication sharedApplication].keyWindow.rootViewController = tb;
                }

                
                 [[UserManager shareInstaced]loginYXSDK];
                
                
                
               
            }
                 break;
                
                
                default:
                break;
        }
    } fail:^(NSError *error) {
        
        
    }];
}

#pragma mark 发送手机验证码
- (void)getVerificationCode:(id)sender
{
    NSLog(@"发送验证码");
    

    // BOOL isValid = [predicate evaluateWithObject:_phoneNum];
    if ([iphoneTextField.text isEqualToString:@""]) {
       
        [[iToast makeText:@"请输入有效的手机号码" ] show];

        NSLog(@"请输入有效的手机号码");
    }
    else{
        
   WKProgressHUD * hud  = [WKProgressHUD showInView:self.navigationController.view withText:@"" animated:YES];

        
        phone_number = iphoneTextField.text;
      
        NSMutableDictionary *sendPhoneCode = [[NSMutableDictionary alloc] init];
        sendPhoneCode[@"deviceId"] = [DeviceInfo getDeviceId];
        sendPhoneCode[@"mecheck"] = @"";
        sendPhoneCode[@"phone_number"] = phone_number;

        [UrlRequest postRequestWithUrl:kSecurityCodeUrl parameters:sendPhoneCode success:^(NSDictionary * jsonDict) {
            [hud dismiss:YES];
            NSLog(@"短信请求返回数据:%@", jsonDict);
            if([jsonDict[@"code"] intValue] == 0)
            {
                
                [self getPhoneCode];
                
                NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
                [userDefaults setValue:phone_number forKey:kAcountKey];
                [userDefaults synchronize];
                
                codeResponseModel = [PhoneCodeResponseModel keyWithDict:jsonDict];
            }
            
            
        } fail:^(NSError *error) {
            
        }];
//        NSLog(@"注册码已发送:%@", phone_number);
        
    }
}

- (void)usersAgreement
{
    NSLog(@"用户协议");
    
    YZTVProtocolViewController * protoclVC=[[YZTVProtocolViewController alloc]init];
    [self.navigationController pushViewController:protoclVC animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

     
 //  颜色转换为背景图片
 - (UIImage *)imageWithColor:(UIColor *)color {
     CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
     UIGraphicsBeginImageContext(rect.size);
     CGContextRef context = UIGraphicsGetCurrentContext();
     
     CGContextSetFillColorWithColor(context, [color CGColor]);
     CGContextFillRect(context, rect);
     
     UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     
     return image;
 }
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)getPhoneCode
{
    
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];//button title
                getVerificationCodeButton.titleLabel.font = [UIFont fontWithName:TextFontName size:12];
                [getVerificationCodeButton setTitleColor:[UIColor customColorWithString:@"#28904e"] forState:UIControlStateNormal];//title color
                [getVerificationCodeButton.layer setBorderColor:[[UIColor customColorWithString:@"#28904e"] CGColor]];

                getVerificationCodeButton.userInteractionEnabled = YES;
                getVerificationCodeButton.enabled=YES;
                getVerificationCodeButton.selected=NO;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d秒", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                // NSLog(@"____%@",strTime);
                [getVerificationCodeButton setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                [getVerificationCodeButton setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateDisabled];
                //                sendCode.titleLabel.textColor=[YZColor colorWithHexString:@"#8a8a8a"];
                [getVerificationCodeButton setTitleColor:[UIColor customColorWithString:@"#d4d4d4"] forState:UIControlStateNormal];
                [getVerificationCodeButton.layer setBorderColor:[[UIColor customColorWithString:@"#d4d4d43333333333"] CGColor]];

                getVerificationCodeButton.enabled=NO;
                //                sendCode.selected=YES;
//                getVerificationCodeButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == iphoneTextField || textField == verificationCodeTextField) {
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField

{
    NSLog(@"%f------%f",backView.center.y, self.view.bounds.size.height/2);
    if(backView.center.y == self.view.bounds.size.height/2){
        [UIView transitionWithView:backView duration:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            backView.center = CGPointMake(backView.center.x, self.view.bounds.size.height/2 - pushUpY);
        } completion:^(BOOL finished) {
           
        }];
    }
    
}

//输入框编辑完成以后，将视图恢复到原始状态

-(void)textFieldDidEndEditing:(UITextField *)textField

{
    
    [UIView transitionWithView:backView duration:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        backView.center = CGPointMake(backView.center.x, self.view.bounds.size.height/2);
    } completion:^(BOOL finished) {
        
    }];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) return YES;
    
    if (textField == iphoneTextField && textField.text.length >= 11) {
        
        // 手机号
        
        return NO;
        
    }else if (textField == verificationCodeTextField && textField.text.length >= 6){
        
        // 密码
        
        return NO;
        
    }else{
        
        return YES;
        
    }
}

- (void)success:(NSInteger)needPhone;
{
    if(needPhone == 0){
        YZTVTabBarController *tb = [[YZTVTabBarController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tb;
    }
    else{
        BindingMobilePhoneViewController *vc = [[BindingMobilePhoneViewController alloc] init];
        //    UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:tb];
        [self.navigationController pushViewController:vc animated:YES];
    }

    NSLog(@"成功了");
}

- (void)failure;
{
    NSLog(@"tmd失败了");
}

@end
