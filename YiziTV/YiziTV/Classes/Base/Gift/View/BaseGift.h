//
//  BaseGift.h
//  YiziTV
//
//  Created by 井泉 on 16/7/2.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GiftInfoModel;

typedef NS_ENUM(NSInteger, GiftState)
{
    GiftStateFinished = 0,
    GiftStatePlaying = 1,
    GiftStateprepare = 2
};

@protocol GiftDelegate <NSObject>

@optional
- (void)finished:(NSInteger)pos;
@end

@interface BaseGift : UIView
{
    
}

@property (nonatomic, assign) NSInteger giftState;
@property (nonatomic, strong) GiftInfoModel *presentInfo;
@property (nonatomic, assign) NSInteger showPosition;

- (void)showPresent;

@end
