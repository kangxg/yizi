//
//  YZTVTabBarButton.m
//  YiziTV
//
//  Created by 井泉 on 16/6/15.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "YZTVTabBarButton.h"

@interface YZTVTabBarButton ()
{
   
    
    
}
@end

@implementation YZTVTabBarButton

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        CGFloat iconWidth=frame.size.width;
        CGFloat iconHeight=frame.size.height;
        self.iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(iconWidth/2-25/2, 5, 25, 25)];
        [self addSubview:self.iconImage];
        
        self.iconTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, iconHeight-7-12, iconWidth, 12)];
        self.iconTitle.font=[UIFont fontWithName:TextFontName size:10];
        self.iconTitle.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.iconTitle];
        
        
        
        
        
    }
    return self;
}
-(void)setIconTitleHighlightColor:(BOOL)highlight
{
    if (highlight) {
        self.iconTitle.textColor=[UIColor customColorWithString:@"#28904e"];
    }else
    {
       self.iconTitle.textColor=[UIColor customColorWithString:@"#909290"];
        
    }
}
@end
