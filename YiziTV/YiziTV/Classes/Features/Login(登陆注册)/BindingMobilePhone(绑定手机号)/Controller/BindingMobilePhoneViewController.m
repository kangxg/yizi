//
//  BindingMobilePhoneViewController.m
//  YiziTV
//
//  Created by 井泉 on 16/6/25.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "BindingMobilePhoneViewController.h"
#import "PhoneCodeResponseModel.h"
#import "YZTVTabBarController.h"
#import "UserInfoModel.h"
#import "iToast.h"

@interface BindingMobilePhoneViewController () <UITextFieldDelegate>
{
    UITextField *verificationCodeTextField;
    UITextField *iphoneTextField;
    UIButton *getVerificationCodeButton;
    PhoneCodeResponseModel *codeResponseModel;

}
@end

@implementation BindingMobilePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController.viewControllers.count==1) {
        leftBotton.hidden=YES;
    }
    self.title=@"绑定手机";
    self.view.backgroundColor = [UIColor customColorWithString:@"#eeeeee"];

//    UIButton * rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, KNavBarHeight)];
//    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
//    [rightButton setTitleColor:[UIColor customColorWithString:@"28904e"] forState:UIControlStateNormal];
//    rightButton.titleLabel.font=[UIFont fontWithName:TextFontName size:18];
//    rightButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
//    [rightButton addTarget:self action:@selector(saveMobilePhone) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem=rightItem ;
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, KNavBarHeight + 20, kScreenWidth, 238/2)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    /*
     *输入电话号码lable和短信验证码框
     *
     */

    //添加手机输入框
    iphoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, 0, CGRectGetMaxX(whiteView.frame) - 11 - 120, whiteView.bounds.size.height / 2)];
    // 设置输入框提示
    //    iphoneTextField.placeholder = @"输入手机号码";
    [iphoneTextField setPlaceholder:@"输入手机号码" withFont:[UIFont fontWithName:TextFontName size:16] color:[UIColor customColorWithString:@"#d4d4d4"]];
    iphoneTextField.keyboardAppearance=UIKeyboardAppearanceDark;
    
    NSUserDefaults * userdefaults=[NSUserDefaults standardUserDefaults];
    NSString * acount=[userdefaults valueForKey:kAcountKey];
    if (acount) {
      iphoneTextField.text =acount;
    }
    // 输入框中预先输入的文字
    
    // 设置输入框文本的字体
    iphoneTextField.font = [UIFont fontWithName:TextFontName size:16];
    // 设置输入框字体颜色
    iphoneTextField.textColor = [UIColor blackColor];
    // 设置输入框的背景颜色
//        iphoneTextField.backgroundColor = [UIColor redColor];//customColorWithString:@"#f1f1f1"];
    iphoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    // 设置输入框边框样式
    iphoneTextField.borderStyle = UITextBorderStyleNone;
    iphoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    iphoneTextField.delegate = self;
    [whiteView addSubview:iphoneTextField];
    
    //添加验证码输入框
    verificationCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, whiteView.bounds.size.height / 2, CGRectGetMaxX(whiteView.frame) - 11 - 120, whiteView.bounds.size.height / 2)];
    // 设置输入框提示
    //    verificationCodeTextField.placeholder = @"输入验证码";
    [verificationCodeTextField setPlaceholder:@"输入验证码" withFont:[UIFont fontWithName:TextFontName size:16] color:[UIColor customColorWithString:@"#d4d4d4"]];
    // 输入框中预先输入的文字
    verificationCodeTextField.text = @"";
    // 设置输入框文本的字体
    verificationCodeTextField.font = [UIFont fontWithName:TextFontName size:16];
    // 设置输入框字体颜色
    verificationCodeTextField.textColor = [UIColor blackColor];
    // 设置输入框的背景颜色
