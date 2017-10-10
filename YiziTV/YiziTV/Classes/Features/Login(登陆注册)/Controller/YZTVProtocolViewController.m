//
//  YZTVProtocolViewController.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/29.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "YZTVProtocolViewController.h"

@interface YZTVProtocolViewController ()<UIWebViewDelegate>
{
    UIWebView * mainWebView;
    UIActivityIndicatorView *activityIndicatorView;
    
}
@end

@implementation YZTVProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"椅子TV用户协议";
    
    mainWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, KNavBarHeight, kScreenWidth, kScreenHeight)];
    mainWebView.delegate = self;
    mainWebView.scalesPageToFit = YES;
    mainWebView.scrollView.bounces=NO;
    [self.view addSubview:mainWebView];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    [activityIndicatorView setCenter: self.view.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray] ;
    [self.view addSubview : activityIndicatorView] ;
    
    NSString *str = @"http://app.yizijob.com/static/common/useragreement.html";
    NSLog(@"协议str = %@",str);
    NSURL *webUrl =[NSURL URLWithString:str];
    NSURLRequest *request =[[NSURLRequest alloc]initWithURL:webUrl cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    [mainWebView loadRequest:request];
    

    
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* rurl=[[request URL] absoluteString];
    NSLog(@"11111 = %@",rurl);
    if ([rurl hasPrefix:@"protocol://"]) {
        NSString *paraString = [rurl substringFromIndex:[@"protocol://" length]];
        NSLog(@"22222 = %@",paraString);
        NSArray *arr = [paraString componentsSeparatedByString:@":"];
        NSLog(@"33333 = %@",arr);
        if ([arr count] > 1) {
            NSString *info = [arr objectAtIndex:0];
            NSLog(@"参数 = %@",info);
            //NSArray *arr1 = [info componentsSeparatedByString:@","];
            NSString *actionName = [paraString substringFromIndex:[info length]+1];
            NSLog(@"命令名 = %@",actionName);
            if ([actionName isEqualToString:@"002"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView

{
    
    [activityIndicatorView startAnimating] ;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView

{
    [webView stringByEvaluatingJavaScriptFromString:@"WHCLBridge.setPlatform('ios');"];
    [activityIndicatorView stopAnimating];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error

{
    
    if ((([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == -999) ||
         ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)))
    {
        UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"服务器君正在没命加载，亲等等我哦~一下下就好~~就一下下~~~" message:nil  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
        
        [alterview show];
    }
    
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
