//
//  ChatTableViewCell.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/30.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatCellData.h"

@interface ChatTableViewCell : UITableViewCell
@property(strong,nonatomic)ChatCellData * cellData;
-(void)setCellData:(ChatCellData *)cellData;

@end
