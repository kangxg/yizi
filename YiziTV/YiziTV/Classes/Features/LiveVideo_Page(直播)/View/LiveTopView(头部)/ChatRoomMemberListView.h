//
//  ChatRoomMemberListView.h
//  YiziTV
//
//  Created by 梁飞 on 16/7/14.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatRoomMemberListView : UIView
@property(assign,nonatomic)BOOL isAnchorAction;
-(void)showInView;
-(void)hiddenInView;
-(void)refreshRoomMemberList:(NSMutableArray*)roomMemberArray;
//是否是主播操作
-(void)setIsAnchorAction:(BOOL)isAnchorAction;
-(instancetype)initWithRoomId:(NSString*)roomId;

@end
