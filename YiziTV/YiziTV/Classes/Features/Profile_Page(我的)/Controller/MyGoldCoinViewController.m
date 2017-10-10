//
//  MyGoldCoinViewController.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/21.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "MyGoldCoinViewController.h"
#import <StoreKit/StoreKit.h>


@interface MyGoldCoinViewController ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>
{
    int buyType;
    
    UILabel * goldCoinLabel;
    
    UIView * rechargeBackView;
    
    WKProgressHUD  * hud;
}
@end

//在内购项目创建的商品单号

#define ProductID_IAP0p12 @"com.whcl.yiziTV01" //12
#define ProductID_IAP1p50 @"com.whcl.yiziTV02" //50
#define ProductID_IAP2p108 @"com.whcl.yiziTV03" //108
#define ProductID_IAP3p518 @"com.whcl.yiziTV04" //518
#define ProductID_IAP4p1148 @"com.whcl.yiziTV07" //1148
#define ProductID_IAP5p4998 @"com.whcl.yiziTV08" //4998

@implementation MyGoldCoinViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"我的金币";
    
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
    
   
    [self createUI];
    
    

}
-(void)createUI
{
    
    UIImageView * iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-103/2, KNavBarHeight+20, 103, 103)];
    if (iPhone4) {
        iconImage.frame=CGRectMake(kScreenWidth/2-53/2, KNavBarHeight+20, 53, 53);
    }
    iconImage.image=[UIImage imageNamed:@"coin"];
    [self.view addSubview:iconImage];

    UILabel * label=[UILabel setLabelFrame:CGRectMake(20, CGRectGetMaxY(iconImage.frame)+20, kScreenWidth-40, 15) Text:@"当前金币余额" TextColor:[UIColor customColorWithString:@"909290"] font:[UIFont fontWithName:TextFontName size:13] textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:label];
    
    
    goldCoinLabel=[UILabel setLabelFrame:CGRectMake(25, CGRectGetMaxY(label.frame)+10, kScreenWidth-50, 50) Text:self.infoModel.goldCoinCount TextColor:[UIColor customColorWithString:@"0d0e0d"] font:[UIFont fontWithName:TextFontName size:50] textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:goldCoinLabel];
    
    
    UIView * line=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(goldCoinLabel.frame)+10, kScreenWidth, 0.5)];
    line.backgroundColor=[UIColor customColorWithString:@"dfdfdf"];
    [self.view addSubview:line];
    
    
    rechargeBackView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame)+25, kScreenWidth, 110)];
    [self.view addSubview:rechargeBackView];
    
    CGFloat buttonWidth=(kScreenWidth-50-30)/3;
    
    NSArray * goldCoinArray=@[@"1200",@"5000",@"10800",@"51800",@"114800",@"499800"];
    
    NSArray * moneyArray=@[@"¥12",@"¥50",@"¥108",@"¥518",@"¥1148",@"¥4998"];
    for (int i=0; i<moneyArray.count; i++) {
        
        UIButton* button=[[UIButton alloc]initWithFrame:CGRectMake(25+(buttonWidth+10)*(i%3), (50+10)*(i/3), buttonWidth, 50)];
        button.layer.masksToBounds=YES;
        button.layer.cornerRadius=4.0;
        button.layer.borderColor=[[UIColor customColorWithString:@"ea8b5e"]CGColor];
        button.layer.borderWidth=0.5;
        
        UILabel * goldLabel=[UILabel setLabelFrame:CGRectMake(0, 10, buttonWidth, 16) Text:[goldCoinArray objectAtIndex:i] TextColor:[UIColor customColorWithString:@"ea8b5e"]  font:[UIFont fontWithName:TextFontName size:16] textAlignment:NSTextAlignmentCenter];
        goldLabel.tag=101+i;
        [button addSubview:goldLabel];
        
        
        UILabel * moneyLabel=[UILabel setLabelFrame:CGRectMake(0, 50-10-12, buttonWidth, 12) Text:[moneyArray objectAtIndex:i] TextColor:[UIColor customColorWithString:@"ea8b5e"]  font:[UIFont fontWithName:TextFontName size:12] textAlignment:NSTextAlignmentCenter];
        moneyLabel.tag=201+i;
        [button addSubview:moneyLabel];
        
        
        button.tag=12+i;
        [rechargeBackView addSubview:button];
        if (i==0) {
            button.selected=YES;
            goldLabel.textColor=[UIColor whiteColor];
            moneyLabel.textColor=goldLabel.textColor;
            button.backgroundColor=[UIColor customColorWithString:@"ea8b5e"];
        }
        
        [button addTarget:self action:@selector(selectMoney:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    UIButton * finfishButton=[[UIButton alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(rechargeBackView.frame)+25, kScreenWidth-50, 50)];
    finfishButton.layer.masksToBounds=YES;
    finfishButton.layer.cornerRadius=5.f;
    finfishButton.backgroundColor=[UIColor customColorWithString:@"ea8b5e"];
    [finfishButton setTitle:@"立即充值" forState:UIControlStateNormal];
    [finfishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    finfishButton.titleLabel.font=[UIFont fontWithName:TextFontName size:17];
    [self.view addSubview:finfishButton];
    
    [finfishButton addTarget:self action:@selector(clickFinishButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * explainLabel=[UILabel setLabelFrame:CGRectMake(0, CGRectGetMaxY(finfishButton.frame)+13,kScreenWidth, 15) Text:@"如有问题,请联系客服:010-58515065" TextColor:[UIColor customColorWithString:@"909290"] font:[UIFont fontWithName:TextFontName size:13] textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:explainLabel];
    
    
    
}
-(void)clickFinishButton
{

    for (UIButton * button in rechargeBackView.subviews) {
        if (button.selected) {
            [self buyWithType:(int)button.tag];
            
        }
    }


}
-(void)selectMoney:(UIButton*)btn
{
    for (UIButton * button in rechargeBackView.subviews) {
        if (button.tag==btn.tag) {
            button.selected=YES;
            button.backgroundColor=[UIColor customColorWithString:@"ea8b5e"] ;
            UILabel * label1=[button viewWithTag:101+button.tag-12];
            UILabel * label2=[button viewWithTag:201+button.tag-12];
            label1.textColor=[UIColor whiteColor];
            label2.textColor=[UIColor whiteColor];
        }else{
        
            button.selected=NO;
            button.backgroundColor=[UIColor whiteColor];
            UILabel * label1=[button viewWithTag:101+button.tag-12];
            UILabel * label2=[button viewWithTag:201+button.tag-12];
            label1.textColor=[UIColor customColorWithString:@"ea8b5e"];
            label2.textColor=[UIColor customColorWithString:@"ea8b5e"];
            
        }
    }
}
-(void)buyWithType:(int)type
{
    buyType=type;
    if ([SKPaymentQueue canMakePayments]) {
       NSLog(@"允许程序内付费购买");
        hud = [WKProgressHUD showInView:self.navigationController.view withText:@"" animated:YES];

         [self RequestProductData];
        
    }else
    {
    
        NSLog(@"不允许程序内付费购买");
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您禁止了应用内购买权限,请到设置中开启"
                                                           delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        
        [alerView show];

    }
    
}
-(void)RequestProductData
{
    
    NSLog(@"---------请求对应的产品信息------------");
    NSArray *product = nil;
    switch (buyType) {
        case IAP0p12:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP0p12,nil];
            break;
        case IAP1p50:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP1p50,nil];
            break;
        case IAP2p108:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP2p108,nil];
            break;
        case IAP3p518:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP3p518,nil];
            break;
        case IAP4p1148:
            product=[[NSArray alloc] initWithObjects:ProductID_IAP4p1148,nil];
            break;
        case IAP5p4998:
             product=[[NSArray alloc] initWithObjects:ProductID_IAP5p4998,nil];
            break;
        default:
            break;
    }
    
    
    
    

    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    request.delegate=self;
    [request start];



}

#pragma mark request delegate
//<SKProductsRequestDelegate> 请求协议
//收到的产品信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud dismiss:YES];
    });

    
    
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", (int)[myProduct count]);
    
    NSArray *products = response.products;
    SKProduct *product = [products count] > 0 ? [products objectAtIndex:0] : nil;
    
   

    if (product) {
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
               //添加付款请求到队列
        
        
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
    } else {
        //无法获取商品信息
            NSLog(@"无法获取商品信息");
    }
    NSLog(@"---------发送购买请求------------");

    
}

