//
//  EditMyCardInfoViewController.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/22.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "EditMyCardInfoViewController.h"
#import "EditTextModel.h"
#import "EditMyCardInfoTableViewCell.h"
#import "FullTimeView.h"
#import "NSString+Date.h"

@interface EditMyCardInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,FinishPickView>
{
    UITableView * editTableView;
    NSArray * titlrArr;
    NSArray * placeholderArr;
    
    //编辑cell的Y坐标
    CGFloat cellY;
    
}
@end

@implementation EditMyCardInfoViewController
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    
}
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
    NSLog(@"----------%f+++++++++%f",keyY,cellY);
    if (keyY<cellY) {
        editTableView.frame=CGRectMake(0, keyY-20-cellY, editTableView.width, editTableView.height);
        
    }else{
    
        editTableView.frame=CGRectMake(0, KNavBarHeight+20, editTableView.width, editTableView.height);

    
    }
    
    
    
}
-(void)hiddenKeyboard:(NSNotification *)notic
{

  editTableView.frame=CGRectMake(0, KNavBarHeight+20, editTableView.width, editTableView.height);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
       self.title=@"我的名片";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenKeyboard:) name:UIKeyboardDidHideNotification object:nil];


    UIButton * rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, KNavBarHeight)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor customColorWithString:@"28904e"] forState:UIControlStateNormal];
    rightButton.titleLabel.font=[UIFont fontWithName:TextFontName size:18];
    rightButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [rightButton addTarget:self action:@selector(saveMyCardInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightItem ;
    
    self.view.backgroundColor=[UIColor customColorWithString:@"eeeeee"];
    
    
    
    titlrArr=@[@"真实姓名",@"手机号码",@"所在城市",@"毕业院校",@"所学专业",@"毕业时间",@"目标岗位"];
    placeholderArr=@[@"请输入真实姓名",@"请输入手机号码",@"请输入所在城市",@"请输入毕业院校",@"请输入所学专业",@"请选择毕业时间",@"请输入目标岗位"];
    
    
    editTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, KNavBarHeight+20, kScreenWidth, kScreenHeight-KNavBarHeight-20) style:UITableViewStylePlain] ;
    editTableView.backgroundColor=[UIColor whiteColor];
    editTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    editTableView.delegate=self;
    editTableView.dataSource=self;
    [self.view addSubview:editTableView];
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titlrArr.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    switch (indexPath.row) {
            
        case 0:
        {
        
            EditMyCardInfoTableViewCell * cell=[[EditMyCardInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.titleLabel.text=[titlrArr objectAtIndex:indexPath.row];
            
            if (self.cardModel.name.length) {
                cell.textFiled.text=self.cardModel.name;
            }else{
                [cell.textFiled setPlaceholder:[placeholderArr objectAtIndex:indexPath.row] withFont:[UIFont fontWithName:TextFontName size:16] color:[UIColor customColorWithString:@"c8c8c8"]];
                
                
            }
            cell.textFiled.delegate=self;
            [cell.textFiled addTarget:self action:@selector(nameTextChange:) forControlEvents:UIControlEventEditingChanged];
            cell.textFiled.tag=101+indexPath.row;
            return cell;

        }
            break;
        case 1:
        {
            EditMyCardInfoTableViewCell * cell=[[EditMyCardInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.titleLabel.text=[titlrArr objectAtIndex:indexPath.row];

            if (self.cardModel.phoneNum.length) {
                cell.textFiled.text=self.cardModel.phoneNum;
                cell.textFiled.enabled=NO;
            }else{
                [cell.textFiled setPlaceholder:[placeholderArr objectAtIndex:indexPath.row] withFont:[UIFont fontWithName:TextFontName size:16] color:[UIColor customColorWithString:@"c8c8c8"]];
                
                
            }
            cell.textFiled.delegate=self;
            cell.textFiled.tag=101+indexPath.row;
            cell.textFiled.keyboardType=UIKeyboardTypePhonePad;
            return cell;
        }
            break;
        case 2:
        {
            EditMyCardInfoTableViewCell * cell=[[EditMyCardInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.titleLabel.text=[titlrArr objectAtIndex:indexPath.row];

            if (self.cardModel.locationCity.length) {
                cell.textFiled.text=self.cardModel.locationCity;
            }else{
                [cell.textFiled setPlaceholder:[placeholderArr objectAtIndex:indexPath.row] withFont:[UIFont fontWithName:TextFontName size:16] color:[UIColor customColorWithString:@"c8c8c8"]];
                
            }
            
            cell.textFiled.delegate=self;
            [cell.textFiled addTarget:self action:@selector(locationCityTextChange:) forControlEvents:UIControlEventEditingChanged];
            cell.textFiled.tag=101+indexPath.row;
            return cell;
        }
            break;
        case 3:
        {
            EditMyCardInfoTableViewCell * cell=[[EditMyCardInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.titleLabel.text=[titlrArr objectAtIndex:indexPath.row];

            if (self.cardModel.shcool.length) {
                cell.textFiled.text=self.cardModel.shcool;
            }else{
                [cell.textFiled setPlaceholder:[placeholderArr objectAtIndex:indexPath.row] withFont:[UIFont fontWithName:TextFontName size:16] color:[UIColor customColorWithString:@"c8c8c8"]];
                
            }
            cell.textFiled.delegate=self;
            cell.textFiled.tag=101+indexPath.row;
           return cell;
        }
            break;
        case 4:
            
        {
            EditMyCardInfoTableViewCell * cell=[[EditMyCardInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.titleLabel.text=[titlrArr objectAtIndex:indexPath.row];

            if (self.cardModel.professional.length) {
                cell.textFiled.text=self.cardModel.professional;
            }else{
                [cell.textFiled setPlaceholder:[placeholderArr objectAtIndex:indexPath.row] withFont:[UIFont fontWithName:TextFontName size:16] color:[UIColor customColorWithString:@"c8c8c8"]];
                
            }
            cell.textFiled.delegate=self;
            cell.textFiled.tag=101+indexPath.row;
            return cell;
        }
            break;
        case 5:
        {
            SelectMyCardInfoTableViewCell * cell=[[SelectMyCardInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.titleLabel.text=[titlrArr objectAtIndex:indexPath.row];

            if (self.cardModel.graduateTime.length) {
                cell.selectLabel.text=self.cardModel.graduateTime;
                cell.selectLabel.textColor=[UIColor customColorWithString:@"0d0e0d"];
            }else{
                cell.selectLabel.text= [placeholderArr objectAtIndex:indexPath.row];
                cell.selectLabel.textColor=[UIColor customColorWithString:@"c8c8c8"];
            
                
            }
            
            UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectgraduateTime)];
            [cell.selectLabel addGestureRecognizer:tap];
            
            return cell;
        }
            break;
        case 6:
        {
            EditMyCardInfoTableViewCell * cell=[[EditMyCardInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.titleLabel.text=[titlrArr objectAtIndex:indexPath.row];

            if (self.cardModel.wantJobName.length) {
                cell.textFiled.text=self.cardModel.wantJobName;
            }else{
                [cell.textFiled setPlaceholder:[placeholderArr objectAtIndex:indexPath.row] withFont:[UIFont fontWithName:TextFontName size:16] color:[UIColor customColorWithString:@"c8c8c8"]];
                
            }
            cell.textFiled.delegate=self;
            cell.textFiled.tag=101+indexPath.row;
            cell.line.hidden=YES;
            return cell;
        }
            break;

        default:
            break;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

#pragma mark textfiled delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   
    cellY=KNavBarHeight+20+60.0*(textField.tag-101);
    
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
    
    if (textField.tag==101+YZTVEeditCardInfoPhone) {
        
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        
        if (existedLength - selectedLength + replaceLength > 13) {
            return NO;
        }

    }
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    switch (textField.tag-101) {
        case YZTVEeditCardInfoName:
            
            self.cardModel.name=textField.text;
            
            break;
        case YZTVEeditCardInfoPhone:
            self.cardModel.phoneNum=textField.text;
            break;
        case YZTVEeditCardInfoCity:
            self.cardModel.locationCity=textField.text;
            break;
        case YZTVEeditCardInfoSchool:
            self.cardModel.shcool=textField.text;
            break;
        case YZTVEeditCardInfoProsession:
            self.cardModel.professional=textField.text;
            break;
        case YZTVEeditCardInfoWantJob:
            self.cardModel.wantJobName=textField.text;
            break;
            
        default:
            break;
    }
    

}
-(void)locationCityTextChange:(UITextField*)textField
{
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
-(void)nameTextChange:(UITextField*)textField
{

    NSString * toBeString = textField.text;
    NSString * lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange * selectedRange = [textField markedTextRange];
        UITextPosition * position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position)
        {
            if (toBeString.length > 8)
            {
                NSRange range ={0,8};
                textField.text = [toBeString substringWithRange:range];
            }
            
            
            
            
        }
        
    }

}
#pragma mark 选择时间
-(void)selectgraduateTime
{
    
    [self.view endEditing:YES];
    
    FullTimeView * pickView=[[FullTimeView alloc]initWithFrame:CGRectMake(0, kScreenHeight-220, kScreenWidth, 220)];
    [self.view addSubview:pickView];
    if (self.cardModel.graduateTime.length) {
        
    }else{
        pickView.curDate=[NSDate date];
    }

    pickView.delegate=self;
    
}
-(void)didFinishPickView:(NSDate*)date
{
    NSDateFormatter * formate=[[NSDateFormatter alloc]init];
    [formate setDateFormat:@"YYYY.MM.dd"];
    NSString * gradeTime=[formate stringFromDate:date];
    
    self.cardModel.graduateTime=gradeTime;
    
  [editTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:YZTVEeditCardInfoTime inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    

    

}
//保存我的信息
-(void)saveMyCardInfo
{
    
    [self.view endEditing:YES];
    
    WKProgressHUD *hud = [WKProgressHUD showInView:self.navigationController.view withText:@"正在保存" animated:YES];

    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:self.cardModel.name forKey:@"card.name"];
    [paramDic setValue:self.cardModel.locationCity forKey:@"card.position"];
    [paramDic setValue:self.cardModel.shcool forKey:@"card.school"];
    [paramDic setValue:self.cardModel.professional forKey:@"card.major"];
    [paramDic setValue:self.cardModel.wantJobName forKey:@"card.job"];
    
    NSLog(@"tijiao======%@",self.cardModel.professional );
    
   long long time= [self.cardModel.graduateTime dateStringWithFormateStyle:@"YYYY.MM.dd"];
    [paramDic setValue:[NSNumber numberWithLongLong:time] forKey:@"card.graduation_date"];
    
    [UrlRequest postRequestWithUrl:kSaveMyCardInfoUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud dismiss:YES];
        });
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            
            [self.navigationController popViewControllerAnimated:YES];
            
            if (self.saveSuccess!=nil) {
                
                self.saveSuccess(self.cardModel);
                
            }

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
