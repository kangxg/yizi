//
//  LiveTVViewController.m
//  YiziTV
//
//  Created by 井泉 on 16/6/15.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "LiveTVViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SettingDeviceLimitView.h"
#import "LivePreviewView.h"
#import "AnchorChatSessionView.h"
#import "ChatSessionModel.h"
#import "ChatCellData.h"
#import "AnchorLiveTopView.h"
#import "LiveMediaCaptureManager.h"
#import "YZTVChatRoom.h"
#import "NIMSDK.h"
#import "ChatRoomManager.h"
#import "GiftShow.h"
#import "CallingCardView.h"
#import "ShowCardDetailViewController.h"
#import "CardInfoDetailView.h"
#import "SharePageView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "ChatRoomMemberListView.h"
#import "EnterRoomMessageStage.h"
#import "LiveBottomView.h"
#import "YZLocationManager.h"
#import "CallingVardViewController.h"
#import "FansContributionRankViewController.h"
#import "ShowCardViewManager.h"


@interface LiveTVViewController ()<LivePreviewViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,LiveTopViewActionDelegate,ChatRoomSessionDeleaget,ChatRoomMangeDelegate,UIAlertViewDelegate,LiveBottomViewDelegate>
{
    SettingDeviceLimitView * setDeviceLimitView;
    
    
    LivePreviewView * livePreview;
    
    AnchorChatSessionView  * sessionView;
    
    AnchorLiveTopView * liveTopView;
    
    NSString * pushUrl;
   
    //房间类
    YZTVChatRoom *yztvChatRoom;
    
    
     GiftShow *giftShow;
    
     CallingCardView * cardView;
    
     ChatRoomMemberListView * chatRoomMemberView;
    
     EnterRoomMessageStage *  enterRoomMessageStage;
    
      LiveBottomView * liveBottomView;
    
      ShowCardViewManager   * showCardManager;
}
@end

@implementation LiveTVViewController

