//
//  GiftButtonView.m
//  YiziTV
//
//  Created by 井泉 on 16/6/29.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "GiftButtonView.h"

@interface GiftButtonView ()
{
    UIImageView * giftImageView;
    UILabel * giftNameLabel;
    UILabel * giftPriceLabel;
    
    UIButton * selectButton;
    
}

@end

@implementation GiftButtonView
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        giftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.width/2-50/2, 10, 50, 50)];
        giftImageView.userInteractionEnabled=YES;
        
        [self addSubview:giftImageView];
        
        selectButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, giftImageView.width, giftImageView.height)];
        [selectButton setImage:[UIImage imageNamed:@"nothing"] forState:UIControlStateNormal];
        [selectButton setImage:[UIImage imageNamed:@"giftSelectedEdge"] forState:UIControlStateSelected];
        
        [giftImageView addSubview:selectButton];
        
        [selectButton addTarget:self action:@selector(clickSelectBtton) forControlEvents:UIControlEventTouchUpInside];
        
        
        giftNameLabel=[UILabel setLabelFrame:CGRectMake(0, CGRectGetMaxY(giftImageView.frame)+7, self.width, 13) Text:nil TextColor:[UIColor whiteColor] font:[UIFont fontWithName:TextFontName size:13] textAlignment:NSTextAlignmentCenter];
        [self addSubview:giftNameLabel];
        
        giftPriceLabel=[UILabel setLabelFrame:CGRectMake(0, CGRectGetMaxY(giftNameLabel.frame)+7, self.width, 10) Text:nil TextColor:[UIColor customColorWithString:@"909290"] font:[UIFont fontWithName:TextFontName size:10] textAlignment:NSTextAlignmentCenter];
        [self addSubview:giftPriceLabel];
        
        
        
        
        
    }
    return self;

}
-(void)clickSelectBtton
{
    selectButton.selected=!selectButton.selected;
    
    if (selectButton.selected) {
        //加入
        if ([self.delegate respondsToSelector:@selector(selectedGift:)]) {
            [self.delegate selectedGift:_giftModel];
        }
        
    }else
    {
        //减去
        if ([self.delegate respondsToSelector:@selector(removeGift:)]) {
            [self.delegate removeGift:_giftModel];
        }
        
    }

}
-(void)setGiftModel:(GiftInfoModel *)giftModel
{

    _giftModel=giftModel;
    [giftImageView sd_setImageWithURL:[NSURL URLWithString:giftModel.giftImageUrl] placeholderImage:nil];
    giftNameLabel.text=giftModel.giftname;
    giftPriceLabel.text=[NSString stringWithFormat:@"%@金币",giftModel.currentPrice];
    
}
-(void)setSelectButtonNomal
{
    selectButton.selected=NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
