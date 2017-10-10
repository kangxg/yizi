//
//  ChatRoomManager.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/3.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "ChatRoomManager.h"
#import "AttachmentDecoder.h"
#import "YZChatRoomCustomAttachment.h"

@interface ChatRoomManager ()<NIMChatManagerDelegate>
@property(strong,nonatomic)NSMutableDictionary * myInfo;
@property (nonatomic, assign) NSInteger limit; //分页条数
@property(strong,nonatomic)NSMutableArray * membersArr;

@end

@implementation ChatRoomManager
+(instancetype)shareManager
{

    static ChatRoomManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ChatRoomManager alloc]init];
    });
    return instance;
}
-(id)init
{
    self=[super init];
    if (self) {
        
        _myInfo=[NSMutableDictionary dictionary];
        self.membersArr=[NSMutableArray array];
       
        
        
    }
    return self;

}
-(void)dealloc
{
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    
}

- (NIMChatroomMember *)myInfo:(NSString *)roomId
{
    NIMChatroomMember *member = _myInfo[roomId];
   
    return member;
}

- (void)cacheMyInfo:(NIMChatroomMember *)info roomId:(NSString *)roomId
{

  
    [_myInfo setObject:info forKey:roomId];
}


#pragma mark NIMChatManagerDelegate


//收到消息
- (void)onRecvMessages:(NSArray *)messages
{
   
dispatch_async(dispatch_get_main_queue(),^{
    
    for (NIMMessage *message in messages) {
        
        NSLog(@"收到消息++++++++%@",message);

        //聊天室文本消息
        if (message.session.sessionType == NIMSessionTypeChatroom
            && message.messageType == NIMMessageTypeText)
        {
            [self dealTextMessage:message];
            
            return;
        }
        else if (message.messageType==NIMMessageTypeNotification) {
          
            NIMNotificationObject *object = message.messageObject;
            NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)object.content;
            
//            NSLog(@"content.eventTypecontent.eventTypecontent.eventType%ld",content.eventType);
            switch (content.eventType) {
                    
                    //成员进入聊天室
                case NIMChatroomEventTypeEnter:
                {
                    NSLog(@" //成员进入聊天室");
//                     NIMUser * yxuser=[[NIMSDK sharedSDK].userManager userInfo:[NIMSDK sharedSDK].loginManager.currentAccount];
                   
                    for (NIMChatroomNotificationMember *memebr in content.targets) {
//                         if (![memebr.userId isEqualToString:yxuser.userId])
//                         {
                        NSLog(@"=====NIMChatroomNotificationMember");
                        [self showPersonEnterChatRoomMessage:memebr];
//                         }
                    }
                    
                    return;
                }
                    break;
                    
                    //成员离开聊天室
                case NIMChatroomEventTypeExit:
                {
                     NIMUser * yxuser=[[NIMSDK sharedSDK].userManager userInfo:[NIMSDK sharedSDK].loginManager.currentAccount];
                    
                    for (NIMChatroomNotificationMember *memebr in content.targets) {
                        
//                        if (![memebr.userId isEqualToString:yxuser.userId]) {
//                            [self showPersonExitChatRoomMessage];

//                        }
                    }

                   
                    
                    
                    return;
                
                }break;
                    
                case NIMChatroomEventTypeAddMuteTemporarily:
                {
                
                    for (NIMChatroomNotificationMember *memebr in content.targets) {
                        
                        [self showAddMuterChatRoomMessage:memebr];
                    }

                  
                    
                    return;
                }
                    break;
                    
                case NIMChatroomEventTypeRemoveMuteTemporarily:
                {
                
                    for (NIMChatroomNotificationMember *memebr in content.targets) {
                        
                        [self showRemoveMuterChatRoomMessage:memebr];
                    }

                
                    return;
                }
                    break;
                    
                    
                default:
                {
                
                }
                    break;
            }
            
            
            return;
        }
        
        
       else if (message.messageType==NIMMessageTypeCustom) {
           
            NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
            AttachmentDecoder *attachment  = (AttachmentDecoder *)object.attachment;
           
        }
       
        
    }
    
});
               
}

