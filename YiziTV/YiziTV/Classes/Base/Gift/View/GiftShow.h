//
//  GiftShow.h
//  YiziTV
//
//  Created by 井泉 on 16/7/1.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeetGiftView.h"

@class GiftInfoModel;

@interface GiftShow : NSObject
{

}

- (id)initWithView:(UIView*)view;
-(void)setShowViewFrameY:(CGFloat)originalY;
- (void)play;
- (void)addGift2QueueWithModelArray:(NSMutableArray*)list;
- (void)addGift2QueueWithModel:(GiftInfoModel*)list;
- (void)sendGift:(GiftInfoModel*)giftInfo;
@end
