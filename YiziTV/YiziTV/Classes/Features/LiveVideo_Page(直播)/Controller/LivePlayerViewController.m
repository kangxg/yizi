//
//  LivePlayerViewController.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/20.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "LivePlayerViewController.h"
#import "AudienceChatSessionView.h"
#import "AudienceLiveTopView.h"
#import "NELivePlayer.h"
#import "NELivePlayerController.h"
#import "iToast.h"
#import "NIMSDK.h"
#import "ChatRoomManager.h"
#import "ChatCellData.h"
#import "SendMyCardView.h"
#import "EditMyCardInfoInLiveViewController.h"
#import "EditMyCardInfoViewController.h"
#import "GiftKeyboardView.h"
#import "GiftInfoModel.h"
#import "GiftShow.h"
#import "CallingCardView.h"
#import "MyGoldCoinViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "SharePageView.h"
#import "ChatRoomMemberListView.h"
#import "EnterRoomMessageStage.h"
#import "FansContributionRankViewController.h"
#import "ShowMemberInfoView.h"
@interface LivePlayerViewController ()<LiveTopViewActionDelegate,ChatRoomMangeDelegate,ChatRoomSessionDeleaget,SendMyCardViewDelegate,GiftKeyboardDelegate,UIAlertViewDelegate>
{
    AudienceChatSessionView * sessionView;
    
    AudienceLiveTopView * liveTopView;
    
    id<NELivePlayer>liveplayer;
    
    NSURL * playUrl;
    
    UIImageView * coverImageView;
    
    WKProgressHUD * hud;
    
    SendMyCardView * sendMyCardView;
    
    
     GiftShow * giftShow;
    
    CallingCardView * cardView;
    
    ChatRoomMemberListView * chatRoomMemberView;
    
    EnterRoomMessageStage *  enterRoomMessageStage;
    
    //结束直播的最后一帧
    UIImageView * lastView;
    
    
}
@end

@implementation LivePlayerViewController
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeKeyBoardNotice];
//    [[ChatRoomManager shareManager]removeChatManagerDelegate];
    self.navigationController.navigationBarHidden=NO;
    [UIApplication sharedApplication].idleTimerDisabled=NO;//自动锁屏
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addKeyBoardNotice];
//    [[ChatRoomManager shareManager]addChatManagerDelegate];
    self.navigationController.navigationBarHidden=YES;
    [UIApplication sharedApplication].idleTimerDisabled=YES;//不自动锁屏
}

