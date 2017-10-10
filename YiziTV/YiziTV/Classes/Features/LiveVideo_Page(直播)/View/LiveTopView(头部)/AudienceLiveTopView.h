//
//  AudienceLiveTopView.h
//  YiziTV
//
//  Created by 梁飞 on 16/7/1.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "LiveTopView.h"
#import "LiveInfoModel.h"

/*
 观众看到的头部
 */
@interface AudienceLiveTopView : LiveTopView
@property(strong,nonatomic)LiveInfoModel * liveInfoModel;
-(void)setLiveInfoModel:(LiveInfoModel *)liveInfoModel;


@end