//聊天室文本消息
- (void)dealTextMessage:(NIMMessage *)message
{
    
    NSLog(@"------处理消息--------");
    ChatSessionModel  * sessionModel=[[ChatSessionModel alloc]init];
    sessionModel.cardInfoModel=[[CardInfoModel alloc]init];
    sessionModel.cardInfoModel.nickName=[message.remoteExt valueForKey:kNickNameKey];
    sessionModel.yztvMessageType=[[message.remoteExt valueForKey:kMessageTypeKey]intValue];
    sessionModel.uid=[message.remoteExt valueForKey:kUserIdKey];
    sessionModel.yxID=[message.remoteExt valueForKey:kYXIDKey];
    sessionModel.text=message.text;
    
    if ([self.delegate respondsToSelector:@selector(receiveChatSessionMessage:)]) {
        [self.delegate receiveChatSessionMessage:sessionModel];
    }
  
    
   
    
  
}
-(void)sendNomalTextMessageWithChatSessionModel:(ChatSessionModel *)sessionMode roomId:(NSString *)roomId
{

    NIMSession *session = [NIMSession session:roomId type:NIMSessionTypeChatroom];
    
    [[NIMSDK sharedSDK].chatManager sendMessage:sessionMode toSession:session error:nil];


}
//关注
-(void)senFocusMessageWithRoomID:(NSString *)roomId
{

    NIMUser * yxuser=[[NIMSDK sharedSDK].userManager userInfo:[NIMSDK sharedSDK].loginManager.currentAccount];
    
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];

    //自己显示
    
    ChatSessionModel  * sessionModel=[[ChatSessionModel alloc]init];
    sessionModel.cardInfoModel=[[CardInfoModel alloc]init];
    sessionModel.cardInfoModel.nickName=yxuser.userInfo.nickName;
    sessionModel.yztvMessageType=ChatMessageTypeFocus;
    sessionModel.text=kFocusContentKey;
    sessionModel.yxID=yxuser.userId;
    sessionModel.uid=user.uid;
    
    
    //发送出去
    
    NIMMessage * message=[[NIMMessage alloc]init];
    message.text=kFocusContentKey;
    
    
    if (yxuser.userInfo.nickName.length) {
    message.remoteExt=@{kNickNameKey:yxuser.userInfo.nickName,kMessageTypeKey:[NSNumber numberWithInt:ChatMessageTypeFocus],kUserIdKey:user.uid,kYXIDKey:yxuser.userId};
    }else
    {
    message.remoteExt=@{kNickNameKey:@"匿名者",kMessageTypeKey:[NSNumber numberWithInt:ChatMessageTypeFocus],kUserIdKey:user.uid,kYXIDKey:yxuser.userId};
    
    }
    
    NIMSession * session=[NIMSession session:roomId type:NIMSessionTypeChatroom];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
    
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(receiveChatSessionMessage:)]) {
        [self.delegate receiveChatSessionMessage:sessionModel];
    }
    
    

    

}
//显示成员进入聊天室消息
-(void)showPersonEnterChatRoomMessage:(NIMChatroomNotificationMember*)member
{

//    NIMUser * yxuser=[[NIMSDK sharedSDK].userManager userInfo:[NIMSDK sharedSDK].loginManager.currentAccount];
    
    ChatSessionModel  * sessionModel=[[ChatSessionModel alloc]init];
    sessionModel.yxID=member.userId;
    sessionModel.cardInfoModel=[[CardInfoModel alloc]init];
    if (member.nick.length) {
        sessionModel.cardInfoModel.nickName=member.nick;
    }
    else
    {
         sessionModel.cardInfoModel.nickName=@"匿名者";
    
    }
    sessionModel.yztvMessageType=ChatMessageTypeEnter;
    sessionModel.text=kEnterRoomContentKey;
    
    
    NIMChatroomMembersByIdsRequest * request=[[NIMChatroomMembersByIdsRequest alloc]init];
    request.roomId=[_myInfo.allKeys firstObject];
    request.userIds=@[member.userId];
    
    [[[NIMSDK sharedSDK]chatroomManager] fetchChatroomMembersByIds:request completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
        
        if (error==nil) {
          
            NIMChatroomMember * member=[members firstObject];
            if ([self.delegate respondsToSelector:@selector(showMemberEnterRoomMessage:)]) {
                CardInfoModel * giftMode=[[CardInfoModel alloc]init];
                giftMode.nickName=member.roomNickname;
                giftMode.headImageUrl=member.roomAvatar;
                
                [self.delegate showMemberEnterRoomMessage:giftMode];
                
                [self refreshRoomPersonCount];
                
            }

        }
        
    }];
    
    
    
   
    
    
   
    
    
    
    
    if ([self.delegate respondsToSelector:@selector(receiveChatSessionMessage:)]) {
        [self.delegate receiveChatSessionMessage:sessionModel];
    }

    
    
    
   

}
//显示被禁言消息

