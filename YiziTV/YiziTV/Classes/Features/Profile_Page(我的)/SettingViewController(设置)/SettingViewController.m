//
//  SettingViewController.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/22.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "SettingViewController.h"
#import "UserInfoModel.h"
#import "SettingTableViewCell.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "EditMyPersonInfoViewController.h"
#import "AcountSecurityViewController.h"
#import "SuggestViewController.h"
#import "CertificationViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITableView * settingTableView;
    
    UIImageView * coverImageView;
    
    UIView * headViewBackView;
}
@end

@implementation SettingViewController

-(void)setLiveCoverImage
{
    [headViewBackView removeFromSuperview];
    
    headViewBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth+8)];
    headViewBackView.backgroundColor=[UIColor customColorWithString:@"eeeeee"];
    
    settingTableView.tableHeaderView=headViewBackView;
    
    coverImageView=[[UIImageView alloc]initWithFrame:CGRectMake(16, 20, kScreenWidth-32, kScreenWidth-32)];
    coverImageView.userInteractionEnabled=YES;

    [headViewBackView addSubview:coverImageView];
    if (self.infoModel.coverImageUrl.length) {
    
        [coverImageView sd_setImageWithURL:[NSURL URLWithString:self.infoModel.coverImageUrl] placeholderImage:nil];
        coverImageView.userInteractionEnabled=YES;
        CGFloat width=[UILabel getLabelWidthWithText:@"设置直播封面" wordSize:16 height:20];
        CGFloat imageViewWidth=width+7+15;
        UIImageView * iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(coverImageView.width/2-imageViewWidth/2, coverImageView.height-13-15, 15, 15)];
        iconImage.image=[UIImage imageNamed:@"btn_pic"];
        [coverImageView addSubview:iconImage];
        
        UILabel * label=[UILabel setLabelFrame:CGRectMake(CGRectGetMaxX(iconImage.frame)+7,coverImageView.height-13-20, width, 20) Text:@"设置直播封面" TextColor:[UIColor whiteColor] font:[UIFont fontWithName:TextFontName size:16] textAlignment:NSTextAlignmentLeft];
        [coverImageView addSubview:label];
        
        
        
    }else
    {
        coverImageView.backgroundColor=[UIColor whiteColor];
        UIImage * coveImage=[UIImage imageNamed:@"pic"];
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(coverImageView.width/2-coveImage.size.width/2, coverImageView.height/2-coveImage.size.height/2, coveImage.size.width, coveImage.size.height)];
        imageView.image=coveImage;
        imageView.userInteractionEnabled=YES;
        [coverImageView addSubview:imageView];
        

    
    }

    
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCoverImageView)];
    [coverImageView addGestureRecognizer:tap];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"设置";
    self.view.backgroundColor=[UIColor customColorWithString:@"eeeeee"];
    
    settingTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, KNavBarHeight, kScreenWidth, kScreenHeight-KNavBarHeight) style:UITableViewStyleGrouped];
    
    settingTableView.backgroundColor=[UIColor customColorWithString:@"eeeeee"];
    settingTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    settingTableView.delegate=self;
    settingTableView.dataSource=self;
    [self.view addSubview:settingTableView];
    
    [self setLiveCoverImage];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
            
        default:
            break;
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        switch (indexPath.row) {
            case 0:
            {
            
                SettingTableViewCell * cell=[[SettingTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                cell.rightImage.hidden=YES;
                cell.leftTitleLabel.text=@"账号安全";
                
                UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
                
                if (user.phone_number.length) {
                    NSMutableString * mutableString=[[NSMutableString alloc]initWithString:user.phone_number];
                    [mutableString replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                    
                    UILabel * phoneLabel=[UILabel setLabelFrame:CGRectMake(14, 40, 200, 10) Text:[NSString stringWithFormat:@"绑定手机号码 %@",mutableString] TextColor:[UIColor customColorWithString:@"909290"] font:[UIFont fontWithName:TextFontName size:10] textAlignment:NSTextAlignmentLeft];
                    [cell addSubview:phoneLabel];
                    
                    
                    UILabel * buttonLabel=[UILabel setLabelFrame:CGRectMake(kScreenWidth-16-37, 59/2-15/2, 37, 15) Text:@"已绑定" TextColor:[UIColor customColorWithString:@"28904e"] font:[UIFont fontWithName:TextFontName size:11] textAlignment:NSTextAlignmentCenter];
                    buttonLabel.layer.masksToBounds=YES;
                    buttonLabel.layer.cornerRadius=2;
                    buttonLabel.layer.borderColor=[[UIColor customColorWithString:@"28904e"]CGColor];
                    buttonLabel.layer.borderWidth=0.5;
                    [cell addSubview:buttonLabel];
                    
                }
                
                
                return cell;
                
            }
                break;
            case 1:
            {
                
                UserInfoModel * userInfo=[[UserManager shareInstaced]getUserInfoModel];
                
                SettingTableViewCell * cell=[[SettingTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                cell.rightImage.hidden=YES;
                cell.leftTitleLabel.text=@"实名认证";
                if (userInfo.isCertification) {
                  
                    UILabel * reminderLabel=[UILabel setLabelFrame:CGRectMake(CGRectGetMaxX(cell.leftTitleLabel.frame)+2, cell.leftTitleLabel.y+2, 49, 15) Text:@"主播必须" TextColor:[UIColor whiteColor] font:[UIFont fontWithName:TextFontName size:11] textAlignment:NSTextAlignmentCenter];
                    [cell addSubview:reminderLabel];
                    
                    
                    UILabel * buttonLabel=[UILabel setLabelFrame:CGRectMake(kScreenWidth-16-37, 59/2-15/2, 37, 15) Text:@"已认证" TextColor:[UIColor customColorWithString:@"28904e"] font:[UIFont fontWithName:TextFontName size:11] textAlignment:NSTextAlignmentCenter];
                    buttonLabel.layer.masksToBounds=YES;
                    buttonLabel.layer.cornerRadius=2;
                    buttonLabel.layer.borderColor=[[UIColor customColorWithString:@"28904e"]CGColor];
                    buttonLabel.layer.borderWidth=0.5;
                    [cell addSubview:buttonLabel];
                    

                    
                    
                }
                
                
                return cell;
            
            }
                break;
            case 2:
            {
                SettingTableViewCell * cell=[[SettingTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                cell.line.hidden=YES;
                cell.leftTitleLabel.text=@"个人资料";
                
                
                return cell;
            
            }
                break;
                
            default:
                break;
        }
        
        
        
    }
    else if (indexPath.section==1){
        switch (indexPath.row) {
            case 0:
            {
                SettingTableViewCell * cell=[[SettingTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        
                cell.leftTitleLabel.text=@"产品反馈";
                
                
                return cell;

                
                
            }
                break;
            case 1:
            {
                SettingTableViewCell * cell=[[SettingTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                cell.line.hidden=YES;
                cell.rightImage.hidden=YES;
                cell.leftTitleLabel.text=@"版本号";
                
                
                UILabel * visionLabel=[UILabel setLabelFrame:CGRectMake(kScreenWidth-16-100, 22, 100, 15) Text:[NSString stringWithFormat:@"版本V%@",[DeviceInfo getCurrentAPPVision ]] TextColor:[UIColor customColorWithString:@"909290"] font:[UIFont fontWithName:TextFontName size:11] textAlignment:NSTextAlignmentRight];
                [cell addSubview:visionLabel];
                
                
                return cell;

            
            }
                break;
                
            default:
                break;
        }
    
    }
    else if (indexPath.section==2)
    {
        
        SettingTableViewCell * cell=[[SettingTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.line.hidden=YES;
        cell.rightImage.hidden=YES;
        cell.leftTitleLabel.text=@"退出登录";
        cell.leftTitleLabel.frame=CGRectMake(0, cell.leftTitleLabel.y, kScreenWidth, cell.leftTitleLabel.height);
        cell.leftTitleLabel.textColor=[UIColor customColorWithString:@"f04a4b"];
        cell.leftTitleLabel.textAlignment=NSTextAlignmentCenter;
        return cell;
    
    }


    return nil;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59.f;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.00000001f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        if (indexPath.row==2) {
            EditMyPersonInfoViewController * editMyInfo=[[EditMyPersonInfoViewController alloc]init];
            [self.navigationController pushViewController:editMyInfo animated:YES];
        }
        if (indexPath.row==0) {
            
                           AcountSecurityViewController * acountVC=[[AcountSecurityViewController alloc]init];
                [self.navigationController pushViewController:acountVC animated:YES];

        
        }
        
        if (indexPath.row==1) {
            UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
            if (!user.isCertification) {
                

            CertificationViewController * cerVC=[[CertificationViewController alloc]init];
            [self.navigationController pushViewController:cerVC animated:YES];
                
                cerVC.CerNumCallback=^{
                
                    [settingTableView reloadData];
                };
                
            }
        }
    }
    
    if (indexPath.section==1) {
        
        if (indexPath.row==0) {
            SuggestViewController * suggestVC=[[SuggestViewController alloc]init];
            [self.navigationController pushViewController:suggestVC animated:YES];
        }
    }

    if (indexPath.section==2) {
        
        [[UserManager shareInstaced]exitLogin];
        AppDelegate * delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        LoginViewController * login=[[LoginViewController alloc]init];
        UINavigationController * nav=[[UINavigationController alloc]initWithRootViewController:login];
        delegate.window.rootViewController=nav;
        
    }

}
-(void)tapCoverImageView
{
    UIActionSheet * actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄",@"从相册上传", nil];
    [actionSheet showInView:self.view];

}
#pragma mark actionsheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    switch (buttonIndex) {
            //相机
        case 0:
        {
            
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:nil];
                
            } else {
                NSString *title = @"错误信息";
                NSString *msg = @"对不起，您的设备不支持拍照或者拍照设备损坏！";
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alert show];
            }
            

        
        }
            break;
            //相册
        case 1:
        {
            UIImagePickerController *picker_library = [[UIImagePickerController alloc] init];
            picker_library.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker_library.allowsEditing = YES;
            picker_library.delegate = self;
            
            [self presentViewController:picker_library animated:YES completion:nil];

            
            
        }
            break;
            
        default:
            break;
    }
    

    
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
        NSLog(@"------修改封面----%@",jsonDict);
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            self.infoModel.coverImageUrl=[jsonDict valueForKey:@"pop_pic"];
            user.setLiveCoverImageUrl=self.infoModel.coverImageUrl;
            [[UserManager shareInstaced]setUserInfo:user];
            
            [self setLiveCoverImage];
            
            
        }
        
        
    } fail:^(NSError *error) {
        
    }];
    
    
    

    
    
}

-(void)backToLastController
{
    [self.navigationController popViewControllerAnimated:YES];
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
