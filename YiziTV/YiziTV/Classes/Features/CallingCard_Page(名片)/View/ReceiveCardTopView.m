//
//  ReceiveCardTopView.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/21.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "ReceiveCardTopView.h"

@interface ReceiveCardTopView ()
{
    UIView * verLine;
    
    //图标
    UIImageView * timeIcon;
    
    //时间日期
    UILabel * timeLabel;
    

}
@end

//高度  46
@implementation ReceiveCardTopView
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        CGFloat height=frame.size.height;
        verLine=[[UIView alloc]initWithFrame:CGRectMake(20, 0, 0.5, height)];
        verLine.backgroundColor=[UIColor customColorWithString:@"c8c8c8"];
        [self addSubview:verLine];
        
        timeIcon=[[UIImageView alloc]initWithFrame:CGRectMake(12, 20, 16, 16)];
        timeIcon.image=[UIImage imageNamed:@"time"];
        [self addSubview:timeIcon];
        
        timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(timeIcon.frame)+12, 20, 200, 16)];
        timeLabel.font=[UIFont fontWithName:TextFontName size:11];
        timeLabel.textColor=[UIColor customColorWithString:@"#909290"];
        [self addSubview:timeLabel];
        
        

    }
    return self;
}
-(void)setShowTime:(NSString *)time
{
    timeLabel.text=time;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
