//
//  CallingVardViewController.m
//  YiziTV
//
//  Created by 井泉 on 16/6/15.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "CallingVardViewController.h"
#import "ReceiveCardTopView.h"
#import "ReceiveCardTableViewCell.h"
#import "CardInfoModel.h"
#import "ReceiveCardModel.h"
#import "AppDelegate.h"
#import "CardInfoDetailView.h"
#import "ShowCardDetailViewController.h"
#import "MJRefresh.h"

@interface CallingVardViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * cardTableView;
    
    NSMutableArray * dataArray;
    
    int pageIndex;
    
    
    NSMutableArray * timeArray;
    
    MJRefreshAutoNormalFooter * footer;
    
    //所有返回数组中的字典
    NSMutableArray * dicArray;
    
    WKProgressHUD * cardHud;
    
    UIImageView * nullView;
    UILabel * contentLabel;
    

}
@end

@implementation CallingVardViewController
-(void)nullDataView
{
    if (nullView==nil) {
    
    nullView=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-87/2, (kScreenHeight-KNavBarHeight-kTabBarHeight-40)/2-69/2, 87, 69)];
    nullView.image=[UIImage imageNamed:@"empty_card"];
    [self.view addSubview:nullView];
    
    contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-200/2, CGRectGetMaxY(nullView.frame)+20, 200, 20)];
    contentLabel.text=@"您还没有收到名片";
    contentLabel.textAlignment=NSTextAlignmentCenter;
    contentLabel.font=[UIFont fontWithName:TextFontName size:16];
    contentLabel.textColor=[UIColor customColorWithString:@"c8c8c8"];
    [self.view addSubview:contentLabel];
        
    }
    

}
-(void)viewWillAppear:(BOOL)animated
{
    if (!self.isComeFromLiveRoom) {
        
        [super viewWillAppear:animated];
    }
    
    
     [self requestUrl];
}
-(void)requestUrl
{
    
    pageIndex=1;
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:[NSNumber numberWithInt:pageIndex] forKey:@"pageIndex"];
    
    [UrlRequest postRequestWithUrl:kGetMyReceiveCardsUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        NSLog(@"我收到的名片======%@",jsonDict);
        [cardHud dismiss:YES];
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            [cardTableView.mj_header endRefreshing];
            NSArray * arr=[jsonDict valueForKey:@"data"];
            if (arr.count) {
                if (nullView) {
                    [nullView removeFromSuperview];
                    [contentLabel removeFromSuperview];
                    
                }
                if (dataArray.count) {
                    [dataArray removeAllObjects];
                    [dicArray removeAllObjects];
                }
            NSMutableArray * tempTimeArr=[NSMutableArray array];
            for (int i=0; i<arr.count; i++) {
            NSDictionary * dic=[arr objectAtIndex:i];
                [dicArray addObject:dic];
            long long timeInterval=[[dic valueForKey:@"send_time"]longLongValue];
            NSString * time=[NSString dateWithIntervale:timeInterval formateStyle:@"YYYY-MM-dd"];
            [tempTimeArr addObject:time];
                
            }
            

                
            for (int j=0; j<tempTimeArr.count; j++) {
                
                NSString * string=[tempTimeArr objectAtIndex:j];
                if ([timeArray containsObject:[tempTimeArr objectAtIndex:j]]==NO) {
                    
                   
                    [timeArray addObject:string];
                    
                    
                }
            }
                
           
            for (int x=0; x<timeArray.count; x++) {
                NSString * time=[timeArray objectAtIndex:x];
                ReceiveCardModel  * cardModel=[[ReceiveCardModel alloc]init];
                cardModel.dateTime=time;
                for (int y=0; y<dicArray.count; y++) {

                    NSDictionary * modelDic=[dicArray objectAtIndex:y];
                    long long timeInterval=[[modelDic valueForKey:@"send_time"]longLongValue];
                    NSString * modeltime=[NSString dateWithIntervale:timeInterval formateStyle:@"YYYY-MM-dd"];
                    if ([time isEqualToString:modeltime]) {
                        CardInfoModel * model=[[CardInfoModel alloc]init];
                        [model analysisMyReceiveCardsRequestWithDic:modelDic];
                         [cardModel.cardArray addObject:model];

                    }
                   
                }
                [dataArray addObject:cardModel];
                
                [cardTableView reloadData];
                
                
            }
            }
            else{
            
                [self nullDataView];
            }
            
            
        }
        
    } fail:^(NSError *error) {
        
    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"收到的名片";
    
    
    if (self.isComeFromLiveRoom) {
        UIButton *  leftBotton=[[UIButton alloc]initWithFrame:CGRectMake(0,0,60, KNavBarHeight)];
        
        UIBarButtonItem * leftButton=[[UIBarButtonItem alloc]initWithCustomView:leftBotton];
        [leftBotton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [leftBotton setImage:[UIImage imageNamed:@"back_press"] forState:UIControlStateHighlighted];
        [leftBotton setImageEdgeInsets:UIEdgeInsetsMake(KNavBarHeight/2-18/2, 0, KNavBarHeight/2-18/2, 31+18)];
        [leftBotton addTarget:self action:@selector(backToLastController) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem=leftButton;

    }
    
    dataArray =[NSMutableArray array];
    timeArray=[NSMutableArray array];
    dicArray=[NSMutableArray array];

    
    self.view.backgroundColor=[UIColor customColorWithString:@"eeeeee"];
   
    
    cardHud = [WKProgressHUD showInView:self.navigationController.view withText:@"" animated:YES];

    
    cardTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, KNavBarHeight, kScreenWidth, kScreenHeight-kTabBarHeight-KNavBarHeight) style:UITableViewStyleGrouped];
    if (self.isComeFromLiveRoom) {
        cardTableView.frame=CGRectMake(0, KNavBarHeight, kScreenWidth, kScreenHeight-KNavBarHeight);
    }
    cardTableView.backgroundColor=[UIColor customColorWithString:@"#eeeeee"];
    cardTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    cardTableView.dataSource=self;
    cardTableView.delegate=self;
    [self.view addSubview:cardTableView];

    
    cardTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self requestUrl];
    }];
    
    footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    cardTableView.mj_footer=footer;
    footer.automaticallyHidden=YES;

    
}
-(void)backToLastController
{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)loadMoreData
{

    pageIndex++;
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:[NSNumber numberWithInt:pageIndex] forKey:@"pageIndex"];
    
    
    NSLog(@"-----------上传----%@",paramDic);
    [UrlRequest postRequestWithUrl:kGetMyReceiveCardsUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        NSLog(@"加载更多我收到的名片======%@",jsonDict);
        
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            NSArray * arr=[jsonDict valueForKey:@"data"];
            if (arr.count) {
               
                [footer endRefreshing];
                NSMutableArray * tempTimeArr=[NSMutableArray array];
                for (int i=0; i<arr.count; i++) {
                    NSDictionary * dic=[arr objectAtIndex:i];
                    [dicArray addObject:dic];
                    long long timeInterval=[[dic valueForKey:@"send_time"]longLongValue];
                    NSString * time=[NSString dateWithIntervale:timeInterval formateStyle:@"YYYY-MM-dd"];
                    [tempTimeArr addObject:time];
                    
                }
                
                
                for (int j=0; j<tempTimeArr.count; j++) {
                    
                    if ([timeArray containsObject:[tempTimeArr objectAtIndex:j]]==NO) {
                        [timeArray addObject:[tempTimeArr objectAtIndex:j]];
                        
                    }
                }
                
                [dataArray removeAllObjects];
                
                for (int x=0; x<timeArray.count; x++) {
                    NSString * time=[timeArray objectAtIndex:x];
                    ReceiveCardModel  * cardModel=[[ReceiveCardModel alloc]init];
                    cardModel.dateTime=time;
                    for (int y=0; y<dicArray.count; y++) {
                        NSDictionary * modelDic=[dicArray objectAtIndex:y];
                        long long timeInterval=[[modelDic valueForKey:@"send_time"]longLongValue];
                        NSString * modeltime=[NSString dateWithIntervale:timeInterval formateStyle:@"YYYY-MM-dd"];
                        if ([time isEqualToString:modeltime]) {
                            CardInfoModel * model=[[CardInfoModel alloc]init];
                            [model analysisMyReceiveCardsRequestWithDic:modelDic];
                            [cardModel.cardArray addObject:model];
                        }
                        
                    }
                    [dataArray addObject:cardModel];
                    
                    
                }
            }
            else
            {
            
                [cardTableView.mj_footer endRefreshing];
                [footer setRefreshingTitleHidden:YES];
                [footer setTitle:@"没有更多数据" forState:MJRefreshStateIdle];
            
            }
        
            [cardTableView reloadData];
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
     ReceiveCardModel * model=[dataArray objectAtIndex:section];
     return model.cardArray.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cardID=@"cardID";
    ReceiveCardTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cardID];
    if (cell==nil) {
        cell=[[ReceiveCardTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cardID];
    }
    
    ReceiveCardModel * cardModel =[dataArray objectAtIndex:indexPath.section];
    CardInfoModel * model=[cardModel.cardArray objectAtIndex:indexPath.row];
    [cell setCardModel:model];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 46.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000000001;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ReceiveCardTopView * topView=[[ReceiveCardTopView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 46)];
     ReceiveCardModel * model=[dataArray objectAtIndex:section];
    [topView setShowTime:model.dateTime];
    return topView;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
  UIImageView * imageView=  [UIImageView blurImageWithView:self.view];
    CardInfoDetailView * detailView=[[CardInfoDetailView alloc]init];
    [imageView addSubview:detailView];
    ReceiveCardModel * cardModel =[dataArray objectAtIndex:indexPath.section];
    CardInfoModel * model=[cardModel.cardArray objectAtIndex:indexPath.row];
    [detailView setModel:model];
    ShowCardDetailViewController * detailController=[[ShowCardDetailViewController alloc]init];
    detailController.backImageView=imageView;
    [self presentViewController:detailController animated:YES completion:nil];
    
    detailView.closeShowView=^{
    
        [detailController dismissViewControllerAnimated:YES completion:nil];
    };
    
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
