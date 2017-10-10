//
//  LiveTopView.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/1.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "LiveTopView.h"


@interface LiveTopView ()
{
    UIView * gradiedtView;
    
    BOOL isAnimation;
    
}

@end

@implementation LiveTopView
-(id)init
{
    CGRect beginFrame=CGRectMake(0, 0, kScreenWidth, kLiveTopHeight);
    self=[super initWithFrame:beginFrame];
    if (self) {
        
//        self.backgroundColor=[UIColor clearColor];
        
        
        gradiedtView=[[UIView alloc]initWithFrame:beginFrame];
        gradiedtView.backgroundColor=[UIColor blackColor];
        [self addSubview:gradiedtView];
        [self setLayerDisplay];

        headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 50, 50)];
        headImageView.layer.masksToBounds=YES;
        headImageView.layer.cornerRadius=headImageView.width/2;
        headImageView.backgroundColor=[UIColor customColorWithString:@"eeeeee"];
        [self addSubview:headImageView];
        
        nickNameLabel=[UILabel setLabelFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+8, 15, kScreenWidth-12-45-10-100, 18) Text:nil TextColor:[UIColor whiteColor] font:[UIFont fontWithName:TextFontName size:16] textAlignment:NSTextAlignmentLeft];
        [self addSubview:nickNameLabel];
        
        
        
        
        personCountImage=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+8, CGRectGetMaxY(nickNameLabel.frame)+10, 15, 14)];
        personCountImage.userInteractionEnabled=YES;
        personCountImage.image=[UIImage imageNamed:@"viewer_ yellow"];
        [self addSubview:personCountImage];
        
        personCountLabel=[UILabel setLabelFrame:CGRectMake(CGRectGetMaxX(personCountImage.frame)+5, personCountImage.y, 60, 13) Text:@"1 ＞ " TextColor:[UIColor whiteColor] font:[UIFont fontWithName:TextFontName size:13] textAlignment:NSTextAlignmentLeft];
        [self addSubview:personCountLabel];
        
        UIButton * personCountButton=[[UIButton alloc]initWithFrame:CGRectMake(personCountImage.x, 0, CGRectGetMaxX(personCountLabel.frame)-personCountImage.x,CGRectGetMaxY(personCountImage.frame))];
        [self addSubview:personCountButton];
        [personCountButton addTarget:self action:@selector(clickpersonCountButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView * verLine=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(personCountLabel.frame), personCountLabel.y, 0.5, 14)];
        verLine.backgroundColor=[UIColor whiteColor];
//        [self addSubview:verLine];
        
        
        giftCountImage=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(verLine.frame)+10, verLine.y, 18, 14)];
        giftCountImage.image=[UIImage imageNamed:@"gift"];
        [self addSubview:giftCountImage];
        
        giftCountLabel=[UILabel setLabelFrame:CGRectMake(CGRectGetMaxX(giftCountImage.frame)+5, giftCountImage.y, kScreenWidth/2-60, 13) Text:@"0 ＞" TextColor:[UIColor whiteColor] font:[UIFont fontWithName:TextFontName size:13] textAlignment:NSTextAlignmentLeft];
        [self addSubview:giftCountLabel];
        
        
        UIButton * giftCountButton=[[UIButton alloc]initWithFrame:CGRectMake(giftCountImage.x, 0, giftCountImage.width+5+giftCountLabel.width, personCountButton.height)];
        [self addSubview:giftCountButton];
        
        [giftCountButton addTarget:self action:@selector(clickGiftCountButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        closeButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-60, 0, 60, 60)];
        [closeButton setImage:[UIImage imageNamed:@"btn_power_normal"] forState:UIControlStateNormal];
        [closeButton setImage:[UIImage imageNamed:@"btn_power_press"] forState:UIControlStateHighlighted];
        [closeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 18, 0, 12)];
        [self addSubview:closeButton];
        
        [closeButton addTarget:self action:@selector(closeLive) forControlEvents:UIControlEventTouchUpInside];
        
        
       
        
        
        
        
    }
    return self;

}

-(void)setLayerDisplay
{
    
    CALayer * layer=gradiedtView.layer;
    // Add Shine
    CAGradientLayer * shineLayer = [CAGradientLayer layer];
    shineLayer.frame = CGRectMake(0, 0, gradiedtView.width, gradiedtView.height);
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[[UIColor blackColor]colorWithAlphaComponent:0.3].CGColor,
                         (id)[[UIColor blackColor]colorWithAlphaComponent:0.0].CGColor,
                         nil];
    shineLayer.locations =  [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:0.0f],
                             [NSNumber numberWithFloat:1.0f],
                             nil];
    shineLayer.startPoint=CGPointMake(0, 0);
    shineLayer.endPoint=CGPointMake(0, 1);
    layer.mask=shineLayer;
}
//关闭直播
-(void)closeLive
{
    
    if ([self.liveDelegate respondsToSelector:@selector(closeLiveAction)]) {
        [self.liveDelegate closeLiveAction];
    }

    
}
-(void)refreshPersonCount:(long long)personCount
{

    if (!isAnimation) {
      
        isAnimation=YES;
        personCountImage.transform = CGAffineTransformMakeScale(5, 5);
        
        [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            personCountImage.transform = CGAffineTransformMakeScale(1, 1);
            
           
            
        } completion:^(BOOL finished) {
            
            isAnimation=NO;

        }];

    }
   
   
}
-(void)clickpersonCountButton
{
    if ([self.liveDelegate respondsToSelector:@selector(clickMemberCountButton)]) {
        [self.liveDelegate clickMemberCountButton];
    }

}
-(void)clickGiftCountButton
{

   

}
-(void)refreshGiftCount:(long long)giftCount
{

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