//请求商品错误
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud dismiss:YES];
    });

    NSLog(@"-------弹出错误信息----------");
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
    
}
-(void)requestDidFinish:(SKRequest *)request
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud dismiss:YES];
    });

    dispatch_async(dispatch_get_main_queue(), ^{
         hud = [WKProgressHUD showInView:self.navigationController.view withText:@"" animated:YES];
             
             
});
    
}









#pragma mark SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    

    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:{//交易完成
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud dismiss:YES];
                });
                [self completeTransaction:transaction];
                NSLog(@"-----交易完成 --------");
                
                
            } break;
            case SKPaymentTransactionStateFailed://交易失败
            { [self failedTransaction:transaction];
                NSLog(@"-----交易失败 --------");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud dismiss:YES];
                });
                UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"购买失败，请重新尝试购买"
                                                                    delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
                
                [alerView2 show];
                
            }break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud dismiss:YES];
                });
                [self restoreTransaction:transaction];
                 NSLog(@"-----已经购买过该商品 --------");
                
            }
                break;
            case SKPaymentTransactionStatePurchasing:
                //商品添加进列表
            
                NSLog(@"-----商品添加进列表 --------");
                
                
                break;
            default:
                break;
        }
    }
}

-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{
    
    
    
}
-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
   
}

