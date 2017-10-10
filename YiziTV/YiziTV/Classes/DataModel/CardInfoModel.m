//
//  CardInfoModel.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/21.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "CardInfoModel.h"
#import "NSString+Date.h"

@implementation CardInfoModel
-(void)analysisRequestJsonNSDictionary:(NSDictionary *)dic
{
    self.headImageUrl=[dic valueForKey:@"head_photo"];
    self.nickName=[dic valueForKey:@"nickname"];
    
    self.shcool=[dic valueForKey:@"school"];
    self.professional=[dic valueForKey:@"major"];

    long fans=[[dic valueForKey:@"fans_count"]longValue];
    self.fansCount=[NSString stringWithFormat:@"%ld",fans];
    long focus=[[dic valueForKey:@"follow_count"]longValue];
    self.focusCount=[NSString stringWithFormat:@"%ld",focus];;
    self.grand=[[dic valueForKey:@"gender"]intValue];
    self.coverImageUrl=[dic valueForKey:@"pop_pic"];
    if (self.coverImageUrl.length) {
        
        UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
        user.setLiveCoverImageUrl=self.coverImageUrl;
        [[UserManager shareInstaced]setUserInfo:user];
        
    }
    if (self.nickName.length) {
        
        UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
        user.nickName=self.nickName;
        [[UserManager shareInstaced]setUserInfo:user];
    }

    

}
-(void)analysisCardRequestWithDic:(NSDictionary *)cardDic
{

    self.name=[cardDic valueForKey:@"name"];
    long ID=[[cardDic valueForKey:@"id"]longValue];
    
    self.ID=[NSString stringWithFormat:@"%ld",ID];
    self.locationCity=[cardDic valueForKey:@"position"];;
    self.shcool=[cardDic valueForKey:@"school"];
    self.professional=[cardDic valueForKey:@"major"];
    self.wantJobName=[cardDic valueForKey:@"job"];
    long long gradTime=[[cardDic valueForKey:@"graduation_date"]longLongValue];
    if (gradTime) {
       
         self.graduateTime=[NSString dateWithIntervale:gradTime formateStyle:@"YYYY.MM.dd"];
    }
    long long createTime=[[cardDic valueForKey:@"create_time"]longLongValue];
    self.cardTime=[NSString dateWithIntervale:createTime formateStyle:@"HH:mm:ss"];
    
   long long pnum=[[cardDic valueForKey:@"phone"]longLongValue];
    
    self.phoneNum=[NSString stringWithFormat:@"%lld",pnum];


}
-(void)analysisMyReceiveCardsRequestWithDic:(NSDictionary *)cardDic
{
    self.name=[cardDic valueForKey:@"card_name"];
    self.locationCity=[cardDic valueForKey:@"card_position"];
    self.wantJobName=[cardDic valueForKey:@"card_job"];
    self.shcool=[cardDic valueForKey:@"card_school"];
    self.professional=[cardDic valueForKey:@"card_major"];
    self.headImageUrl=[cardDic valueForKey:@"head_photo"];
    self.grand=[[cardDic valueForKey:@"gender"]intValue];
    long long phoneNum=[[cardDic valueForKey:@"phone_number"]longLongValue];
    self.phoneNum=[NSString stringWithFormat:@"%lld",phoneNum];
    
    long long timeInterval=[[cardDic valueForKey:@"send_time"]longLongValue];
    NSString * time=[NSString dateWithIntervale:timeInterval formateStyle:@"HH:mm:ss"];
    self.cardTime=time;
    
    long long graduateInterval=[[cardDic valueForKey:@"card_graduation_date"]longLongValue];
    if (graduateInterval) {
        self.graduateTime=[NSString dateWithIntervale:graduateInterval formateStyle:@"YYYY.MM.dd"];
    }
    
    
}
//粉丝
-(void)analysisMyFansFocusRequestWithDic:(NSDictionary*)fansDic

{
    
    long Id=[[fansDic valueForKey:@"user_id"]longValue];
    
    self.ID=[NSString stringWithFormat:@"%ld",Id];
    
    self.isCared=[[fansDic valueForKey:@"is_follow"]intValue];
    
    self.headImageUrl=[fansDic valueForKey:@"head_photo"];
    
    self.nickName=[fansDic valueForKey:@"nickname"];
    
    

}
-(void)analysisCustomMessageWithDic:(NSDictionary *)messageDic
{
    
    long long ID =[[messageDic valueForKey:@"cardID"]longLongValue];
    self.ID=[NSString stringWithFormat:@"%lld",ID];
    self.name=[messageDic valueForKey:@"name"];
    self.headImageUrl=[messageDic valueForKey:@"headImage"];
    self.nickName=[messageDic valueForKey:@"nickName"];
    self.grand=[[messageDic valueForKey:@"grand"]intValue];
    self.locationCity=[messageDic valueForKey:@"city"];
    long long pNum=[[messageDic valueForKey:@"phoneNum"]longLongValue];
    self.phoneNum=[NSString stringWithFormat:@"%lld",pNum];
    self.shcool=[messageDic valueForKey:@"school"];
    self.professional=[messageDic valueForKey:@"professional"];
    long long time=[[messageDic valueForKey:@"graduateTime"]longLongValue];
    
    self.graduateTime=[NSString dateWithIntervale:time formateStyle:@"YYYY.MM.dd"];
    self.wantJobName=[messageDic valueForKey:@"wantJob"];
    
    long long uid=[[messageDic valueForKey:@"user_id"]longLongValue];
    
    self.uid=[NSString stringWithFormat:@"%lld",uid];
    self.yxID=[messageDic valueForKey:@"vcloud_id"];
    
    
    
    
    
    
    
}

-(void)analysisGetUserInfoWithUidDic:(NSDictionary *)infoDic
{
    
    self.headImageUrl=[infoDic valueForKey:@"head_photo"];
    self.nickName=[infoDic valueForKey:@"nickname"];
    self.grand=[[infoDic valueForKey:@"gender"]intValue];
    self.shcool=[infoDic valueForKey:@"school"];
    self.professional=[infoDic valueForKey:@"major"];
    self.locationCity=[infoDic valueForKey:@"position"];
    self.wantJobName=[infoDic valueForKey:@"job"];
    long fans=[[infoDic valueForKey:@"fans_count"]longValue];
    self.fansCount=[NSString stringWithFormat:@"%ld",fans];
    long focus=[[infoDic valueForKey:@"follow_count"]longValue];
    self.focusCount=[NSString stringWithFormat:@"%ld",focus];;
    self.isCared=[[infoDic valueForKey:@"is_follow"]intValue];
    long ID=[[infoDic valueForKey:@"user_id"]longValue];
    self.ID=[NSString stringWithFormat:@"%ld",ID];


}
@end
