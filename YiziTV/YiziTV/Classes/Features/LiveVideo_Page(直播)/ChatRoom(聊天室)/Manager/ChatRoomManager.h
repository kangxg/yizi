//
//  ChatRoomManager.h
//  YiziTV
//
//  Created by 梁飞 on 16/7/3.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMSDK.h"
#import "ChatSessionModel.h"
#import "CardInfoModel.h"
#import "GiftInfoModel.h"


@protocol ChatRoomMangeDelegate <NSObject>


//收到文本消息
-(void)receiveChatSessionMessage:(ChatSessionModel*)sessionModel;

//刷新房间内的人数
-(void)refreshRoomMember;

//收到礼物消息
-(void)receiveGiftMessage:(GiftInfoModel*)giftModel;

//收到卡片消息
-(void)receiveCardInfoMeaage:(CardInfoModel*)cardInfoModel;

//显示成员进入聊天室动画消息
-(void)showMemberEnterRoomMessage:(CardInfoModel*)cardInfoModel;


@optional
//刷新主播收到的礼物数
-(void)refreAnchorReceiveGiftCount:(long)GiftCount;

@optional
-(void)liveOverMessage;

@end




@interface ChatRoomManager : NSObject

@property(weak,nonatomic)id<ChatRoomMangeDelegate>delegate;


+(instancetype)shareManager;

- (NIMChatroomMember *)myInfo:(NSString *)roomId;

- (void)cacheMyInfo:(NIMChatroomMember *)info roomId:(NSString *)roomId;
//发送普通文本消息
-(void)sendNomalTextMessageWithChatSessionModel:(ChatSessionModel*)sessionMode roomId:(NSString*)roomId;


////发送名片消息
//-(void)senCardMessage:(CardInfoModel*)cardModel roomId:(NSString*)roomId;


//发送关注消息
-(void)senFocusMessageWithRoomID:(NSString*)roomId;

//获取房间内成员
-(void)getChatroomMemberInblock:(void (^)(NSMutableArray *returnMembers ))returnMembers RoomID:(NSString*)roomId;

//加载更多房间内成员
-(void)loadMoreMemberListWithRoomID:(NSString*)roomID returnInblock:(void (^)(NSMutableArray *returnMembers ))returnMembers;

#pragma mark 获取房间内人员数
-(void)getChatroomMemberCountInblock:(void (^)(NSInteger memberCount))memberCount RoomID:(NSString *)roomId;



//离开聊天室
-(void)exitChatRoomWithRoomId:(NSString*)roomId;

-(void)dealCardInfoMessage:(NSDictionary*)dict;

//收到礼物消息
-(void)dealGiftMessage:(NSDictionary*)dict;

//主播下麦消息
-(void)anchorOverLiveMessage;

////添加hatManager delegate
-(void)addChatManagerDelegate;

////移除chatManager delegate
-(void)removeChatManagerDelegate;


@end