//        verificationCodeTextField.backgroundColor = [UIColor redColor];//customColorWithString:@"#f1f1f1"];
    verificationCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    verificationCodeTextField.keyboardAppearance=UIKeyboardAppearanceDark;
    // 设置输入框边框样式
    verificationCodeTextField.borderStyle = UITextBorderStyleNone;
    verificationCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    verificationCodeTextField.delegate = self;
    
    [whiteView addSubview:verificationCodeTextField];
    
    
    //登陆按钮
    UIButton *logoinButton = [[UIButton alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(whiteView.frame) + 36/2, self.view.bounds.size.width - 50, 50)];
    [logoinButton setTitle:@"确认绑定" forState:UIControlStateNormal];//button title
    logoinButton.titleLabel.font = [UIFont fontWithName:TextFontName size:17];
    
    [logoinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//title color
    
    [logoinButton addTarget:self action:@selector(BindingPhone) forControlEvents:UIControlEventTouchUpInside];//button 点击回调方法
    
    //    logoinButton.backgroundColor = [UIColor customColorWithString:@"#28904e"];
    [logoinButton setBackgroundImage:[self imageWithColor:[UIColor customColorWithString:@"#28904e"]] forState:UIControlStateNormal];
    [logoinButton setBackgroundImage:[self imageWithColor:[UIColor customColorWithString:@"#3abf6b"]] forState:UIControlStateHighlighted];
    
    [logoinButton.layer  setCornerRadius:4.0];//圆角
    [logoinButton.layer setMasksToBounds:YES];
    [self.view addSubview:logoinButton];
    
    //获取验证码button
    getVerificationCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(whiteView.frame.size.width - 11 - 144 / 2.0, 13, 72, 30)];
    [getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];//button title
    getVerificationCodeButton.titleLabel.font = [UIFont fontWithName:TextFontName size:12];
    [getVerificationCodeButton setTitleColor:[UIColor customColorWithString:@"#28904e"] forState:UIControlStateNormal];//title color
    //    getVerificationCodeButton.backgroundColor = [UIColor lightGrayColor];
    
    [getVerificationCodeButton addTarget:self action:@selector(getVerificationCode) forControlEvents:UIControlEventTouchUpInside];//button 点击回调方法
    
    //    logoinButton.backgroundColor = [UIColor customColorWithString:@"#28904e"];
