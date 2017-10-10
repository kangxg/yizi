//
//  HomeViewController.m
//  YiziTV
//
//  Created by 井泉 on 16/6/15.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "HomeViewController.h"
#import "LivePlayerViewController.h"
#import "LiveInfoModel.h"
#import "HomeViewTableViewCell.h"
#import "MJRefresh.h"
#import "YZTVTabBar.h"
#import "SearchViewController.h"
#import "CityViewController.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * homeTableView;
    
    NSMutableArray * dataArray;
    
    int  page_index;
    
    MJRefreshAutoNormalFooter * footer;
    
    CGFloat contentOffsetY;
    CGFloat oldContentOffsetY;
    CGFloat newContentOffsetY;
    
    WKProgressHUD * homeHud;
    //选择的城市
    NSString * selectCity;
    
    BOOL isAnchor;
    
    
    
    
   
}


@end

@implementation HomeViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestUrl];
    
    
}

-(void)requestUrl
{
    page_index=1;
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:[NSNumber numberWithInt:page_index] forKey:@"page_index"];
    if (selectCity.length) {
        [paramDic setValue:selectCity forKey:@"postion_city"];
    }
    [paramDic setValue:[NSNumber numberWithBool:isAnchor] forKey:@"anchor_type"];
    [UrlRequest postRequestWithUrl:kGetHomeDataUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        
        [homeHud dismiss:YES];
        [homeTableView.mj_header endRefreshing];
        
//        NSLog(@"大厅数据 ------%@",jsonDict);
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            if (dataArray.count) {
                [dataArray removeAllObjects];
            }

            NSArray * arr=[jsonDict valueForKey:@"data"];
            for (int i=0; i<arr.count; i++) {
                NSDictionary * dic=[arr objectAtIndex:i];
               
                    LiveInfoModel * model=[[LiveInfoModel alloc]init];
                    [model analysisRequestJsonNSDictionary:dic];
                    [dataArray addObject:model];
        
                
            }
            
            [homeTableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"椅子TV";
    dataArray=[NSMutableArray array];
    
   homeHud = [WKProgressHUD showInView:self.navigationController.view withText:@"" animated:YES];
    
    homeTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, KNavBarHeight, kScreenWidth, kScreenHeight-kTabBarHeight-KNavBarHeight) style:UITableViewStyleGrouped];
    homeTableView.backgroundColor=[UIColor customColorWithString:@"#eeeeee"];
    homeTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    homeTableView.dataSource=self;
    homeTableView.delegate=self;
    [self.view addSubview:homeTableView];
    
    
    
    homeTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestUrl];
    }];
    

    
    footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    homeTableView.mj_footer=footer;
    footer.automaticallyHidden=YES;
    
//    [self setNavViewItem];

}
-(void)setNavViewItem
{
    
    
    //搜索
    
    UIButton * leftButoon=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, KNavBarHeight, KNavBarHeight-20)];
//    leftButoon.backgroundColor=[UIColor redColor];
    [leftButoon setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [leftButoon setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, KNavBarHeight-22+2)];
    [leftButoon setImage:[UIImage imageNamed:@"search_press"] forState:UIControlStateHighlighted];
    UIBarButtonItem * leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftButoon];
    leftButoon.width=KNavBarHeight;
    [leftButoon addTarget:self action:@selector(gotoSearchVC) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    //签约主播
    UIButton *  signButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18+22, KNavBarHeight-20)];
    [signButton setImageEdgeInsets:UIEdgeInsetsMake(0, 18, 0, 0)];
    [signButton setImage:[UIImage imageNamed:@"medal"] forState:UIControlStateNormal];
//    signButton.backgroundColor=[UIColor redColor];
    [signButton setImage:[UIImage imageNamed:@"medal_select"] forState:UIControlStateSelected];
    [signButton addTarget:self action:@selector(clickSignButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * signItem=[[UIBarButtonItem alloc]initWithCustomView:signButton];
    
    UIButton * locationButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18+20, KNavBarHeight-20)];
