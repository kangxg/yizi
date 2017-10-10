//
//  SettingDeviceLimitView.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/27.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "SettingDeviceLimitView.h"

@interface SettingDeviceLimitView ()<UIAlertViewDelegate>
{
    UIButton  *cameraButton;
    UIButton * microphoneButton;
    
}
@end

@implementation SettingDeviceLimitView
-(instancetype)init
{
    CGRect newframe=CGRectMake(0,0, kScreenWidth, kScreenHeight);
    self=[super initWithFrame:newframe];
    if (self) {
        
        
        self.frame=newframe;
        [self createUI];
    }
    
    return self;
    
}
-(void)createUI
{
    
    UIView * backView=[[UIView alloc]initWithFrame:self.bounds];
    backView.backgroundColor=[UIColor blackColor];
    backView.alpha=0.2;
    [self addSubview:backView];
    CGRect newframe=CGRectMake(kScreenWidth/2-280/2, kScreenHeight/2-312/2, 280, 312);
    UIView * whiteView=[[UIView alloc]initWithFrame:newframe];
    whiteView.backgroundColor=[UIColor whiteColor];
    whiteView.layer.masksToBounds=YES;
    whiteView.layer.cornerRadius=4.f;
    [self addSubview:whiteView];
    
    UIImageView * iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(newframe.size.width/2-145/2, 20, 145, 90)];
    iconImage.image=[UIImage imageNamed:@"img"];
    [whiteView addSubview:iconImage];
    
    UILabel * contentLabel=[UILabel setLabelFrame:CGRectMake(0, CGRectGetMaxY(iconImage.frame)+29, whiteView.width, 20) Text:@"创建直播需要启用以下功能" TextColor:[UIColor customColorWithString:@"0d0e0d"] font:[UIFont fontWithName:TextFontName size:17] textAlignment:NSTextAlignmentCenter];
    [whiteView addSubview:contentLabel];
    
    
    cameraButton=[[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(contentLabel.frame)+40, whiteView.width-80, 36)];
    cameraButton.layer.masksToBounds=YES;
    cameraButton.layer.cornerRadius=4.f;
    cameraButton.layer.borderWidth=1;
    cameraButton.layer.borderColor=[[UIColor customColorWithString:@"28904e"]CGColor];
    [cameraButton setImage:[UIImage imageNamed:@"green_camera_normal"] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:@"green_camera_press"] forState:UIControlStateHighlighted];
    [cameraButton setImage:[UIImage imageNamed:@"enabled"] forState:UIControlStateDisabled];
    [cameraButton setTitle:@"启用相机" forState:UIControlStateNormal];
    cameraButton.titleLabel.font=[UIFont fontWithName:TextFontName size:16];
    cameraButton.titleLabel.textAlignment=NSTextAlignmentLeft;
    [cameraButton setTitleColor:[UIColor customColorWithString:@"28904e"] forState:UIControlStateNormal];
    [cameraButton setTitleColor:[UIColor customColorWithString:@"cecece"] forState:UIControlStateDisabled];
    [cameraButton setImageEdgeInsets:UIEdgeInsetsMake(7.5, 0, 7.5, 13)];
    [cameraButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 13, 0, 0)];
    [whiteView addSubview:cameraButton];
    
    
    microphoneButton=[[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(cameraButton.frame)+13, cameraButton.width, cameraButton.height)];
    microphoneButton.layer.masksToBounds=YES;
    microphoneButton.layer.cornerRadius=4.f;
    microphoneButton.layer.borderWidth=1;
    microphoneButton.layer.borderColor=[[UIColor customColorWithString:@"28904e"]CGColor];
    [microphoneButton setImage:[UIImage imageNamed:@"green_mic_normal"] forState:UIControlStateNormal];
    [microphoneButton setImage:[UIImage imageNamed:@"green_mic_press"] forState:UIControlStateHighlighted];
    [microphoneButton setImage:[UIImage imageNamed:@"enabled"] forState:UIControlStateDisabled];
    [microphoneButton setTitleColor:[UIColor customColorWithString:@"cecece"] forState:UIControlStateDisabled];
    [microphoneButton setTitle:@"启用麦克风" forState:UIControlStateNormal];
    microphoneButton.titleLabel.font=[UIFont fontWithName:TextFontName size:16];
    microphoneButton.titleLabel.textAlignment=NSTextAlignmentLeft;
    [microphoneButton setTitleColor:[UIColor customColorWithString:@"28904e"] forState:UIControlStateNormal];
    [microphoneButton setImageEdgeInsets:UIEdgeInsetsMake(7.5, 26, 7.5, 26)];
    [microphoneButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 26, 0, 0)];
   
    [whiteView addSubview:microphoneButton];
    
    
    
    UIButton * closeButton=[[UIButton alloc]initWithFrame:CGRectMake(self.width/2-80/2, CGRectGetMaxY(whiteView.frame), 80, 80)];
    [closeButton setImage:[UIImage imageNamed:@"btn_close_normal"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"btn_close_press"] forState:UIControlStateHighlighted];
    
    [self addSubview:closeButton];
    
    [closeButton addTarget:self action:@selector(pressCloseButton) forControlEvents:UIControlEventTouchUpInside];
    

    



}
-(void)pressCloseButton
{
    if (self.closeSettingDeviceLimitView!=nil) {
        self.closeSettingDeviceLimitView();
    }


}

-(void)setButtonStatus:(YZDeviceErrorStatus)status
{
    switch (status) {
        case 1:
        {
        
            cameraButton.enabled=NO;
              cameraButton.layer.borderColor=[[UIColor customColorWithString:@"cecece"]CGColor];
            [microphoneButton addTarget:self action:@selector(clickmicrophoneButton) forControlEvents:UIControlEventTouchUpInside];
           
            
        }
            break;
        case 2:
        {
           microphoneButton.enabled=NO;
           microphoneButton.layer.borderColor=[[UIColor customColorWithString:@"cecece"]CGColor];
           [cameraButton addTarget:self action:@selector(clickCameraButton) forControlEvents:UIControlEventTouchUpInside];
            
        }
            break;
        case 3:
        {
            [microphoneButton addTarget:self action:@selector(clickmicrophoneButton) forControlEvents:UIControlEventTouchUpInside];
            [cameraButton addTarget:self action:@selector(clickCameraButton) forControlEvents:UIControlEventTouchUpInside];


            
        
        }
            break;
            
        default:
            break;
    }

}

// 跳转到麦克风
-(void)clickmicrophoneButton
{
    
    
    [self alwertViewShowWithTitle:@"需要访麦克风" Content:@"要开启直播，椅子TV需要访问您设备上的麦克风，点击“设置”按钮为椅子TV启用麦克风权限"];
}
//跳转到相机
-(void)clickCameraButton
{
    
    [self alwertViewShowWithTitle:@"需要访问相机" Content:@"要开启直播，椅子TV需要访问您设备上的相机，点击“设置”按钮为椅子TV启用相机权限"];

}
-(void)alwertViewShowWithTitle:(NSString*)title Content:(NSString*)content
{
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"设置", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        [self openMyAPPSetting];
    }
}
-(void)openMyAPPSetting
{
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([app canOpenURL:settingsURL]) {
        [app openURL:settingsURL];
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
