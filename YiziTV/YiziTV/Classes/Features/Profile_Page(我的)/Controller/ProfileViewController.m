//
//  ProfileViewController.m
//  YiziTV
//
//  Created by 井泉 on 16/6/15.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "ProfileViewController.h"
#import "MyCardView.h"
#import "CardInfoModel.h"
#import "EditMyCardInfoViewController.h"
#import "MyGoldCoinViewController.h"
#import "SettingViewController.h"
#import "EditMyPersonInfoViewController.h"
#import "MyFansAndCareViewController.h"
#import "FansContributionRankViewController.h"

@interface ProfileViewController ()<MyCardViewDelegateProtocol>
{
    
    UIScrollView * backScrollView;
    
    UIImageView * backImageView;
    UIButton * goldCoinButton;
    UIImageView * headImageView;
    
    //名字
    UILabel * nameLabel;
    //收到的礼物数
    UILabel * receiveGiftCountLabel;
    
    //礼物image
    UIImageView * giftImageView;
    
    //关注
    UILabel * focusCountLabel;
    
    //粉丝
    UILabel * fansCountLabel;
    
    UIImageView * grandImageVeiw;
    
    MyCardView * mycardVeiw;
    
    //个人信息
    CardInfoModel * infoModel;
    
    //钻背景
    UIView * giftBackView;
    
    
}
@end

@implementation ProfileViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   self.navigationController.navigationBarHidden=YES;
    
    [self requestInfo];

}
//刷新UI
-(void)refreshUI
{
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.headImageUrl] placeholderImage:[UIImage imageNamed:@"head_mine"]];

    CGFloat nameWidth=[UILabel getLabelWidthWithText:infoModel.nickName wordSize:18 height:20];
    if (nameWidth>80) {
        nameLabel.frame=CGRectMake(kScreenWidth/2-nameWidth/2, nameLabel.y, nameWidth, nameLabel.height);
        grandImageVeiw.frame=CGRectMake(CGRectGetMaxX(nameLabel.frame)+5, nameLabel.y, 14, 14);
        
    }
    grandImageVeiw.image=infoModel.grand==1?ImageGirl:ImageBoy;
    
    
    CGFloat giftCountWidth=[UILabel getLabelWidthWithText:infoModel.receiveGiftCount wordSize:12 height:15];
    giftImageView.frame=CGRectMake(kScreenWidth/2-(18+5+giftCountWidth)/2, giftImageView.y, giftImageView.width, giftImageView.height);
    receiveGiftCountLabel.frame=CGRectMake(CGRectGetMaxX(giftImageView.frame)+5, receiveGiftCountLabel.y, giftCountWidth, receiveGiftCountLabel.height);

    nameLabel.text=infoModel.nickName;
    receiveGiftCountLabel.text=infoModel.receiveGiftCount;
    
    
    giftBackView.frame=CGRectMake(kScreenWidth/2-(20+5+giftCountWidth+giftImageView.width)/2, giftBackView.y, 20+5+giftCountWidth+giftImageView.width, giftBackView.height);
    
    focusCountLabel.text=infoModel.focusCount;
    fansCountLabel.text=infoModel.fansCount;
    [goldCoinButton setTitle:infoModel.goldCoinCount forState:UIControlStateNormal];
    [mycardVeiw setModel:infoModel];
    
    
    
    


}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
  self.navigationController.navigationBarHidden=NO;
}
-(void)requestInfo
{
    
    
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    
    NSLog(@"我的信息请求=====%@",paramDic);
    
    [UrlRequest postRequestWithUrl:kGetUserInfoUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        
        NSLog(@"我的信息----%@",jsonDict);
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            [infoModel analysisRequestJsonNSDictionary:jsonDict];
            [self refreshUI];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
    
    
    [UrlRequest postRequestWithUrl:kGetMyCardUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
    
        NSLog(@"卡片信息----%@",jsonDict);

        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            NSDictionary * dic=[[jsonDict valueForKey:@"data"] firstObject];;
            [infoModel analysisCardRequestWithDic:dic];
            
            [self refreshUI];
        }

        
    } fail:^(NSError *error) {
        
    }];
    
    
    //获取我的金币
    [UrlRequest postRequestWithUrl:kGetMyGoldCoinUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        
        NSLog(@"我的金币----%@",jsonDict);
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            double goldCoin=[[jsonDict valueForKey:@"user_gold"]longLongValue];
            infoModel.goldCoinCount=[NSString stringWithFormat:@"%.0f",goldCoin];
            [self refreshUI];

            
            
        }
        
    } fail:^(NSError *error) {
        
    }];
    
    
    //是否实名认证
    if (!user.isCertification) {
       
        [UrlRequest postRequestWithUrl:kIsCerIDnumUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
            NSLog(@"是否实名认证---%@",jsonDict);
            int code=[[jsonDict valueForKey:@"code"]intValue];
            if (code==0) {
                
                int is_card_auth=[[jsonDict valueForKey:@"is_card_auth"]intValue];
                user.isCertification=is_card_auth;
                user.realName=[jsonDict valueForKey:@"card_name"];
                user.IDNum=[jsonDict valueForKey:@"card_no"];
                
                [[UserManager shareInstaced]setUserInfo:user];
    
            }
            
            
        } fail:^(NSError *error) {
            
        }];
        
        
        
        
    }
    
    
    
    
    //++++++++++++收到的礼物数++++++++
    [paramDic setValue:user.uid forKey:@"anchor_id"];
    
    [UrlRequest postRequestWithUrl:kGetAnchorGiftCountUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            long giftCount=[[jsonDict valueForKey:@"anchor_gift_count"]longValue];
            
            infoModel.receiveGiftCount=[NSString stringWithFormat:@"%ld",giftCount];
            [self refreshUI];
            
            
        }
        
    } fail:^(NSError *error) {
        
    }];

   

}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    infoModel=[[CardInfoModel alloc]init];
    
    [self requestInfo];
    
    [self createUI];
    

    
}
//创建UI
-(void)createUI
{

    UIImageView * imageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.userInteractionEnabled=YES;
    imageView.image=[UIImage imageNamed:@"bj_1242.jpg"];
    [self.view addSubview:imageView];
    
    backScrollView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    backScrollView.bounces=NO;
    [self.view addSubview:backScrollView];
    if (kScreenHeight<667){
        backScrollView.contentSize=CGSizeMake(kScreenWidth, 680);
        backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 667)];
    }else
    {
        
        backImageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    }
