//
//  ChatRoomSessionView.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/30.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatSessionModel.h"

@protocol ChatRoomSessionDeleaget <NSObject>


@optional
//发消息
-(void)sendChatRoomMessage:(ChatSessionModel*)message;

//切换摄像头
-(void)changeCameraPositionAction;

//分享
-(void)shareLiveAction;

//发送名片
-(void)sendMyCardInfo;

//发送礼物
-(void)sendGiftActionWithGiftArr:(NSMutableArray *)giftArrary;

//点击充值
-(void)clickAddGoldButtonWithMyCardInfo:(CardInfoModel *)myCardInfo;


@optional
//显示任何键盘键盘
-(void)keyboardDidShow;

@optional
//隐藏键盘
-(void)keyboardDidHiden;


@end


@interface ChatRoomSessionView : UIView

{
    UITableView * chatTableView;
    
    YZKeyboardType keyboardType;
    
    NSString * _roomID;
    
}

@property(strong,nonatomic)NSMutableArray * sessionArray;

@property(strong,nonatomic)NSMutableArray * cellDataArray;

@property(assign,nonatomic)id<ChatRoomSessionDeleaget>delegate;
-(instancetype)initWithRoomID:(NSString*)roomId;

-(void)showNomalKeyBoardWithKeyBoardHeight:(CGFloat)keyBoardHeight;


-(void)hideNomalKeyBoard;


-(void)refreshUI;


-(YZKeyboardType)getKeyboardType;
@end
