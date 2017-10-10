//
//  SharePageView.m
//  YiziTV
//
//  Created by 井泉 on 16/7/5.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "SharePageView.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>

@interface SharePageView()
{
    UIView *sharePageBaseView;
    
    UIButton *cancelButton;

    NSArray *shareItem;
    NSArray *shareItemImage;
    NSArray * shareTypeArr;

    UIButton *button;
}

@end

@implementation SharePageView

- (id)initFullScreen
{
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    if (self) {
     
        //判断是否安装微信
        BOOL isHand = [WXApi isWXAppInstalled];
        //判断是否安装QQ
        BOOL isQQHand=[QQApiInterface isQQInstalled];
        //分享的种类
        if (isHand&&isQQHand) {
            shareItem = @[@"微信", @"朋友圈", @"QQ", @"QQ空间", @"举报"];
            shareItemImage = @[@"share_weixin", @"share_pengyouquan", @"share_qq", @"share_qqkongjian", @"share_police"];
            shareTypeArr=@[[NSNumber numberWithInteger:YZShareWXType],[NSNumber numberWithInteger:YZShareWXFriendType],[NSNumber numberWithInteger:YZShareQQType],[NSNumber numberWithInteger:YZShareTypeQQZoneType],[NSNumber numberWithInteger:YZShareReportType]];
            
        }else if (isHand&&!isQQHand)
        {
            
            shareItem = @[@"微信", @"朋友圈", @"举报"];
            shareItemImage = @[@"share_weixin", @"share_pengyouquan", @"share_police"];

            shareTypeArr=@[[NSNumber numberWithInteger:YZShareWXType],[NSNumber numberWithInteger:YZShareWXFriendType],[NSNumber numberWithInteger:YZShareReportType]];
            
        }else if (!isHand&&isQQHand)
        {
        
            shareItem = @[@"QQ", @"QQ空间", @"举报"];
            shareItemImage = @[@"share_qq", @"share_qqkongjian", @"share_police"];
            shareTypeArr=@[[NSNumber numberWithInteger:YZShareQQType],[NSNumber numberWithInteger:YZShareTypeQQZoneType],[NSNumber numberWithInteger:YZShareReportType]];

        
        }else
        {
            shareItem = @[@"举报"];
            shareItemImage = @[ @"share_police"];
            shareTypeArr=@[[NSNumber numberWithInteger:YZShareReportType]];
        
        }
       
        [self setItem];
        
        [self showBase];

        
    }
       return self;
}

- (void)setItem
{
    self.backgroundColor = [UIColor colorWithWhite:0.01 alpha:0.5];
    
    if (iPhone4) {
        
    }
    
    CGRect rect = CGRectMake(0, 0, kScreenWidth, 366 / 2.0);
    sharePageBaseView = [[UIView alloc] initWithFrame:rect];
    sharePageBaseView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:sharePageBaseView];
    //Base的初始位置
    sharePageBaseView.center = CGPointMake(sharePageBaseView.center.x, self.size.height + sharePageBaseView.size.height / 2.0);
    
    //按钮
    NSInteger buttonSize;
    if (iPhone6plus) {
        buttonSize = 1.5;
    }
    else{
        buttonSize = 1;
    }
    
    NSLog(@"buttonSize:%ld", buttonSize);

    NSInteger padingSize = (NSInteger)(kScreenWidth - buttonSize / 2.0 * shareItem.count) / ((float)shareItem.count + 1);
    NSInteger offset = (kScreenWidth - 20) / (float)(shareItem.count) ;
    NSInteger posX = 10;

//    NSInteger 
    for (int i = 0; i < shareItem.count; i++)
    {
        NSLog(@"padingSize:%ld", padingSize);
        
        button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonSize * 100 / 2.0, buttonSize * 100 / 2.0)];
        [button setImage:[UIImage imageNamed:shareItemImage[i]] forState:UIControlStateNormal];
        
        UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(posX + offset * i, 30, offset, 146 * buttonSize / 2.0)];
        buttonView.backgroundColor = [UIColor clearColor];
        
        [buttonView addSubview:button];
        button.center = CGPointMake(buttonView.size.width / 2.0, button.size.height / 2.0);
        [button addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    
        button.tag = [[shareTypeArr objectAtIndex:i]integerValue];
        
        
        CGRect StrSize = [self getTextSizeWithSize:26 /2.0 font:TextFontName string:shareItem[i]];
        UILabel *itemName = [[UILabel alloc] initWithFrame:StrSize];
        itemName.text = shareItem[i];
        itemName.font = [UIFont fontWithName:TextFontName size:26.0 / 2];
        itemName.backgroundColor = [UIColor clearColor];
        itemName.center = CGPointMake(buttonView.size.width / 2.0, buttonView.size.height - itemName.size.height / 2.0);
        [buttonView addSubview:itemName];

        
        [sharePageBaseView addSubview:buttonView];
        
    }



    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, sharePageBaseView.size.height - 98 / 2.0, kScreenWidth, 98 / 2.0)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor customColorWithString:@"0d0e0d"] forState:UIControlStateNormal];
    cancelButton.titleLabel.font=[UIFont fontWithName:TextFontName size:18];
    [cancelButton addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [sharePageBaseView addSubview:cancelButton];
    
    //分割线
    CALayer *maskLayer = [[CALayer alloc]init];
    maskLayer.backgroundColor = [[UIColor customColorWithString:@"#d9d9d9"] CGColor];
    //大小
    maskLayer.bounds = CGRectMake(0, 0 ,self.size.width, 0.5);
    //墙上的位置
    maskLayer.position = CGPointMake(sharePageBaseView.center.x, sharePageBaseView.size.height - 98 / 2.0);
    
    [sharePageBaseView.layer addSublayer:maskLayer];
}
-(void)cancleButtonClick
{
    [self removeFromSuperview];
}
- (void)showBase
{
    [UIView transitionWithView:sharePageBaseView duration:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        sharePageBaseView.center = CGPointMake(sharePageBaseView.center.x, self.size.height - sharePageBaseView.size.height / 2.0);
    } completion:^(BOOL finished) {

    }];

}

- (void)shareClick:(UIButton*)button{
    
   
    if (self.shareType!=nil) {
        self.shareType((NSInteger)button.tag);
    }
    
    
}

- (CGRect)getTextSizeWithSize:(CGFloat)size font:(NSString*)font string:(NSString*)str
{
    //设置字体的大小
    UIFont *myFont = [UIFont fontWithName:font size:size];
    NSDictionary *dict = @{NSFontAttributeName:myFont};
    //设置文本能占用的最大宽高
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    
    CGRect rect =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    CGRect Result;
    if(rect.size.width > 80)
    {
        Result = CGRectMake(0, 0, 80, rect.size.height);
    }
    else{
        Result = rect;
    }
    
    return Result;
}

@end
