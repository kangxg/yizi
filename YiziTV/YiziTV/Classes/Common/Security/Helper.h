//
//  Helper.h
//  YiziTV
//
//  Created by 井泉 on 16/6/19.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

////MD5
//+ (NSString *) md5:(NSString *)str;
//
////Base64
+ (NSString *)base64StringFromText:(NSString *)text;
+ (NSString *)textFromBase64String:(NSString *)base64;
+ (NSString *)base64EncodedStringFrom:(NSData *)data;
//
////DES加密
//+(NSString *)encryptSting:(NSString *)sText key:(NSString *)key andDesiv:(NSString *)ivDes;
//
////DES解密
//+(NSString *)decryptWithDESString:(NSString *)sText key:(NSString *)key andiV:(NSString *)iv;

//AES加密
+ (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv withNSData:(NSData *)data;

//AES解密
+ (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv withNSData:(NSData *)data;

@end