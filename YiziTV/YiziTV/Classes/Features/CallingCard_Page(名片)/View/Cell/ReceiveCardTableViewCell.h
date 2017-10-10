//
//  ReceiveCardTableViewCell.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/21.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardInfoModel.h"

@interface ReceiveCardTableViewCell : UITableViewCell
@property(strong,nonatomic)CardInfoModel * cardModel;

-(void)setCardModel:(CardInfoModel *)cardModel;

@end
