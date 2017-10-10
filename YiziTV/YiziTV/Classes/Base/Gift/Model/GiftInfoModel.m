//
//  GiftInfoModel.m
//  YiziTV
//
//  Created by 井泉 on 16/7/1.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "GiftInfoModel.h"

@implementation GiftInfoModel
-(void)analysisGiftInfoWithDic:(NSDictionary *)dict
{
    int giftID=[[dict valueForKey:@"goods_id"]intValue];
    self.giftId=[NSString stringWithFormat:@"%d",giftID];
    self.giftname=[dict valueForKey:@"goods_name"];
    double op=[[dict valueForKey:@"goods_price"]doubleValue];
    self.originalPrice=[NSString stringWithFormat:@"%.0f",op];
    double cp=[[dict valueForKey:@"goods_cur_price"]doubleValue];
    self.currentPrice=[NSString stringWithFormat:@"%.0f",cp];
    self.giftImageUrl=[dict valueForKey:@"goods_pic"];
    self.presentCount=[[dict valueForKey:@"goods_count"]integerValue];
    self.nickname=[dict valueForKey:@"user_nickname"];
    self.duration=1.5;
    self.animationType=[[dict valueForKey:@"animating_type"] integerValue];
    long uid=[[dict valueForKey:@"user_id"]longValue];
    self.uid=[NSString stringWithFormat:@"%ld",uid];
    self.yxID=[dict valueForKey:@"vcloud_id"];
    
}
@end
