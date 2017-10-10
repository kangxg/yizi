//
//  EditTextModel.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/22.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 编辑多项的时候用
 占位符
 标题
 
 */
@interface EditTextModel : NSObject

//标题
@property(copy,nonatomic) NSString * editTitle;
//placehold
@property(copy,nonatomic) NSString * editPlaceholder;

@end
