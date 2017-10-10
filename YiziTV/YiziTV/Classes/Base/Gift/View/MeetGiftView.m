//
//  BaseGiftView.m
//  YiziTV
//
//  Created by 井泉 on 16/7/1.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "MeetGiftView.h"
#import "StrokeWordLable.h"

@interface MeetGiftView ()
{
    UILabel *nikenameLable;
    UILabel *sendLable;
    UIImageView *giftImageView;
    UIView *BGView;
    GiftInfoModel *presentInfo;
    StrokeWordLable *presentCountLable;
    StrokeWordLable *presentCountSigeLable;
    UIView *presentCountView;
    NSString *currentName;
    
    CGPoint BGViewOriginalPos;
    CGPoint BGViewTargetPos;

    CGPoint presentCountViewOriginalPos;
    CGPoint presentCountViewTargetPos;
    
}
@end

@implementation MeetGiftView

- (id)initWithPresent:(GiftInfoModel*)present
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.618, 114 / 2.0)];
    if (self) {
        presentInfo = [[GiftInfoModel alloc] init];
        presentInfo = present;
        
        self.backgroundColor = [UIColor clearColor];
        BGView = [[UIView alloc] initWithFrame:self.frame];
        [self addSubview:BGView];
        currentName = present.nickname;
    }
    
    [self createMisc];
    [self setGiftImageView];
    return self;
}

- (void)showPresent
{
    if(self.giftState == GiftStateprepare)
    {
        /*
         *从屏幕外飞入
         *
         */
        [UIView transitionWithView:BGView duration:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //从屏幕外飞入
            BGView.center = CGPointMake(self.frame.size.width / 2.0 + 38/2.0, BGView.center.y);
            
            [UIView animateWithDuration:0.1 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                //飞入到一半数字出现
                presentCountView.alpha = 1.0;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    
                    presentCountView.center = CGPointMake(CGRectGetMaxX(giftImageView.frame) + 20, presentCountView.center.y);
                    presentCountView.transform = CGAffineTransformMakeScale(0.5, 0.5);
                    
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        presentCountView.transform = CGAffineTransformMakeScale(0.8, 0.8);
                        presentCountView.center = CGPointMake(CGRectGetMaxX(giftImageView.frame) +20, presentCountView.center.y);
                    } completion:^(BOOL finished) {
                        [self removeSelfFromSuperView];
                    }];
                    
                }];
            }];
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)createMisc
{
    NSString *sendStr = @" 送了一个";
    CGRect sendStrSize = [self getTextSizeWithSize:28 /2.0 font:TextFontName string:sendStr];
    
    //        _nickname = @"nL5DPe";
    CGRect nicknameSize = [self getTextSizeWithSize:28 /2.0 font:TextFontName string:presentInfo.nickname];
    
    //送出去的文字
    nikenameLable = [[UILabel alloc] initWithFrame:nicknameSize];
    nikenameLable.font = [UIFont fontWithName:TextFontName size:28.0 / 2];
    nikenameLable.backgroundColor = [UIColor clearColor];
    nikenameLable.textColor = [UIColor customColorWithString:@"#ea8b5e"];
    nikenameLable.text = presentInfo.nickname;
    nikenameLable.center = CGPointMake(nikenameLable.frame.size.width / 2.0 + 10 / 2.0, self.frame.size.height/2.0);
    [BGView addSubview:nikenameLable];
    
    sendLable = [[UILabel alloc] initWithFrame:sendStrSize];
    sendLable.font = [UIFont fontWithName:TextFontName size:28.0 / 2];
    sendLable.backgroundColor = [UIColor clearColor];
    sendLable.textColor = [UIColor whiteColor];
    sendLable.text = sendStr;
    sendLable.center = CGPointMake(CGRectGetMaxX(nikenameLable.frame) + sendLable.frame.size.width / 2.0, self.frame.size.height/2.0);
    [BGView addSubview:sendLable];
}

