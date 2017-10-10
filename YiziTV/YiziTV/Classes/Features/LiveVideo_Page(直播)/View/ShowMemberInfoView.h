//
//  ShowMemberInfoView.h
//  YiziTV
//
//  Created by 梁飞 on 16/7/21.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowMemberInfoView : UIView

//头像
@property(strong,nonatomic)UIImageView * headImageView;

//id
@property(copy,nonatomic)NSString * uid;

//云信ID
@property(copy,nonatomic)NSString * yxUid;

//是否开启禁言功能
@property(assign,nonatomic)BOOL isOpenSilentAction;
//是否禁言
@property(assign,nonatomic)BOOL isMuted;

//聊天室ID
@property(copy,nonatomic)NSString * roomID;


-(void)createUI;
@end
