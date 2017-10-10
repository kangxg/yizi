//
//  SuggestViewController.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/24.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "SuggestViewController.h"
#import "iToast.h"

@interface SuggestViewController ()<UITextViewDelegate>
{
    UILabel * _remainCountLabel;
    UITextView * _tv;
    
}
@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=[UIColor customColorWithString:@"eeeeee"];
    self.title=@"产品反馈";
    
    
    UIButton * rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, KNavBarHeight)];
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor customColorWithString:@"28904e"] forState:UIControlStateNormal];
    rightButton.titleLabel.font=[UIFont fontWithName:TextFontName size:18];
    rightButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [rightButton addTarget:self action:@selector(sendMysuggest) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightItem ;
    UIView * backView=[[UIView alloc]initWithFrame:CGRectMake(0, KNavBarHeight+20, kScreenWidth, 128)];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    _tv=[[UITextView alloc]initWithFrame:CGRectMake(16,0, kScreenWidth-32, 120)];
    
    _tv.delegate=self;
    _tv.font=[UIFont fontWithName:TextFontName size:16];
    _tv.textColor=[UIColor customColorWithString:@"0d0e0d"];
    
    _tv.selectedRange=NSMakeRange(16,0);
    _tv.text=@"为什么...";
    [backView addSubview:_tv];

    
    
    _remainCountLabel=[UILabel setLabelFrame:CGRectMake(kScreenWidth-16-100, backView.height-13-10, 100, 10) Text:@"仅限100字以内" TextColor:[UIColor customColorWithString:@"909290"] font:[UIFont fontWithName:TextFontName size:10] textAlignment:NSTextAlignmentRight];
    [backView addSubview:_remainCountLabel];
    
    
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length==0) {
        textView.text=@"为什么...";
        textView.tag=0;
    }
    
    
    NSString * toBeString = textView.text;
    NSString * lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    
    if ([lang isEqualToString:@"zh-Hans"])
    {
        UITextRange * selectedRange = [textView markedTextRange];
        UITextPosition * position = [textView positionFromPosition:selectedRange.start offset:0];
        if (!position)
        {
            
            if (toBeString.length > 100)
            {
                NSRange range ={0,100};
                textView.text = [toBeString substringWithRange:range];
            }
            
            
        }
        
    }
    else if([lang isEqualToString:@"emoji"])
    {
        NSRange range ={0,textView.text.length-1};
        textView.text = [toBeString substringWithRange:range];
    }
    else
    {
        
        if (textView.text.length > 100)
        {
            NSRange range ={0,100};
            textView.text = [toBeString substringWithRange:range];
        }
        
        
        
        
    }

    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_tv resignFirstResponder];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([textView.textInputMode.primaryLanguage isEqualToString:@"emoji"]) {
        
        return NO;
    }
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView.tag==0) {
        textView.text=@"";
        textView.tag=1;
    }
    return YES;

}
-(void)sendMysuggest
{
    [self.view endEditing:YES];
    
    if (_tv.text.length==0) {
        
        [[iToast makeText:@"请把您的建议反馈告诉我们"]show];
        return;
    }
    
    
    WKProgressHUD * hud=[WKProgressHUD showInView:self.navigationController.view withText:nil animated:YES];

    
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    
    [paramDic setValue:_tv.text forKey:@"content"];
    
    [UrlRequest postRequestWithUrl:kSuggestUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        [hud dismiss:YES];
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            [[iToast makeText:@"感谢您的反馈"]show];
            
            [self backToLastController];
  
            
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