- (void)setGiftImageView
{
    UIImage *presentImage = [UIImage imageNamed:@"nothing"];
    
    //礼物图
//    CGRect ret = CGRectMake(0, 0, presentImage.size.width, presentImage.size.height);
//    giftImageView = [[UIImageView alloc] initWithFrame:ret];
    giftImageView = [[UIImageView alloc] initWithImage:presentImage];
    giftImageView.center = CGPointMake(CGRectGetMaxX(sendLable.frame) + presentImage.size.width / 2.0 + 10, self.frame.size.height / 2.0);
    //    [giftImageView setContentMode:UIViewContentModeScaleAspectFit];
    //    giftImageView.frame = CGRectMake(0, 0, 50, 50);
    [giftImageView sd_setImageWithURL:[NSURL URLWithString:presentInfo.giftImageUrl] placeholderImage:nil];
    [BGView addSubview:giftImageView];
    
    //背景气泡
    CALayer *bubbleLayer = [[CALayer alloc]init];
    bubbleLayer.backgroundColor = [[UIColor colorWithWhite:0.1 alpha:0.75] CGColor];
    //大小
    bubbleLayer.bounds = CGRectMake(0, 0, CGRectGetMaxX(giftImageView.frame) - presentImage.size.width / 2.0, 30);
    //墙上的位置
    //        bubbleLayer.position = CGPointMake(phoneNumberView.frame.size.width / 2, phoneNumberView.frame.size.height / 2);
    bubbleLayer.position = CGPointMake(bubbleLayer.frame.size.width / 2.0 , self.frame.size.height/2.0);
    bubbleLayer.masksToBounds=YES;
    
    bubbleLayer.cornerRadius= 8;
    
    [BGView.layer insertSublayer:bubbleLayer atIndex:0];
    
    BGView.center = CGPointMake(-CGRectGetMaxX(giftImageView.frame), BGView.center.y);
    
    self.giftState = GiftStateprepare;

    /*
     *送出的礼物的数量
     */
    CGRect presentCountSigeLableRect = [self getTextSizeWithSize:44.0 font:TextFontName string:[NSString stringWithFormat:@"%ld", presentInfo.presentCount]];
    
    presentCountLable = [[StrokeWordLable alloc] initWithFrame:presentCountSigeLableRect];
    presentCountLable.font = [UIFont fontWithName:TextFontName size:44.0];
    presentCountLable.backgroundColor = [UIColor clearColor];
    presentCountLable.textColor = [UIColor customColorWithString:@"#ea8b5e"];
    presentCountLable.text = [NSString stringWithFormat:@"%ld", presentInfo.presentCount];
    
    
    CGRect presentCountLableRect = [self getTextSizeWithSize:44.0 / 1.5 font:TextFontName_Light string:@"x"];
    
    presentCountSigeLable = [[StrokeWordLable alloc] initWithFrame:presentCountLableRect];
    presentCountSigeLable.font = [UIFont fontWithName:TextFontName_Light size:44.0 / 1.5];
    presentCountSigeLable.backgroundColor = [UIColor clearColor];
    presentCountSigeLable.textColor = [UIColor customColorWithString:@"#ea8b5e"];
    presentCountSigeLable.text = @"x";
    presentCountSigeLable.center = CGPointMake(CGRectGetMaxX(presentCountLable.frame) + presentCountSigeLable.frame.size.width, presentCountSigeLable.center.y);
    
    presentCountView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BGView.size.height, BGView.size.height)];
    presentCountView.backgroundColor = [UIColor clearColor];
    [BGView addSubview:presentCountView];
    
    [presentCountView addSubview:presentCountLable];
    [presentCountView addSubview:presentCountSigeLable];
    
    //计算X号的中心高度
    presentCountSigeLable.center = CGPointMake(presentCountView.size.width/2.0 - presentCountLableRect.size.width/2.0, presentCountView.size.width/2.0);
    //计算数字的中心高度
    presentCountLable.center = CGPointMake(presentCountView.size.width/2.0 + presentCountSigeLableRect.size.width/2.0,
                                           CGRectGetMaxY(presentCountSigeLable.frame) - presentCountLableRect.size.height / 2.0 - 3);

    //设置礼物数量View的位置
    presentCountView.center = CGPointMake(CGRectGetMaxX(giftImageView.frame) / 2.0, BGView.size.height / 2.0);
    
    presentCountView.transform = CGAffineTransformMakeScale(1.3, 1.3);

    presentCountView.alpha = 0;
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

- (void)removeSelfFromSuperView
{
    __block int timeout = (int)presentInfo.duration; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.alpha = 0;
                } completion:^(BOOL finished) {
                    if ([self.delegate respondsToSelector:@selector(finished:)]) {
                        [self.delegate finished:self.showPosition];
                    }
                    [self removeFromSuperview];
                }];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
