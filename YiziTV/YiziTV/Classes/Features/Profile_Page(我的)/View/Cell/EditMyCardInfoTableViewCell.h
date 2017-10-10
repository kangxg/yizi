//
//  EditMyCardInfoTableViewCell.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/22.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditMyCardInfoTableViewCell : UITableViewCell
//左侧标题
@property(strong,nonatomic)UILabel * titleLabel;
//线
@property(strong,nonatomic)UIView * line;
//输入
@property(strong,nonatomic)UITextField * textFiled;

@end

//点击label

@interface SelectMyCardInfoTableViewCell : UITableViewCell
//左侧标题
@property(strong,nonatomic)UILabel * titleLabel;
//线
@property(strong,nonatomic)UIView * line;

@property(strong,nonatomic)UILabel * selectLabel;

@end


//右侧头像
@interface EditHeadImageViewTableViewCell : UITableViewCell
//左侧标题
@property(strong,nonatomic)UILabel * titleLabel;
@property(strong,nonatomic)UIImageView * headImageView;
@end