-(void)addKeyBoardNotice
{

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)removeKeyBoardNotice
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    

    
    
}
-(void)showKeyboard:(NSNotification *)notic
{

    NSDictionary * userInfo=notic.userInfo;
    NSValue * value=[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect  keyboardsize=value.CGRectValue;
    CGFloat keyH=keyboardsize.size.height;
    
    [sessionView showNomalKeyBoardWithKeyBoardHeight:keyH];
    
    [self keyboardDidShow];

    
}

-(void)hiddenKeyboard:(NSNotification *)notic

{
    
    [sessionView hideNomalKeyBoard];
    
    [self keyboardDidHiden];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor blackColor];
    self.navigationController.navigationBarHidden=YES;
    
    [self beginLivePlay];
    
    [self initGitfView];
    
    [self loginRoomAndCreateUI];
    
    
    
   
}
#pragma mark 初始化礼物空间 
-(void)initGitfView
{
    
    
    if (giftShow==nil) {
        giftShow = [[GiftShow alloc] initWithView:self.view];
    }
    
    if (enterRoomMessageStage==nil) {
        enterRoomMessageStage= [[EnterRoomMessageStage alloc] initWithView:self.view];
    }
    
    
}
//登录房间，渲染房间UI
-(void)loginRoomAndCreateUI
{
     [[UserManager shareInstaced]autoLoginYXSDK];
    
    NIMUser * yxuser=[[NIMSDK sharedSDK].userManager userInfo:[NIMSDK sharedSDK].loginManager.currentAccount];
    NIMChatroomEnterRequest * request=[[NIMChatroomEnterRequest alloc]init];
    
    request.roomId=self.liveModel.roomID;
    
    request.roomNickname=yxuser.userInfo.nickName;
    request.roomAvatar=yxuser.userInfo.avatarUrl;
    //扩展字段
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    request.roomExt=user.uid;
    
    NSLog(@"+++++++++++登录房间请求----%@",request.roomId);
    
    
    
    if (sessionView==nil) {
        sessionView=[[AudienceChatSessionView alloc]initWithRoomID:self.liveModel.roomID];
        sessionView.delegate=self;
        [self.view addSubview:sessionView];
        
        liveTopView=[[AudienceLiveTopView alloc]init];
        liveTopView.liveDelegate=self;
        [liveTopView setLiveInfoModel:self.liveModel];
        
        [self.view addSubview:liveTopView];
        
    }
    

    
    //登录房间
    [[[NIMSDK sharedSDK]chatroomManager]enterChatroom:request completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom, NIMChatroomMember * _Nullable me) {
        if (error==nil) {
         
            
         
            
            
            
        //接收消息
    [[ChatRoomManager shareManager]cacheMyInfo:me roomId:self.liveModel.roomID];
    [ChatRoomManager shareManager].delegate=self;
           
    [[ChatRoomManager shareManager]addChatManagerDelegate];         

            

            
        }else
        {
            
            
            
        }
        
        
    }];
    
   
    
}

#pragma mark   接收消息 roomManager
-(void)receiveChatSessionMessage:(ChatSessionModel *)sessionModel
{
    NSLog(@" 接收聊天室消息 roomManager");
    
   
        
        NSLog(@"+++++渲染UI+++++++++                                            ");
        ChatCellData  * cellData=[[ChatCellData alloc]initWoithSessionModel:sessionModel];
        
        [sessionView.sessionArray addObject:sessionModel];
        [sessionView.cellDataArray addObject:cellData];
        [sessionView refreshUI];



}
-(void)refreshRoomMember
{

    
    [[ChatRoomManager shareManager]getChatroomMemberCountInblock:^(NSInteger memberCount) {
        
        [liveTopView refreshPersonCount:memberCount];
        
        
    } RoomID:self.liveModel.roomID];
    
    [[ChatRoomManager shareManager]getChatroomMemberInblock:^(NSMutableArray *returnMembers) {
        
        [chatRoomMemberView refreshRoomMemberList:returnMembers];
        
    } RoomID:self.liveModel.roomID];
    
    

}

-(void)receiveGiftMessage:(GiftInfoModel *)giftModel
{
    
   
        
     YZKeyboardType type= [sessionView getKeyboardType];
        if (type==YZAudienceKeyboardNomal)
            {
        
            [giftShow setShowViewFrameY:sessionView.y];
            }else
            {
            
          [giftShow setShowViewFrameY:kScreenHeight-(ChatGiftView_Height+kTabBarHeight)];
                
            }
    [giftShow addGift2QueueWithModel:giftModel];
    [giftShow play];
 
    

    
}
-(void)refreAnchorReceiveGiftCount:(long)GiftCount
{
    
        [liveTopView refreshGiftCount:GiftCount];
        
   
    
}
-(void)showMemberEnterRoomMessage:(CardInfoModel *)cardInfoModel
{
   
 YZKeyboardType type= [sessionView getKeyboardType];
        if (type==YZAudienceKeyboardNomal)
        {
            
            enterRoomMessageStage.messageY =sessionView.y;
        }else
        {
            
           enterRoomMessageStage.messageY = kScreenHeight-(ChatGiftView_Height+kTabBarHeight);
            
        }

        [enterRoomMessageStage addOne2QueueWithModel:cardInfoModel];
        
        

    
}
-(void)liveOverMessage
{
    
    [self showLiveOverView];

}
-(void)receiveCardInfoMeaage:(CardInfoModel *)cardInfoModel
{
  
    
    
}

