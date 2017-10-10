//
//  UserInfoModel.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/20.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_uid forKey:@"UID"];
    [aCoder encodeObject:_deviceId forKey:@"deviceId"];

    [aCoder encodeObject:_phone_number forKey:@"phone_number"];
    [aCoder encodeObject:_user_token forKey:@"user_token"];
    [aCoder encodeObject:[NSNumber numberWithInt:_isCertification] forKey:@"isCertification"];
    
    [aCoder encodeObject:_setLiveCoverImageUrl forKey:@"LiveCoverImageUrl"];
    
    [aCoder encodeObject:_realName forKey:@"REALNAME"];
    [aCoder encodeObject:_IDNum forKey:@"IDNUM"];
    
    [aCoder encodeObject:_YXAcount forKey:@"YXACOUNT"];
    [aCoder encodeObject:_YXToken forKey:@"YXToken"];
    
    [aCoder encodeObject:_nickName forKey:@"NK"];
    [aCoder encodeObject:_liveTheme forKey:@"THEME"];
    
    
    
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    if (self) {
      
        self.uid=[aDecoder decodeObjectForKey:@"UID"];
        self.deviceId=[aDecoder decodeObjectForKey:@"deviceId"];
        self.phone_number=[aDecoder decodeObjectForKey:@"phone_number"];
        self.user_token=[aDecoder decodeObjectForKey:@"user_token"];
        
        self.isCertification=[[aDecoder decodeObjectForKey:@"isCertification"]intValue];
        
        self.setLiveCoverImageUrl=[aDecoder decodeObjectForKey:@"LiveCoverImageUrl"];
        
        self.realName=[aDecoder decodeObjectForKey:@"REALNAME"];
        self.IDNum=[aDecoder decodeObjectForKey:@"IDNUM"];
        
        self.YXAcount=[aDecoder decodeObjectForKey:@"YXACOUNT"];
        self.YXToken=[aDecoder decodeObjectForKey:@"YXToken"];
        self.nickName=[aDecoder decodeObjectForKey:@"NK"];
        
        self.liveTheme=[aDecoder decodeObjectForKey:@"THEME"];
        
        
        
    }
    return self;
    
}
@end
