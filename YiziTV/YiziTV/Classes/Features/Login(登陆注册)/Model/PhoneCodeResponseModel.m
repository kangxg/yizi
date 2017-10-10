//
//  PhoneCodeResponse.m
//  YiziTV
//
//  Created by 井泉 on 16/6/24.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "PhoneCodeResponseModel.h"

@implementation PhoneCodeResponseModel


+ (instancetype)keyWithDict:(NSDictionary *)dic;
{
    PhoneCodeResponseModel *_phoneCode = [[self alloc] init];
    
    _phoneCode.code = dic[@"code"];
    _phoneCode.msg =dic[@"msg"];
    _phoneCode.sign =dic[@"sign"];
    
    return _phoneCode;
}
@end
