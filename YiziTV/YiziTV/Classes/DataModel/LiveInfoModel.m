//
//  LiveInfoModel.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/20.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "LiveInfoModel.h"
#import "NSString+Date.h"
//直播者信息
@implementation LiveInfoModel


-(void)analysisRequestJsonNSDictionary:(NSDictionary *)dic
{
    self.isRest=NO;
    long long count=[[dic valueForKey:@"spec_count"]longLongValue];
    self.lookerCount=count;
    self.nickName=[dic valueForKey:@"anchor_nickname"];
    self.liveTheme=[dic valueForKey:@"room_title"];
    self.liveCoverImageUrl=[dic valueForKey:@"pop_pic"];
    long rID=[[dic valueForKey:@"chatroom_id"]longValue];
    self.roomID=[NSString stringWithFormat:@"%ld",rID];
    self.playUrl=[dic valueForKey:@"rtmp_pull_url"];
    
    long uID=[[dic valueForKey:@"anchor_id"]longValue];
    self.uid=[NSString stringWithFormat:@"%ld",uID];
    
    self.anchorType=[[dic valueForKey:@"anchor_type"]integerValue];
    
    
// self.liveCoverImageUrl  =   @"http://wx.qlogo.cn/mmopen/Afx2WH3poQKW55pYLQ0CibUETaGs1nwBias5FtDu0MVWVvqf7PEGiccsl71qLS9eiaK1YKF1FVp596Kv4ZTa0xxtkkntyRgibUjVib/0";
    self.headImageUrl=[dic valueForKey:@"head_photo"];
    
//self.headImageUrl= @"http://app.yizijob.com/upload/20160619/770722/head/51fup.jpg";
    

}


@end
