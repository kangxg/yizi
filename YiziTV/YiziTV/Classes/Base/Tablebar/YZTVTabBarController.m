//
//  YZTVTabBarController.m
//  YiziTV
//
//  Created by 井泉 on 16/6/15.
//  Copyright © 2016年 JQ. All rights reserved.
//



#import "YZTVTabBarController.h"
#import "YZTVTabBarButton.h"
#import "YZTVTabBar.h"


@interface YZTVTabBarController () <YZTVTabBarDelegate>

@end


@implementation YZTVTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.hidden=YES;
    [self.tabBar removeFromSuperview];
    self.yzTabBar = [[YZTVTabBar alloc] initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth, 49)];
     self.yzTabBar.tabBarDelegate = self;
    [self.view addSubview: self.yzTabBar];
    
    
  
     NSMutableArray* array=[[NSMutableArray alloc]init];
     NSArray* viewArray=[NSArray arrayWithObjects:@"HomeViewController",@"CallingVardViewController",@"ProfileViewController", nil];
    for (int i=0; i<viewArray.count; i++) {
        NSString* viewName=[viewArray objectAtIndex:i];
        UINavigationController* nav=[self creatNav:viewName];
        [array addObject:nav];
        
    }
    
    self.viewControllers=array;

}

#pragma mark - HWTabBarDelegate代理方法
- (void)tabBarDidClickPlusButton
{
    UINavigationController * navigationController =[self creatNav:@"LiveTVViewController"];
    [self presentViewController:navigationController animated:YES completion:nil];
}
-(void)clickTabarItemButton:(YZTVTabBarButton *)YZbtn
{
 
    
    for (int i=1; i<4; i++) {
        YZTVTabBarButton * button=[self.yzTabBar viewWithTag:i];
        if (i==YZbtn.tag) {
            
            button.iconImage.highlighted=YES;
            [button setIconTitleHighlightColor:YES];
        }else
        {
            button.iconImage.highlighted=NO;
            [button setIconTitleHighlightColor:NO];
        }
    }
    
    self.selectedIndex=YZbtn.tag-1;

}
-(UINavigationController*)creatNav:(NSString*)viewname
{
    Class cls=NSClassFromString(viewname);
    UIViewController* vc=[[cls alloc]init];
    UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:vc];
    return nav;
}


@end