#pragma mark end 发送Action
//发送消息
-(void)sendChatRoomMessage:(ChatSessionModel *)message
{
    
    [[ChatRoomManager shareManager] sendNomalTextMessageWithChatSessionModel:message roomId:self.liveModel.roomID];
    
}
-(void)sendMyCardInfo
{

    UIImageView * imageView=  [UIImageView blurImageWithView:self.view];
    sendMyCardView=[[SendMyCardView alloc]initWithBackImage:imageView];
    sendMyCardView.deleaget=self;;
    [self.view addSubview:sendMyCardView];

}
-(void)sendGiftActionWithGiftArr:(NSMutableArray *)giftArrary
{


    NSString * giftList=[giftArrary componentsJoinedByString:@"-"];
    
    WKProgressHUD * Gifthud  = [WKProgressHUD showInView:self.navigationController.view withText:@"" animated:YES];
    
    
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:self.liveModel.uid forKey:@"anchor_id"];
    [paramDic setValue:giftList forKey:@"goods_id_list"];
    
    [UrlRequest postRequestWithUrl:kBatchSendGiftUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        
        NSLog(@"++++++++++++++++++******%@",jsonDict);
        [Gifthud dismiss:YES];
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            
           
            [sessionView refreshGiftListAndGoldCion];
            
            
        }else
        {
            
            if (code==YZErrorCodeGoldShort||code==YZErrorOneCodeGoldShort) {
                
                
                UIAlertView * aler=[[UIAlertView alloc]initWithTitle:@"余额不足" message:@"当前余额不足，充值后才可以继续送礼，是否去充值" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [aler show];
                
            }
            
            
            
        }
        
        
        
    } fail:^(NSError *error) {
        
    }];
    
    
}
-(void)clickAddGoldButtonWithMyCardInfo:(CardInfoModel *)myCardInfo
{
    MyGoldCoinViewController * goldVC=[[MyGoldCoinViewController alloc]init];
    goldVC.infoModel=myCardInfo;
    [self.navigationController pushViewController:goldVC animated:YES];
}
#pragma mark alertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        MyGoldCoinViewController * goldVC=[[MyGoldCoinViewController alloc]init];
        goldVC.infoModel=sessionView.giftKeyBoardView.myCardInfo;
        [self.navigationController pushViewController:goldVC animated:YES];
    }
}
-(void)shareLiveAction
{

    SharePageView * shareView=[[SharePageView alloc]initFullScreen];
    [self.view addSubview:shareView];
    __weak  typeof(shareView)wself=shareView;
    shareView.shareType=^(YZSharePlatformType type)
    {
        
        [wself removeFromSuperview];
        
        SSDKPlatformType platformType;
        
        switch (type) {
            case YZShareWXType:
            {
                
                platformType=SSDKPlatformTypeWechat;
                [self requestShareWithWithType:platformType];
                
            }
                break;
            case YZShareWXFriendType:
            {
                
                platformType=SSDKPlatformSubTypeWechatTimeline;
                [self requestShareWithWithType:platformType];
                
            }break;
            case YZShareQQType:
            {
                platformType=SSDKPlatformTypeQQ;
                [self requestShareWithWithType:platformType];
            }break;
            case YZShareTypeQQZoneType:
            {
                platformType=SSDKPlatformSubTypeQZone;
                [self requestShareWithWithType:platformType];
                
                
            }break;
            case YZShareReportType:
            {
                
                UIAlertView * aler=[[UIAlertView alloc]initWithTitle:@"" message:@"已收到您的举报，我们将马上审核处理，非常感谢" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [aler show];
                
            }break;
                
            default:
                break;
        }
        
        
    };
    
    
    
}
-(void)requestShareWithWithType:(SSDKPlatformType)platformType
{
    
    
    WKProgressHUD * sharehud  = [WKProgressHUD showInView:self.view withText:@"" animated:YES];
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:[NSNumber numberWithInteger:YZShareAudienceType] forKey:@"type"];
    [paramDic setValue:self.liveModel.uid forKey:@"anchor_id"];
    
    [UrlRequest postRequestWithUrl:kShareUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        NSLog(@"分享返回===%@",jsonDict);
        [sharehud dismiss:YES];
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            
            NSString * content=[jsonDict valueForKey:@"share_desc"];
            NSString * imagePath=[[jsonDict valueForKey:@"share_photo"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString * url=[[jsonDict valueForKey:@"share_url"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString * titleText=[jsonDict valueForKey:@"share_title"];
            
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            NSArray* imageArray = @[imagePath];
            [shareParams SSDKSetupShareParamsByText:content
                                             images:imageArray
                                                url:[NSURL URLWithString:url]
                                              title:titleText
                                               type:SSDKContentTypeAuto];
            
            
            
            //            NSLog(@"分享++++++%@",type);
            
            [ShareSDK share:platformType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                
                switch (state) {
                        
                    case SSDKResponseStateBegin:
                    {
                        
                        break;
                    }
                    case SSDKResponseStateSuccess:
                    {
                        
                        
                        
                        break;
                    }
                    case SSDKResponseStateFail:
                    {
                        break;
                        
                    }
                    case SSDKResponseStateCancel:
                    {
                        
                        break;
                    }
                    default:
                        break;
                }
                
                
                
            }];
            
            
            
        }
        
    } fail:^(NSError *error) {
        
    }];
    
    
    
}

-(void)keyboardDidHiden
{
    
   
    enterRoomMessageStage.messageY=kScreenHeight-(ChatGiftView_Height+kTabBarHeight);
    [UIView animateWithDuration:0.25 animations:^{
      
        liveTopView.frame=CGRectMake(0, 0, liveTopView.width, liveTopView.height);
        
        
        
    }];

    
     [chatRoomMemberView hiddenInView];
    
}
-(void)keyboardDidShow
{

    enterRoomMessageStage.messageY=sessionView.y;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        liveTopView.frame=CGRectMake(0, -liveTopView.height, liveTopView.width, liveTopView.height);
        
        
    }];
    
   


}

