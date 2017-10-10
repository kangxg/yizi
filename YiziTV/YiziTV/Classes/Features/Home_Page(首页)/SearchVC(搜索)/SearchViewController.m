//
//  SearchViewController.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/25.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchOptionView.h"

@interface SearchViewController ()
{
    //输入框
    UITextField * searchTf;
}

@property (nonatomic, strong) SearchOptionView * themeView;//主题

@property (nonatomic, strong) SearchOptionView * nicknameView;//昵称

@property (nonatomic, strong) NSArray * themeDataArray;

@property (nonatomic, strong) NSArray * nicknameDataArray;
@end

@implementation SearchViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden=NO;
}
-(void)createNavView
{
    
    UIView * navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KNavBarHeight)];
    navView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:navView];
    
    UIView  * line=[[UIView alloc]initWithFrame:CGRectMake(0, KNavBarHeight, kScreenWidth, 0.5)];
    line.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.15];
    [self.view addSubview:line];
    
    searchTf=[[UITextField alloc]initWithFrame:CGRectMake(16, 29, kScreenWidth-16-61, 27)];
    searchTf.backgroundColor=[UIColor customColorWithString:@"#eeeeee"];
    searchTf.font=[UIFont fontWithName:TextFontName size:13];
    searchTf.layer.masksToBounds=YES;
    searchTf.layer.cornerRadius=2.f;
    [searchTf setPlaceholder:@"输入在播主题 主播昵称" withFont:[UIFont fontWithName:TextFontName size:13] color:[UIColor customColorWithString:@"#c8c8c8"]];
    searchTf.clearsOnBeginEditing=YES;
    searchTf.clearButtonMode=UITextFieldViewModeWhileEditing;
    searchTf.textColor=[UIColor customColorWithString:@"0d0e0d"];
    searchTf.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    
    [navView addSubview:searchTf];
    
    
    UIView * leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 32, 27)];
    
    
    UIImageView * tfLeftImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7.5, 12, 12)];
    tfLeftImage.image=[UIImage imageNamed:@"btn_search"];
    [leftView addSubview:tfLeftImage];
    searchTf.leftView=leftView;
    searchTf.leftViewMode=UITextFieldViewModeAlways;
   
    
    UIButton * cancleButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-61, searchTf.y, 61, searchTf.height)];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor customColorWithString:@"#0d0e0d"] forState:UIControlStateNormal];
    cancleButton.titleLabel.font=[UIFont fontWithName:TextFontName size:15];
    [navView addSubview:cancleButton];
    [cancleButton addTarget:self action:@selector(pressCancleButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    

}
-(void)pressCancleButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavView];
    
    self.themeDataArray = @[@"#主要看气质",@"#老友记",@"#小清新",@"#小旗帜",@"#主要看气质",@"#这个是用来测试的我想看看一个超级长的标题会不会出现问题",@"宇宙超级无敌小清新"];
    
    self.nicknameDataArray = @[@"candy520",@"敲代码的兔子",@"loloo",@"那个红线是个什么玩意?"];
    
    
    [self creatThemeView];
    
    [self creatNicknameView];
    
    [self updateView];

    
    
}

- (void)creatThemeView
{
    self.themeView = [[SearchOptionView alloc] initWithFrame:CGRectMake(0, KNavBarHeight, kScreenWidth, 0) Title:@"主播主题"];
    
    [self.view addSubview:self.themeView];
    
    
    __weak SearchViewController * wSelf = self;
    self.themeView.itemBlock = ^(NSInteger tag){
        
        
        NSString * text = wSelf.themeDataArray[tag];
        NSLog(@"点击了%@",text);
    };
}

- (void)creatNicknameView
{
    self.nicknameView = [[SearchOptionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nicknameView.frame), kScreenWidth, 0) Title:@"主播昵称"];
    
    [self.view addSubview:self.nicknameView];
    
    
    __weak SearchViewController * wSelf = self;
    self.nicknameView.itemBlock = ^(NSInteger tag){
        
        
        NSString * text = wSelf.nicknameDataArray[tag];
        NSLog(@"点击了%@",text);
    };
}


- (void)updateView
{
    [self.themeView updateViewWithDataArray:self.themeDataArray Color:[UIColor customColorWithString:@"ea8b5e"]];
    self.themeView.height = CGRectGetMaxY(self.themeView.backView.frame);
    
    
    
    [self.nicknameView updateViewWithDataArray:self.nicknameDataArray Color:[UIColor customColorWithString:@"7baf42"]];
    self.nicknameView.height = CGRectGetMaxY(self.nicknameView.backView.frame);
    self.nicknameView.y = CGRectGetMaxY(self.themeView.frame);
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
