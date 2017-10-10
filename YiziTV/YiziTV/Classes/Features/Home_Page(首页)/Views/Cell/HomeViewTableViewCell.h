//
//  HomeViewTableViewCell.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/20.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveInfoModel.h"
@interface HomeViewTableViewCell : UITableViewCell

@property(strong,nonatomic)LiveInfoModel * infoModel;

-(void)setInfoModel:(LiveInfoModel *)infoModel;

-(void)beginZoomAnimation:(void (^)(BOOL finish))handler;
@end
