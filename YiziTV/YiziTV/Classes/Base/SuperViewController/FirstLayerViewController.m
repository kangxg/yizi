//
//  FirstLayerViewController.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/20.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "FirstLayerViewController.h"
#import "YZTVTabBar.h"
@interface FirstLayerViewController ()

@end

@implementation FirstLayerViewController
-(void)viewWillAppear:(BOOL)animated
{

    YZTVTabBar * tabbarview=[self.tabBarController.view.subviews objectAtIndex:1];
    [UIView animateWithDuration:0.3 animations:^(void){
        
        tabbarview.alpha=1;
        
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
