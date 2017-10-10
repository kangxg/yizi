//
//  SharePageView.h
//  YiziTV
//
//  Created by 井泉 on 16/7/5.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharePageView : UIView

@property(copy,nonatomic)void(^shareType)(YZSharePlatformType type);


- (id)initFullScreen;


@end
