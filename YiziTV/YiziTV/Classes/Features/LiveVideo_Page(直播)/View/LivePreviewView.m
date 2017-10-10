//
//  LivePreviewView.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/28.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "LivePreviewView.h"
#import "LiveShareView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>


@interface LivePreviewView ()<UITextFieldDelegate>
{

    UIImageView *   coverImageView;
    //主题
    UITextField * themeTextFiled;
  //
    UITextField * nameTextFiled;
    UITextField * IDNumTextFiled;
    
    UIButton * IDNumButton;
    
    UIButton * beginLiveBUtton;
    
    NSInteger shareIndex;

    
}
@end

@implementation LivePreviewView
-(id)init
{
    CGRect frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self=[super initWithFrame:frame];
    if (self) {
        [self createUI];
        
        [self requestUrl];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenKeyboard:) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}
-(void)showKeyboard:(NSNotification *)notic
{
    
    NSDictionary * userInfo=notic.userInfo;
    NSValue * value=[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect  keyboardsize=value.CGRectValue;
    CGFloat keyH=keyboardsize.size.height;
    
    //键盘的Y坐标
    CGFloat keyY=kScreenHeight-keyH;
    
    if (IDNumTextFiled.y+IDNumTextFiled.height>keyY) {
        
        self.frame=CGRectMake(0, -IDNumTextFiled.height*2, self.width, self.height);
        
    }
    
    
    
}
-(void)hiddenKeyboard:(NSNotification *)notic
{
    
    self.frame=CGRectMake(0, 0, self.width, self.height);

}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)requestUrl
{
    
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    if (!user.isCertification) {
        


    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
   
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    

        [UrlRequest postRequestWithUrl:kIsCerIDnumUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
            NSLog(@"是否实名认证---%@",jsonDict);
            int code=[[jsonDict valueForKey:@"code"]intValue];
            if (code==0) {
                
                int is_card_auth=[[jsonDict valueForKey:@"is_card_auth"]intValue];
                user.isCertification=is_card_auth;
                user.realName=[jsonDict valueForKey:@"card_name"];
                user.IDNum=[jsonDict valueForKey:@"card_no"];
                
                [[UserManager shareInstaced]setUserInfo:user];
                
                [self refreshUI];
                
            }
            
            
        } fail:^(NSError *error) {
            
        }];
        

        
        
        
        
    
    }else
    {
        
        [self refreshUI];
    
    }
    
    
    

}

-(void)createUI
{
    
    UIView * backView=[[UIView alloc]initWithFrame:self.bounds];
    backView.alpha=0.2;
    backView.backgroundColor=[UIColor blackColor];
    [self addSubview:backView];
    
    
    UIButton * closeButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-60, 0, 60, 60)];
    [closeButton setImage:[UIImage imageNamed:@"white_close_normal"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"white_close_press"] forState:UIControlStateHighlighted];
    [closeButton setImageEdgeInsets:UIEdgeInsetsMake(15, 25, 24, 14)];
    [self addSubview:closeButton];
    
    [closeButton addTarget:self action:@selector(closePreviewButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * changeCameraButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-60-60, 0, 60, 60)];
    [changeCameraButton setImageEdgeInsets:UIEdgeInsetsMake(15, 28, 24, 11)];
    [changeCameraButton setImage:[UIImage imageNamed:@"white_camera_normal"] forState:UIControlStateNormal];
    [changeCameraButton setImage:[UIImage imageNamed:@"white_camera_press"] forState:UIControlStateHighlighted];
    [changeCameraButton addTarget:self action:@selector(clickChangeCameraButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:changeCameraButton];
    
    
    
    coverImageView=[[UIImageView alloc]
                    initWithFrame:CGRectMake(25, CGRectGetMaxY(changeCameraButton.frame)+15, 75, 75)];
    coverImageView.backgroundColor=[UIColor customColorWithString:@"eeeeee"];
    coverImageView.userInteractionEnabled=YES;
    [self addSubview:coverImageView];
    UITapGestureRecognizer * tapCover=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCoverImage)];
    [coverImageView addGestureRecognizer:tapCover];
    
    
    
    UIImageView * setCoverImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 38, 75, 37)];
    setCoverImage.userInteractionEnabled=YES;
    setCoverImage.image=[UIImage imageNamed:@"set_cover"];
    [coverImageView addSubview:setCoverImage];
    
    [self setUIView];
    
}