#pragma mark 硬件权限
//应用程序需要事先申请音视频使用权限
- (void)requestMediaCapturerAccessWithCompletionHandler:(void (^)(YZDeviceErrorStatus status))handler {
    
    
    AVAuthorizationStatus videoAuthorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    AVAuthorizationStatus audioAuthorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
//    NSLog(@"----------%ld---------Video---%ld",audioAuthorStatus,videoAuthorStatus);
    
    if (AVAuthorizationStatusAuthorized == videoAuthorStatus && AVAuthorizationStatusAuthorized == audioAuthorStatus) {
        handler(AVDeviceNOErrorStatus);
        
    }else{
        
        //相机没开，麦克风开
        if ((AVAuthorizationStatusRestricted == videoAuthorStatus || AVAuthorizationStatusDenied == videoAuthorStatus)&&(AVAuthorizationStatusAuthorized == audioAuthorStatus)) {
           
            handler(VedioDeviceErrorStatus);
            
            return;
        }
        
        //麦克风没开，相机开
        else if ((AVAuthorizationStatusRestricted == audioAuthorStatus || AVAuthorizationStatusDenied == audioAuthorStatus)&&(AVAuthorizationStatusAuthorized == videoAuthorStatus)) {
            
            handler(AudioDeviceErrorStatus);
            
            return;
        }
        
        //相机麦克风都没开
       else if ((AVAuthorizationStatusRestricted == audioAuthorStatus || AVAuthorizationStatusDenied == audioAuthorStatus)&&(AVAuthorizationStatusRestricted == videoAuthorStatus || AVAuthorizationStatusDenied == videoAuthorStatus)) {
            
            handler(AVDeviceErrorStatus);
           
            return;
        }else
        {
            //未作出选择
        
        
            
          

        //请求相机
         [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
             
            if (granted) {
                //请求麦克风
                [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                    if (granted) {
                       
                        dispatch_async(dispatch_get_main_queue(), ^{
                         
                            handler(AVDeviceNOErrorStatus);

                        });

                        

                    }else{
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                           
                             handler(AudioDeviceErrorStatus);
                        });

                       
                        
                    }
                }];
                
                
                
              }else{
               
                  [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                      if (granted) {
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                            
                               handler(VedioDeviceErrorStatus );
                          });

                         
                          
                          
                      }else{
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                             
                               handler(AVDeviceErrorStatus);
                          });

                         
                          
                      }
                  }];

               
            }
        }];
            
     }
        
        
        
        
}
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[ChatRoomManager shareManager]removeChatManagerDelegate];
    [UIApplication sharedApplication].idleTimerDisabled=NO;//自动锁屏
    self.navigationController.navigationBarHidden=NO;
    if (sessionView) {
        [self removeKeyBoardNotice];
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[ChatRoomManager shareManager]addChatManagerDelegate];
    self.navigationController.navigationBarHidden=YES;
    [UIApplication sharedApplication].idleTimerDisabled=YES;//不自动锁屏
    
    if (sessionView) {
        [self addKeyBoardNotice];
    }
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
    
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=[UIColor clearColor];
    
    
    
    
    [self requestMediaCapturerAccessWithCompletionHandler:^(YZDeviceErrorStatus status) {
       
        switch (status) {
            case 0:
            {
                //都同意
                
                    UIView * localPreview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                    
                    [[LiveMediaCaptureManager shareInstance]createCapatureWithSuperView:self.view andpreView:localPreview];
                    
                    livePreview=[[LivePreviewView alloc]init];
                    livePreview.delegate=self;
                    [self.view addSubview:livePreview];
                

              
               
                
            }
                break;
            default:
            {
                
                    setDeviceLimitView=[[SettingDeviceLimitView alloc]init];
                    [setDeviceLimitView setButtonStatus:status];
                    [self.view addSubview:setDeviceLimitView];
                    __weak typeof(self)wself=self;
                    setDeviceLimitView.closeSettingDeviceLimitView=^{
                        
                        [wself backToLastController];
                        
                    };



                
            
            }
                break;
        }
        
    
        
        
    }];
   
    
    
    
}

