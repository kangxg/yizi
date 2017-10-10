//
//  MyFansAndCareViewController.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/28.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "MyFansAndCareViewController.h"
#import "FansTableViewCell.h"
#import "CardInfoModel.h"
#import "MJRefresh.h"

@interface MyFansAndCareViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * dataArray;
    
    UITableView * fansTableView;
    
    int pageIndex;
    
    NSString * url;
    
    MJRefreshAutoNormalFooter * footer;
    

}
@end

@implementation MyFansAndCareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.isComeFans) {
        self.title=@"粉丝";
    }else{
        self.title=@"关注";
        
    }
    
    self.view.backgroundColor=[UIColor customColorWithString:@"#eeeeee"];
    
    pageIndex=1;
    
    dataArray=[NSMutableArray array];
    
    fansTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, KNavBarHeight, kScreenWidth, kScreenHeight-KNavBarHeight) style:UITableViewStylePlain];
    fansTableView.backgroundColor=[UIColor clearColor];
    fansTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    fansTableView.delegate=self;
    fansTableView.dataSource=self;
    [self.view addSubview:fansTableView];
    [self requestUrl];
    
    footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    footer.automaticallyHidden=YES;
    fansTableView.mj_footer=footer;

    

    
}
-(void)requestUrl
{
    
   
    if (self.isComeFans) {
        url=kMyFansListUrl;
        
    }else
    {
        url=kMyFocusListUrl;
        
    }

    
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    UserInfoModel * user =[[UserManager shareInstaced]getUserInfoModel];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:[NSNumber numberWithInt:pageIndex] forKey:@"pageIndex"];
    
    [UrlRequest postRequestWithUrl:url parameters:paramDic success:^(NSDictionary *jsonDict) {
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            NSLog(@"关注粉丝======%@",jsonDict);
            NSArray * array=[jsonDict valueForKey:@"data"];
            
            if (array.count) {
                
            for (int i=0; i<array.count; i++) {
                
                CardInfoModel * model=[[CardInfoModel alloc]init];
                [model analysisMyFansFocusRequestWithDic:[array objectAtIndex:i]];
                
                [dataArray addObject:model];
            }
            
            
            [fansTableView reloadData];
            
            
            [self loadMoreData];
            }
            else
            {
            
                [self showNullView];
            
            }
        }
        
    } fail:^(NSError *error) {
        
    }];
    
    
}
-(void)showNullView
{
    NSString * content;
     if (self.isComeFans) {
         
       
         content=@"你还没有粉丝哦";
     }else
     {
         content=@"您还没有关注的人哦，快去看直播";
     }

    
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-93/2, (kScreenHeight-KNavBarHeight-40)/2-85/2, 93, 85)];
    imageView.image=[UIImage imageNamed:@"smile"];
    [self.view addSubview:imageView];
    
    UILabel * contentLabel=[UILabel setLabelFrame:CGRectMake(10, CGRectGetMaxY(imageView.frame)+20, kScreenWidth-20, 20) Text:content TextColor:[UIColor customColorWithString:@"c8c8c8"] font:[UIFont fontWithName:TextFontName size:16] textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:contentLabel];
    
    
    

}
-(void)loadMoreData
{
    pageIndex++;
    
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    UserInfoModel * user =[[UserManager shareInstaced]getUserInfoModel];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:[NSNumber numberWithInt:pageIndex] forKey:@"pageIndex"];
    
    [UrlRequest postRequestWithUrl:url parameters:paramDic success:^(NSDictionary *jsonDict) {
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            [fansTableView.mj_footer endRefreshing];
            NSArray * array=[jsonDict valueForKey:@"data"];
            if (array.count==0 ) {
            
                [footer setRefreshingTitleHidden:YES];
                [footer setTitle:@"没有更多数据" forState:MJRefreshStateIdle];
                

                
            }else
            {
            
            for (int i=0; i<array.count; i++) {
                
                CardInfoModel * model=[[CardInfoModel alloc]init];
                [model analysisMyFansFocusRequestWithDic:[array objectAtIndex:i]];
                
                [dataArray addObject:model];
            }
            }
            
            [fansTableView reloadData];
        }
        
    } fail:^(NSError *error) {
        
    }];

    

}
#pragma mark tableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FansTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"FCELL"];
    if (cell==nil) {
        cell=[[FansTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"FCELL"];
        
    }

    CardInfoModel * model=[dataArray objectAtIndex:indexPath.row];
    [cell setModel:model];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66.0;
    
}

-(void)backToLastController
{
    
    if (self.returnCallback!=nil) {
        self.returnCallback();
    }
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
