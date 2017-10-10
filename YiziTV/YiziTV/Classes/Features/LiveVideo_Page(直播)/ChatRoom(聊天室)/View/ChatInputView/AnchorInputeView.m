//
//  AnchorInputeView.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/1.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "AnchorInputeView.h"

@implementation AnchorInputeView

-(instancetype)initWithFrame:(CGRect)frame
{

    self=[super initWithFrame:frame];
    if (self) {
       
        //切换摄像头
//        UIButton * changeCameraPositionButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 54, kTabBarHeight)];
//        [changeCameraPositionButton setImage:[UIImage imageNamed:@"camera_normal"] forState:UIControlStateNormal];
//        [changeCameraPositionButton setImage:[UIImage imageNamed:@"camera_press"] forState:UIControlStateSelected];
//        [changeCameraPositionButton addTarget:self action:@selector(clickChangeCameraPosition) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:changeCameraPositionButton];
        
        self.inputView.frame=CGRectMake(18, kTabBarHeight/2-30/2, kScreenWidth-36, 30);
        self.inputView.layer.cornerRadius=self.inputView.height/2;
        self.inputView.layer.borderWidth=0.5;
        self.inputView.layer.borderColor=[[[UIColor blackColor]colorWithAlphaComponent:0.2] CGColor];
        [self.inputView setPlaceHolder:@"说点什么吧"];
        
//        UIButton * sharaButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-54, 0, 54, kTabBarHeight)];
//        [sharaButton setImage:[UIImage imageNamed:@"share_normal"] forState:UIControlStateNormal];
//        [sharaButton setImage:[UIImage imageNamed:@"share_press"] forState:UIControlStateSelected];
//        [sharaButton addTarget:self action:@selector(clickSharaButton) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:sharaButton];
//        
        
        
        
    }
    
    return self;


}
-(void)dealloc
{

    [[NSNotificationCenter defaultCenter]removeObserver:self];
    

}


////点击切换照相机
//-(void)clickChangeCameraPosition
//{
//
//    if ([self.inputDelegate respondsToSelector:@selector(clickInputViewChangeCamera)]) {
//        [self.inputDelegate clickInputViewChangeCamera];
//    }
//    
//}
//-(void)clickSharaButton
//{
//    
//   
//    [self.inputView endEditing:YES];
//    
//    if ([self.inputDelegate respondsToSelector:@selector(clickInputViewShareButton)]) {
//        [self.inputDelegate clickInputViewShareButton];
//    }
//    
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
