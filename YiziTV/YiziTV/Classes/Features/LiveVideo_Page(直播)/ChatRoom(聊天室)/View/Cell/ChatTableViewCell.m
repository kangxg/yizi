//
//  ChatTableViewCell.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/30.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "ChatTableViewCell.h"

@interface ChatTableViewCell ()
{
    //气泡
    UIImageView * bubbleImageView;
    
    UILabel * contenLabel;
    
    UIImageView * giftImageView;
    
    CAGradientLayer *shineLayer;
    
}

@end

@implementation ChatTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor clearColor];
        
        bubbleImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 30)];
        bubbleImageView.userInteractionEnabled=YES;
        [self addSubview:bubbleImageView];
        
        contenLabel=[UILabel setLabelFrame:CGRectMake(12, 8, 10, 15) Text:nil TextColor:[UIColor whiteColor] font:[UIFont fontWithName:TextFontName size:14] textAlignment:NSTextAlignmentLeft];
        contenLabel.numberOfLines=0;
        [bubbleImageView addSubview:contenLabel];
        
        giftImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        giftImageView.userInteractionEnabled=YES;
        giftImageView.hidden=YES;
        [bubbleImageView addSubview:giftImageView];
        
        

    }
    
    return self;
    

}
-(void)setCellData:(ChatCellData *)cellData
{
    _cellData=cellData;

    
    bubbleImageView.frame=CGRectMake(18, 0, cellData.bubbleWidth, cellData.bubbleHeight);
    bubbleImageView.image=[UIImage imageNamed:cellData.bubbleImageName];
   

    switch (cellData.yztvMessageType) {
            
        case ChatMessageTypeGift:
        {
        
            giftImageView.hidden=NO;
            giftImageView.frame=CGRectMake(bubbleImageView.width-14-25,0, 25, 25);
            [giftImageView sd_setImageWithURL:[NSURL URLWithString:cellData.giftImageUrl] placeholderImage:nil];
            giftImageView.center=CGPointMake(bubbleImageView.width-14-25+25/2, bubbleImageView.height/2-3);
        }break;
            
        case ChatMessageTypeEnter:
        {
          giftImageView.hidden=YES;    
        
        }
        break;
            
        default:
        {
            giftImageView.hidden=YES;

        
        }
            break;
    }
    
    contenLabel.frame=CGRectMake(15, 6, cellData.contentWidth, cellData.contentHeight);
    contenLabel.numberOfLines=0;
    contenLabel.attributedText=cellData.contentString;
    [contenLabel sizeToFit];

    
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