-(void)showAddMuterChatRoomMessage:(NIMChatroomNotificationMember*)member
{
    
    ChatSessionModel  * sessionModel=[[ChatSessionModel alloc]init];
    sessionModel.yxID=member.userId;
    sessionModel.cardInfoModel=[[CardInfoModel alloc]init];
    if (member.nick.length) {
        sessionModel.cardInfoModel.nickName=member.nick;
    }
    else
    {
        sessionModel.cardInfoModel.nickName=@"匿名者";
        
    }
    sessionModel.yztvMessageType=ChatMessageTypeAddMute;
    sessionModel.text=kAddMuteContentkey;
    
    
    if ([self.delegate respondsToSelector:@selector(receiveChatSessionMessage:)]) {
        [self.delegate receiveChatSessionMessage:sessionModel];
    }
    
    

    
    


}
//显示被解除禁言的消息
-(void)showRemoveMuterChatRoomMessage:(NIMChatroomNotificationMember*)member
{
    // //被禁言
   // ChatMessageTypeAddMute,
    
    //解除禁言
   // ChatMessageTypeRemoveMute,
    

    
    ChatSessionModel  * sessionModel=[[ChatSessionModel alloc]init];
    sessionModel.yxID=member.userId;
    sessionModel.cardInfoModel=[[CardInfoModel alloc]init];
    if (member.nick.length) {
        sessionModel.cardInfoModel.nickName=member.nick;
    }
    else
    {
        sessionModel.cardInfoModel.nickName=@"匿名者";
        
    }
    sessionModel.yztvMessageType=ChatMessageTypeRemoveMute;
    sessionModel.text=kRemoveMuteContentkey;
    
    
    if ([self.delegate respondsToSelector:@selector(receiveChatSessionMessage:)]) {
        [self.delegate receiveChatSessionMessage:sessionModel];
    }
    
    


    
}

//成员离开房间
-(void)showPersonExitChatRoomMessage
{

    [self refreshRoomPersonCount];

}
//刷新房间内的人数
-(void)refreshRoomPersonCount
{
    

    if (self.delegate&&[self.delegate respondsToSelector:@selector(refreshRoomMember)]) {
      
                
        [self.delegate refreshRoomMember];
        

    }

}

-(void)getChatroomMemberInblock:(void (^)(NSMutableArray *returnMembers ))returnMembers RoomID:(NSString *)roomId
{
    
    self.limit=100;
    __weak typeof(self) wself = self;
    [self requestTeamMembers:nil handler:^(NSError *error, NSArray *members) {
        if (!error)
        {
            
            wself.membersArr =[NSMutableArray arrayWithArray:members];
                
            [wself sortMember];
            
            returnMembers(wself.membersArr);
            
        }
        else
        {
            returnMembers(wself.membersArr);
            NSLog(@"直播间成员获取失败--%@", error.description);
        }
    } RoomID:roomId];
    
    
    
    
    
}
//加载更多成员
-(void)loadMoreMemberListWithRoomID:(NSString*)roomID returnInblock:(void (^)(NSMutableArray *returnMembers ))returnMembers
{
    
    self.limit=100;
    __weak typeof(self) wself = self;
    //加载更多
    NIMChatroomMember * lastMember=[self.membersArr lastObject];
    [self requestTeamMembers:lastMember handler:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
        
        if (error==nil) {
            
            [wself.membersArr arrayByAddingObjectsFromArray:members];
            [wself sortMember];
            returnMembers(wself.membersArr);
            
                
            
        }else
        {
        
            returnMembers(wself.membersArr);
        }
        
        
    } RoomID:roomID];
    

    

}

