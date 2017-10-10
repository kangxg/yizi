//
//  PublicKey.h
//  YiziTV
//
//  Created by 井泉 on 16/6/19.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZTVPublicKey : NSObject<NSCoding>
@property (nonatomic, copy) NSString *publicKey;
@property (nonatomic, copy) NSString *sign;

+ (instancetype)keyWithDict:(NSDictionary *)dic;
@end