#pragma mark LivePreview Delegate
-(void)closePreview
{
    [self backToLastController];
}
-(void)clickCoverImageView
{

    
    UIImagePickerController *picker_library = [[UIImagePickerController alloc] init];
    picker_library.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker_library.allowsEditing = YES;
    picker_library.delegate = self;
    
    [self presentViewController:picker_library animated:YES completion:nil];
    


}
-(void)clickBeginButtonWithThemeTitle:(NSString *)title
{
    
    WKProgressHUD * hud  = [WKProgressHUD showInView:self.navigationController.view withText:@"" animated:YES];

    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    
    NSString * locationCity=[[YZLocationManager shareManagerInstance]getLocationCityName];
    
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:title forKey:@"room_name"];
    if (locationCity.length) {
     [paramDic setValue:locationCity forKey:@"position_city"];
    }
    
    NSLog(@"推流给的参数=====%@",paramDic);
    
    [UrlRequest postRequestWithUrl:kBeginPushLiveUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        [hud dismiss:YES];
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            [livePreview removeFromSuperview];
            
//            NSLog(@"开始推流------%@",jsonDict);
            pushUrl=[jsonDict valueForKey:@"push_url"];
            yztvChatRoom =[[YZTVChatRoom alloc]init];
            long roomID=[[jsonDict valueForKey:@"chatroom_id"]longValue];
            yztvChatRoom.roomId=[NSString stringWithFormat:@"%ld",roomID];
            
            
           
            
            [self startPushLive];
            [self loginRoomAndCreateUI];
            
            
        }
        
    } fail:^(NSError *error) {
        
    }];
    
    
    
    
    
    
    
}
-(void)clickChangeCameraPositionACtion
{
    [self changeCameraPositionAction];
}
//开始推流
-(void)startPushLive
{

    
    [[LiveMediaCaptureManager shareInstance] startLiveStreamingWithLiveUrl:pushUrl];
    
    [LiveMediaCaptureManager shareInstance].liveErrorCallback=^(NSError* error){
    
        if (error.code==404) {
            
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:error.domain message:@"您的网络状况暂时不适合当网红，请稍后再试"  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag=404;
            [alert show];
        }
    
    };

    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==404) {
        
        [self closeLiveAction];
        
    }
}
//登录房间，渲染房间UI
-(void)loginRoomAndCreateUI
{

    [[UserManager shareInstaced]autoLoginYXSDK];
    
    NIMUser * yxuser=[[NIMSDK sharedSDK].userManager userInfo:[NIMSDK sharedSDK].loginManager.currentAccount];
    NIMChatroomEnterRequest * request=[[NIMChatroomEnterRequest alloc]init];
    request.roomId=yztvChatRoom.roomId;
    request.roomNickname=yxuser.userInfo.nickName;
    request.roomAvatar=yxuser.userInfo.avatarUrl;
//
    //扩展字段没暂时没加
    NSLog(@"+++++++++++登录房间请求----%@",request.roomId);

    if (sessionView==nil) {
        
        
        
        giftShow = [[GiftShow alloc] initWithView:self.view];
        
        if (enterRoomMessageStage==nil) {
            enterRoomMessageStage= [[EnterRoomMessageStage alloc] initWithView:self.view];
        }


        sessionView=[[AnchorChatSessionView alloc]initWithRoomID:yztvChatRoom.roomId];
        sessionView.delegate=self;
        [self.view addSubview:sessionView];
        
        [sessionView refreshUI];
        
        
        liveTopView=[[AnchorLiveTopView alloc]init];
        liveTopView.liveDelegate=self;
        [liveTopView showAnchorInfo];
        [self.view addSubview:liveTopView];
        
        
        liveBottomView=[[LiveBottomView alloc]init];
        liveBottomView.delegate=self;
        [self.view addSubview:liveBottomView];
        
        
        [self addKeyBoardNotice];
        
        
        
        
        
    }

    
    //登录房间
    [[[NIMSDK sharedSDK]chatroomManager]enterChatroom:request completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom, NIMChatroomMember * _Nullable me) {
        if (error==nil) {
            
            
            
   //接收消息
  [[ChatRoomManager shareManager]cacheMyInfo:me roomId:yztvChatRoom.roomId];
  [ChatRoomManager shareManager].delegate=self;
  [[ChatRoomManager shareManager]addChatManagerDelegate];
           
        
            
        
        
    }else
    {
        NSLog(@"登录房间错误----%@", error.description);
        
        
        [self loginRoomAndCreateUI];
        
        
    }
        
        
        
}];
}



