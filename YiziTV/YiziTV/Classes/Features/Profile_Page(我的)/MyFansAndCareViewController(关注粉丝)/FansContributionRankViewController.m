//
//  FansContributionRankViewController.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/20.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "FansContributionRankViewController.h"
#import "FansContributionRankTableViewCell.h"
#import "FansModel.h"

@interface FansContributionRankViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * fansContributionTaleView;
    
    NSMutableArray * fansArray;
    
    UIView * nullView;
}
@end

@implementation FansContributionRankViewController
-(void)requesturl
{

    //kFansContributionUrl
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:[DeviceInfo getDeviceId] forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:self.uid forKey:@"anchor_id"];
    
    [UrlRequest postRequestWithUrl:kFansContributionUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            NSArray * dataArray=[jsonDict valueForKey:@"data"];
            if (dataArray.count) {
               
               
                double money=[[jsonDict valueForKey:@"sum_contribution"]doubleValue];
                
                _receiveGiftCount=[NSString stringWithFormat:@"%0.f",money];
                
                [self showDiamon];
                if (nullView) {
                    [nullView removeFromSuperview];
                }
                for (int i = 0; i < dataArray.count; i++) {
                    
                    FansModel * model=[[FansModel alloc]init];
                    NSDictionary * dic=[dataArray objectAtIndex:i];
                    [model analysisRequestJsonNSDictionary:dic];
                    [fansArray addObject:model];
                    
                }
                
                [fansContributionTaleView reloadData];
                
                
                
            }else
            {
            
                [self showNullView];
            
            }
            
            
        }
        
    } fail:^(NSError *error) {
        
    }];
    

}
-(void)showNullView
{

    if (nullView==nil) {
        
    
    nullView=[[UIView alloc]initWithFrame:CGRectMake(0, KNavBarHeight, kScreenWidth, kScreenHeight-KNavBarHeight)];
        nullView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:nullView];
        
        
     UIImageView *    nullImageView=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-93/2, (nullView.height)/2-(85)/2-100, 93, 85)];
        nullImageView.image=[UIImage imageNamed:@"gift_empty"];
     [nullView addSubview:nullImageView];
        
      UILabel *   contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-200/2, CGRectGetMaxY(nullImageView.frame)+20, 200, 20)];
        
        NSString * content;
        UserInfoModel   * user=[[UserManager shareInstaced]getUserInfoModel];
        if ([user.uid isEqualToString:self.uid]) {
            
        content=@"快去直播赚钱吧";
            
        }else
        {
        content=@"快来为TA出份力";
            
        }
        contentLabel.text=content;
        contentLabel.textAlignment=NSTextAlignmentCenter;
        contentLabel.font=[UIFont fontWithName:TextFontName size:16];
        contentLabel.textColor=[UIColor customColorWithString:@"c8c8c8"];
        [nullView addSubview:contentLabel];

        
        
        
        
    }

}
-(void)showDiamon
{
    NSString * showSting=[NSString stringWithFormat:@"共计：%@",_receiveGiftCount];
    CGFloat giftCountWidth=[UILabel getLabelWidthWithText:showSting wordSize:14 height:15];
    UIImageView * diaImageView=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-(18+7+giftCountWidth)/2, KNavBarHeight+(46/2-18/2), 23, 16)];
    diaImageView.image=[UIImage imageNamed:@"icon_diamond"];
    [self.view addSubview:diaImageView];
    
    UILabel * countLabel=[UILabel setLabelFrame:CGRectMake(CGRectGetMaxX(diaImageView.frame)+7, diaImageView.y, giftCountWidth, 14) Text:showSting TextColor:[UIColor customColorWithString:@"0d0e0d"] font:[UIFont fontWithName:TextFontName size:14] textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:countLabel];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"粉丝贡献榜";
    leftBotton.hidden=NO;
    self.view.backgroundColor=[UIColor customColorWithString:@"#eeeeee"];
    
    
    

    
    fansArray=[NSMutableArray array];
    
    
    fansContributionTaleView=[[UITableView alloc]initWithFrame:CGRectMake(0,KNavBarHeight+46, kScreenWidth, kScreenHeight-KNavBarHeight-46) style:UITableViewStylePlain];
    fansContributionTaleView.separatorStyle=UITableViewCellSelectionStyleNone;
    fansContributionTaleView.delegate=self;
    fansContributionTaleView.dataSource=self;
    [self.view addSubview:fansContributionTaleView];
    
    [self requesturl];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return fansArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    switch (indexPath.row) {
        case 0:
        {
            
            FansContributionRankTableViewCell * cell=[[FansContributionRankTableViewCell
                                                       alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ID"];
            
            FansModel * model=[fansArray objectAtIndex:indexPath.row];
            [cell setFansModel:model];
            [cell setSingImageView:@"1"];
            return cell;
            

        }
            break;
        case 1:
        {
            
            FansContributionRankTableViewCell * cell=[[FansContributionRankTableViewCell
                                                       alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ID"];
            
            FansModel * model=[fansArray objectAtIndex:indexPath.row];
            [cell setFansModel:model];
            [cell setSingImageView:@"2"];
            return cell;
            

        
        }
            break;
        case 2:
        {
            
            FansContributionRankTableViewCell * cell=[[FansContributionRankTableViewCell
                                                       alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ID"];
            
            FansModel * model=[fansArray objectAtIndex:indexPath.row];
            [cell setFansModel:model];
            [cell setSingImageView:@"3"];
            
            return cell;
            

        
        }
            break;
            
        default:
        {
            FansContributionTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"FCell"];
            if (cell==nil) {
            
                cell=[[FansContributionTableViewCell
                       alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"FCell"];
            }
            
            
          
            
            FansModel * model=[fansArray objectAtIndex:indexPath.row];
            [cell setFansModel:model];
            [cell setRankName:[NSString stringWithFormat:@"%ld",indexPath.row+1]];            
            return cell;
            

        
        }
            break;
    }
    
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<3) {
       return 75.0f;
    }
   
    return 63.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0000001;
}
-(void)backToLastController
{
    [self.navigationController popViewControllerAnimated:NO];
    
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
