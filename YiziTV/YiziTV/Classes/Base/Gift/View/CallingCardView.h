//
//  CallingCardView.h
//  YiziTV
//
//  Created by 井泉 on 16/7/4.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardInfoModel.h"
@interface CallingCardView : UIView



@property(strong,nonatomic)CardInfoModel * cardInfoModel;

-(void)setCardInfoModel:(CardInfoModel *)cardInfoModel;

@end