#pragma mark LiveBottomViewDelegate 
-(void)clickLiveBottomViewChatButton
{
    [sessionView beginChatSession];

}
-(void)clickInputViewChangeCamera
{
    [self changeCameraPositionAction];

}
-(void)clickLiveBottomViewShareButton
{
    [self shareLiveAction];

}
-(void)clickLiveBottomViewCardButton
{

    CallingVardViewController * cardVC=[[CallingVardViewController alloc]init];
    cardVC.isComeFromLiveRoom=YES;
    [self.navigationController pushViewController:cardVC animated:NO];
    

}
#pragma mark  roomManager delegate 接收消息
-(void)receiveChatSessionMessage:(ChatSessionModel *)sessionModel
{

    ChatCellData  * cellData=[[ChatCellData alloc]initWoithSessionModel:sessionModel];
    
    [sessionView.sessionArray addObject:sessionModel];
    [sessionView.cellDataArray addObject:cellData];
    [sessionView refreshUI];


}
-(void)refreshRoomMember
{
    

    
    [[ChatRoomManager shareManager]getChatroomMemberCountInblock:^(NSInteger memberCount) {
        
        [liveTopView refreshPersonCount:memberCount];
        
        
    } RoomID:yztvChatRoom.roomId];
    
    
    [[ChatRoomManager shareManager]getChatroomMemberInblock:^(NSMutableArray *returnMembers) {
        
        [chatRoomMemberView refreshRoomMemberList:returnMembers];
        
    } RoomID:yztvChatRoom.roomId];

    
    
}
//收到礼物消息
-(void)receiveGiftMessage:(GiftInfoModel *)giftModel
{
    
         [giftShow setShowViewFrameY:sessionView.y];
         [giftShow addGift2QueueWithModel:giftModel];
         [giftShow play];

    
}
//收到名片消息
-(void)receiveCardInfoMeaage:(CardInfoModel *)cardInfoModel
{
  
    if (showCardManager==nil) {
        //初始化卡片显示view
     showCardManager=[[ShowCardViewManager alloc]initWithSuperView:self.view];

    }
    
   
    
    [showCardManager receiveCardInfo:cardInfoModel];
    
    
    __weak typeof(self)wself=self;
    
     ShowCardDetailViewController * detailController=[[ShowCardDetailViewController alloc]init];
    
    showCardManager.tapCardViewCallback=^(UIImageView*imageView){
    
       
        detailController.backImageView=imageView;
        [wself presentViewController:detailController animated:NO completion:nil];
        
        
        
    
    };
    
    showCardManager.closeCardDetailView=^{
    
        [detailController dismissViewControllerAnimated:NO completion:nil];
    };

    
}

//显示进入房间动画

-(void)showMemberEnterRoomMessage:(CardInfoModel *)cardInfoModel
{
        YZKeyboardType type= [sessionView getKeyboardType];
        if (type==YZAudienceKeyboardNomal)
        {
            
            enterRoomMessageStage.messageY =sessionView.y;
        }else
        {
            
            enterRoomMessageStage.messageY=kScreenHeight-(ChatGiftView_Height+kTabBarHeight);
            
        }
        
        [enterRoomMessageStage addOne2QueueWithModel:cardInfoModel];
        
        
//    });
    
    
}




-(void)refreAnchorReceiveGiftCount:(long)GiftCount
{
//    dispatch_async(dispatch_get_main_queue(), ^{
    [liveTopView refreshGiftCount:GiftCount];
         
//     });

}
#pragma mark end
#pragma mark chatroom message delegate
//发送消息
-(void)sendChatRoomMessage:(ChatSessionModel *)message
{
    [[ChatRoomManager shareManager] sendNomalTextMessageWithChatSessionModel:message roomId:yztvChatRoom.roomId];
    
    
}


-(void)changeCameraPositionAction
{
    [[LiveMediaCaptureManager shareInstance]changeCameraPosition];

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
    [paramDic setValue:user.uid forKey:@"anchor_id"];
    [paramDic setValue:[NSNumber numberWithInteger:YZShareAnchorType] forKey:@"type"];
    
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
    liveBottomView.hidden=NO;
    enterRoomMessageStage.messageY=kScreenHeight-(ChatGiftView_Height+kTabBarHeight);
    [UIView animateWithDuration:0.25 animations:^{
        
        liveTopView.frame=CGRectMake(0, 0, liveTopView.width, liveTopView.height);
        
        
    }];
    
    
     [chatRoomMemberView hiddenInView];
    
}
-(void)keyboardDidShow
{
    liveBottomView.hidden=YES;
     enterRoomMessageStage.messageY=sessionView.y;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        liveTopView.frame=CGRectMake(0, -liveTopView.height, liveTopView.width, liveTopView.height);
        
        
    }];
    
    
}