#pragma mark end
-(void)editMyCardInfoWithCardInfoModel:(CardInfoModel *)cardInfoModel backgroundImage:(UIImageView *)backImageView
{
//    EditMyCardInfoInLiveViewController * editMycardInfoVC=[[EditMyCardInfoInLiveViewController alloc]init];
//    [self presentViewController:editMycardInfoVC animated:YES completion:nil];
//
    
    EditMyCardInfoViewController * editMycardInfoVC=[[EditMyCardInfoViewController alloc]init];
    editMycardInfoVC.cardModel=cardInfoModel;
    
    [self.navigationController pushViewController:editMycardInfoVC animated:YES];
    editMycardInfoVC.saveSuccess=^(CardInfoModel*InfoModel){
    
        [sendMyCardView refreshCardInfoView:InfoModel];
    
        
    };
    
    

}
-(void)senCardWithPayType:(YZTVPayType)payType CardInfo:(CardInfoModel *)cardInfoModel
{
    
    [sendMyCardView removeFromSuperview];
    
    if (payType==YZTVPayShareType) {
        
        
        WKProgressHUD * sharehud  = [WKProgressHUD showInView:self.view withText:@"" animated:YES];
        UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
        NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
        [paramDic setValue:user.user_token forKey:@"user_token"];
        [paramDic setValue:user.deviceId forKey:@"deviceId"];
        [paramDic setValue:@"mcheck" forKey:@"mcheck"];
        [paramDic setValue:[NSNumber numberWithInteger:YZShareCardType] forKey:@"type"];
        [paramDic setValue:self.liveModel.uid forKey:@"anchor_id"];
        
        [UrlRequest postRequestWithUrl:kShareUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
            NSLog(@"分享返回===%@",jsonDict);
            [sharehud dismiss:YES];
            int code=[[jsonDict valueForKey:@"code"]intValue];
            if (code==0) {
                
                
                NSString * content=[jsonDict valueForKey:@"share_desc"];
                NSString * imagePath=[[jsonDict valueForKey:@"share_photo"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString * url=[[jsonDict valueForKey:@"share_url"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString * titleText=[jsonDict valueForKey:@"share_title"];
                
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                NSArray* imageArray = @[imagePath];
                [shareParams SSDKSetupShareParamsByText:content
                                                 images:imageArray
                                                    url:[NSURL URLWithString:url]
                                                  title:titleText
                                                   type:SSDKContentTypeAuto];
                
                
                
                //            NSLog(@"分享++++++%@",type);
                
                [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                    
                    
                    [self senMyCardRequestCardInfo:cardInfoModel isFree:YES];

                    switch (state) {
                            
                        case SSDKResponseStateBegin:
                        {
                            
                            break;
                        }
                        case SSDKResponseStateSuccess:
                        {
                            
                            
                            
                            break;
                        }
                        case SSDKResponseStateFail:
                        {
                            break;
                            
                        }
                        case SSDKResponseStateCancel:
                        {
                            
                            break;
                        }
                        default:
                            break;
                    }
                    
                    
                    
                }];
                
                
                
            }
            
        } fail:^(NSError *error) {
            
        }];

    }
    else{
        
        [self senMyCardRequestCardInfo:cardInfoModel isFree:NO];
       
    }

}
-(void)senMyCardRequestCardInfo:(CardInfoModel *)cardInfoModel isFree:(BOOL)isfree
{

    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:cardInfoModel.ID forKey:@"business_card_id"];
    [paramDic setValue:self.liveModel.uid forKey:@"receive_user_id"];
    
    [paramDic setValue:self.liveModel.roomID forKey:@"chatroom_id"];
    [paramDic setValue:@"2" forKey:@"oemid"];
    [paramDic setValue:[NSNumber numberWithBool:isfree] forKey:@"is_free"];
    
  
    
    //少个分享字段++++++++++
    
    [UrlRequest postRequestWithUrl:kSenCardUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        
        NSLog(@"发名片++++++%@",jsonDict);
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
         
//            [[ChatRoomManager shareManager]senCardMessage:cardInfoModel roomId:self.liveModel.roomID];

            
        }else
        {
            if (code==YZErrorOneCodeGoldShort) {
                
                
                UIAlertView * aler=[[UIAlertView alloc]initWithTitle:@"余额不足" message:@"当前余额不足，充值后才可以继续送礼，是否去充值" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [aler show];
                
            }

        }
        
        
    } fail:^(NSError *error) {
        
    }];
    
    
    
   
}
#pragma mark---- 监听视频--------
-(void)regiserVideoPlayerNotice
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NELivePlayerDidPreparedToPlay:)
                                                 name:NELivePlayerDidPreparedToPlayNotification
                                               object:liveplayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(NeLivePlayerloadStateChanged:)
                                                 name:NELivePlayerLoadStateChangedNotification
                                               object:liveplayer];
    
    //播放器第一针显示的时候的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(NELivePlayerFirstVideoDisplayed:) name:NELivePlayerFirstVideoDisplayedNotification object:liveplayer];
    
    //播放器资源释放完成通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(NELivePlayerReleaseSueecss:) name:NELivePlayerReleaseSueecssNotification object:liveplayer];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(NELivePlayerPlayBackFinished:) name:NELivePlayerPlaybackFinishedNotification object:liveplayer];
    
    
    
}
//初始化视频完成后
- (void)NELivePlayerDidPreparedToPlay:(NSNotification*)notification
{
    //add some methods
    [liveplayer play]; //开始播放
    
    
    
}
//播放器加载状态发生改变时的消息通知
- (void)NeLivePlayerloadStateChanged:(NSNotification*)notification
{
    NELPMovieLoadState nelpLoadState = liveplayer.loadState;
    
    if (nelpLoadState == NELPMovieLoadStatePlaythroughOK)
    {
        NSLog(@"finish buffering");
        
    }
    else if (nelpLoadState == NELPMovieLoadStateStalled)
    {
        NSLog(@"begin buffering");
        
        
    }
    
}
//播放器第一帧视频显示时的消息通知
-(void)NELivePlayerFirstVideoDisplayed:(NSNotification*)notification
{

    [coverImageView removeFromSuperview];
    
}
//播放器资源释放完成时的消息通知
-(void)NELivePlayerReleaseSueecss:(NSNotification*)notification
{
    NSLog(@"NELivePlayerReleaseSueecss");
    
}