//    locationButton.backgroundColor=[UIColor blueColor];
    [locationButton setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
    [locationButton setImage:[UIImage imageNamed:@"map_press"] forState:UIControlStateHighlighted];
    [locationButton setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, -2)];
    [locationButton addTarget:self action:@selector(gotoCityViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * locationItem=[[UIBarButtonItem alloc]initWithCustomView:locationButton];
    self.navigationItem.rightBarButtonItems=@[locationItem,signItem];
    
    
    
    
    
}
-(void)clickSignButton:(UIButton*)btn
{
    
    btn.selected=!btn.selected;
    isAnchor=btn.selected;
    [self requestUrl];
    

}
-(void)gotoCityViewController
{
    CityViewController * cityVC=[[CityViewController alloc]init];
    cityVC.selectLiveCityName=^(NSString * cityName)
    {
        selectCity=cityName;
        [self requestUrl];
        
    };
    [self.navigationController pushViewController:cityVC animated:YES];
}
-(void)gotoSearchVC
{
    SearchViewController * searchVC=[[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
}
-(void)loadMoreData
{
    page_index++;
    
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:[NSNumber numberWithInt:page_index] forKey:@"page_index"];
    
    if (selectCity.length) {
        [paramDic setValue:selectCity forKey:@"postion_city"];
    }
   [paramDic setValue:[NSNumber numberWithBool:isAnchor] forKey:@"anchor_type"];
    
    [UrlRequest postRequestWithUrl:kGetHomeDataUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
       
        
        NSLog(@"加载更多大厅数据 ------%@",jsonDict);
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            NSArray * arr=[jsonDict valueForKey:@"data"];
            if (arr.count) {
                [homeTableView.mj_footer endRefreshing];
                for (int i=0; i<arr.count; i++) {
                    NSDictionary * dic=[arr objectAtIndex:i];
                    
                    LiveInfoModel * model=[[LiveInfoModel alloc]init];
                    [model analysisRequestJsonNSDictionary:dic];
                    [dataArray addObject:model];
                    
                    
                }

            }else{
                [homeTableView.mj_footer endRefreshing];
                [footer setRefreshingTitleHidden:YES];
                [footer setTitle:@"没有更多数据" forState:MJRefreshStateIdle];
            }
            
            [homeTableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];
    

    

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID=@"homeCell";
    HomeViewTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[HomeViewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    LiveInfoModel * model=[dataArray objectAtIndex:indexPath.section];

    [cell setInfoModel:model];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenWidth+70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0000000001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LivePlayerViewController * livePlayVC=[[LivePlayerViewController alloc]init];
    LiveInfoModel * model=[dataArray objectAtIndex:indexPath.section];
//    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    
//    if ([model.uid isEqualToString:user.uid]) {
//        
//        return;
//        
//    }
//    HomeViewTableViewCell * cell=[homeTableView cellForRowAtIndexPath:indexPath];
    livePlayVC.liveModel=model;
    livePlayVC.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:livePlayVC animated:NO];

   
    
}
// 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"++开始拖拽");
    contentOffsetY = scrollView.contentOffset.y;
}

// 滚动时调用此方法(手指离开屏幕后)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollView.contentOffset:%f, %f", scrollView.contentOffset.x, scrollView.contentOffset.y);
    newContentOffsetY = scrollView.contentOffset.y;
    if (newContentOffsetY > oldContentOffsetY && oldContentOffsetY > contentOffsetY) { // 向上滚动
       NSLog(@"up");
    } else if (newContentOffsetY < oldContentOffsetY && oldContentOffsetY < contentOffsetY) {// 向下滚动
        NSLog(@"down");
    } else {
        //        NSLog(@"dragging");
    }
    if (scrollView.dragging) { // 拖拽
        //        NSLog(@"scrollView.dragging");
        //        NSLog(@"contentOffsetY: %f", contentOffsetY);
        //        NSLog(@"newContentOffsetY: %f", scrollView.contentOffset.y);
        if ((scrollView.contentOffset.y - contentOffsetY) > 5.0f) {  // 向上拖拽
//            NSLog(@"向上拖拽");
            
            // 隐藏导航栏和选项栏
            
           
            YZTVTabBar * tabbarview=[self.tabBarController.view.subviews objectAtIndex:1];
            
            [UIView animateWithDuration:0.25 animations:^(void){
                
                 homeTableView.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight);
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                tabbarview.alpha=0;
                
            } completion:^(BOOL finish){
                
                
                
            }];

            
            
            
        }
        else if ((contentOffsetY - scrollView.contentOffset.y) > 5.0f)
        {   // 向下拖拽
//            NSLog(@"--向下拖拽");
            
            
            YZTVTabBar * tabbarview=[self.tabBarController.view.subviews objectAtIndex:1];
            
            [UIView animateWithDuration:0.25 animations:^(void){
                homeTableView.frame=CGRectMake(0, KNavBarHeight, kScreenWidth, kScreenHeight-KNavBarHeight-kTabBarHeight);
                [self.navigationController setNavigationBarHidden:NO animated:NO];
                tabbarview.alpha=1;
                
            } completion:^(BOOL finish){
                
                
                
            }];

            
        } else {
            
        }
    }
}

// 完成拖拽(滚动停止时调用此方法，手指离开屏幕前)
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // NSLog(@"scrollViewDidEndDragging");
    oldContentOffsetY = scrollView.contentOffset.y;
//    NSLog(@"停止拖拽");
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
