//
//  RequestPublicKey.h
//  YiziTV
//
//  Created by 井泉 on 16/6/18.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface RequestPublicKey : NSObject
{

}
+ (NSString*)getPublicKey:(NSString*)port URL:(NSString *)urlStr ;
@end