//播放器播放完成或播放发生错误时的消息通知
- (void)NELivePlayerPlayBackFinished:(NSNotification*)notification
{
    switch ([[[notification userInfo] valueForKey:NELivePlayerPlaybackDidFinishReasonUserInfoKey] intValue])
    {
            
            
            
        case NELPMovieFinishReasonPlaybackEnded:
        {
            NSLog(@"推流结束 NELPMovieFinishReasonPlaybackEnded");
            [self showLiveOverView];
           
        }
            break;
            
            
        case NELPMovieFinishReasonPlaybackError:
            //@"播放失败"   需要提示
            
        {
            
            [hud dismiss:YES];
            [coverImageView removeFromSuperview];
            [self showLiveOverView];

            
            
        }
            break;
            
        case NELPMovieFinishReasonUserExited:
        {
            
            NSLog(@"NELPMovieFinishReasonUserExited");
            
        }
            
            break;
        default:break;
            
            
            
            
    }
    

    
}
-(void)removeVideoPlayerNotice
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerDidPreparedToPlayNotification object:liveplayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerLoadStateChangedNotification object:liveplayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerFirstVideoDisplayedNotification object:liveplayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerReleaseSueecssNotification object:liveplayer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NELivePlayerPlaybackFinishedNotification object:liveplayer];
    
}

