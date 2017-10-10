//
//  CityViewController.h
//  YiziTV
//
//  Created by 梁飞 on 16/7/25.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "SecondLayerViewController.h"

@interface CityViewController : SecondLayerViewController

//
@property(copy,nonatomic)NSString * currentCityName;


@property(copy,nonatomic)void(^selectLiveCityName)(NSString* cityName);


@end
