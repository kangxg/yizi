//
//  RequestPublicKey.m
//  YiziTV
//
//  Created by 井泉 on 16/6/18.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "RequestPublicKey.h"
#import "UrlConstantKey.h"
#import "DeviceInfo.h"

#import "UrlRequest.h"
#import "UrlConstantKey.h"

#import "NSData+AES.h"
#import "GTMBase64.h"

#import "YZTVPublicKey.h"
#import "Helper.h"
#define AESKey @"o2t0NHcRC9sA82EXByGE6C14zRl8nBxkBNislDfvdjfId9wage4WS0NdBjw4EpgIix58Xx8UWvrg7UI9e5PWwtLdoTou1J9Oi3GhwzLtdwS0AcNhCrvxaxA6jkoi2TXa"

@implementation RequestPublicKey


+(AFHTTPSessionManager*)getRequstManager
{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval=30.0;
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
   //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    return manager;
}

+ (NSString*)getPublicKey:(NSString*)port URL:(NSString *)urlStr 
{
    NSLog(@"设备号:%@", [DeviceInfo getUser_agent]);
    NSString *TestPublicKey = @"MMfuoKJ+QjoPxBgY3aNBBg==";
    //检测网络是否畅通
    NSString *networkTest = [DeviceInfo networkingStatesFromStatebar];
    
    if (![networkTest  isEqual: @"notReachable"]) {
        NSLog(@"网络畅通:%@", networkTest);
    }
    else{
        NSLog(@"请检查网络:%@", networkTest);

    }
    //--------------------------------------------------------------

    NSData* xmlData = [TestPublicKey dataUsingEncoding:NSUTF8StringEncoding];
    NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:TestPublicKey options:0];//base64解码没问题
    
    //加密
    NSData *aesEnData = [Helper AES128EncryptWithKey:@"1234567890123456" iv:@"1" withNSData:[@"abc" dataUsingEncoding:NSASCIIStringEncoding]];

    NSString* encodeResult = [aesEnData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSLog(@"encodeResult is:%@",encodeResult);

    //解密
    //        NSData *publicKey_De64 = [Helper base64EncodedStringFrom:TestPublicKey];
    //AES
    NSData* decodeData1 = [[NSData alloc] initWithBase64EncodedString:TestPublicKey options:0];
    NSData *aesDeData = [Helper AES128DecryptWithKey:@"123456" iv:@"1" withNSData:decodeData1];
    
    NSString* decodeStr = [[NSString alloc] initWithData:aesDeData encoding:NSASCIIStringEncoding];
    
    //        publicKey_De64 = [GTMBase64 decodeString:[Helper base64EncodedStringFrom:aesEnData]];
    
    //        NSString *aesEnStr = ;;
    NSLog(@"AES256aesEnStr is:%@",[[@"abc" dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:@"123456"] );
    NSLog(@"aesEnStr is:%@",[[[@"abc" dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:@"123456"] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]);//Log is HZKhnRLlQ8XjMjpelOAwsQ==
    //--------------------------------------------------------------
    AFHTTPSessionManager * manager=[self getRequstManager];
    
    //创建一个可变字典
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    //往字典里面添加需要提交的参数
//    [parametersDic setObject:[DeviceInfo getUser_agent] forKey:@"deviceId"];
//    [parametersDic setObject:@"IOS" forKey:@"deviceType"];
//    [parametersDic setObject:@"" forKey:@"getRsaPublicKey"];
    parametersDic[@"deviceId"] = [DeviceInfo getUser_agent];
    parametersDic[@"deviceType"] = @"IOS";
    parametersDic[@"getRsaPublicKey"] = @"jq";
    
    NSString * url=[NSString stringWithFormat:@"%@:%@/%@",kBaseURL, port, urlStr];
    NSLog(@"请求接口:%@", url);
//    @"http://123.125.226.166:8010/HallAction.a"
//    [manager POST:url parameters:parametersDic progress:^(NSProgress * _Nonnull uploadProgress) {
//    
//    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
//        YZTVPublicKey *getKey = [YZTVPublicKey keyWithDict:responseObject];
//        
        
//        NSData* xmlData = [TestPublicKey dataUsingEncoding:NSUTF8StringEncoding];
//        NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:TestPublicKey options:0];//base64解码没问题
//        
//        //加密
//        NSData *aesEnData = [Helper AES128EncryptWithKey:@"123456" iv:@"1" withNSData:[@"abc" dataUsingEncoding:NSASCIIStringEncoding]];
//        
//        NSString* encodeResult = [aesEnData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//        
//        //解密
//        //        NSData *publicKey_De64 = [Helper base64EncodedStringFrom:TestPublicKey];
//        //AES
//        NSData* decodeData1 = [[NSData alloc] initWithBase64EncodedString:TestPublicKey options:0];
//        NSData *aesDeData = [Helper AES128DecryptWithKey:@"123456" iv:@"1" withNSData:decodeData1];
//        
//        NSString* decodeStr = [[NSString alloc] initWithData:aesDeData encoding:NSASCIIStringEncoding];
//
////        publicKey_De64 = [GTMBase64 decodeString:[Helper base64EncodedStringFrom:aesEnData]];
//        
////        NSString *aesEnStr = ;;
//        NSLog(@"aesEnStr is:%@",[[NSString alloc] initWithData:[aesEnData AES256EncryptWithKey:@"123456"]  encoding:NSASCIIStringEncoding]);//Log is HZKhnRLlQ8XjMjpelOAwsQ==
    
//        NSData *aesDeData = [Helper AES128DecryptWithKey:AESKey iv:AESKey withNSData:aesEnData];
//        NSString *aesDEStr = [Helper base64EncodedStringFrom:aesDeData];
//        NSString *result = [Helper textFromBase64String:aesDEStr];
//        NSLog(@"aesDEStr is %@ and result is %@",aesDEStr,result);//Log is aesDEStr is 5oiR54ix5L2gAAAAAAAAAA== and result is 我爱你

//        NSLog(@"网络成功:%@", responseObject);
//
//        NSLog(@"网络成功:%@", responseObject[@"publicKey"]);
//        
//        NSData *publicKey_De64 = [GTMBase64 decodeString:TestPublicKey];
//        NSData *decodedAESData_test = [Helper AES128DecryptWithKey:AESKey iv:AESKey withNSData:publicKey_De64];
//
//        
//        NSData *aesDeData = [Helper AES128DecryptWithKey:AESKey iv:AESKey withNSData:publicKey_De64];
//        NSString *aesDEStr = [Helper base64EncodedStringFrom:aesDeData];
//        NSString *result = [Helper textFromBase64String:aesDEStr];
//        
//        NSString *decodedBase64String = [[NSString alloc] initWithData:aesDeData encoding:NSASCIIStringEncoding];
//        NSLog(@"解码Base64:%@", result);
//        
////        NSData *decodedAESData = [publicKey_De64 AES256DecryptWithKey:AESKey];
//        NSData *decodedAESData = [Helper AES128DecryptWithKey:AESKey iv:AESKey withNSData:publicKey_De64];
//        NSString *decodedAESString = [[NSString alloc] initWithData:decodedAESData encoding:NSUTF8StringEncoding];
////
//        NSLog(@"解码AES:%@", decodedAESString);
////        NSData *decodedBase64_2String = [[NSData alloc] initWithBase64EncodedString:decodedBase64String options:0];
//        NSLog(@"解码De64_2:%@", [Helper base64EncodedStringFrom:[GTMBase64 decodeString:aesDEStr]]);
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"网络错误1:%@", error);
//    }];
    
//    NSString *str = @"VsmcRX+T01PBMqJlcCcYJldzyJ2RwDyUij6LSa34VZMKIOqyZDLEjGp1u0UpijAna4FKC22XkhxbAlE7xQYTTPPsfY20jsndL3sT6Aek5ReB18NKFHSsaGAvkLw061/pEvEYsrE/iflKJ1yG9rTsDVDWgRtb/9FAP73xUOhqLSLt/94brUnH16jcn4uJSYxGB5YVbYxyFXtOUn328/CMnnyGkb8OODrwXzD+XapMK2g1q0X1chy14vljzJiyKlLXHie9+ayi+89qf+Cz1M45cb6q/DbL7uTRrNrgKxPl6TY=";
    
    NSString *base64String = @"foo";
    // 解码
//    NSData *data = [GTMBase64 decodeString:str];
    // 使用UTF8编码方式初始化数据库
//    NSString *decodeString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
//    NSString *base64EncodedString = [[str dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    


//    [manager POST:@"http://123.125.226.166:8010/HallAction.a" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"网络成功:%@", responseObject);
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"网络错误1:%@", error);
//
//    }];
    
    return @"e";
}

@end
