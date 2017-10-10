//
//  LineDashView.h
//  YiziTV
//
//  Created by 井泉 on 16/7/4.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <UIKit/UIKit.h>

@interface LineDashView : UIView

@property (nonatomic, strong) NSArray   *lineDashPattern;  // 线段分割模式
@property (nonatomic, assign) CGFloat    endOffset;        // 取值在 0.001 --> 0.499 之间

- (instancetype)initWithFrame:(CGRect)frame
              lineDashPattern:(NSArray *)lineDashPattern
                    endOffset:(CGFloat)endOffset;

@end