//
//  UrlRequest.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/18.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "UrlRequest.h"
#import "UrlConstantKey.h"

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <CommonCrypto/CommonDigest.h>
#import "iToast.h"


@implementation UrlRequest

+(AFHTTPSessionManager*)getRequstManager
{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval=30.0;
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    return manager;
}

/**
 * POST请求调用方法 不加密
 */
+(void)postRequestWithUrl:(NSString *)urlStr parameters:(NSDictionary *)praDict success:(void (^)(NSDictionary * jsonDict))success fail:(void (^)(NSError *))fail
{
    AFHTTPSessionManager * manager=[self getRequstManager];
    NSString * url=[NSString stringWithFormat:@"%@/%@",kBaseURL,urlStr];
    NSLog(@"%@",url);
    [manager POST:url parameters:praDict progress:^(NSProgress * _Nonnull uploadProgress) {
      
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        success(responseObject);

        int code=[[responseObject valueForKey:@"code"]intValue];
        if (code) {
            [self executeCodeWithcode:code msg:[responseObject valueForKey:@"msg"]];

        }
        

        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            
            
            fail(error);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [WKProgressHUD dismissAll:YES];
            });

            if (error.code==-1001) {
    
                
                [[iToast makeText:@"请求超时，请检查您的网络" ] show];
                
            }else
            {
                 [[iToast makeText:[NSString stringWithFormat:@"连接服务器%ld",error.code] ] show];
            }

        }
        NSLog(@"error:%@", error);
        
    }];
    
    
}


#pragma mark 请求数据成功后对于不同的code执行不同的操作
+(void)executeCodeWithcode:(int)code  msg:(NSString * )msg
{

    switch (code) {
        case 100:
        {
        
             [[iToast makeText:msg ] show];
            
            
        }
            break;
        case 110:
        {
        [[iToast makeText:msg ] show];
        }
            break;
        case 120:
        {
        
            [[UserManager shareInstaced]exitLogin];
            
            
        }
            break;
        case 130:
        {
            [[iToast makeText:msg ] show];
        
        }
            break;
        case 140:
        
        {
        
           [[iToast makeText:msg ] show];
           
        }
             break;
        case 150:
        {
           [[iToast makeText:msg ] show];
            
        }break;
            
        default:
            break;
    }


}
/**
 *  GET请求调用方法 不加密
 */
+(void)getRequestWithUrl:(NSString *)urlStr success:(void (^)(NSDictionary * jsonDict))success fail:(void (^)(NSError *))fail
{
    AFHTTPSessionManager * manager=[self getRequstManager];
    NSString * url=[NSString stringWithFormat:@"%@/%@",kBaseURL,urlStr];
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        

        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableDictionary * dic=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        success(responseObject);
        int code=[[dic valueForKey:@"code"]intValue];
        if (code) {
            [self executeCodeWithcode:code msg:[dic valueForKey:@"msg"]];
            
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
        
    }];
    
    

}

/*** 上传图片 不加密 ***/
+(void)uploadImageWithUrl:(NSString *)urlStr imagefileName:(NSString*)name imageData:(NSData *)imagedata parameters:(id)parameters  success:(void (^)(NSDictionary * jsonDic))success fail:(void (^)(NSError * error))fail;
{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
   
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSString * url=[NSString stringWithFormat:@"%@/%@",kBaseURL,urlStr];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
        NSTimeInterval interval=[[NSDate date]timeIntervalSince1970];
        [formData appendPartWithFileData:imagedata name:name fileName:[NSString stringWithFormat:@"%ff.jpg",interval] mimeType:@"multipart/form-data"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        
        int code=[[responseObject valueForKey:@"code"]intValue];
        if (code) {
            [self executeCodeWithcode:code msg:[responseObject valueForKey:@"msg"]];
            
        }
        

        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
    
    
}

@end
