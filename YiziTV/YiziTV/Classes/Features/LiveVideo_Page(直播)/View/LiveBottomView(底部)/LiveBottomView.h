//
//  LiveBottomView.h
//  YiziTV
//
//  Created by 梁飞 on 16/7/18.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LiveBottomViewDelegate <NSObject>

//点击聊天按钮
-(void)clickLiveBottomViewChatButton;

//点击切换摄像头
-(void)clickInputViewChangeCamera;

//点击分享
-(void)clickLiveBottomViewShareButton;

//点击名片
-(void)clickLiveBottomViewCardButton;

@end


@interface LiveBottomView : UIView

@property(assign,nonatomic)id<LiveBottomViewDelegate>delegate;


@end