//    [getVerificationCodeButton setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [getVerificationCodeButton setBackgroundImage:[self imageWithColor:[UIColor customColorWithString:@"#3abf6b"]] forState:UIControlStateHighlighted];
    
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
    
    [whiteView  addSubview:getVerificationCodeButton];

    //分割线
    CALayer *lineLayer = [[CALayer alloc]init];
    lineLayer.backgroundColor = [[UIColor customColorWithString:@"#c8c8c8"] CGColor];
    //大小
    lineLayer.bounds = CGRectMake(0, 0 ,kScreenWidth, 0.5);
    //墙上的位置
    lineLayer.position = CGPointMake(whiteView.bounds.size.width / 2 + 20, whiteView.bounds.size.height / 2);
    
    [whiteView.layer addSublayer:lineLayer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backToLastController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 绑定手机按钮
- (void)BindingPhone
{
    UserInfoModel *userInfoModel = [[UserInfoModel alloc] init];
    userInfoModel = [[UserManager shareInstaced] getUserInfoModel];

    
    NSMutableDictionary *BindPhoneDic = [[NSMutableDictionary alloc] init];
    BindPhoneDic[@"deviceId"] = [DeviceInfo getDeviceId];
    BindPhoneDic[@"mcheck"] = @"123456";
    BindPhoneDic[@"user_token"] = userInfoModel.user_token;
    BindPhoneDic[@"phone_number"] = iphoneTextField.text;
    BindPhoneDic[@"phone_code"] = verificationCodeTextField.text;//template_type
    BindPhoneDic[@"sign"] = codeResponseModel.sign;
    BindPhoneDic[@"bindPhone"] = @"";
    NSLog(@"绑定手机发送的数据:%@", BindPhoneDic);

    NSLog(@"绑定手机接口路径:%@", kBindPhoneUrl);

    [UrlRequest postRequestWithUrl:kBindPhoneUrl parameters:BindPhoneDic success:^(NSDictionary *jsonDict) {
        //        if([jsonDict[@"code"] intValue] == 0)
        //        {
        //            UserInfoModel *userInfoModel = [[UserInfoModel alloc] init];
        //            userInfoModel.phone_number = iphoneTextField.text;
        //            userInfoModel.deviceId = [DeviceInfo getDeviceId];
        //            userInfoModel.user_token = jsonDict[@"user_token"];
        //            [[UserManager shareInstaced] setUserInfo:userInfoModel];
        //            NSLog(@"user_token:%@", userInfoModel.user_token);
        //        }
        NSLog(@"绑定手机:%@", jsonDict);
        switch ([jsonDict[@"code"] intValue]) {
            case 0:{
                NSLog(@"成功");
                NSUserDefaults * userdefault=[NSUserDefaults standardUserDefaults];
                [userdefault setValue:iphoneTextField.text forKey:kAcountKey];
                [userdefault synchronize];
                
                UserInfoModel *userInfoModel = [[UserInfoModel alloc] init];
                userInfoModel.phone_number = iphoneTextField.text;
                userInfoModel.deviceId = kDeviceId;
                userInfoModel.user_token=[jsonDict valueForKey:@"user_token"];
                [[UserManager shareInstaced] setUserInfo:userInfoModel];
                NSLog(@"user_token:%@", userInfoModel.user_token);
                NSLog(@"deviceId:%@", userInfoModel.deviceId);
                
                if([jsonDict[@"need_evpi"] intValue] == 1)
                {
//                    EditMyPersonInfoViewController *editMyPersonInfo = [[EditMyPersonInfoViewController alloc] init];
//                    editMyPersonInfo.isHiddenBackButton=YES;
//                    editMyPersonInfo.isChangeRootVC=YES;
//                    editMyPersonInfo.titleString=@"完善个人信息";
//                    [self.navigationController pushViewController:editMyPersonInfo animated:YES];
                }
                else{
                    YZTVTabBarController *tb = [[YZTVTabBarController alloc] init];
                    [UIApplication sharedApplication].keyWindow.rootViewController = tb;
                }
                
                break;
            }
                
                       default:
                break;
        }
    } fail:^(NSError *error) {
        
    }];
    NSLog(@"绑定手机");
}

#pragma mark 获得短信验证码
- (void)getVerificationCode
{
    NSLog(@"发送验证码");
    
    
    // BOOL isValid = [predicate evaluateWithObject:_phoneNum];
    if ([iphoneTextField.text isEqualToString:@""]) {
        // [CCommonClass alertAutoDismiss:@"提示" withMessage:@"请输入有效的用户名" withTime:1.0];
        [[iToast makeText:@"请输入有效的手机号码"]show];
     
        NSLog(@"请输入有效的手机号码");
    }
    else{
        NSMutableDictionary *sendPhoneCode = [[NSMutableDictionary alloc] init];
        sendPhoneCode[@"deviceId"] = [DeviceInfo getDeviceId];
        sendPhoneCode[@"mecheck"] = @"";
        sendPhoneCode[@"phone_number"] = iphoneTextField.text;
        sendPhoneCode[@"template_type"] = @20;
        
        [UrlRequest postRequestWithUrl:kSecurityCodeUrl parameters:sendPhoneCode success:^(NSDictionary * jsonDict) {
            NSLog(@"短信请求返回数据:%@", jsonDict);
            if([jsonDict[@"code"] intValue] == 0)
            {
                [self getPhoneCode];

                codeResponseModel = [PhoneCodeResponseModel keyWithDict:jsonDict];
            }
            
            
        } fail:^(NSError *error) {
            
        }];
        //        NSLog(@"注册码已发送:%@", phone_number);
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
@end
