//
//  HomeViewTableViewCell.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/20.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "HomeViewTableViewCell.h"

@interface HomeViewTableViewCell ()
{
    //直播标记
    UIImageView  * livingIcon;
    //直播封面
    UIImageView * liveCover;
    //用户头像
    UIImageView * headImageView;
    //昵称
    UILabel * nickNameLabel;
    //观看者人数icon
    UIImageView * lookerIcon;
    //观看者人数
    UILabel * lookerCountLabel;
    
    //直播主题
    UILabel * liveThemeLabel;
    
    //签约主播标志
    UIImageView * signAnchorIcon;
    
    
}
@end


@implementation HomeViewTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor whiteColor];
        
        liveCover=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
        liveCover.backgroundColor=[UIColor customColorWithString:@"eeeeee"];
        [self addSubview:liveCover];
        
        livingIcon=[[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 48, 18)];
        livingIcon.image=[UIImage imageNamed:@"label_live"];
        livingIcon.highlightedImage=[UIImage imageNamed:@"label_rest"];
        [self addSubview:livingIcon];
        
        
        UIView * infoView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(liveCover.frame), kScreenWidth, 70)];
        infoView.backgroundColor=[UIColor whiteColor];
        [self addSubview:infoView];
        
        
        headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 70/2-45/2, 45, 45)];
        headImageView.layer.masksToBounds=YES;
        headImageView.layer.cornerRadius=45/2;
        headImageView.backgroundColor=[UIColor customColorWithString:@"#eeeeee"];
        [infoView addSubview:headImageView];
        
        nickNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+10, 17, kScreenWidth-CGRectGetMaxX(headImageView.frame)-24-20-7-67, 20)];
        nickNameLabel.textColor=[UIColor customColorWithString:@"#0d0e0d"];
        nickNameLabel.font=[UIFont fontWithName:TextFontName size:15];
        [infoView addSubview:nickNameLabel];
        
        
        lookerIcon=[[UIImageView alloc]initWithFrame:CGRectMake(nickNameLabel.frame.origin.x, CGRectGetMaxY(nickNameLabel.frame)+8, 12, 11)];
        lookerIcon.image=[UIImage imageNamed:@"viewer"];
        [infoView addSubview:lookerIcon];
        
        lookerCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lookerIcon.frame)+5, lookerIcon.frame.origin.y-2, kScreenWidth/2-CGRectGetMaxX(lookerIcon.frame)-5, 15)];
        lookerCountLabel.textColor=[UIColor customColorWithString:@"#909290"];
        lookerCountLabel.font=[UIFont fontWithName:TextFontName size:12];
        [infoView addSubview:lookerCountLabel];
        
        
        liveThemeLabel=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-12-kScreenWidth/2, lookerCountLabel.frame.origin.y, kScreenWidth/2-12, 15)];
        liveThemeLabel.textColor=[UIColor customColorWithString:@"#e56e36"];
        liveThemeLabel.font=[UIFont fontWithName:TextFontName size:12];
        liveThemeLabel.textAlignment=NSTextAlignmentRight;
        [infoView addSubview:liveThemeLabel];
        
        signAnchorIcon=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nickNameLabel.frame)+7, 17, 67, 16)];
        signAnchorIcon.image=[UIImage imageNamed:@"label_medal"];
        [infoView addSubview:signAnchorIcon];
        signAnchorIcon.hidden=YES;
        
        
        
        
        
    }
    return self;
}
-(void)setInfoModel:(LiveInfoModel *)infoModel
{

    _infoModel=infoModel;
       if (infoModel.isRest) {
        livingIcon.highlighted=YES;
    }
    if (infoModel.headImageUrl.length==0) {
        
        headImageView.image=[UIImage imageNamed:@"head"];
    }
    
    
    if (infoModel.anchorType==YZTVAnchorTypeSigned) {
        

    CGFloat nickNameWidth=[UILabel getLabelWidthWithText:infoModel.nickName wordSize:15 height:20];
    if (nickNameWidth<nickNameLabel.width) {
        nickNameLabel.frame=CGRectMake(nickNameLabel.x, nickNameLabel.y, nickNameWidth, nickNameLabel.height);
    }
    signAnchorIcon.hidden=NO;
    signAnchorIcon.frame=CGRectMake(CGRectGetMaxX(nickNameLabel.frame)+7, signAnchorIcon.y, 67, 16);
        
        
    }else
    {
        signAnchorIcon.hidden=YES;
    }
    
    nickNameLabel.text=infoModel.nickName;
    liveThemeLabel.text=infoModel.liveTheme;
    lookerCountLabel.text=[NSString stringWithFormat:@"%lld",infoModel.lookerCount];
    
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.headImageUrl] placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
    }];
    
    
    [liveCover sd_setImageWithURL:[NSURL URLWithString:infoModel.liveCoverImageUrl] placeholderImage:nil];
    
    

}
-(void)beginZoomAnimation:(void (^)(BOOL))handler
{
    
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView animateWithDuration:0.3 animations:^{
        liveCover.transform=CGAffineTransformMakeScale(2, 2);
    } completion:^(BOOL finished) {
        
         liveCover.transform=CGAffineTransformMakeScale(1, 1);
          handler(finished);
    
    }];
    

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
