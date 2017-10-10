//
//  EnterRoomMessageStage.h
//  YiziTV
//
//  Created by 井泉 on 16/7/17.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardInfoModel.h"
#import "EnterRoomMessageView.h"

@interface EnterRoomMessageStage : NSObject

@property (nonatomic, assign) NSInteger messageY;

- (id)initWithView:(UIView*)view;
- (void)play;
- (void)addOne2QueueWithModel:(CardInfoModel*)infoModel;

@end
