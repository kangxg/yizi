//
//  GiftTestViewController.m
//  YiziTV
//
//  Created by 井泉 on 16/7/1.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "GiftTestViewController.h"
#import "GiftInfoModel.h"
#import "CallingCardView.h"
#import "SharePageView.h"
#import "EnterRoomMessageView.h"
#import "EnterRoomMessageStage.h"
@interface GiftTestViewController ()
{
    GiftShow *giftShow;
    GiftInfoModel *presentInfo;
    NSInteger count;
    CallingCardView *callingCardView;
    SharePageView *sharePage;
    EnterRoomMessageView *enterRoom;
    EnterRoomMessageStage *enterRoomMessageStage;
}

@end

@implementation GiftTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    UIView *myView;
    UIView *myView1;

    UIButton *iconButton;
    NSString *str;
    
    myView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 750, 35 + 50)];
    myView1.backgroundColor = [UIColor blueColor];

    for (int i = 0; i < 10; i++) {
        switch (i) {
            case 0:
                str = @"send-card_press";
                break;
            case 1:
                str = @"btn_close_normal";
                break;
            case 2:
                str = @"send_gift_normal";
                break;
            case 3:
                str = @"head";
                break;
            case 4:
                str = @"send_gift_press";
                break;
            case 5:
                str = @"log in_qq";
                break;
            case 6:
                str = @"logo";
                break;
            case 7:
                str = @"share_weixin";
                break;
            default:
                break;
        }
        
        myView = [[UIView alloc] initWithFrame:CGRectMake(i * 50 + 4.5, 20, 35 + 30 / 2.0, 35 + 24)];
        
        myView.backgroundColor = [UIColor colorWithWhite:i/7.0 alpha:1];
        
        iconButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        [iconButton setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
        iconButton.center = CGPointMake(myView.size.width / 2.0, myView.size.height / 2.0);
        [iconButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        iconButton.tag = 100 + i;
        [myView addSubview:iconButton];
        [myView1 addSubview:myView];

    }

    [self.view addSubview:myView1];
//    myView1.center = CGPointMake(myView1.center.x, 300);

    [self enterRoom];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
//    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"414_736_0"]];
//    [self.view addSubview:bg];
//    
//    count = 0;
//    giftShow = [[GiftShow alloc] initWithView:self.view];
//    
//    presentInfo = [[GiftInfoModel alloc] init];
//    presentInfo.giftname = @"red-heart";
//    presentInfo.nickname = @"井泉呵呵哒浪你个浪";
//    presentInfo.duration = 1;
//    
//    
////    [giftShow addGift2QueueWithModel:presentInfo];
//    count++;
//    presentInfo = [[GiftInfoModel alloc] init];
//    presentInfo.giftname = @"red-heart";
//    presentInfo.nickname = [NSString stringWithFormat:@"井泉%d", (int)count];
//    presentInfo.duration = 1;
//    
//    
////    [giftShow addGift2QueueWithModel:presentInfo];
//    count++;
//    presentInfo = [[GiftInfoModel alloc] init];
//    presentInfo.giftname = @"red-heart";
//    presentInfo.nickname = [NSString stringWithFormat:@"井泉%d", (int)count];
//    presentInfo.duration = 1;
//    
//    
////    [giftShow addGift2QueueWithModel:presentInfo];
//    count++;
//    presentInfo = [[GiftInfoModel alloc] init];
//    presentInfo.giftname = @"red-heart";
//    presentInfo.nickname = [NSString stringWithFormat:@"井泉%d", (int)count];
//    presentInfo.duration = 1;
//    
//    
//    [giftShow addGift2QueueWithModel:presentInfo];
//    count++;
//    
//    UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight - 80, kScreenWidth, 80)];
//    bt.titleLabel.text = @"送礼";
//    bt.backgroundColor = [UIColor grayColor];
//    [bt addTarget:self action:@selector(sendGift) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:bt];
//    
//    callingCardView = [[CallingCardView alloc] initWithFrame:CGRectMake(36/2, 100, 0, 0)];
//
//    [self.view addSubview:callingCardView];
//    
//    sharePage = [[SharePageView alloc] initFullScreen];
//    [self.view addSubview:sharePage];
}

- (void)click:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"clickTag:%ld", button.tag);
    NSLog(@"clickImage:%@", button.imageView.image);
    NSLog(@"center:%@", NSStringFromCGPoint([button convertPoint:button.center toView:self.view]));
    NSLog(@"center:%@", [button superview]);

    UIView *myview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    myview.center = [[button superview] convertPoint:button.center toView:[[[UIApplication sharedApplication] delegate] window]];
    myview.backgroundColor = [UIColor redColor];
    
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, button.size.width, button.size.height)];
    iconView.center = [[button superview] convertPoint:button.center toView:[[[UIApplication sharedApplication] delegate] window]];
    [iconView setImage:button.imageView.image];
    [self.view addSubview:myview];
    iconView.layer.cornerRadius = iconView.size.height / 2.0f;
    iconView.layer.borderWidth = 1.0f;
    iconView.layer.borderColor = [UIColor customColorWithString:@"#fffff"].CGColor;

    
    UIView *BgView = [[UIView alloc] initWithFrame:CGRectMake(50, 200 , kScreenWidth - 100, 0)];
    BgView.layer.masksToBounds=YES;
    BgView.layer.cornerRadius = 10.0f;
    BgView.layer.borderWidth = 2.0f;
    BgView.layer.borderColor = [UIColor customColorWithString:@"#ffd200"].CGColor;
    [self.view addSubview:BgView];
    [self.view addSubview:iconView];

    BgView.backgroundColor = [UIColor blueColor];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        iconView.center = CGPointMake(kScreenWidth / 2.0, 200);
        iconView.transform = CGAffineTransformMakeScale(2, 2);
    } completion:^(BOOL finished) {
        iconView.layer.masksToBounds=YES;

        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            BgView.frame = CGRectMake(50, 200 , kScreenWidth - 100, 300);
        } completion:^(BOOL finished) {
            
        }];
    }];

}

- (void)enterRoom
{
//    enterRoom = [[EnterRoomMessageView alloc] initFormName:@"1小YY2小YY3小YY4小YY5小YY" headIcon:[UIImage imageNamed:@"share_pengyouquan"]];
//    [self.view addSubview:enterRoom];
//    enterRoom.center = CGPointMake(kScreenWidth / 2.0, kScreenHeight /2.0);
    

    
//    enterRoomMessageStage = [[EnterRoomMessageStage alloc] initWithView:self.view];
//    for (int i=0; i<25; i++) {
//
//        presentInfo = [[GiftInfoModel alloc] init];
//        presentInfo.giftname = @"red-heart";
//        presentInfo.nickname = [NSString stringWithFormat:@"井泉呵呵%d", i];
//        presentInfo.duration = 1;
//        [enterRoomMessageStage addOne2QueueWithModel:presentInfo];
//    }
//    
//    enterRoomMessageStage.messageY = 200;
}

- (void)sendGift
{
    presentInfo = [[GiftInfoModel alloc] init];
    presentInfo.giftname = @"red-heart";
    presentInfo.nickname = [NSString stringWithFormat:@"井泉%d", (int)count];
    presentInfo.duration = 1;
    presentInfo.presentCount = 10;

    count++;
    [giftShow addGift2QueueWithModel:presentInfo];
    [giftShow play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