#pragma mark end

-(void)beginLivePlay
{
    
    
    if (coverImageView==nil) {
        coverImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        coverImageView.contentMode=UIViewContentModeScaleAspectFill;
        [coverImageView sd_setImageWithURL:[NSURL URLWithString:self.liveModel.liveCoverImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }
         ];
        [self.view addSubview:coverImageView];
        
    }
    

    playUrl=[NSURL URLWithString:self.liveModel.playUrl];
    NSLog(@"拉流地址------%@",self.liveModel.playUrl);
    
    liveplayer= [[NELivePlayerController alloc] initWithContentURL:playUrl];
    
    if (liveplayer==nil) {
        
        NSLog(@"+++++++++++++r=try  again  +++++++++++++");
        [self beginLivePlay];
        
        return;
    }

    
    liveplayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    liveplayer.view.frame = CGRectMake(0, 0,kScreenWidth , kScreenHeight);
    [liveplayer setScalingMode:NELPMovieScalingModeAspectFill];
    [self.view addSubview:liveplayer.view];
    
    
    
    [liveplayer setBufferStrategy:NELPLowDelay];//!< 网络直播低延时，适用于视频直播，延时低
    [liveplayer setShouldAutoplay:YES]; //设置prepareToPlay完成后是否自动播放
    if (IOS8_OR_LATER) {
        [liveplayer setHardwareDecoder:YES]; //设置解码模式，是否开启硬件解码
    }else
    {
        [liveplayer setHardwareDecoder:NO]; //设置解码模式，是否开启硬件解码
    }
    
    [liveplayer setPauseInBackground:NO]; //设置切入后台时的状态，暂停还是继续播放
    [liveplayer prepareToPlay]; //初始化视频文件
    
    NSString *  version= [liveplayer getSDKVersion];
    
    NSLog(@"-------version----------%@",version);
    
    [self regiserVideoPlayerNotice];

    
}

