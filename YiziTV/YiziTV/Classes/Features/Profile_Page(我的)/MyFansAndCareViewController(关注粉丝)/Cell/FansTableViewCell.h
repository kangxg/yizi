//
//  FansTableViewCell.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/28.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardInfoModel.h"

@interface FansTableViewCell : UITableViewCell
@property(strong,nonatomic)CardInfoModel * model;
@property(strong,nonatomic)UIImageView * headImageView;

@property(strong,nonatomic)UILabel * nameLabel;

@property(strong,nonatomic) UIButton * addButton;

@property(strong,nonatomic)UIView * line;

-(void)setModel:(CardInfoModel *)model;
@end
