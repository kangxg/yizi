//
//  CallingCardView.m
//  YiziTV
//
//  Created by 井泉 on 16/7/4.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "CallingCardView.h"
#import "LineDashView.h"

@interface CallingCardView ()
{
    UIImageView *headSculptureImageView;
    UILabel *nikenameLable;
    UILabel *jobTitleLable;
    LineDashView *line1;
}
@end

@implementation CallingCardView

- (id)initWithFrame:(CGRect)frame
{
    
   CGRect rect = CGRectMake(frame.origin.x, frame.origin.y, kScreenWidth * 0.618, 190 / 2);
    self = [super initWithFrame:rect];
    if (self) {
        self.userInteractionEnabled=YES;
        [self setElements];
    }
    
    
    return self;
}

- (void)setElements
{
    self.backgroundColor = [UIColor whiteColor];
    
    //设置边框
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0;
    self.layer.borderColor = [[UIColor customColorWithString:@"#ea8b5e"] CGColor];
    self.layer.borderWidth = 1.0;
    
    //lable:个人名片
   

    CGRect rect = CGRectMake(20 / 2, 20 / 2, self.width-20, 15);
    UILabel *personalCallingCardLable = [[UILabel alloc] initWithFrame:rect];
    personalCallingCardLable.text = @"个人名片";
    personalCallingCardLable.font = [UIFont fontWithName:TextFontName size:24.0 / 2];
    personalCallingCardLable.backgroundColor = [UIColor clearColor];
    personalCallingCardLable.textColor = [UIColor customColorWithString:@"#545554"];
    [self addSubview:personalCallingCardLable];
    
    // 虚线：线条宽度
    CGFloat lineHeight = 1;//c8c8c8
    // 线条1
    line1 = [[LineDashView alloc] initWithFrame:CGRectMake(10, 54 / 2, self.size.width - 20, lineHeight)
                                              lineDashPattern:@[@1, @2]
                                                    endOffset:0.499];
    line1.backgroundColor = [UIColor customColorWithString:@"c8c8c8"];
    [self addSubview:line1];
    
    headSculptureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, CGRectGetMaxY(line1.frame) + 10, 45, 45)];
    headSculptureImageView.backgroundColor = [UIColor grayColor];
    [self addSubview:headSculptureImageView];
    
    nikenameLable=[UILabel setLabelFrame:CGRectMake(CGRectGetMaxX(headSculptureImageView.frame)+11, CGRectGetMaxY(line1.frame)+15, self.width-CGRectGetMaxX(headSculptureImageView.frame)-11-10, 15) Text:nil TextColor:[UIColor customColorWithString:@"#ea8b5e"] font:[UIFont fontWithName:TextFontName size:30.0 / 2] textAlignment:NSTextAlignmentLeft];
    [self addSubview:nikenameLable];
    
    
    jobTitleLable=[UILabel setLabelFrame:CGRectMake(nikenameLable.x, CGRectGetMaxY(nikenameLable.frame)+6, nikenameLable.width, 15) Text:nil TextColor:[UIColor customColorWithString:@"0d0e0d"] font:[UIFont fontWithName:TextFontName size:13] textAlignment:NSTextAlignmentLeft];
    [self addSubview:jobTitleLable];
    
    
    
}

-(void)setCardInfoModel:(CardInfoModel *)cardInfoModel
{
    _cardInfoModel=cardInfoModel;
    nikenameLable.text=cardInfoModel.name;
    jobTitleLable.text=cardInfoModel.wantJobName;
    [headSculptureImageView sd_setImageWithURL:[NSURL URLWithString:cardInfoModel.headImageUrl] placeholderImage:nil];
}


@end