-(void)getChatroomMemberCountInblock:(void (^)(NSInteger memberCount))memberCount  RoomID:(NSString *)roomId
{
    

    
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomInfo:roomId completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom) {
        
        if (error==nil) {

            memberCount(chatroom.onlineUserCount);
            
        }
        
    }];
    
    
}
- (void)requestTeamMembers:(NIMChatroomMember *)lastMember handler:(NIMChatroomMembersHandler)handler RoomID:(NSString *)roomId
{
    
    
    NIMChatroomMemberRequest *request = [[NIMChatroomMemberRequest alloc] init];
    request.roomId = roomId;
    request.lastMember = lastMember;
    request.type   = lastMember.type == NIMChatroomMemberTypeGuest ? NIMChatroomFetchMemberTypeTemp : NIMChatroomFetchMemberTypeRegularOnline;
    request.limit  = self.limit;
    __weak typeof(self) wself = self;
    
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembers:request completion:^(NSError *error, NSArray *members) {
        if (!error)
        {
            if (members.count <wself.limit && request.type == NIMChatroomFetchMemberTypeRegularOnline) {
                //固定的没抓够，再抓点临时的充数
                NIMChatroomMemberRequest *req = [[NIMChatroomMemberRequest alloc] init];
                req.roomId = roomId;
                req.lastMember = nil;
                req.type   = NIMChatroomFetchMemberTypeTemp;
                req.limit  = wself.limit;
                [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembers:req completion:^(NSError *error, NSArray *tempMembers) {
                    NSArray *result;
                    if (!error) {
                        result = [members arrayByAddingObjectsFromArray:tempMembers];
                        if (result.count > wself.limit) {
                            result = [result subarrayWithRange:NSMakeRange(0, wself.limit)];
                        }
                    }
                    handler(error,result);
                }];
            }
            else
            {
                handler(error,members);
            }
        }
        else
        {
            handler(error,members);
        }
    }];
}

- (void)sortMember
{
    NSDictionary<NSNumber *,NSNumber *> *values =
    @{
      @(NIMChatroomMemberTypeCreator) : @(1),
      @(NIMChatroomMemberTypeManager) : @(2),
      @(NIMChatroomMemberTypeNormal ) : @(3),
      @(NIMChatroomMemberTypeLimit  ) : @(4),
      @(NIMChatroomMemberTypeGuest  ) : @(5),
      };
    [self.membersArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NIMChatroomMember *member1  = obj1;
        NIMChatroomMember *member2  = obj2;
        NIMChatroomMemberType type1 = member1.type;
        NIMChatroomMemberType type2 = member2.type;
        return values[@(type1)].integerValue > values[@(type2)].integerValue;
    }];
}

-(void)exitChatRoomWithRoomId:(NSString *)roomId
{
    [[[NIMSDK sharedSDK]chatroomManager] exitChatroom:roomId completion:^(NSError * _Nullable error) {
        
    }];
}