#pragma mark end

-(void)PurchasedTransaction: (SKPaymentTransaction *)transaction{
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
}


- (void)completeTransaction: (SKPaymentTransaction *)transaction

{
    NSLog(@"-----completeTransaction--------");
 
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud dismiss:YES];
    });

    
    [WKProgressHUD showInView:self.navigationController.view withText:@"" animated:YES];

    
    
    
    NSString * pruductID;
    
    switch (buyType) {
        case IAP0p12:
            pruductID=ProductID_IAP0p12;
            break;
        case IAP1p50:
            pruductID=ProductID_IAP1p50;
            break;
        case IAP2p108:
            pruductID=ProductID_IAP2p108;
            break;
        case IAP3p518:
            pruductID=ProductID_IAP3p518;
            break;
        case IAP4p1148:
            pruductID=ProductID_IAP4p1148;
            break;
        case IAP5p4998:
            pruductID=ProductID_IAP5p4998;
            break;
        default:
            break;
    }

    
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    NSString * receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    
    
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:receiptString forKey:@"receipt_data"];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    [paramDic setValue:user.deviceId forKey:@"deviceId"];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:pruductID forKey:@"product_id"];
    NSLog(@"凭证Data%@ 凭证:%@",receiptData,receiptString);
    
        [UrlRequest postRequestWithUrl:kUploadReceiptUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        
        
       
        NSLog(@"金币服务器返回-----%@",jsonDict);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [WKProgressHUD dismissAll:YES];
        });
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            double gold=[[jsonDict valueForKey:@"user_gold"]doubleValue];
            
            self.infoModel.goldCoinCount=[NSString stringWithFormat:@"%.0f",gold];
            
            goldCoinLabel.text=[NSString stringWithFormat:@"%.0f",gold];
            
            UIAlertView * aler=[[UIAlertView alloc]initWithTitle:@"恭喜" message:@"充值成功！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [aler show];

        }else if (code==160)
        {
            UIAlertView * aler=[[UIAlertView alloc]initWithTitle:@"充值异常" message:@"请静待客服处理OR致电客服催促:010--58515605" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [aler show];
            
        }            
        
        
    } fail:^(NSError *error) {
        
    }];
    
    
    
    

    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}
//记录交易
-(void)recordTransaction:(NSString *)product{
    NSLog(@"-----记录交易--------");
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    NSLog(@"-----下载--------");
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"失败");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}


- (void)restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@" 交易恢复处理");
    
    
    
}




-(void)backToLastController
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
