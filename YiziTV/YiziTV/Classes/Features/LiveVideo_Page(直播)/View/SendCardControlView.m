//
//  SendCardControlView.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/4.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "SendCardControlView.h"

@interface SendCardControlView ()
{
    CGFloat itemWidth;
}
@end

@implementation SendCardControlView

- (instancetype)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    //初始化UI
    if (self)
    {
        itemWidth=aFrame.size.width/2;
        
        NSArray * nameArr=@[@"分享朋友圈免费",@"付费(2金币)   "];
        for (int i=0; i<nameArr.count; i++) {
            
            UIButton * button=[[UIButton alloc]initWithFrame:CGRectMake(itemWidth*i, 0, itemWidth, 42)];
            button.tag=i;
            [button setImage:[UIImage imageNamed:@"select_normal"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"select_press"] forState:UIControlStateSelected];
            [button setTitle:[nameArr objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor customColorWithString:@"909290"] forState:UIControlStateNormal];
            button.titleLabel.font=[UIFont fontWithName:TextFontName size:12];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button setImageEdgeInsets:UIEdgeInsetsMake(15, 20, 15, 5)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 11+5+5+5, 0, 0)];
            [self addSubview:button];
            
            
            if (i==0) {
                button.selected=YES;
                
            }
            
            [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }
        
        
    }
    return self;
    
}
-(void)selectButton:(UIButton*)btn
{
    for (UIButton * button in self.subviews) {
        
        if (btn.tag==button.tag) {
            button.selected=YES;
        }else{
            button.selected=NO;
        }
        
    }


}
-(YZTVPayType)getPayType
{
   NSInteger  type=0;
    
    for (UIButton * button in self.subviews)
    {
        if (button.selected==YES) {
           
            type=button.tag;
        }
    
    }
    
    switch (type) {
        case 0:
        {
            type=YZTVPayShareType;
            
        }
            break;
        case 1:
        {
            type=YZTVPayGoldType;
        
        }
            break;
            
        default:
            break;
    }
    
    return  type;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