//    backImageView.image=[UIImage imageNamed:@"bj_1242.jpg"];
    
    backImageView.userInteractionEnabled=YES;
    [backScrollView addSubview:backImageView];
    
    //金币按钮
    goldCoinButton=[[UIButton alloc]initWithFrame:CGRectMake(15, 31, 100, 21)];
    [goldCoinButton setImage:[UIImage imageNamed:@"money_normal"] forState:UIControlStateNormal];
    [goldCoinButton setImage:[UIImage imageNamed:@"money_press"] forState:UIControlStateHighlighted];
    [goldCoinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [goldCoinButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [goldCoinButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    goldCoinButton.titleLabel.font=[UIFont fontWithName:TextFontName size:18];
    goldCoinButton.titleLabel.alpha=0.7;
    [goldCoinButton setTitle:infoModel.goldCoinCount forState:UIControlStateNormal];
    goldCoinButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [goldCoinButton addTarget:self action:@selector(clickgoldCoinButton) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:goldCoinButton];
    
    
    //设置按钮
    UIButton * settingButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-15-60, 31, 60, 60)];
    [settingButton setImage:[UIImage imageNamed:@"btn_set_normal"] forState:UIControlStateNormal];
    [settingButton setImage:[UIImage imageNamed:@"btn_set_press"] forState:UIControlStateHighlighted];
    [settingButton setImageEdgeInsets:UIEdgeInsetsMake(0, 39, 39, 0)];
    [backImageView addSubview:settingButton];
    [settingButton addTarget:self action:@selector(clickSettingButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    //头像
    headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-75/2, 44, 75, 75)];
    headImageView.layer.masksToBounds=YES;
    headImageView.layer.cornerRadius=75/2;
    headImageView.layer.borderWidth=1;
    headImageView.layer.borderColor=[[UIColor whiteColor]CGColor];
    [backImageView addSubview:headImageView];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.headImageUrl] placeholderImage:[UIImage imageNamed:@"head_mine"]];
    headImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer * tapHeadImage=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeadImageView)];
    [headImageView addGestureRecognizer:tapHeadImage];
    
    
    
    nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-80/2, CGRectGetMaxY(headImageView.frame)+15, 80, 20)];
    nameLabel.font=[UIFont fontWithName:TextFontName size:18];
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.textAlignment=NSTextAlignmentCenter;
    [backImageView addSubview:nameLabel];
    
    grandImageVeiw=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+5, nameLabel.y+3.5, 14, 14)];
    
    grandImageVeiw.image=[UIImage imageNamed:@"girl"];
    [backImageView addSubview:grandImageVeiw];
    
    
    giftBackView=[[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2-80/2, CGRectGetMaxY(nameLabel.frame)+10, 80, 20)];
    giftBackView.backgroundColor=[UIColor blackColor];
    giftBackView.alpha=0.2;
    giftBackView.layer.masksToBounds=YES;
    giftBackView.layer.cornerRadius=10.0;
    [backImageView addSubview:giftBackView];

    
    giftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(headImageView.x, CGRectGetMaxY(nameLabel.frame)+13.5, 18, 13)];
    giftImageView.image=[UIImage imageNamed:@"gift"];
    giftImageView.userInteractionEnabled=YES;
    [backImageView addSubview:giftImageView];
    
    
    //我收到的礼物按钮
    UIButton  * giftButton=[[UIButton alloc]initWithFrame:CGRectMake(headImageView.x,nameLabel.y, headImageView.width, nameLabel.height+10+20)];
    [giftButton addTarget:self action:@selector(clickGiftButton) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:giftButton];
    
    receiveGiftCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(giftImageView.frame)+5, CGRectGetMaxY(nameLabel.frame)+12, 80, 15)];
    receiveGiftCountLabel.textColor=[UIColor whiteColor];
    receiveGiftCountLabel.textAlignment=NSTextAlignmentLeft;
    receiveGiftCountLabel.font=[UIFont fontWithName:TextFontName size:12];

    [backImageView addSubview:receiveGiftCountLabel];
    
    
    UIView * focusView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(receiveGiftCountLabel.frame)+25, kScreenWidth/2, 50)];
    [backImageView addSubview:focusView];
    
    UITapGestureRecognizer * tapFocusView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFocus)];
    [focusView addGestureRecognizer:tapFocusView];
    
    
    UIView * fansView=[[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2, focusView.y, kScreenWidth/2, 50)];
    [backImageView addSubview:fansView];
    
    UITapGestureRecognizer * fansTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFans)];
    [fansView addGestureRecognizer:fansTap];
    
    
    focusCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 4, focusView.width, 20)];
    focusCountLabel.textColor=[UIColor whiteColor];
    focusCountLabel.font=[UIFont fontWithName:TextFontName size:18];
    focusCountLabel.textAlignment=NSTextAlignmentCenter;
    [focusView addSubview:focusCountLabel];
    
    
    fansCountLabel=[[UILabel alloc]initWithFrame:focusCountLabel.frame];
    fansCountLabel.font=focusCountLabel.font;
    fansCountLabel.textColor=focusCountLabel.textColor;
    fansCountLabel.textAlignment=NSTextAlignmentCenter;
    [fansView addSubview:fansCountLabel];
    
    UILabel * focusLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(fansCountLabel.frame)+7, focusCountLabel.width, 15)];
    focusLabel.textColor=[UIColor whiteColor];
    focusLabel.text=@"关注";
    focusLabel.alpha=0.7;
    focusLabel.font=[UIFont fontWithName:TextFontName size:12];
    focusLabel.textAlignment=NSTextAlignmentCenter;
    [focusView addSubview:focusLabel];
    
    UILabel * fansLabel=[UILabel setLabelFrame:focusLabel.frame Text:@"粉丝" TextColor:[UIColor whiteColor] font:[UIFont fontWithName:TextFontName size:12] textAlignment:NSTextAlignmentCenter];
    fansLabel.alpha=0.7;
    [fansView addSubview:fansLabel];
    
    
    UIView * verLine=[[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2-0.5, focusView.y, 0.5, 50)];
    verLine.alpha=0.2;
    verLine.backgroundColor=[UIColor whiteColor];
    [backImageView addSubview:verLine];
    
    CGFloat nameWidth=[UILabel getLabelWidthWithText:infoModel.nickName wordSize:18 height:20];
    if (nameWidth>80) {
        nameLabel.frame=CGRectMake(kScreenWidth/2-nameWidth/2, nameLabel.y, nameWidth, nameLabel.height);
        grandImageVeiw.frame=CGRectMake(CGRectGetMaxX(nameLabel.frame)+5, nameLabel.y, 14, 14);
        
    }
    
    CGFloat giftCountWidth=[UILabel getLabelWidthWithText:infoModel.receiveGiftCount wordSize:12 height:15];
    giftImageView.frame=CGRectMake(kScreenWidth/2-(18+5+giftCountWidth)/2, giftImageView.y, giftImageView.width, giftImageView.height);
    receiveGiftCountLabel.frame=CGRectMake(CGRectGetMaxX(giftImageView.frame)+5, receiveGiftCountLabel.y, giftCountWidth, receiveGiftCountLabel.height);
    nameLabel.text=infoModel.nickName;
    receiveGiftCountLabel.text=infoModel.receiveGiftCount;
    focusCountLabel.text=infoModel.focusCount;
    fansCountLabel.text=infoModel.fansCount;
    
   
    
    mycardVeiw=[[MyCardView alloc]initWithHeight:CGRectGetMaxY(verLine.frame)+25];
    [backImageView addSubview:mycardVeiw];
    
    
    [mycardVeiw setModel:infoModel];
     mycardVeiw.delegate=self;

}
#pragma mark 点击关注
-(void)tapFocus
{
    MyFansAndCareViewController * focusVC=[[MyFansAndCareViewController alloc]init];
    __weak typeof(self)wself=self;
    focusVC.returnCallback=^{
        [wself requestInfo];
    };

    [self.navigationController pushViewController:focusVC animated:YES];

    
}
#pragma mark 点击粉丝
-(void)tapFans
{

    MyFansAndCareViewController * fansVC=[[MyFansAndCareViewController alloc]init];
    fansVC.isComeFans=YES;
    __weak typeof(self)wself=self;
    fansVC.returnCallback=^{
        [wself requestInfo];
    };
    [self.navigationController pushViewController:fansVC animated:YES];
    
    

}

