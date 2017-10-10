//
//  EditMyPersonInfoViewController.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/23.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "EditMyPersonInfoViewController.h"
#import "EditTextModel.h"
#import "EditMyCardInfoTableViewCell.h"
#import "AppDelegate.h"
#import "YZTVTabBarController.h"

@interface EditMyPersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITableView * infoTableView;
    
    NSArray * titleArr;
    NSArray * placeholderArr;
    
    CGFloat cellY;

}
@end

@implementation EditMyPersonInfoViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)showKeyboard:(NSNotification *)notic
{
    
    NSDictionary * userInfo=notic.userInfo;
    NSValue * value=[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect  keyboardsize=value.CGRectValue;
    CGFloat keyH=keyboardsize.size.height;
    
    //键盘的Y坐标
    CGFloat keyY=kScreenHeight-keyH;
    
    if (keyY<cellY) {
        infoTableView.frame=CGRectMake(0, keyY-cellY, infoTableView.width, infoTableView.height);
        
    }else{
        
        infoTableView.frame=CGRectMake(0, KNavBarHeight, infoTableView.width, infoTableView.height);
        
        
    }
    
    
    
}
-(void)hiddenKeyboard:(NSNotification *)notic
{
    
    infoTableView.frame=CGRectMake(0, KNavBarHeight, infoTableView.width, infoTableView.height);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenKeyboard:) name:UIKeyboardDidHideNotification object:nil];

    

    self.title=self.titleString;
    leftBotton.hidden=self.isHiddenBackButton;
    UIButton * rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, KNavBarHeight)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor customColorWithString:@"28904e"] forState:UIControlStateNormal];
    rightButton.titleLabel.font=[UIFont fontWithName:TextFontName size:18];
    rightButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [rightButton addTarget:self action:@selector(saveMyCardInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightItem ;
    

    [self requestMyInfo];
    
    self.view.backgroundColor=[UIColor customColorWithString:@"eeeeee"];
    titleArr=@[@[@"头  像"],@[@"昵  称",@"性  别",@"毕业院校",@"所学专业"]];
    placeholderArr=@[@[@"touxiang"],@[@"请输入昵称",@"请选择性别",@"请输入毕业院校",@"请输入所学专业"]];
    infoTableView=[[UITableView alloc]
                   initWithFrame:CGRectMake(0, KNavBarHeight, kScreenWidth, kScreenHeight-KNavBarHeight) style:UITableViewStyleGrouped];
    infoTableView.backgroundColor=[UIColor customColorWithString:@"eeeeee"];
    infoTableView.dataSource=self;
    infoTableView.delegate=self;
    infoTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:infoTableView];
    
    
    
}
//请求我的个人信心

-(void)requestMyInfo
{
    
    
    NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
    UserInfoModel * user =[[UserManager shareInstaced]getUserInfoModel];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    
    [UrlRequest postRequestWithUrl:kGetUserInfoUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
      
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            NSLog(@"获取用户信息-----%@",jsonDict);
            if (self.infoModel==nil) {
                self.infoModel=[[CardInfoModel alloc]init];
                
            }
            
            [self.infoModel analysisRequestJsonNSDictionary:jsonDict];
            
            [infoTableView reloadData];
  
        }
        
        
    } fail:^(NSError *error) {
        
    }];
    
    

}