-(void)setUIView
{
    
    UILabel * symbolLabel=[UILabel setLabelFrame:CGRectMake(CGRectGetMaxX(coverImageView.frame)+15, coverImageView.y+coverImageView.height/2-20, 20, 20) Text:@"#" TextColor:[UIColor whiteColor] font:[UIFont fontWithName:TextFontName size:20] textAlignment:NSTextAlignmentCenter];
    [self addSubview:symbolLabel];
    
    
    themeTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(symbolLabel.frame), symbolLabel.y, kScreenWidth-self.x-25, 20)];
    [themeTextFiled setPlaceholder:@"请输入主题" withFont:[UIFont fontWithName:TextFontName size:20] color:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
    themeTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    themeTextFiled.textColor=[UIColor whiteColor];
    themeTextFiled.font=[UIFont fontWithName:TextFontName size:20];
    themeTextFiled.delegate=self;
    themeTextFiled.keyboardAppearance=UIKeyboardAppearanceDark;
    [themeTextFiled addTarget:self action:@selector(themeTextChange) forControlEvents:UIControlEventEditingChanged];
    
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    if (user.liveTheme.length) {
       themeTextFiled.text=user.liveTheme;
    }else{
        themeTextFiled.text=@"主要看气质";
    }
    
    [self addSubview:themeTextFiled];
    
    UIView * themeLine=[[UIView alloc]initWithFrame:CGRectMake(symbolLabel.x, CGRectGetMaxY(coverImageView.frame)-0.5, kScreenWidth-symbolLabel.x-25, 0.5)];
    themeLine.backgroundColor=[UIColor whiteColor];
    themeLine.alpha=0.5;
    [self addSubview:themeLine];
    
    
    
    nameTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(coverImageView.frame)+63, kScreenWidth-50, 15)];
    [nameTextFiled setPlaceholder:@"请输入真实姓名" withFont:[UIFont fontWithName:TextFontName size:15] color:[[UIColor whiteColor]colorWithAlphaComponent:0.5] ];
    nameTextFiled.textColor=[UIColor whiteColor];
    nameTextFiled.font=[UIFont fontWithName:TextFontName size:15];
    nameTextFiled.delegate=self;
    [nameTextFiled addTarget:self action:@selector(nameTextChaneg) forControlEvents:UIControlEventEditingChanged];
    nameTextFiled.keyboardAppearance=UIKeyboardAppearanceDark;
    [self addSubview:nameTextFiled];
    
    
    UIView * nameLine=[[UIView alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(nameTextFiled.frame)+22, nameTextFiled.width, 0.5)];
    nameLine.backgroundColor=[UIColor whiteColor];
    nameLine.alpha=0.5;
    [self addSubview:nameLine];
    
    
    IDNumTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(nameLine.frame)+22, kScreenWidth-50-72, 15)];
    IDNumTextFiled.keyboardAppearance=UIKeyboardAppearanceDark;
    [IDNumTextFiled setPlaceholder:@"请输入身份证号" withFont:[UIFont fontWithName:TextFontName size:15] color:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
    IDNumTextFiled.textColor=[UIColor whiteColor];
    IDNumTextFiled.font=[UIFont fontWithName:TextFontName size:15];
    IDNumTextFiled.delegate=self;
    [IDNumTextFiled addTarget:self action:@selector(IDNumTextChange) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:IDNumTextFiled];
    
    
    UIView * IDNumLine=[[UIView alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(IDNumTextFiled.frame)+22, kScreenWidth-50, 0.5)];
    IDNumLine.backgroundColor=[UIColor whiteColor];
    IDNumLine.alpha=0.5;
    [self addSubview:IDNumLine];
    
    IDNumButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-72-25, CGRectGetMaxY(nameLine.frame)+14.5, 72, 30)];
    IDNumButton.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5];
    IDNumButton.layer.masksToBounds=YES;
    IDNumButton.layer.cornerRadius=4.0;
    [IDNumButton setTitle:@"实名认证" forState:UIControlStateNormal];
   
    [IDNumButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
    [IDNumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    IDNumButton.titleLabel.font=[UIFont fontWithName:TextFontName size:14];
    [IDNumButton addTarget:self action:@selector(clickIDNumButton) forControlEvents:UIControlEventTouchUpInside];
    IDNumButton.enabled=NO;
    [self addSubview:IDNumButton];
    
    
    NSString * share=@"分享";
    CGFloat shareWidth=[UILabel getLabelWidthWithText:share wordSize:15 height:25];
    UILabel * shareLabel=[UILabel setLabelFrame:CGRectMake(25, CGRectGetMaxY(IDNumLine.frame)+70, shareWidth, 25) Text:share TextColor:[UIColor whiteColor] font:[UIFont fontWithName:TextFontName size:15] textAlignment:NSTextAlignmentCenter];
    
    [self addSubview:shareLabel];
    shareLabel.hidden=YES;
    
    
    
    LiveShareView * shareView=[[LiveShareView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shareLabel.frame)+15, CGRectGetMaxY(IDNumLine.frame)+70, 69, 25)];
    [self addSubview:shareView];
    [shareView addTarget:self action:@selector(selectSomeoneShare:) forControlEvents:UIControlEventValueChanged];

    BOOL isshare=[shareView isshareShow];
    shareLabel.hidden=!isshare;
    
    
    beginLiveBUtton=[[UIButton alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(shareView.frame)+25, kScreenWidth-50, 50)];
    beginLiveBUtton.layer.masksToBounds=YES;
    beginLiveBUtton.layer.cornerRadius=4.f;
    beginLiveBUtton.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    beginLiveBUtton.titleLabel.font=[UIFont fontWithName:TextFontName size:17];
    [beginLiveBUtton setTitle:@"开始直播" forState:UIControlStateNormal];
    [beginLiveBUtton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
     [beginLiveBUtton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [beginLiveBUtton addTarget:self action:@selector(clickBeginLiveButton) forControlEvents:UIControlEventTouchUpInside];
    
    beginLiveBUtton.enabled=NO;
    
    [self addSubview:beginLiveBUtton];
    

}
-(void)selectSomeoneShare:(LiveShareView*)shareView
{
    shareIndex=shareView.tag;
    
}
-(void)refreshUI
{
    
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    if (user.isCertification) {
        nameTextFiled.text=user.realName;
        IDNumTextFiled.text=user.IDNum;
        nameTextFiled.enabled=NO;
        IDNumTextFiled.enabled=NO;
        IDNumButton.enabled=NO;
        [IDNumButton setTitle:@"已认证" forState:UIControlStateDisabled];
         [beginLiveBUtton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        IDNumButton.backgroundColor=[UIColor customColorWithString:@"28904e"];
        
    }
    
    if (user.setLiveCoverImageUrl.length) {
        [coverImageView sd_setImageWithURL:[NSURL URLWithString:user.setLiveCoverImageUrl] placeholderImage:nil];
        
    }
    
    

    if (themeTextFiled.text.length) {
        
        [self themeTextChange];
    }
    
    


}
-(void)themeTextChange
{
    
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    if (user.isCertification&&themeTextFiled.text.length) {
        
        beginLiveBUtton.backgroundColor=[UIColor customColorWithString:@"28904e"];
      [beginLiveBUtton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        beginLiveBUtton.enabled=YES;
        
        
    }else
    {
             beginLiveBUtton.enabled=NO;
            [beginLiveBUtton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
             beginLiveBUtton.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5];

    
    }
    
    
    NSString * toBeString = themeTextFiled.text;
    NSString * lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange * selectedRange = [themeTextFiled markedTextRange];
        UITextPosition * position = [themeTextFiled positionFromPosition:selectedRange.start offset:0];
        if (!position)
        {
            if (toBeString.length > 18)
            {
                NSRange range ={0,18};
                themeTextFiled.text = [toBeString substringWithRange:range];
            }
            
            
            
            
        }
        
    }

   
    
}

#pragma mark 开始直播
-(void)clickBeginLiveButton
{
    
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    user.liveTheme=themeTextFiled.text;
    [[UserManager shareInstaced]setUserInfo:user];
    
    
    if (shareIndex) {
        
        switch (shareIndex) {
                //朋友圈
            case YZShareWXFriendType:
            {
             [self shareWithType:SSDKPlatformSubTypeWechatTimeline];
            }
                break;
                //空间
            case YZShareTypeQQZoneType:
            {
            //SSDKPlatformSubTypeQZone
            [self shareWithType:SSDKPlatformSubTypeQZone];
                
            }
                break;
                
            default:
                break;
        }
    }else
    {
    
    
    if ([self.delegate respondsToSelector:@selector(clickBeginButtonWithThemeTitle:)]) {
        [self.delegate clickBeginButtonWithThemeTitle:themeTextFiled.text];
    }
    }
    
}
-(void)shareWithType:(SSDKPlatformType)type
{

    WKProgressHUD * hud  = [WKProgressHUD showInView:self withText:@"" animated:YES];
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
     NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:[NSNumber numberWithInteger:YZShareAnchorType] forKey:@"type"];
    [paramDic setValue:user.uid forKey:@"anchor_id"];
    
    [UrlRequest postRequestWithUrl:kShareUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        NSLog(@"分享返回===%@",jsonDict);
        [hud dismiss:YES];
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
            
            [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                
                if ([self.delegate respondsToSelector:@selector(clickBeginButtonWithThemeTitle:)]) {
                    [self.delegate clickBeginButtonWithThemeTitle:themeTextFiled.text];
                }

                
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
-(void)clickIDNumButton
{
    [self endEditing:YES];
    
    WKProgressHUD * hud=[WKProgressHUD showInView:self withText:nil animated:YES];
    
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:nameTextFiled.text forKey:@"card_name"];
    [paramDic setValue:IDNumTextFiled.text forKey:@"card_no"];
    
    [UrlRequest postRequestWithUrl:kCerIDNumUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        
        NSLog(@"实名认证 返回  %@",jsonDict);
        [hud dismiss:YES];
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            int is_card_auth=[[jsonDict valueForKey:@"is_card_auth"]intValue];
            if (is_card_auth) {
                user.isCertification=is_card_auth;
                user.realName=[jsonDict valueForKey:@"card_name"];
                user.IDNum=[jsonDict valueForKey:@"card_no"];
                
                [[UserManager shareInstaced]setUserInfo:user];
                
                [self refreshUI];
                
            }
          
            
            
            
        }
        
    } fail:^(NSError *error) {
        
    }];
    

    

}
-(void)nameTextChaneg
{
    [self changeIDNumButton];
    
}
-(void)changeIDNumButton
{
    if (IDNumTextFiled.text.length&&nameTextFiled.text.length) {
        
        IDNumButton.backgroundColor=[UIColor customColorWithString:@"28904e"];
        IDNumButton.enabled=YES;
        [IDNumButton setTitle:@"实名认证" forState:UIControlStateNormal];
        
    }else
    {
        IDNumButton.enabled=NO;
        IDNumButton.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5];
        [IDNumButton setTitle:@"实名认证" forState:UIControlStateNormal];
        
    }

}
-(void)IDNumTextChange
{

    
      [self changeIDNumButton];

}
-(void)closePreviewButton
{
    if ([self.delegate respondsToSelector:@selector(closePreview)]) {
        [self.delegate closePreview];
    }

}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    

}

-(void)tapCoverImage
{
    if ([self.delegate respondsToSelector:@selector(clickCoverImageView)]) {
        [self.delegate clickCoverImageView];
    }

}
-(void)changeCoverImageWithImageUrl:(NSString *)imageUrl
{
    [coverImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    
}
-(void)clickChangeCameraButton
{
    if ([self.delegate respondsToSelector:@selector(clickChangeCameraPositionACtion)]) {
        [self.delegate clickChangeCameraPositionACtion];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
