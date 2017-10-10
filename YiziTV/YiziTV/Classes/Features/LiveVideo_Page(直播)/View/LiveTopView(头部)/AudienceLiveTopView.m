//
//  AudienceLiveTopView.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/1.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "AudienceLiveTopView.h"

#import "ChatRoomManager.h"


@interface AudienceLiveTopView ()
{

    UIButton * focusButton;
    
    long long anchorGiftCount;
}

@end

@implementation AudienceLiveTopView

-(id)init
{
    self=[super init];
    if (self) {
        
        
        headImageView.userInteractionEnabled=YES;
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeadImageView)];
        [headImageView addGestureRecognizer:tap];
        
        focusButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-60-(24+12), 0, 60, 60)];
        [focusButton setImage:[UIImage imageNamed:@"btn_follow_normal"] forState:UIControlStateNormal];
        [focusButton setImage:[UIImage imageNamed:@"btn_follow_press"] forState:UIControlStateSelected];
        [focusButton addTarget:self action:@selector(clickFocusButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:focusButton];
        
        
        
    }
    return self;
}
-(void)tapHeadImageView
{
    
    if ([self.liveDelegate respondsToSelector:@selector(clickHeadImageViewAction:)]) {
        [self.liveDelegate clickHeadImageViewAction:headImageView];
    }
    
}
-(void)requestUrl
{
    
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:self.liveInfoModel.uid forKey:@"to_user_id"];
    
    [UrlRequest postRequestWithUrl:kQueryWheatherFocusUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            int is_follow=[[jsonDict valueForKey:@"is_follow"]intValue];
            focusButton.selected=is_follow;
            
        }
        
    } fail:^(NSError *error) {
        
    }];
    
    
    [self getAnchorGiftCount];

    

}
-(void)getAnchorGiftCount
{
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:self.liveInfoModel.uid forKey:@"anchor_id"];
    
    [UrlRequest postRequestWithUrl:kGetAnchorGiftCountUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            anchorGiftCount=[[jsonDict valueForKey:@"anchor_gift_count"]longLongValue];
            [self refreshGiftCount:anchorGiftCount];
            
            
            
            
        }
        
    } fail:^(NSError *error) {
        
    }];


}
-(void)setLiveInfoModel:(LiveInfoModel *)liveInfoModel
{
    _liveInfoModel=liveInfoModel;
    [self requestUrl];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:liveInfoModel.headImageUrl] placeholderImage:nil];
    nickNameLabel.text=liveInfoModel.nickName;
    [self refreshPersonCount:_liveInfoModel.lookerCount];

}
-(void)clickFocusButton
{
    
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:self.liveInfoModel.uid forKey:@"to_user_id"];

    //取消关注
    if (focusButton.selected) {
       
        focusButton.selected=NO;
        
        
        [UrlRequest postRequestWithUrl:kCancleFocusActionUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
            int code=[[jsonDict valueForKey:@"code"]intValue];
            if (code==0) {
                
          
            }
            
        } fail:^(NSError *error) {
            
        }];

    }else
    {
    
        //关注
        focusButton.selected=YES;
        [UrlRequest postRequestWithUrl:kFocusActionUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
            int code=[[jsonDict valueForKey:@"code"]intValue];
            if (code==0) {
                
                [self senFocusMessage];
                
        }
            
        } fail:^(NSError *error) {
            
        }];
    
    }

}
-(void)senFocusMessage
{
    [[ChatRoomManager shareManager]senFocusMessageWithRoomID:self.liveInfoModel.roomID];
    
}
-(void)refreshPersonCount:(long long)personCount
{
    
    [super refreshPersonCount:personCount];
    if (personCount/10000>1) {
        CGFloat floatCount=personCount*0.0001;
        personCountLabel.text=[NSString stringWithFormat:@"%.1f万 ＞",floatCount];
        
    }else
    {
        personCountLabel.text=[NSString stringWithFormat:@"%lld ＞",personCount];
    }
    
    
}
-(void)refreshGiftCount:(long long)giftCount
{
    giftCountLabel.text=[NSString stringWithFormat:@"%lld ＞",giftCount];

}
-(void)clickGiftCountButton
{
    
    if ([self.liveDelegate respondsToSelector:@selector(clickReceiveGiftCountButton:)]) {
        [self.liveDelegate clickReceiveGiftCountButton:[NSString stringWithFormat:@"%lld",anchorGiftCount]];
    }
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
