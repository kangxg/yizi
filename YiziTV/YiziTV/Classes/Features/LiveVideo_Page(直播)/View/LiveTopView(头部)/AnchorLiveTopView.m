//
//  AnchorLiveTopView.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/3.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "AnchorLiveTopView.h"
#import "NIMSDK.h"

@interface AnchorLiveTopView ()
{

    
     long long anchorGiftCount;
}

@end

@implementation AnchorLiveTopView

-(void)showAnchorInfo
{
    NIMUser * yxuser=[[NIMSDK sharedSDK].userManager userInfo:[NIMSDK sharedSDK].loginManager.currentAccount];
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:yxuser.userInfo.avatarUrl] placeholderImage:nil];
    nickNameLabel.text=yxuser.userInfo.nickName;
    [self getGiftCount];
    

}
-(void)getGiftCount
{
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:user.uid forKey:@"anchor_id"];
    
    [UrlRequest postRequestWithUrl:kGetAnchorGiftCountUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
           anchorGiftCount=[[jsonDict valueForKey:@"anchor_gift_count"]longLongValue];
            [self refreshGiftCount:anchorGiftCount];
            
            
            
            
        }
        
    } fail:^(NSError *error) {
        
    }];
    

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
-(void)refreshGiftCount:(long long)showgiftCount
{
    
    giftCountLabel.text=[NSString stringWithFormat:@"%lld ＞",showgiftCount];
    
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
