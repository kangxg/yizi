//
//  LiveInfoModel.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/20.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "BaseDataModel.h"

@interface LiveInfoModel : BaseDataModel


//ID
@property(copy,nonatomic)NSString  * uid;

//是否休息中
@property(assign,nonatomic)BOOL isRest;

//直播封面地址
@property(copy,nonatomic)NSString * liveCoverImageUrl;

//直播者头像
@property(copy,nonatomic)NSString * headImageUrl;

//观看数
@property(assign,nonatomic)long long lookerCount;

//直播者昵称
@property(copy,nonatomic)NSString * nickName;

//直播主题
@property(copy,nonatomic)NSString * liveTheme;

//房间ID
@property(copy,nonatomic)NSString * roomID;

//拉流地址
@property(copy,nonatomic)NSString * playUrl;


//主播类型
@property(assign,nonatomic)YZTVAnchorType anchorType;

@end
