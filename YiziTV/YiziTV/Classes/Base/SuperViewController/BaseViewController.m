//
//  BaseViewController.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/17.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor=[UIColor whiteColor];
    self.topTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 20, (kScreenWidth-120)/2, 44)];
    self.topTitleLabel.font=[UIFont systemFontOfSize:18];
    self.topTitleLabel.textColor=[UIColor customColorWithString:@"#0d0e0d"];
    self.topTitleLabel.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=self.topTitleLabel;

}
-(void)setTitle:(NSString *)title
{
    self.topTitleLabel.text=title;
    
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
