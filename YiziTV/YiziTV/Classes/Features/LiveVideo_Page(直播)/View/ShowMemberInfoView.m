//
//  ShowMemberInfoView.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/21.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "ShowMemberInfoView.h"
#import "CardInfoModel.h"
#import "NIMSDK.h"
#import "ChatRoomManager.h"

@interface ShowMemberInfoView ()
{
    
    //昵称
    UILabel * nickNameLabel;
    //性别
    UIImageView * grandImageView;
    //城市
    UILabel * cityLabel;
    //专业
    UILabel * majorLabel;
    //期望职位
    UILabel * wantJob;
    //关注
    UILabel * focusLabel;
    //粉丝
    UILabel * fansLabel;
    
    UIButton * careButton;
    
    //禁言
    UIButton * muteButton;
    
    CardInfoModel * infoModel;
    
    UIView  * backView;
    
   
    
}

@end


@implementation ShowMemberInfoView
-(id)init
{
    CGRect newFrame=CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self=[super initWithFrame:newFrame];
    if (self) {
        
        infoModel=[[CardInfoModel alloc]init];
        self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.4];
        
    }
    
    return self;

}
-(void)requestUrl
{
//kGetUserInfoWithUidUrl
    
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    if (self.uid.length) {
        
    
    [paramDic setValue:self.uid forKey:@"serach_user_id"];
    }else
    {
        if (self.yxUid.length) {
          [paramDic setValue:self.yxUid forKey:@"serach_accid"];
        }
        
    }
    
    
    [UrlRequest postRequestWithUrl:kGetUserInfoWithUidUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        
        NSLog(@"infoshowView ====%@",jsonDict);
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            
            infoModel=[[CardInfoModel alloc]init];
            [infoModel analysisGetUserInfoWithUidDic:jsonDict];
            
            [self refreshUI];
            
            
        }
        
    } fail:^(NSError *error) {
        
    }];
    
    
}
-(void)createUI
{

    if (self.headImageView==nil&&self.yxUid.length) {
        
        self.headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
         self.headImageView.layer.cornerRadius=self.headImageView.width/2;
         self.headImageView.layer.masksToBounds=YES;
        
        NIMChatroomMembersByIdsRequest * request=[[NIMChatroomMembersByIdsRequest alloc]init];
        request.roomId=self.roomID;
        
         
        request.userIds=@[self.yxUid];
        
        [[[NIMSDK sharedSDK]chatroomManager]fetchChatroomMembersByIds:request completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
            
            NIMChatroomMember * member=[members firstObject];
            self.isMuted=member.isTempMuted;
            [self refreshUI];
            
        }];
        
        
    }

    backView=[[UIView alloc]initWithFrame:CGRectMake(50, kScreenHeight/2-257/2, kScreenWidth-100, 0)];
    backView.layer.masksToBounds=YES;
    backView.layer.cornerRadius=2.0;
    backView.backgroundColor=[UIColor whiteColor];
    self.headImageView.layer.masksToBounds=YES;
    
    [self addSubview:backView];
    [self addSubview:self.headImageView];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
       
        self.headImageView.frame=CGRectMake(50+25, backView.y-35, 75, 75);
        self.headImageView.layer.cornerRadius=self.headImageView.width/2;

    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            backView.frame = CGRectMake(backView.x, backView.y , backView.width, 257);
            [self initInfoView];
            
            [self requestUrl];
            
        
            
        } completion:^(BOOL finished) {
          
            
           
            
        }];
    }];

   
    
    

}
-(void)initInfoView
{
    
    
    nickNameLabel=[UILabel setLabelFrame:CGRectMake(25, 35+16, 35, 22) Text:nil TextColor:[UIColor customColorWithString:@"0d0e0d"] font:[UIFont fontWithName:TextFontName size:18] textAlignment:NSTextAlignmentLeft];
    
    [backView addSubview:nickNameLabel];
    
    grandImageView=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nickNameLabel.frame)+7, nickNameLabel.y+3, 14, 14)];
    
    grandImageView.image=ImageBoy;
    [backView addSubview:grandImageView];
    
    
    UIImageView * locationIcon=[[UIImageView alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(nickNameLabel.frame)+31, 14, 14)];
    locationIcon.image=[UIImage imageNamed:@"btn_location"];
    [backView addSubview:locationIcon];
    
    cityLabel=[UILabel setLabelFrame:CGRectMake(CGRectGetMaxX(locationIcon.frame)+7, locationIcon.y, backView.width-12-CGRectGetMaxX(locationIcon.frame)-7, locationIcon.height) Text:nil TextColor:[UIColor customColorWithString:@"0d0e0d"] font:[UIFont fontWithName:TextFontName size:13] textAlignment:NSTextAlignmentLeft];
    [backView addSubview:cityLabel];
    
    
    UIImageView * majorIcon=[[UIImageView alloc]initWithFrame:CGRectMake(locationIcon.x, CGRectGetMaxY(locationIcon.frame)+13, locationIcon.width, locationIcon.height)];
    majorIcon.image=[UIImage imageNamed:@"btn_degree"];
    [backView addSubview:majorIcon];
    
    majorLabel=[UILabel setLabelFrame:CGRectMake(cityLabel.x, majorIcon.y, cityLabel.width, cityLabel.height) Text:nil TextColor:cityLabel.textColor font:cityLabel.font textAlignment:NSTextAlignmentLeft];
    [backView addSubview:majorLabel];
    
    
    UIImageView * jobIcon=[[UIImageView alloc]initWithFrame:CGRectMake(locationIcon.x, CGRectGetMaxY(majorIcon.frame)+13, locationIcon.width, locationIcon.height)];
    jobIcon.image=[UIImage imageNamed:@"btn_bag"];
    [backView addSubview:jobIcon];
    
    
    wantJob=[UILabel setLabelFrame:CGRectMake(cityLabel.x, jobIcon.y, cityLabel.width, cityLabel.height) Text:nil TextColor:cityLabel.textColor font:cityLabel.font textAlignment:NSTextAlignmentLeft] ;
    [backView addSubview:wantJob];
    
    
    UILabel * focusContentLabel=[UILabel setLabelFrame:CGRectMake(25, CGRectGetMaxY(wantJob.frame)+30, backView.width/2-25-5, 12) Text:@"关注" TextColor:[UIColor customColorWithString:@"bbbbbd"] font:[UIFont fontWithName:TextFontName size:12] textAlignment:NSTextAlignmentCenter];
    
    [backView addSubview:focusContentLabel];
    
    focusLabel=[UILabel setLabelFrame:CGRectMake(25, CGRectGetMaxY(focusContentLabel.frame), focusContentLabel.width, 38) Text:nil TextColor:[UIColor customColorWithString:@"0d0e0d"] font:[UIFont fontWithName:TextFontName size:18] textAlignment:NSTextAlignmentCenter];
    [backView addSubview:focusLabel];
    
    
    UILabel * fansContentLabel=[UILabel setLabelFrame:CGRectMake(backView.width/2+5, focusContentLabel.y, focusLabel.width, focusContentLabel.height) Text:@"粉丝" TextColor:focusContentLabel.textColor font:focusContentLabel.font textAlignment:NSTextAlignmentCenter];
    
    [backView addSubview:fansContentLabel];
    
    
    fansLabel=[UILabel setLabelFrame:CGRectMake(backView.width/2+5, focusLabel.y, focusLabel.width, focusLabel.height) Text:nil TextColor:focusLabel.textColor font:focusLabel.font textAlignment:NSTextAlignmentCenter];
    [backView addSubview:fansLabel];
    
    
    UIView * line =[[UIView alloc]initWithFrame:CGRectMake(backView.width/2-0.5/2, focusLabel.y-5, 0.5, 28)];
    line.backgroundColor=[UIColor customColorWithString:@"#dcdcdc"];
    [backView addSubview:line];
    
    
    //禁言按钮
    if (self.isOpenSilentAction) {
      
        muteButton=[[UIButton alloc]initWithFrame:CGRectMake(backView.width-12-80, 0, 80, 35)];
        [muteButton setTitle:@"禁言" forState:UIControlStateNormal];
        [muteButton setTitle:@"取消禁言" forState:UIControlStateSelected];
        muteButton.titleLabel.font=[UIFont fontWithName:TextFontName size:11];
        [muteButton setTitleColor:[UIColor customColorWithString:@"545554"] forState:UIControlStateNormal];
        [muteButton setTitleColor:[UIColor customColorWithString:@"#bbbbbd"] forState:UIControlStateSelected];
        [muteButton setImage:[UIImage imageNamed:@"icon_no"] forState:UIControlStateNormal];
        [muteButton setImage:[UIImage imageNamed:@"icon_nono"] forState:UIControlStateSelected];
        [muteButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 3)];
        
        muteButton.selected=self.isMuted;
        [muteButton addTarget:self action:@selector(clickMuteButton) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:muteButton];
        
    }
    
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    if (![user.uid isEqualToString:self.uid]) {
        
   
    
    //关注
    careButton=[[UIButton alloc]initWithFrame:CGRectMake(backView.width-25-80, 42, 80, 30)];
    careButton.layer.masksToBounds=YES;
    careButton.layer.cornerRadius=15.f;
    careButton.layer.borderWidth=0.5;
    careButton.layer.borderColor=[[UIColor customColorWithString:@"#f04a4b"]CGColor];
    [careButton setTitle:@"关注" forState:UIControlStateNormal];
    [careButton setTitle:@"已关注" forState:UIControlStateDisabled];
    [careButton setTitleColor:[UIColor customColorWithString:@"#f04a4b"] forState:UIControlStateNormal];
    [careButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [careButton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [careButton setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateDisabled];
    
    careButton.titleLabel.font=[UIFont fontWithName:TextFontName size:12];
    [careButton addTarget:self action:@selector(clickCareButton) forControlEvents:UIControlEventTouchUpInside];
    [careButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 3)];
    [backView addSubview:careButton];
    
    
    }
    

}
-(void)clickCareButton
{
    
    NSLog(@"__++++++++++++++++++++++++++");
    careButton.enabled=NO;
    careButton.backgroundColor=[UIColor customColorWithString:@"#f04a4b"] ;
    
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:infoModel.ID forKey:@"to_user_id"];
    
    
    
    [UrlRequest postRequestWithUrl:kFocusActionUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
          
    [[ChatRoomManager shareManager]senFocusMessageWithRoomID:_roomID];
                
         

            
        }
        
    } fail:^(NSError *error) {
        
    }];

  
    
}
-(void)refreshUI
{
    NSLog(@"refreshUI");
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.headImageUrl] placeholderImage:nil];

    
    CGFloat nickNameWidth=[UILabel getLabelWidthWithText:infoModel.nickName wordSize:18 height:20];
    CGFloat maxWidth=kScreenWidth-100-25-80-50;
    if (nickNameWidth<maxWidth) {
        nickNameLabel.frame=CGRectMake(nickNameLabel.x, nickNameLabel.y, nickNameWidth, nickNameLabel.height);
        
    }else
    {
        nickNameLabel.frame=CGRectMake(nickNameLabel.x, nickNameLabel.y, maxWidth, nickNameLabel.height);

    
    }
    nickNameLabel.text=infoModel.nickName;
    
    grandImageView.frame=CGRectMake(CGRectGetMaxX(nickNameLabel.frame)+7, grandImageView.y, grandImageView.width, grandImageView.height);
    grandImageView.image=infoModel.grand==1?ImageGirl:ImageBoy;
    
    cityLabel.text=infoModel.locationCity;
    majorLabel.text=infoModel.professional;
    wantJob.text=infoModel.wantJobName;
    focusLabel.text=infoModel.focusCount;
    fansLabel.text=infoModel.fansCount;
    
    careButton.enabled=!infoModel.isCared;
    if (infoModel.isCared) {
        careButton.backgroundColor=[UIColor customColorWithString:@"#f04a4b"] ;
    }
    


}
-(void)clickMuteButton
{
    muteButton.selected=!muteButton.selected;
    self.isMuted=muteButton.selected;
//    NIMChatroomMemberUpdateRequest * request =[[NIMChatroomMemberUpdateRequest alloc]init];
//    request.roomId=self.roomID;
//    request.userId=self.yxUid;
//    request.enable=muteButton.selected;
    
    
//    
//    [[[NIMSDK sharedSDK]chatroomManager] updateMemberMute:request completion:^(NSError * _Nullable error) {
//        if (error==nil) {
//            
//            
//            
//        }else
//        {
//           
//            NSLog(@"禁言失败++++++%@", error.description);
//        }
//        
//    }];
    
    
    if (muteButton.selected) {
        [self addMuteRequest];
    }else
    {
        [self removeMuteRequest];
    }

    

}
-(void)addMuteRequest
{
    
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:_roomID forKey:@"chatroom_id"];
    if (self.uid.length) {
        
         [paramDic setValue:self.uid forKey:@"target_user_id"];
    }
   
    
    [UrlRequest postRequestWithUrl:kAddMuteActionUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        
        NSLog(@"jsonDictjsonDictjsonDictjsonDict%@",jsonDict);
        
    } fail:^(NSError *error) {
        
    }];

}
-(void)removeMuteRequest
{
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:_roomID forKey:@"chatroom_id"];
    if (self.uid.length) {
       [paramDic setValue:self.uid forKey:@"target_user_id"];  
    }
   
    
    [UrlRequest postRequestWithUrl:kRemoveMuteActionUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        
         NSLog(@"jsonDictjsonDictjsonDictjsonDict%@",jsonDict);
    } fail:^(NSError *error) {
        
    }];


}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [UIView animateWithDuration:0.5 animations:^{
       
        
        backView.frame=CGRectMake(backView.x, backView.y, backView.width, 0);
        
        self.alpha=0;
        
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
