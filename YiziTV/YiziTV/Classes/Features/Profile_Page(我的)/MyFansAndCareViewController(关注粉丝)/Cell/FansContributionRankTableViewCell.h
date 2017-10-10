//
//  FansContributionRankTableViewCell.h
//  YiziTV
//
//  Created by 梁飞 on 16/7/20.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FansModel.h"

@interface FansContributionRankTableViewCell : UITableViewCell

@property(strong,nonatomic)FansModel * fansModel;

-(void)setFansModel:(FansModel *)fansModel;

-(void)setSingImageView:(NSString*)imageName;

@end

//三名之后的
@interface FansContributionTableViewCell : UITableViewCell

@property(strong,nonatomic)FansModel * fansModel;

-(void)setFansModel:(FansModel *)fansModel;

-(void)setRankName:(NSString*)rank;

@end