//
//  GiftInfoModel.h
//  YiziTV
//
//  Created by 井泉 on 16/7/1.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftInfoModel : NSObject
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *giftname;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger presentCount;

//ID
@property (nonatomic,copy)NSString * giftId;

//商品原价
@property (nonatomic,copy)NSString * originalPrice;
//商品当前价格
@property (nonatomic,copy)NSString * currentPrice;

//商品图片
@property (nonatomic,copy)NSString * giftImageUrl;

//礼物动画类型
@property (nonatomic,assign)YZTVGiftAnimationType animationType;

//用户id
@property (nonatomic,copy)NSString * uid;
//云信ID
@property (nonatomic,copy)NSString * yxID;



-(void)analysisGiftInfoWithDic:(NSDictionary*)dict;

@end
