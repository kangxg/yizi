//
//  UrlRequest.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/18.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface UrlRequest : NSObject
/**
 *  GET请求调用方法 不加密
 */
+(void)getRequestWithUrl:(NSString *)urlStr success:(void (^)(NSDictionary * jsonDict))success fail:(void (^)(NSError * error))fail ;

/**
 * POST请求调用方法 不加密
 */
+(void)postRequestWithUrl:(NSString *)urlStr parameters:(NSDictionary *)praDict  success:(void (^)(NSDictionary * jsonDict))success fail:(void (^)(NSError * error))fail;

/*** 上传图片 不加密 ***/
+(void)uploadImageWithUrl:(NSString *)urlStr imagefileName:(NSString*)name imageData:(NSData *)imagedata parameters:(id)parameters  success:(void (^)(NSDictionary * jsonDic))success fail:(void (^)(NSError * error))fail;

@end
