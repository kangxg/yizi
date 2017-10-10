//
//  ShowCardViewManager.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/25.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "ShowCardViewManager.h"
#import "CallingCardView.h"
#import "CardInfoDetailView.h"


@interface ShowCardViewManager ()
{

    
    NSMutableArray * _cardArray;
    
    UIView * _superView;
    
    UIView * _showCardView;
    
    BOOL   _isShowCardView;
    
    CallingCardView * _cardView;
    

}




@end

@implementation ShowCardViewManager
-(id)initWithSuperView:(UIView *)superView
{
    self=[super init];
    if (self) {
        
        
        
        _cardArray=[NSMutableArray array];
        _showCardView=[[UIView alloc]initWithFrame:CGRectMake(0, 70, ChatScreenWidth, 190/2)];
//        _showCardView.backgroundColor=[UIColor redColor];
        _superView=superView;
        [_superView addSubview:_showCardView];
        
       UITapGestureRecognizer *  tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCardManagerShow:)];
        [_showCardView addGestureRecognizer:tapGesture];

        
    }
    
    return self;
}
-(void)tapCardManagerShow:(UITapGestureRecognizer*)tapGesture
{
    CGPoint touchPoint = [tapGesture locationInView:_showCardView];
    
    if ([_cardView.layer.presentationLayer hitTest:touchPoint]) {
        
//        NSLog(@"cardView.layer.presentationLayer hitTest:touchPoint");
        
        UIImageView * imageView=  [UIImageView blurImageWithView:_superView];
        CardInfoDetailView * detailView=[[CardInfoDetailView alloc]init];
        [imageView addSubview:detailView];
        [detailView setModel:_cardView.cardInfoModel];
        
        if (self.tapCardViewCallback!=nil) {
            self.tapCardViewCallback(imageView);
        }
        
        detailView.closeShowView=^{
            
            if (self.closeCardDetailView!=nil) {
                self.closeCardDetailView();
            }
        
        };
        
    }


}

-(void)receiveCardInfo:(CardInfoModel *)cardInfoModel
{
    [_cardArray addObject:cardInfoModel];
    [self showCardDisplayAnimation];
    
}
//显示卡片进入动画
-(void)showCardDisplayAnimation
{
    
    
    
    if (_cardArray.count&&_isShowCardView==NO) {
        
        CardInfoModel * cardInfoModel=[_cardArray firstObject];
        
        _isShowCardView=YES;
        //        NSLog(@"carINfoModel====%@",cardInfoModel.nickName);
        _cardView=[[CallingCardView alloc]initWithFrame:CGRectMake(-ChatScreenWidth, 0, ChatScreenWidth, 190/2)];
        [_cardView setCardInfoModel:cardInfoModel];
        [_showCardView addSubview:_cardView];
        
        
        [self animationShow];
        
        
        
    }
    
    
    
    
}

-(void)animationShow
{
    


    [UIView animateWithDuration:0.25 animations:^{
        
        _cardView.frame=CGRectMake(18, _cardView.y, _cardView.width, _cardView.height);
        
    } completion:^(BOOL finished) {
        
        
        
        [UIView animateWithDuration:0.25 delay:3 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _cardView.frame=CGRectMake(-ChatScreenWidth, _cardView.y, _cardView.width, _cardView.height);
            
        } completion:^(BOOL finished) {
            
            [_cardView removeFromSuperview];
            _isShowCardView=NO;
            [_cardArray removeObjectAtIndex:0];
            
            [self showCardDisplayAnimation];
            
        }];
        
        
        
    }];
}

@end
