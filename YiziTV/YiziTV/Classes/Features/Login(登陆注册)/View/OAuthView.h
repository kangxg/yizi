//
//  OAuthView.h
//  YiziTV
//
//  Created by 井泉 on 16/6/21.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "UrlRequest.h"


@protocol OAuthViewDelegate <NSObject>

@optional
- (void)success:(NSInteger)needPhone;
- (void)failure;

@end

@interface OAuthView : UIView
{
//    id <OAuthViewDelegate> delegate;

}

- (id)initWithFrame:(CGFloat)height QQ:(BOOL)isQQ WX:(BOOL)isWx;

@property (nonatomic, assign) id <OAuthViewDelegate> delegate;

@end
