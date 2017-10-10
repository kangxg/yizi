//
//  LivePreviewView.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/28.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LivePreviewViewDelegate <NSObject>

@optional
//关闭
-(void)closePreview;
//点击封面
-(void)clickCoverImageView;

//点击开始
-(void)clickBeginButtonWithThemeTitle:(NSString*)title;

-(void)clickChangeCameraPositionACtion;

@end


@interface LivePreviewView : UIView

@property(assign,nonatomic)id<LivePreviewViewDelegate>delegate;

//更换封面
-(void)changeCoverImageWithImageUrl:(NSString*)imageUrl;

@end
