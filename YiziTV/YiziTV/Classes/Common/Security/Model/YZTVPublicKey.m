//
//  PublicKey.m
//  YiziTV
//
//  Created by 井泉 on 16/6/19.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "YZTVPublicKey.h"

@implementation YZTVPublicKey


+ (instancetype)keyWithDict:(NSDictionary *)dic;
{
    YZTVPublicKey *_publicKey = [[self alloc] init];
    _publicKey.publicKey = dic[@"publicKey"];
    _publicKey.sign =dic[@"sign"];

    return _publicKey;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.publicKey forKey:@"publicKey"];
    [aCoder encodeObject:self.sign forKey:@"sign"];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.publicKey = [aDecoder decodeObjectForKey:@"publicKey"];
        self.sign = [aDecoder decodeObjectForKey:@"sign"];

    }
    return self;
}
@end
