//
//  FansModel.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/20.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "FansModel.h"

@implementation FansModel

-(void)analysisRequestJsonNSDictionary:(NSDictionary *)dic
{
    long uid=[[dic valueForKey:@"fans_id"]longValue];
    self.uid=[NSString stringWithFormat:@"%ld",uid];
    self.nickName=[dic valueForKey:@"fans_nickname"];
    self.headImageUrl=[dic valueForKey:@"fans_head_photo"];
    long count=[[dic valueForKey:@"contribution_count"]longValue];
    self.contributionCount=[NSString stringWithFormat:@"%ld",count];
    
}
@end