#pragma mark 结束播放
-(void)stopPlayLive
{
    
    
   

}
-(void)showLiveOverView
{
    
    if (sendMyCardView) {
        [sendMyCardView removeFromSuperview];
    }
    
    [self keyboardDidHiden];
    
    [self removeVideoPlayerNotice];
    
    [self.view endEditing:YES];
    
   
    

    if (lastView==nil) {
        
    UIImage * lastImage=[liveplayer getSnapshot];
    
    
    lastView=[[UIImageView alloc]initWithImage:lastImage];
    lastView.frame=CGRectMake(0, 60, kScreenWidth, kScreenHeight-60-kTabBarHeight);
    lastView.userInteractionEnabled=YES;
    [self.view addSubview:lastView];    
    
    UILabel * contentLabel=[UILabel setLabelFrame:CGRectMake(40, lastView.size.height/2-35/2, kScreenWidth-80, 35) Text:@"主播已结束直播，等待下次吧" TextColor: [UIColor whiteColor] font:[UIFont fontWithName:TextFontName size:16] textAlignment:NSTextAlignmentCenter];
    contentLabel.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.4];
    [lastView addSubview:contentLabel];
    
     [self releasePlayer];
        
    }

}
-(void)releasePlayer
{
    
    [liveplayer stop];
    [liveplayer shutdown]; //退出播放并释放相关资源
    liveplayer=nil;
    //退出房间
    [[ChatRoomManager shareManager]exitChatRoomWithRoomId:self.liveModel.roomID];
    

}

#pragma mark 头部 topViewdelegate
-(void)closeLiveAction
{

     [[ChatRoomManager shareManager]removeChatManagerDelegate];
    
    [self releasePlayer];
    if (chatRoomMemberView) {
        [chatRoomMemberView removeFromSuperview];
    }

    [self.navigationController popViewControllerAnimated:NO];
    
}
//点击观看人数
-(void)clickMemberCountButton
{
    
    if (chatRoomMemberView==nil) {
      
        chatRoomMemberView=[[ChatRoomMemberListView alloc]initWithRoomId:self.liveModel.roomID];
        [chatRoomMemberView setIsAnchorAction:NO];
        [self.view addSubview:chatRoomMemberView];
        [chatRoomMemberView showInView];
        
        [self keyboardDidShow];
        
    }else
    {
        [chatRoomMemberView showInView];
        [self keyboardDidShow];

    
    }
    
   
   
}
//点击礼物
-(void)clickReceiveGiftCountButton:(NSString *)giftCount
{

    
    FansContributionRankViewController * fancVC=[[FansContributionRankViewController alloc]init];
    fancVC.uid=self.liveModel.uid;
    fancVC.receiveGiftCount=giftCount;
    [self.navigationController pushViewController:fancVC animated:NO];
    
    
    

}
-(void)dissmissChatMemberList
{

     [chatRoomMemberView hiddenInView];
      [self keyboardDidHiden];
}
//点击主播头像
-(void)clickHeadImageViewAction:(UIImageView*)headImageView
{

    if (self.liveModel.uid.length) {
        
    
    UIImageView * newheadImageView=[[UIImageView alloc]initWithFrame:headImageView.bounds];
    
    newheadImageView.center = [[headImageView superview] convertPoint:headImageView.center toView:[[[UIApplication sharedApplication] delegate] window]];
    [newheadImageView sd_setImageWithURL:[NSURL URLWithString:self.liveModel.headImageUrl] placeholderImage:nil];
    
    ShowMemberInfoView * showINfoVC=[[ShowMemberInfoView alloc]init];
    showINfoVC.headImageView=newheadImageView;
    showINfoVC.uid=self.liveModel.uid;
    showINfoVC.roomID=self.liveModel.roomID;
    [self.view addSubview:showINfoVC];
    [showINfoVC createUI];
    }
}
#pragma mark end
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([sessionView.inputView.inputView isFirstResponder]) {
        
        [self.view endEditing:YES];
        
    }
   
    [self dissmissChatMemberList];
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