#pragma mark 点击我收到的礼物
-(void)clickGiftButton
{
    
    FansContributionRankViewController * fansContributionVC=[[FansContributionRankViewController alloc]init];
    fansContributionVC.receiveGiftCount=infoModel.receiveGiftCount;
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    fansContributionVC.uid=user.uid;
    [self.navigationController pushViewController:fansContributionVC animated:NO];
    

}

#pragma mark 点击我的金币
-(void)clickgoldCoinButton
{
    MyGoldCoinViewController * goldVC =[[MyGoldCoinViewController alloc]init];
    goldVC.infoModel=infoModel;
   [self.navigationController pushViewController:goldVC animated:YES];

}
#pragma mark点击设置
-(void)clickSettingButton
{
    SettingViewController * setting=[[SettingViewController alloc]init];
    setting.infoModel=infoModel;
    [self.navigationController pushViewController:setting animated:YES];

}

#pragma mark 点击头像按钮
-(void)tapHeadImageView
{
    EditMyPersonInfoViewController * personInfoVC=[[EditMyPersonInfoViewController alloc]init];
    personInfoVC.titleString=@"修改个人信息";
    personInfoVC.isHiddenBackButton=NO;
    personInfoVC.infoModel=infoModel;
    [self.navigationController pushViewController:personInfoVC animated:YES];

}
#pragma mark MyCardView Delegate
-(void)beginEditMyInfo:(CardInfoModel *)cardModel
{
   
    EditMyCardInfoViewController * editInfo=[[EditMyCardInfoViewController alloc]init];
    editInfo.cardModel=cardModel;
    [self.navigationController pushViewController:editInfo animated:YES];
    
    editInfo.saveSuccess=^(CardInfoModel * cardModel){
        
        
    [mycardVeiw setModel:cardModel];
        
        
    };

}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
