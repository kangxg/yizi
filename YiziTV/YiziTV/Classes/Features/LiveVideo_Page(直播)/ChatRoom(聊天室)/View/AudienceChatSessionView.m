//
//  AudienceChatSessionView.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/1.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "AudienceChatSessionView.h"
#import "AudienceInputView.h"
#import "ChatSessionModel.h"
#import "ChatCellData.h"
#import "NIMSDK.h"
#import "ShowMemberInfoView.h"

@interface AudienceChatSessionView ()<ChatInputDelegate,UITableViewDelegate,GiftKeyboardDelegate>
{
    AudienceInputView * _inputBarView;
    
    GiftKeyboardView * _giftKeyBoardView;
    
}
@end

@implementation AudienceChatSessionView
-(instancetype)initWithRoomID:(NSString *)roomId
{
    self=[super initWithRoomID:roomId];
    if (self) {
        
        _inputBarView=[[AudienceInputView alloc]initWithFrame:CGRectMake(0, ChatScreenHeight, kScreenWidth, kTabBarHeight)];
        _inputBarView.inputDelegate=self;
        [self addSubview:_inputBarView];
        
        _giftKeyBoardView=[[GiftKeyboardView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_inputBarView.frame), kScreenWidth, ChatGiftView_Height)];
        _giftKeyBoardView.delegate=self;
        [self addSubview:_giftKeyBoardView];
        
        
        
    }
    return self;
}


#pragma mark self Method
-(void)showNomalKeyBoardWithKeyBoardHeight:(CGFloat)keyBoardHeight
{
    [super showNomalKeyBoardWithKeyBoardHeight:keyBoardHeight];
    
    [self movieChatViewToLeft:NO];
    [self noticeKeyboardDidShow];
    _inputBarView.backgroundColor=[UIColor whiteColor];
    keyboardType=YZAudienceKeyboardNomal;
    [UIView animateWithDuration:0.20 animations:^{
    self.frame=CGRectMake(0,kScreenHeight-keyBoardHeight-ChatScreenHeight-kTabBarHeight, self.width, self.height);
  
    }];
    
    
}

-(void)hideNomalKeyBoard
{
    
    [super hideNomalKeyBoard];
    
    if (keyboardType==YZAudienceKeyboardGift) {
            
            self.frame=CGRectMake(0,kScreenHeight-ChatScreenHeight-kTabBarHeight-ChatGiftView_Height, self.width, self.height);
            _inputBarView.backgroundColor=[UIColor whiteColor];
            
    }else
        {

            
            [UIView animateWithDuration:0.25 animations:^{
                self.frame=CGRectMake(0, kScreenHeight-ChatScreenHeight-kTabBarHeight, kScreenWidth, self.height);
                
            }];
            
            _inputBarView.backgroundColor=[UIColor clearColor];
        }
        
    
}
-(void)refreshUI
{
    [super refreshUI];
}

#pragma mark textViewInput delegate
//点击名片
-(void)clickInputViewCardButton
{

    [self changeToAudienceKeyboardNull];
    keyboardType=YZAudienceKeyboardCard;
   
    
    if ([self.delegate respondsToSelector:@selector(sendMyCardInfo)]) {
        
        [self.delegate sendMyCardInfo];
    }

}




//消息
-(void)clickSendMessageButtonWithMessage:(NSString *)message
{
        
    ChatSessionModel * chatModel=[[ChatSessionModel alloc]init];
     chatModel.cardInfoModel=[[CardInfoModel alloc]init];
    NIMUser * yxuser=[[NIMSDK sharedSDK].userManager userInfo:[NIMSDK sharedSDK].loginManager.currentAccount];
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    chatModel.text=message;
    chatModel.yxID=yxuser.userId;
    chatModel.uid=user.uid;
    
    if (yxuser.userInfo.nickName.length) {
        
        chatModel.remoteExt=@{kNickNameKey:yxuser.userInfo.nickName,kMessageTypeKey:[NSNumber numberWithInt:ChatMessageTypeText],kUserIdKey:user.uid,kYXIDKey:yxuser.userId};
        chatModel.cardInfoModel.nickName=yxuser.userInfo.nickName;
    }
    else
    {
    
        chatModel.remoteExt=@{kNickNameKey:@"匿名者",kMessageTypeKey:[NSNumber numberWithInt:ChatMessageTypeText],kUserIdKey:user.uid,kYXIDKey:yxuser.userId};
        chatModel.cardInfoModel.nickName=@"匿名者";
    }

    
    chatModel.yztvMessageType=ChatMessageTypeText;
    
    ChatCellData * dataModel=[[ChatCellData alloc]initWoithSessionModel:chatModel];
    [self.cellDataArray addObject:dataModel];
    [self.sessionArray addObject:chatModel];
    
    
    if ([self.delegate respondsToSelector:@selector(sendChatRoomMessage:)]) {
        [self.delegate sendChatRoomMessage:chatModel];
    }
    
    [self refreshUI];

    
}
//点击礼物
-(void)clickInputViewGiftButton
{
    
    [self movieChatViewToLeft:YES];
    
    if (keyboardType==YZAudienceKeyboardNomal) {
         keyboardType=YZAudienceKeyboardGift;
        [_inputBarView.inputView resignFirstResponder];
        _inputBarView.backgroundColor=[UIColor whiteColor];
     }else
     {
      keyboardType=YZAudienceKeyboardGift;
        [self showMyViewToGiftKeyBoard];
        

     
     }
   

   

    

    
    
}


