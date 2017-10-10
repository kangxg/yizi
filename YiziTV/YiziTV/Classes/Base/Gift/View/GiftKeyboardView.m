//
//  GiftKeyboardView.m
//  YiziTV
//
//  Created by 井泉 on 16/6/29.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "GiftKeyboardView.h"
#import "GiftInfoModel.h"
#import "GiftButtonView.h"

NSString * const goldCoinStringKey=@"goldCoinCount";

@interface GiftKeyboardView()<UIScrollViewDelegate,GiftButtonDelegate>
{
    NSMutableArray * giftArray;
    
    UIScrollView * backScrollView;
    //竖列
    int verCount;
    //横行
    int horCount;
    
    int page;
    
    //余数
    NSInteger resteNum;
    
    UIPageControl * pageControl;
    
    UIButton * sendGiftButton;
    
    UIButton * goldButton;
    
    NSMutableDictionary * selectGiftDic;
    
    
}
@end

@implementation GiftKeyboardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        horCount=2;
        giftArray=[NSMutableArray array];
        _myCardInfo=[[CardInfoModel alloc]init];
        selectGiftDic=[NSMutableDictionary dictionary];
        
        [_myCardInfo addObserver:self forKeyPath:goldCoinStringKey options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        
        self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.75];
        [self requestGiftUrl];
        
    }
    
    return self;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
  
      NSString * new =change[NSKeyValueChangeNewKey]; // 取key为new对应的值