//-(void)senCardMessage:(CardInfoModel *)cardModel roomId:(NSString *)roomId
//{
//    
//    YZChatRoomCustomAttachment * sendModel=[[YZChatRoomCustomAttachment alloc]init];
//    sendModel.ID=cardModel.ID;
//    sendModel.headImageUrl=cardModel.headImageUrl;
//    sendModel.name=cardModel.name;
//    sendModel.nickName=cardModel.nickName;
//    sendModel.grand=cardModel.grand;
//    sendModel.phoneNum=cardModel.phoneNum;
//    sendModel.shcool=cardModel.shcool;
//    sendModel.professional=cardModel.professional;
//    sendModel.graduateTime=cardModel.graduateTime;
//    sendModel.wantJobName=cardModel.wantJobName;
//    
//    NSLog(@"======cardModel %@ sendModel%@",cardModel.headImageUrl,sendModel.headImageUrl);
//
//     [self otherMessageWithCardInfoModel:cardModel];
//    
//    //构造消息
//    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
//    customObject.attachment=sendModel;
//    
//    NIMMessage *message               = [[NIMMessage alloc] init];
//    message.messageObject             = customObject;
//    
//    NIMSession *session = [NIMSession session:roomId type:NIMSessionTypeChatroom];
//   
//    //发送消息
//    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
//    
//    if (self.delegate&&[self.delegate respondsToSelector:@selector(receiveCardInfoMeaage:)]) {
//        [self.delegate receiveCardInfoMeaage:cardModel];
//    }
//    
//    
//}
//处理礼物消息
-(void)dealGiftMessage:(NSDictionary *)dict
{

    

    GiftInfoModel * model=[[GiftInfoModel alloc]init];
    [model analysisGiftInfoWithDic:dict];
   
   

    
    [self otherMessageWithGift:model];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(receiveGiftMessage:)]) {
        [self.delegate receiveGiftMessage:model];
    }
    
     long  receiveGiftCount=[[dict valueForKey:@"anchor_gift_count"]longValue];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(refreAnchorReceiveGiftCount:)]) {
        [self.delegate refreAnchorReceiveGiftCount:receiveGiftCount];
    }
   
}
-(void)dealCardInfoMessage:(NSDictionary *)dict
{
    
    
    CardInfoModel * cardInfoModel=[[CardInfoModel alloc]init];
    [cardInfoModel analysisCustomMessageWithDic:dict];
    
    
    
    [self otherMessageWithCardInfoModel:cardInfoModel];
    
    
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(receiveCardInfoMeaage:)]) {
        [self.delegate receiveCardInfoMeaage:cardInfoModel];
    }
     
       
}
//发名片息显示文本消息
-(void)otherMessageWithCardInfoModel:(CardInfoModel*)cardInfoModel
{
    //构造文本消息 发送名片类型


    
    ChatSessionModel  * sessionModel=[[ChatSessionModel alloc]init];
    sessionModel.cardInfoModel=[[CardInfoModel alloc]init];
    sessionModel.cardInfoModel=cardInfoModel;
    sessionModel.yztvMessageType=ChatMessageTypeCard;
    sessionModel.text=kSendCardContentKey;
    sessionModel.yxID=cardInfoModel.yxID;
    sessionModel.uid=cardInfoModel.uid;
    

    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(receiveChatSessionMessage:)]) {
        [self.delegate receiveChatSessionMessage:sessionModel];
    }

}
//发礼物显示文消息
-(void)otherMessageWithGift:(GiftInfoModel*)giftModel
{

    ChatSessionModel  * sessionModel=[[ChatSessionModel alloc]init];
    sessionModel.cardInfoModel=[[CardInfoModel alloc]init];
    sessionModel.giftModel=giftModel;
    sessionModel.cardInfoModel.nickName=giftModel.nickname;
    sessionModel.yztvMessageType=ChatMessageTypeGift;
    sessionModel.text=[NSString stringWithFormat:@"%@%d个",kSendGiftContentKey,giftModel.presentCount];
    sessionModel.uid=giftModel.uid;
    sessionModel.yxID=giftModel.yxID;
    
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(receiveChatSessionMessage:)]) {
        [self.delegate receiveChatSessionMessage:sessionModel];
    }


}
-(void)anchorOverLiveMessage
{
    if ([self.delegate respondsToSelector:@selector(liveOverMessage)]) {
        [self.delegate liveOverMessage];
    }

}
-(void)addChatManagerDelegate
{
     [[NIMSDK sharedSDK].chatManager addDelegate:self];

}
-(void)removeChatManagerDelegate
{
   [[NIMSDK sharedSDK].chatManager removeDelegate:self];
}

@end
