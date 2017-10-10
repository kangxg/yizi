//
//  SecondLayerViewController.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/20.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "SecondLayerViewController.h"
#import "YZTVTabBar.h"
@interface SecondLayerViewController ()

@end

@implementation SecondLayerViewController
-(void)viewWillAppear:(BOOL)animated
{
    YZTVTabBar * tabbarview=[self.tabBarController.view.subviews objectAtIndex:1];
    
    [UIView animateWithDuration:0.3 animations:^(void){
        
        tabbarview.alpha=0;
        
    } completion:^(BOOL finish){
        
        
        
    }];
    
    
}
-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    leftBotton=[[UIButton alloc]initWithFrame:CGRectMake(0,0,60, KNavBarHeight)];
    
     UIBarButtonItem * leftButton=[[UIBarButtonItem alloc]initWithCustomView:leftBotton];
    [leftBotton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBotton setImage:[UIImage imageNamed:@"back_press"] forState:UIControlStateHighlighted];
    [leftBotton setImageEdgeInsets:UIEdgeInsetsMake(KNavBarHeight/2-18/2, 0, KNavBarHeight/2-18/2, 31+18)];
    [leftBotton addTarget:self action:@selector(backToLastController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=leftButton;

    
    
    
    
}
-(void)backToLastController
{

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
