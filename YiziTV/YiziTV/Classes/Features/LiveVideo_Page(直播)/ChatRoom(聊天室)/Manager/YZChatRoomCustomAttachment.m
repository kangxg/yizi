//
//  YZChatRoomCustomAttachment.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/4.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "YZChatRoomCustomAttachment.h"

@implementation YZChatRoomCustomAttachment

-(NSString*)encodeAttachment
{
    NSLog(@"encodeAttachment++++++++编码");
    
//    NSDictionary *dict = @{kCardInfoID:self.ID,
//                           kHeadImageUrl:self.headImageUrl,
//                           kName:self.name,
//                           kNickName:self.nickName,
//                           kGrand:[NSNumber numberWithInt:self.grand],
//                           kCity:self.locationCity,
//                           kPhoneNum:self.phoneNum,
//                           kSchool:self.shcool,
//                           kProfessional:self.professional,
//                           kGraduateTime:self.graduateTime,
//                           kWantJob:self.wantJobName,
//                           kCustomMessageType:[NSNumber numberWithInteger:self.customMessageType]};
////    NSDictionary *dict = @{kCardInfoID:self.ID,kHeadImageUrl:self.headImageUrl};

//    NSLog(@"dict++++++++++%@",dict);
//    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
//    NSLog(@"data++++++++++++%@",data);
//    
//    NSString *encodeString = @"";
//    if (data) {
//        encodeString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    }
//    NSLog(@"bianmahou++++++++++++++++++%@",encodeString);
    
    return nil;
    
    
}
-(NSString*)ID
{
    if (!_ID) {
        _ID=@"";
    }
    return _ID;
}
-(NSString*)headImageUrl
{
    if (!_headImageUrl) {
        _headImageUrl=@"";
    }
    return _headImageUrl;
}
-(int)grand
{

    return _grand;
    
}
-(NSString*)name
{
    if (!_name) {
        _name=@"";
    }
    return _name;
}
-(NSString*)nickName
{
    if (!_nickName) {
        _nickName=@"";
    }
    return _nickName;
}
-(NSString*)locationCity
{
    if (!_locationCity) {
        _locationCity=@"";
    }
    return _locationCity;
}
-(NSString*)phoneNum
{
    if (!_phoneNum) {
        _phoneNum=@"";
    }
    return _phoneNum;
}
-(NSString*)shcool
{
    if (!_shcool) {
        _shcool=@"";
    }
    return _shcool;
}
-(NSString*)professional
{
    if (!_professional) {
        _professional=@"";
    }
    return _professional;
}
-(NSString*)graduateTime
{
    if (!_graduateTime) {
        _graduateTime=@"";
    }
    return _graduateTime;
}
-(NSString*)wantJobName
{
    if (!_wantJobName) {
        _wantJobName=@"";
    }
    return _wantJobName;
    
}
-(YZTVCustomMessageType)customMessageType
{
    return CardInfoCustomMessagefoType;
    
}
@end
