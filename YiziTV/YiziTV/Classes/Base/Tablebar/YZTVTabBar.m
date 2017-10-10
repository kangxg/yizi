//
//  YZTVTabBar.m
//  YiziTV
//
//  Created by 井泉 on 16/6/15.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "YZTVTabBar.h"

@interface YZTVTabBar()
@property (nonatomic, strong) UIButton *liveTVBtn;
@end

@implementation YZTVTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        // 添加一个按钮到tabbar中
        
        self.backgroundColor=[UIColor whiteColor];
        CGFloat buttonWidth=self.frame.size.width / 4;
        _liveTVBtn= [[UIButton alloc] initWithFrame:CGRectMake(buttonWidth/2-40/2, kTabBarHeight/2-40/2, 40, 40)];
        [_liveTVBtn setImage:[UIImage imageNamed:@"btn_live_normal"] forState:UIControlStateNormal];
        [_liveTVBtn setBackgroundImage:[UIImage imageNamed:@"btn_live_press"] forState:UIControlStateNormal];
        [_liveTVBtn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [_liveTVBtn sizeToFit];
        [self addSubview:_liveTVBtn];
        
        NSArray * nameArr=@[@"首页",@"名片",@"我的"];
        NSArray * imageNomalNameArr=@[@"btn_home_normal",@"btn_card_normal",@"btn_mine_normal"];
        NSArray * imageSelectNameArr=@[@"btn_home_press",@"btn_card_press",@"btn_mine_press"];
        
        for (int i=0; i<nameArr.count; i++) {
            
            YZTVTabBarButton * btn=[[YZTVTabBarButton alloc]initWithFrame:CGRectMake(buttonWidth+buttonWidth*i, 0, buttonWidth, kTabBarHeight)];
            btn.iconImage.image=[UIImage imageNamed:[imageNomalNameArr objectAtIndex:i]];
            btn.iconImage.highlightedImage=[UIImage imageNamed:[imageSelectNameArr objectAtIndex:i]];
            btn.iconTitle.text=[nameArr objectAtIndex:i];
            
            btn.tag=i+1;
            [self addSubview:btn];
            
            if (i==0) {
                btn.iconImage.highlighted=YES;
                [btn setIconTitleHighlightColor:YES];
                
            }else
            {
                 btn.iconImage.highlighted=NO;
                [btn setIconTitleHighlightColor:NO];
            }
            
            
            [btn addTarget:self action:@selector(clickIconButton:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }
       
       
        
        
    }
    return self;
}

#pragma mark 加号按钮点击事件处理器
- (void)plusClick
{
    // 通知代理
    if ([self.tabBarDelegate respondsToSelector:@selector(tabBarDidClickPlusButton)]) {
        [self.tabBarDelegate tabBarDidClickPlusButton];
    }
}
-(void)clickIconButton:(YZTVTabBarButton*)btn
{

    if ([self.tabBarDelegate respondsToSelector:@selector(clickTabarItemButton:)]) {
        [self.tabBarDelegate clickTabarItemButton:btn];
    }
    
}
///**布局子视图*/
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    CGFloat tabbarButtonW = self.frame.size.width / 4;
//    CGFloat tabbarButtonIndex = 1;
//    // 1.设置加号按钮的位置
//
//    // 2.设置其它UITabBarButton的位置和尺寸
//
//    
//    _liveTVBtn.frame = CGRectMake(tabbarButtonW / 2 - _liveTVBtn.frame.size.width / 2,
//                                  self.frame.size.height / 2 - _liveTVBtn.frame.size.height / 2,
//                                  _liveTVBtn.frame.size.width,
//                                  _liveTVBtn.frame.size.height);
//    
//   
//    for (int i=0; i < self.subviews.count; i++) {
//        UIView *child = self.subviews[i];
//        Class class = NSClassFromString(@"UITabBarButton");
//        Class btnclass = NSClassFromString(@"UITabBarButtonLabel");
//        if ([child isKindOfClass:class]) {
////            NSLog(@"tabbarButtonIndex = %@",child );
//            for (UIView *child1 in child.subviews) {
//                if ([child1 isKindOfClass:btnclass]) {
//                    
//                    NSLog(@"tabbarButtonIndex = %@",child1 );
////
//                }
//            }
//            
//            // 设置宽度
//            child.frame = CGRectMake(tabbarButtonIndex * tabbarButtonW, 0, tabbarButtonW, child.frame.size.height);
////            NSLog(@"ori = %f", child.frame.origin.x);
//
//            tabbarButtonIndex++;
//
//        }
//    }
//}
//




@end
