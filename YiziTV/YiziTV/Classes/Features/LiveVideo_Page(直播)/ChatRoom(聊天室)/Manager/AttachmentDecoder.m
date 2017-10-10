//
//  AttachmentDecoder.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/4.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "AttachmentDecoder.h"
#import "ChatRoomManager.h"


@implementation AttachmentDecoder
- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content{
    //所有的自定义消息都会走这个解码方法，如有多种自定义消息请自行做好类型判断和版本兼容。这里仅演示最简单的情况。
    
    NSLog(@"++++++收到自定义消息都会走这个解码+++++++++");
    id<NIMCustomAttachment> attachment;
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        
         dispatch_async(dispatch_get_main_queue(), ^{
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            NSLog(@"++++++++++自定义消息内容====%@",dict);
            
            
            NSInteger customMessageType=[[dict valueForKey:kCustomMessageType]integerValue];
            
            switch (customMessageType) {
                //礼物
                case GiftCustomMesaagaType:
                {
                    [self analysisGiftMessage:dict];
                }
                    break;
                //名片
                case CardInfoCustomMessagefoType:
                {
                
                    [self analysisCardInfoMessage:dict];
                
                }
                    break;
                    
                case CloseLiveCustomMessagefoType:
                {
                
                    [[ChatRoomManager shareManager]anchorOverLiveMessage];
                    
                
                }break;
                    
                    
                default:
                    break;
            }
            
            
            
        }
         });
        
    }
    return attachment;
}
-(void)analysisGiftMessage:(NSDictionary*)giftDic
{
   
    [[ChatRoomManager shareManager]dealGiftMessage:giftDic];

}
-(void)analysisCardInfoMessage:(NSDictionary*)cardInfoDic
{
    [[ChatRoomManager shareManager]dealCardInfoMessage:cardInfoDic];
}
@end
