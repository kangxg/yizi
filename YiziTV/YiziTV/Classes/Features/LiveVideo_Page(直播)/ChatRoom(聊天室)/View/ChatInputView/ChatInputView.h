//
//  ChatInputView.h
//  YiziTV
//
//  Created by 梁飞 on 16/7/1.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatInputTextView.h"

@protocol ChatInputDelegate <NSObject>

@optional

//点击发送按钮
-(void)clickSendMessageButtonWithMessage:(NSString*)message;

//点击分享
-(void)clickInputViewShareButton;

//点击礼物
-(void)clickInputViewGiftButton;
//点击名片
-(void)clickInputViewCardButton;



@end




@interface ChatInputView : UIView<UITextViewDelegate>

@property (nonatomic, assign) NSInteger maxTextLength;
@property (nonatomic, assign) CGFloat  inputBottomViewHeight;

@property (nonatomic, weak) id<ChatInputDelegate> inputDelegate;

@property(nonatomic,strong) ChatInputTextView  * inputView;


- (instancetype)initWithFrame:(CGRect)frame;




@end
