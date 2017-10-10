  //
//  AnchorChatSessionView.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/1.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "AnchorChatSessionView.h"
#import "AnchorInputeView.h"
#import "ChatSessionModel.h"
#import "ChatCellData.h"
#import "NIMSDK.h"
#import "ShowMemberInfoView.h"

@interface AnchorChatSessionView ()<ChatInputDelegate,UITableViewDelegate>
{
    AnchorInputeView * _inputBarView;
}
@end

@implementation AnchorChatSessionView

-(instancetype)initWithRoomID:(NSString *)roomId

{
    self=[super initWithRoomID:roomId];
    if (self) {
        
        _inputBarView=[[AnchorInputeView alloc]initWithFrame:CGRectMake(0, ChatScreenHeight, kScreenWidth, kTabBarHeight)];
        _inputBarView.inputDelegate=self;
        [self addSubview:_inputBarView];
        _inputBarView.hidden=YES;
    }
    return self;
}


-(void)showNomalKeyBoardWithKeyBoardHeight:(CGFloat)keyBoardHeight
{
    
    [super showNomalKeyBoardWithKeyBoardHeight:keyBoardHeight];
    keyboardType=YZAudienceKeyboardNomal;
    [UIView animateWithDuration:0.25 animations:^{
      
        _inputBarView.backgroundColor=[UIColor whiteColor];
        self.frame=CGRectMake(0,kScreenHeight-keyBoardHeight-kTabBarHeight-ChatScreenHeight, self.width, self.height);
        _inputBarView.hidden=NO;
        

    }];
    
}
-(void)hideNomalKeyBoard
{
    [super hideNomalKeyBoard];
    
    [UIView animateWithDuration:0.25 animations:^{
       
        self.frame=CGRectMake(0, kScreenHeight-ChatScreenHeight-kTabBarHeight, kScreenWidth, self.height);
        _inputBarView.backgroundColor=[UIColor clearColor];
        _inputBarView.hidden=YES;

    }];
    
}

-(void)beginChatSession
{
    [_inputBarView.inputView becomeFirstResponder];
}
#pragma mark textViewInput delegate

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
        
        chatModel.remoteExt=@{kNickNameKey:@"匿名者",kMessageTypeKey:[NSNumber numberWithInt:ChatMessageTypeText],kUserIdKey:user.uid,kYXIDKey:yxuser.userId,kYXIDKey:yxuser.userId};
        chatModel.cardInfoModel.nickName=@"匿名者";
    }
    
    
    
    
    chatModel.yztvMessageType=ChatMessageTypeText;
    
    ChatCellData * dataModel=[[ChatCellData alloc]initWoithSessionModel:chatModel];
    [self.cellDataArray addObject:dataModel];
    [self.sessionArray addObject:chatModel];
    
    [self refreshUI];
    
    if ([self.delegate respondsToSelector:@selector(sendChatRoomMessage:)]) {
        [self.delegate sendChatRoomMessage:chatModel];
    }


}
//
//-(void)clickInputViewChangeCamera
//{
//
//    if ([self.delegate respondsToSelector:@selector(changeCameraPositionAction)]) {
//        [self.delegate changeCameraPositionAction];
//    }
//}
//-(void)clickInputViewShareButton
//{
//    if (keyboardType==YZAudienceKeyboardNomal) {
//        
//      [_inputBarView.inputView resignFirstResponder];
//    }
//    keyboardType=YZAudienceKeyboardShare;
//    if ([self.delegate respondsToSelector:@selector(shareLiveAction)]) {
//        [self.delegate shareLiveAction];
//    }
//    
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   [_inputBarView.inputView resignFirstResponder];
    
     NSInteger index=self.sessionArray.count-1-indexPath.row;
    ChatSessionModel * sessinModel=[self.sessionArray objectAtIndex:index];
    
    if (sessinModel.uid.length&&sessinModel.yxID.length) {
    
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
            showInfoView.isOpenSilentAction=YES;
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
    [_inputBarView.inputView resignFirstResponder];    
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
