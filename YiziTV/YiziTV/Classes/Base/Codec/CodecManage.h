//
//  CodecManage.h
//  YiziTV
//
//  Created by 井泉 on 16/6/18.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CodecManage : NSObject


- (NSString*)EncodeURL:(NSArray*)inputArray;
- (NSString*)DecodeURL:(NSString*)inputStr;
@end
