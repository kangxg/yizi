//
//  PhoneCodeResponse.h
//  YiziTV
//
//  Created by 井泉 on 16/6/24.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneCodeResponseModel : NSObject

@property (nonatomic, copy) NSString *phoneCode;

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *sign;

+ (instancetype)keyWithDict:(NSDictionary *)dic;

@end
