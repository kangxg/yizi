//
//  EnterRoomView.h
//  YiziTV
//
//  Created by 井泉 on 16/7/14.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterRoomMessageView : UIView

@property (nonatomic, strong) UIImageView *headIconImageView;

- (id)initFormName:(NSString*)nickname withImageUrl:(NSString*)imageUrl;

@end