#pragma mark top delegate
-(void)closeLiveAction
{
    
      WKProgressHUD * hud  = [WKProgressHUD showInView:self.navigationController.view withText:@"" animated:YES];
    
    [[LiveMediaCaptureManager shareInstance]stopPushLiving:^(NSError * error) {
        
        
        if (error==nil) {
            
            
            NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
            UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
            [paramDic setValue:user.user_token forKey:@"user_token"];
            [paramDic setValue:user.deviceId forKey:@"deviceId"];
            [paramDic setValue:@"mcheck" forKey:@"mcheck"];
            [UrlRequest postRequestWithUrl:kStopPushLiveUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
                [hud dismiss:YES];
                int code=[[jsonDict valueForKey:@"code"]intValue];
                if (code==0) {
                    [self backToLastController];
                }
                
                
                
            } fail:^(NSError *error) {
                
            }];
            
            
            
          
            
            
        }
        
        else{
            
            
            //不能结束
        
        }
    }];
    
    
    
   

}

//点击观看人数
-(void)clickMemberCountButton
{
    
    if (chatRoomMemberView==nil) {
        
        chatRoomMemberView=[[ChatRoomMemberListView alloc]initWithRoomId:yztvChatRoom.roomId];
        [chatRoomMemberView setIsAnchorAction:YES];
        [self.view addSubview:chatRoomMemberView];
        [chatRoomMemberView showInView];
        
        enterRoomMessageStage.messageY=kScreenHeight-(ChatGiftView_Height+kTabBarHeight);

        [UIView animateWithDuration:0.25 animations:^{
            
            liveTopView.frame=CGRectMake(0, -liveTopView.height, liveTopView.width, liveTopView.height);
            
            
        }];

        
    }else
    {
        [chatRoomMemberView showInView];
        
        enterRoomMessageStage.messageY=sessionView.y;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            liveTopView.frame=CGRectMake(0, -liveTopView.height, liveTopView.width, liveTopView.height);
            
            
        }];
        
        
    }
    
    
    
}
//点击礼物
-(void)clickReceiveGiftCountButton:(NSString *)giftCount
{
    
    
    FansContributionRankViewController * fancVC=[[FansContributionRankViewController alloc]init];
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    fancVC.uid=user.uid;
    fancVC.receiveGiftCount=giftCount;
    [self.navigationController pushViewController:fancVC animated:NO];
    
    
    
    
}

-(void)dissmissChatMemberList
{
    
    [chatRoomMemberView hiddenInView];
    [self keyboardDidHiden];
}
#pragma  mark UIImagePickerViewdelegate----
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage * compressImage;
    [picker dismissViewControllerAnimated:NO completion:nil];
    if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
        UIImage * image=[info valueForKey:UIImagePickerControllerEditedImage];
        compressImage=[image imageByScalingAndCroppingForSize:CGSizeMake(kScreenWidth, kScreenWidth)];
        
    }
    else if(picker.sourceType==UIImagePickerControllerSourceTypePhotoLibrary)
    {
        UIImage * image=[info valueForKey:UIImagePickerControllerEditedImage];
        compressImage=[image imageByScalingAndCroppingForSize:CGSizeMake(kScreenWidth, kScreenWidth)];
        
    }
    
    NSData * imageData=[compressImage compressedDataSize:CoverImageSize];
    
    NSString * stringImage=[imageData base64EncodedStringWithOptions:0];
    
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:@"jpg" forKey:@"suffix"];
    [paramDic setValue:stringImage forKey:@"pop_pic"];
    
    [UrlRequest postRequestWithUrl:kEditMyCoverImageUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
    
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
        user.setLiveCoverImageUrl=[jsonDict valueForKey:@"pop_pic"];
        [livePreview changeCoverImageWithImageUrl:[jsonDict valueForKey:@"pop_pic"]];
        [[UserManager shareInstaced]setUserInfo:user];
            
            
            
        }
        
        
    } fail:^(NSError *error) {
        
    }];
    
    
    
    
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   
    if ([sessionView.inputView.inputView isFirstResponder]) {
        
        [self.view endEditing:YES];
        
    }
    
     [self dissmissChatMemberList];
    
}
-(void)backToLastController
{
    [[ChatRoomManager shareManager]removeChatManagerDelegate];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
