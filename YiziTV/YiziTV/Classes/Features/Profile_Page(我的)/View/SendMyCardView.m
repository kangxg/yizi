//
//  SendMyCardView.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/4.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "SendMyCardView.h"
#import "MyCardView.h"

#import "SendCardControlView.h"


@interface SendMyCardView ()<MyCardViewDelegateProtocol>
{
    MyCardView * myCardInfoView;
    CardInfoModel * infoModel;
    UIImageView * _backImageView;
    
    SendCardControlView * sendCardControl;
}

@end

@implementation SendMyCardView
-(instancetype)initWithBackImage:(UIImageView *)backImageView
{
    CGRect newFrame=backImageView.bounds;
    self=[super initWithFrame:newFrame];
    if (self) {
      
        _backImageView=backImageView;
        backImageView.userInteractionEnabled=YES;
        [self addSubview:backImageView];
         [self createUI];
        [self requestMyCardInfo];
        
        
    }
    return self;
}
-(void)requestMyCardInfo
{
    

    WKProgressHUD * hud  = [WKProgressHUD showInView:self withText:@"" animated:YES];
    infoModel=[[CardInfoModel alloc]init];

    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];

    [UrlRequest postRequestWithUrl:kGetMyCardUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        [hud dismiss:YES];
        
        NSLog(@"请求+++卡片信息----%@",jsonDict);
        
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            NSDictionary * dic=[[jsonDict valueForKey:@"data"] firstObject];
            
            [infoModel analysisCardRequestWithDic:dic];
           
            [self refreshUI];
            
           
        }
        
    } fail:^(NSError *error) {
        
    }];
    
    
    [UrlRequest postRequestWithUrl:kGetUserInfoUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        
        NSLog(@"请求我的信息----%@",jsonDict);
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            [infoModel analysisRequestJsonNSDictionary:jsonDict];
            [self refreshUI];
        }
        
    } fail:^(NSError *error) {
        
    }];




}
-(void)createUI
{
    
    UIView * backView=[[UIView alloc]initWithFrame:CGRectMake(20, kScreenHeight/2-418/2, kScreenWidth-40, 418)];
    if (iPhone4) {
        backView.frame=CGRectMake(20, 5, kScreenWidth-40, 418);
    }
    backView.backgroundColor=[UIColor whiteColor];
    backView.layer.masksToBounds=YES;
    backView.layer.cornerRadius=5;
    [self addSubview:backView];
    
    
    myCardInfoView=[[MyCardView alloc]initWithHeight:backView.y];
    myCardInfoView.delegate=self;
    [self addSubview:myCardInfoView];

    UIView * horLine=[[UIView alloc]initWithFrame:CGRectMake(0, myCardInfoView.height, backView.width, 0.5)];
    horLine.backgroundColor=[UIColor customColorWithString:@"909290"];
    [backView addSubview:horLine];
    
    sendCardControl=[[SendCardControlView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(horLine.frame), backView.width, 42)];
    [backView addSubview:sendCardControl];
    
    UIButton * closeButton=[[UIButton alloc]initWithFrame:CGRectMake(self.width/2-80/2, CGRectGetMaxY(backView.frame), 80, 80)];
    [closeButton setImage:[UIImage imageNamed:@"btn_close_normal"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"btn_close_press"] forState:UIControlStateHighlighted];
    
    [self addSubview:closeButton];
    
    [closeButton addTarget:self action:@selector(pressCloseButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * sendButton=[[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(sendCardControl.frame), backView.width-40, 36)];
    sendButton.backgroundColor=[UIColor customColorWithString:@"28904e"];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    sendButton.layer.masksToBounds=YES;
    sendButton.layer.cornerRadius=4.0;
    sendButton.titleLabel.font=[UIFont fontWithName:TextFontName size:16];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backView addSubview:sendButton];
    
    [sendButton addTarget:self action:@selector(clickSendButton) forControlEvents:UIControlEventTouchUpInside];



}
-(void)pressCloseButton
{


    [self removeFromSuperview];
    

}
-(void)clickSendButton
{

    if ([self.deleaget respondsToSelector:@selector(senCardWithPayType:CardInfo:)]) {
        
        [self.deleaget senCardWithPayType:[sendCardControl getPayType] CardInfo:infoModel];
        
    }
    

}
-(void)refreshUI
{
    [myCardInfoView setModel:infoModel];

}

#pragma mark 点击编辑 myCardInfoView delegate
-(void)beginEditMyInfo:(CardInfoModel *)cardModel
{

    
    if ([self.deleaget respondsToSelector:@selector(editMyCardInfoWithCardInfoModel:backgroundImage:)]) {
        [self.deleaget editMyCardInfoWithCardInfoModel:cardModel backgroundImage:_backImageView];
    }
    
}
-(void)refreshCardInfoView:(CardInfoModel *)cardInfoModel
{
    infoModel=cardInfoModel;
    [myCardInfoView setModel:cardInfoModel];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
