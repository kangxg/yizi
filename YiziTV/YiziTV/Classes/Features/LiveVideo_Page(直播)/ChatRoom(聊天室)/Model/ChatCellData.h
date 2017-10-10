//
//  ChatCellData.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/30.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatSessionModel.h"

@interface ChatCellData : NSObject

{
    
    ChatSessionModel* _sessionModel;
}

@property(assign,nonatomic)CGFloat rowWidth;

@property(assign,nonatomic)CGFloat cellRowHeight;

@property(assign,nonatomic)CGFloat bubbleWidth;

@property(assign,nonatomic)CGFloat contentWidth;

@property(assign,nonatomic)CGFloat bubbleHeight;

@property(assign,nonatomic)CGFloat contentHeight;

//气泡背景图片名字
@property(copy,nonatomic)NSString * bubbleImageName;

//礼物地址
@property(copy,nonatomic)NSString * giftImageUrl;

@property(copy,nonatomic)NSMutableAttributedString * contentString;

@property(assign,nonatomic)YZTVChatMessageType yztvMessageType;

-(id)initWoithSessionModel:(ChatSessionModel*)sessionModel;

@end