#pragma mark tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return titleArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * array=[titleArr objectAtIndex:section];
    return  array.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * array=[titleArr objectAtIndex:indexPath.section];
    if (indexPath.section==0) {
        
        EditHeadImageViewTableViewCell * cell=[[EditHeadImageViewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.titleLabel.text=[array objectAtIndex:indexPath.row];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.infoModel.headImageUrl] placeholderImage:[UIImage imageNamed:@"head"]];
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editMyHeadImageView)];
        [cell.headImageView addGestureRecognizer:tap];
        return cell;
        
    }else
    {
        NSArray * plArray=[placeholderArr objectAtIndex:indexPath.section];
    
        switch (indexPath.row) {
            case 0:
            {
                
                EditMyCardInfoTableViewCell * cell=[[EditMyCardInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                cell.titleLabel.text=[array objectAtIndex:indexPath.row];
                
                if (self.infoModel.nickName.length) {
                    cell.textFiled.text=self.infoModel.nickName;
                }else{
                    [cell.textFiled setPlaceholder:[plArray objectAtIndex:indexPath.row] withFont:[UIFont fontWithName:TextFontName size:16] color:[UIColor customColorWithString:@"c8c8c8"]];
                    
                }
                cell.textFiled.delegate=self;
                cell.textFiled.tag=201+indexPath.row;
                [cell.textFiled addTarget:self action:@selector(nameTextChange:) forControlEvents:UIControlEventEditingChanged];
                return cell;
            
            }
                break;
            case 1:
            {
                SelectMyCardInfoTableViewCell * cell=[[SelectMyCardInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                 cell.selectLabel.textColor=[UIColor customColorWithString:@"0d0e0d"];
                cell.titleLabel.text=[array objectAtIndex:indexPath.row];
                
                cell.selectLabel.text=self.infoModel.grand?@"女":@"男";
                
                UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectGrand)];
                [cell.selectLabel addGestureRecognizer:tap];
                   
                return cell;
                
            }
                break;
            case 2:
            {
                EditMyCardInfoTableViewCell * cell=[[EditMyCardInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                cell.titleLabel.text=[array objectAtIndex:indexPath.row];
                
                if (self.infoModel.shcool.length) {
                    cell.textFiled.text=self.infoModel.shcool;
                }else{
                    [cell.textFiled setPlaceholder:[plArray objectAtIndex:indexPath.row] withFont:[UIFont fontWithName:TextFontName size:16] color:[UIColor customColorWithString:@"c8c8c8"]];
                    
                }
                cell.textFiled.delegate=self;
                cell.textFiled.tag=201+indexPath.row;
                return cell;

            }
                break;
            case 3:
            {
                EditMyCardInfoTableViewCell * cell=[[EditMyCardInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                cell.titleLabel.text=[array objectAtIndex:indexPath.row];
                
                if (self.infoModel.professional.length) {
                    
                    cell.textFiled.text=self.infoModel.professional;
                    
                }else{
                    [cell.textFiled setPlaceholder:[plArray objectAtIndex:indexPath.row] withFont:[UIFont fontWithName:TextFontName size:16] color:[UIColor customColorWithString:@"c8c8c8"]];
                    
                }
                cell.textFiled.delegate=self;
                cell.textFiled.tag=201+indexPath.row;
                cell.line.hidden=YES;
                return cell;

            }
                break;

                

                
            default:
                break;
        }
    
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 75.f;
    }
    return 60.f;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000000001;

}
-(void)editMyHeadImageView
{

    UIActionSheet * actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消"  destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
    actionSheet.tag=EN_EditHeadImageTag;
    [actionSheet showInView:self.view];

}
#pragma mark actionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 相册 相机
    
    if (actionSheet.tag==EN_EditHeadImageTag) {
       
        switch (buttonIndex) {
                //相册
            case 0:
            {
                UIImagePickerController *picker_library = [[UIImagePickerController alloc] init];
                picker_library.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker_library.allowsEditing = YES;
                picker_library.delegate = self;
                
                [self presentViewController:picker_library animated:YES completion:nil];
            }
                break;
            //相机
            case 1:
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
                
            default:
                break;
        }
        
        
        
    }
    else if (actionSheet.tag==EN_EditGrandTag)
    {
        
        self.infoModel.grand=(int)buttonIndex;
        [infoTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        
    
    
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
    
    NSData * imageData=[compressImage compressedDataSize:HeadImageSize];
    
    NSString * stringImage=[imageData base64EncodedStringWithOptions:0];
    
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:@"jpg" forKey:@"suffix"];
    [paramDic setValue:stringImage forKey:@"head_photo"];
    
    [UrlRequest postRequestWithUrl:kEditUserHeadImageUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
       
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            self.infoModel.headImageUrl=[jsonDict valueForKey:@"head_photo"];
            [infoTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            

            
        }
        
        
    } fail:^(NSError *error) {
        
    }];
    
   

    
    
    

}
//选择男女
-(void)selectGrand
{
    [self.view endEditing:YES];
    
    UIActionSheet * actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消"  destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    actionSheet.tag=EN_EditGrandTag;
    [actionSheet showInView:self.view];



}
-(void)saveMyCardInfo
{

    [self.view endEditing:YES];
    
     WKProgressHUD * hud  = [WKProgressHUD showInView:self.navigationController.view withText:@"" animated:YES];

    
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:self.infoModel.nickName forKey:@"edit.nickname"];
    [paramDic setValue:[NSNumber numberWithInt:self.infoModel.grand] forKey:@"edit.gender"];
    [paramDic setValue:self.infoModel.shcool forKey:@"edit.school"];
    [paramDic setValue:self.infoModel.professional forKey:@"edit.major"];
    
    [UrlRequest postRequestWithUrl:kEditUserInfoUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        [hud dismiss:YES];
        NSLog(@"编辑信息返回%@",jsonDict);
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
        UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
        user.nickName=self.infoModel.nickName;
        [[UserManager shareInstaced]setUserInfo:user];
            
            [self saveSuccess];
        }
        
    } fail:^(NSError *error) {
        
    }];
    
   
}

-(void)saveSuccess
{
    if (self.isChangeRootVC) {
        
        YZTVTabBarController * tabarVC=[[YZTVTabBarController alloc]init];
        AppDelegate * delegate=[[UIApplication sharedApplication]delegate];
        delegate.window.rootViewController=tabarVC;
        
    }else
    {
        [self backToLastController];
    }

}
#pragma mark textfiled delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    cellY=KNavBarHeight+115+60.0*(textField.tag-201);
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([textField.textInputMode.primaryLanguage isEqualToString:@"emoji"]) {
        
        return NO;
    }
    
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    switch (textField.tag-201) {
        case 0:
            self.infoModel.nickName=textField.text;
            break;
        case 2:
            self.infoModel.shcool=textField.text;
            break;
        case 3:
            self.infoModel.professional=textField.text;
            break;
            default:
            break;
    }
    
    
}
-(void)nameTextChange:(UITextField*)nametf
{
    NSString * toBeString = nametf.text;
    NSString * lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange * selectedRange = [nametf markedTextRange];
        UITextPosition * position = [nametf positionFromPosition:selectedRange.start offset:0];
        if (!position)
        {
            if (toBeString.length > 8)
            {
                NSRange range ={0,8};
                nametf.text = [toBeString substringWithRange:range];
            }
            
            
            
            
        }
        
    }


}
-(void)textFiledEditChanged:(NSNotification *)notify
{
    UITextField * textField = (UITextField *)notify.object;
    if (textField.tag==201) {
        NSString * toBeString = textField.text;
        NSString * lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
        if ([lang isEqualToString:@"zh-Hans"]) {
            UITextRange * selectedRange = [textField markedTextRange];
            UITextPosition * position = [textField positionFromPosition:selectedRange.start offset:0];
            if (!position)
            {
                if (toBeString.length > 16)
                {
                    NSRange range ={0,16};
                    textField.text = [toBeString substringWithRange:range];
                }
                
                
                
                
            }
            
        }
        
    }
    
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