//点击分享
-(void)clickInputViewShareButton
{
    [self changeToAudienceKeyboardNull];
    
    keyboardType=YZAudienceKeyboardShare;
    
    if ([self.delegate respondsToSelector:@selector(shareLiveAction)]) {
        [self.delegate shareLiveAction];
    }
    
}


#pragma mark  textViewInput  end
//移动聊天界面
-(void)movieChatViewToLeft:(BOOL)isleft
{
    if (isleft) {
      
        [UIView animateWithDuration:0.25 animations:^{
            
            chatTableView.frame=CGRectMake(-chatTableView.width, chatTableView.y, chatTableView.width, chatTableView.height);
            
            
        }];
    }else
    
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            chatTableView.frame=CGRectMake(0, chatTableView.y, chatTableView.width, chatTableView.height);
            
            
        }];
    
    }
   
}

-(void)showMyViewToGiftKeyBoard
{
    [self noticeKeyboardDidShow];
    _inputBarView.backgroundColor=[UIColor whiteColor];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView animateWithDuration:0.25 animations:^{
        
         self.frame=CGRectMake(0, kScreenHeight-ChatScreenHeight-kTabBarHeight-ChatGiftView_Height, kScreenWidth, self.height);

    }];
   

}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
      [self changeToAudienceKeyboardNull];
    
    
    NSInteger index=self.sessionArray.count-1-indexPath.row;
    ChatSessionModel * sessinModel=[self.sessionArray objectAtIndex:index];
    
      if (sessinModel.uid.length&&sessinModel.yxID.length)
      {
    
    switch (sessinModel.yztvMessageType) {
      case ChatMessageTypeEnter:
        {
            
        }
            break;
        case ChatMessageTypeAddMute:
        {
            
        }break;
            
        case ChatMessageTypeRemoveMute:
        {
            
        }
            break;

            
        default:
        {

            
            ShowMemberInfoView * showInfoView=[[ShowMemberInfoView alloc]init];
            showInfoView.uid=sessinModel.uid;
            showInfoView.yxUid=sessinModel.yxID;
            showInfoView.isOpenSilentAction=NO;
            showInfoView.roomID=_roomID;
            [self.superview addSubview:showInfoView];
            [showInfoView createUI];
            

        
        }
            break;
    }
    

      }
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self changeToAudienceKeyboardNull];
    
}

-(void)changeToAudienceKeyboardNull
{
    switch (keyboardType) {
        case YZAudienceKeyboardNomal:
        {
            [_inputBarView.inputView resignFirstResponder];
            
        }
            break;
        case YZAudienceKeyboardGift:
        {
        
            [self hideMyGiftKeyBoard];
           
            
        }
            break;
            
        default:
            break;
    }
    
    
    keyboardType=YZAudienceKeyboardNull;

}
//隐藏礼物键盘
-(void)hideMyGiftKeyBoard
{
    
    [self movieChatViewToLeft:NO];
    [self noticeKeyboardDidHidden];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame=CGRectMake(0, kScreenHeight-ChatScreenHeight-kTabBarHeight, kScreenWidth, self.height);
        
    }];
    _inputBarView.backgroundColor=[UIColor clearColor];
    
}

-(void)refreshGiftListAndGoldCion
{
    
    [_giftKeyBoardView refreshGoldCoin];
    [_giftKeyBoardView refreshGift];
    
}

#pragma mark SendGift delegate
-(void)sendGiftsArray:(NSMutableArray *)giftArrary
{
    if ([self.delegate respondsToSelector:@selector(sendGiftActionWithGiftArr:)]) {
        [self.delegate sendGiftActionWithGiftArr:giftArrary];
    }
    
    
}

-(void)clickGoldCionWithMyCardInfo:(CardInfoModel *)myCardInfo
{
    if ([self.delegate respondsToSelector:@selector(clickAddGoldButtonWithMyCardInfo:)]) {
        [self.delegate clickAddGoldButtonWithMyCardInfo:myCardInfo];
    }

    
}


-(void)noticeKeyboardDidShow
{
    if ([self.delegate respondsToSelector:@selector(keyboardDidShow)]) {
        [self.delegate keyboardDidShow];
    }

}
-(void)noticeKeyboardDidHidden
{
    if ([self.delegate respondsToSelector:@selector(keyboardDidHiden)]) {
        [self.delegate keyboardDidHiden];
    }

}
-(YZKeyboardType)getKeyboardType
{
    return keyboardType;
}
-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
