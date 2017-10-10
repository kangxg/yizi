//
//  AudienceChatSessionView.h
//  YiziTV
//
//  Created by 梁飞 on 16/7/1.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "ChatRoomSessionView.h"
#import "GiftKeyboardView.h"

@interface AudienceChatSessionView : ChatRoomSessionView

@property(strong,nonatomic) GiftKeyboardView * giftKeyBoardView;

/*
 
 
 观看者会话窗口
 
 
 */
-(void)changeToAudienceKeyboardNull;
//刷新礼物列表和金币
-(void)refreshGiftListAndGoldCion;



@end