//    NSString* old = change[NSKeyValueChangeOldKey];
    NSLog(@"new+++++++++%@",new);
    
   [goldButton setTitle:[NSString stringWithFormat:@"充值：%@金币 >",new] forState:UIControlStateNormal];

}
-(void)dealloc
{
    [self.myCardInfo removeObserver:self forKeyPath:goldCoinStringKey];
}
-(void)requestGiftUrl
{
    

    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:kDeviceId forKey:@"deviceId"];
    
    [UrlRequest postRequestWithUrl:kGiftListUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        NSLog(@"liwu=======%@",jsonDict);

        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
        
           
            NSArray * dataArr=[jsonDict valueForKey:@"data"];
            for (int i=0; i<dataArr.count; i++) {
                NSDictionary * dic=[dataArr objectAtIndex:i];
                GiftInfoModel * giftModel=[[GiftInfoModel alloc]init];
                [giftModel analysisGiftInfoWithDic:dic];
                
                [giftArray addObject:giftModel];
                
            }
            
            page=(int)giftArray.count/8;
            
            verCount=4;
            
            
            
            [self createUI];
            [self refreshGoldCoin];
            
        }
        
    } fail:^(NSError *error) {
        
    }];
    
    //
    
    



}
-(void)refreshGoldCoin
{
    NSMutableDictionary * paramDic=[NSMutableDictionary dictionary];
    [paramDic setValue:@"mcheck" forKey:@"mcheck"];
    [paramDic setValue:kDeviceId forKey:@"deviceId"];
    //获取我的金币
    UserInfoModel * user=[[UserManager shareInstaced]getUserInfoModel];
    [paramDic setValue:user.user_token forKey:@"user_token"];
    
    [UrlRequest postRequestWithUrl:kGetMyGoldCoinUrl parameters:paramDic success:^(NSDictionary *jsonDict) {
        
//        NSLog(@"我的金币----%@",jsonDict);
        int code=[[jsonDict valueForKey:@"code"]intValue];
        if (code==0) {
            
            double goldCoin=[[jsonDict valueForKey:@"user_gold"]doubleValue];
            _myCardInfo.goldCoinCount=[NSString stringWithFormat:@"%.0f",goldCoin];
            
            [self refreshUI];
            
            
            
        }
        
    } fail:^(NSError *error) {
        
    }];


    
}
-(void)refreshUI
{

    [goldButton setTitle:[NSString stringWithFormat:@"充值：%@金币 >",_myCardInfo.goldCoinCount] forState:UIControlStateNormal];
    
}
-(void)createUI
{
    
//    NSLog(@"++++++%ld++++++++++++++%ld",giftArray.count,giftArray.count%8);
    backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, ChatGiftView_Height-50)];
    backScrollView.pagingEnabled=YES;
    backScrollView.delegate=self;
    backScrollView.contentSize=CGSizeMake(kScreenWidth*page, backScrollView.height);
    backScrollView.showsHorizontalScrollIndicator=NO;
    [self addSubview:backScrollView];
    
    CGFloat giftHeight=backScrollView.height/2;
    CGFloat giftWidth=kScreenWidth/4;
    
    resteNum=giftArray.count%8;

    for (int x=0; x<page; x++) {
        
        NSLog(@"XXXXXXXXXXXX%d",x);
        for (int i=x*8; i<(x+1)*8; i++) {
            NSLog(@"iiiiiiiiiiiiiiii%d",i);
            int count=verCount+x*8;
            GiftButtonView * giftButton=[[GiftButtonView alloc]initWithFrame:CGRectMake(x*kScreenWidth+giftWidth*(i%verCount), giftHeight*(i/count), giftWidth, giftHeight)];
            
            giftButton.delegate=self;
            GiftInfoModel * giftModel=[giftArray objectAtIndex:i];
            giftButton.tag=[giftModel.giftId integerValue];
            
            [giftButton setGiftModel:giftModel];
            [backScrollView addSubview:giftButton];
            
            
        }

        
    }
    
    
       if (resteNum) {
        
    backScrollView.contentSize=CGSizeMake(kScreenWidth*page+kScreenWidth, backScrollView.height);
        
        
    for (int j=0 ; j<resteNum; j++) {
            
            GiftButtonView * giftButton=[[GiftButtonView alloc]initWithFrame:CGRectMake(kScreenWidth*page+giftWidth*(j%verCount), giftHeight*(j/verCount), giftWidth, giftHeight)];
            giftButton.delegate=self;
            GiftInfoModel * giftModel=[giftArray objectAtIndex:(giftArray.count-resteNum+j)];
           giftButton.tag=[giftModel.giftId integerValue];
           [giftButton setGiftModel:giftModel];
           [backScrollView addSubview:giftButton];
            

            
     }
        
        
    }
    
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(backScrollView.frame)+5, kScreenWidth, 5)];
    pageControl.numberOfPages=backScrollView.contentSize.width/kScreenWidth;
    pageControl.currentPage=0;
    pageControl.autoresizesSubviews=NO;
    [pageControl sizeThatFits:CGSizeMake(kScreenWidth, 5)];
    pageControl.transform=CGAffineTransformMakeScale(0.9, 0.9);
    pageControl.hidesForSinglePage=YES;
    pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
    pageControl.pageIndicatorTintColor=[UIColor customColorWithString:@"909290"];
    [self addSubview:pageControl];
    
    
    sendGiftButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-15-65, CGRectGetMaxY(pageControl.frame)+(ChatGiftView_Height-CGRectGetMaxY(pageControl.frame))/2-30/2, 65,30)];
    sendGiftButton.layer.masksToBounds=YES;
    sendGiftButton.layer.cornerRadius=4.f;
    sendGiftButton.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    sendGiftButton.titleLabel.font=[UIFont fontWithName:TextFontName size:15];
    [sendGiftButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendGiftButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
    [sendGiftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendGiftButton addTarget:self action:@selector(clickSendGiftButton) forControlEvents:UIControlEventTouchUpInside];
    
    sendGiftButton.enabled=NO;
    
    [self addSubview:sendGiftButton];
    
    
    goldButton=[[UIButton alloc]initWithFrame:CGRectMake(15, sendGiftButton.y, kScreenWidth/2-15, sendGiftButton.height)];
    [goldButton setTitleColor:[UIColor customColorWithString:@"e56e36"] forState:UIControlStateNormal];
    goldButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    
    goldButton.titleLabel.font=[UIFont fontWithName:TextFontName size:15];
    [goldButton setTitle:@"充值：0金币 >" forState:UIControlStateNormal];
    [goldButton addTarget:self action:@selector(clickGoldButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:goldButton];

    
}
-(void)clickGoldButton
{

    if ([self.delegate respondsToSelector:@selector(clickGoldCionWithMyCardInfo:)]) {
        [self.delegate clickGoldCionWithMyCardInfo:self.myCardInfo];
    }
}
-(void)clickSendGiftButton
{
    
    NSMutableArray * selectGiftArray=[NSMutableArray array];
    
    for (NSString * giftID in selectGiftDic.allValues) {
        
        [selectGiftArray addObject:giftID];
    }
    
    if ([self.delegate respondsToSelector:@selector(sendGiftsArray:)]) {
        [self.delegate sendGiftsArray:selectGiftArray];
    }
    

}
#pragma mark giftButton delegate
-(void)selectedGift:(GiftInfoModel *)giftModel
{

    [selectGiftDic setValue:giftModel.giftId forKey:giftModel.giftId];
    [self changeSendButtonUI];

}
-(void)removeGift:(GiftInfoModel *)giftModel
{
    [selectGiftDic removeObjectForKey:giftModel.giftId];
    [self changeSendButtonUI];
    

    
}
-(void)changeSendButtonUI
{
    
    if (selectGiftDic.allValues.count) {
        sendGiftButton.enabled=YES;
        sendGiftButton.backgroundColor=[UIColor customColorWithString:@"28904e"];
        
        
    }else
    {

    sendGiftButton.enabled=NO;
    sendGiftButton.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
}
-(void)refreshGift
{

    if (selectGiftDic.allValues.count) {
     
        for (NSString * giftID in selectGiftDic.allValues) {
           
           
            GiftButtonView * giftButton=[backScrollView viewWithTag: [giftID integerValue]];
            [giftButton setSelectButtonNomal];
            
        }
    }
    
    [selectGiftDic removeAllObjects];
    
    [self changeSendButtonUI];
    
   

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    pageControl.currentPage=scrollView.contentOffset.x/(kScreenWidth);
    
}
@end
