//
//  CityViewController.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/25.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "CityViewController.h"
#import "CityTableViewCell.h"
@interface CityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * cityTableView;
    
    NSIndexPath * selectIndexPath;
    
    
    NSMutableArray * cityArray;
    
    
    
}
@end

@implementation CityViewController
-(void)requestUrl
{
    
    WKProgressHUD * hud  = [WKProgressHUD showInView:self.navigationController.view withText:@"" animated:YES];

    
   [UrlRequest postRequestWithUrl:kPositionCityListUrl parameters:nil success:^(NSDictionary *jsonDict) {
       NSLog(@"城市+++++++++%@",jsonDict);
       
       [hud dismiss:YES];
       int code=[[jsonDict valueForKey:@"code"]intValue];
       if (code==0) {
           
           NSArray * dataArray=[jsonDict valueForKey:@"data"];
           if (dataArray.count) {
               
           
           for (int i=0 ; i<dataArray.count; i++) {
            
               NSDictionary * dic=[dataArray objectAtIndex:i];
               
               NSString * position_city=[dic valueForKey:@"position_city"];
               
               if ([position_city isEqualToString:self.currentCityName]) {
                   selectIndexPath=[NSIndexPath indexPathForRow:i inSection:0];
               }
               
               [cityArray addObject:position_city];
               
               
               
           }
               [cityTableView reloadData];
               
        }
       }
       
   } fail:^(NSError *error) {
       
   }];
    
    
    
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //kPositionCityListUrl
    
    self.title=self.currentCityName;
    
    leftBotton.hidden=YES;
    //关闭按钮
    UIButton * closeButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, KNavBarHeight, KNavBarHeight-20)];
    [closeButton setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"x_press"] forState:UIControlStateHighlighted];
    
    [closeButton setImageEdgeInsets:UIEdgeInsetsMake(0, closeButton.width-20, 0, 0)];
    [closeButton addTarget:self action:@selector(closeViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem=[[UIBarButtonItem alloc]initWithCustomView:closeButton];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    selectIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    
   
    cityArray=[NSMutableArray array];
    
    cityTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, KNavBarHeight, kScreenWidth, kScreenHeight-KNavBarHeight) style:UITableViewStylePlain];
    cityTableView.delegate=self;
    cityTableView.dataSource=self;
    cityTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:cityTableView];
    
    [self requestUrl];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cityArray.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CityTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[CityTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ID"];
        
    }
    if (selectIndexPath==indexPath) {
        [cell setSelectStatus:YES];
    }else{
    
       [cell setSelectStatus:NO];
    }
    
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    int newRow = (int)[indexPath row];
    
    int oldRow = (int)(selectIndexPath!=nil) ? (int)[selectIndexPath row] : -1;
    if(newRow != oldRow)
    {
        CityTableViewCell * newCell=(CityTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        [newCell setSelectStatus:YES];
        CityTableViewCell * oldCell=(CityTableViewCell*)[tableView cellForRowAtIndexPath:selectIndexPath];
        [oldCell setSelectStatus:NO];
        
        
        selectIndexPath=[indexPath copy];
        
    
    }
   
    if (self.selectLiveCityName!=nil) {
        
        self.title=self.currentCityName;
        NSString * name=[cityArray objectAtIndex:selectIndexPath.row];
        self.selectLiveCityName(name);
        [self closeViewController];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59;
    
}
-(void)closeViewController
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
