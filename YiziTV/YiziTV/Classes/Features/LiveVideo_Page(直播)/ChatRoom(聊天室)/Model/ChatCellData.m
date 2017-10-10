//
//  ChatCellData.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/30.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "ChatCellData.h"
#import "NSString+React.h"

#define chatLabelMaxWidth  kScreenWidth*0.618-18-15-14


@implementation ChatCellData
-(id)initWoithSessionModel:(ChatSessionModel *)sessionModel
{

    self=[super init];
    if (self) {
    
        _sessionModel=sessionModel;
        _yztvMessageType=sessionModel.yztvMessageType;

        switch (sessionModel.yztvMessageType) {
            case ChatMessageTypeText:
            {
                NSString * content=[NSString stringWithFormat:@"%@:%@",sessionModel.cardInfoModel.nickName,sessionModel.text];
                
                [self showMessageUIWithContent:content];
               _bubbleImageName=@"message_black";
                
                
                
                
            }
                break;
                
                
           case ChatMessageTypeGift:
            {
              _bubbleImageName=@"message_black";
            NSString * content=[NSString stringWithFormat:@"%@ %@",sessionModel.cardInfoModel.nickName,sessionModel.text];
                _giftImageUrl=sessionModel.giftModel.giftImageUrl;
                [self showGiftMessageUIWithContent:content];
            
            }
                break;
            case ChatMessageTypeCard:
            {
                _bubbleImageName=@"message_black";

                NSString * content=[NSString stringWithFormat:@"%@ %@",sessionModel.cardInfoModel.nickName,sessionModel.text];
                [self showMessageUIWithContent:content];
            }
                break;
            case ChatMessageTypeFocus:
            {
                _bubbleImageName=@"message_black";

                NSString * content=[NSString stringWithFormat:@"%@ %@",sessionModel.cardInfoModel.nickName,sessionModel.text];
                 [self showMessageUIWithContent:content];

            }
                break;
                
            case ChatMessageTypeEnter:
            {
                _bubbleImageName=@"message_black";

                NSString * content=[NSString stringWithFormat:@"%@ %@",sessionModel.cardInfoModel.nickName,sessionModel.text];
                [self showMessageUIWithContent:content];
            
            }
                break;
                
            case ChatMessageTypeAddMute:
            {
                _bubbleImageName=@"message_black";
                
                NSString * content=[NSString stringWithFormat:@"%@ %@",sessionModel.cardInfoModel.nickName,sessionModel.text];
                [self showMessageUIWithContent:content];

            
            }
                break;
            case ChatMessageTypeRemoveMute:
            {
            
                _bubbleImageName=@"message_black";
                
                NSString * content=[NSString stringWithFormat:@"%@ %@",sessionModel.cardInfoModel.nickName,sessionModel.text];
                [self showMessageUIWithContent:content];

            }
                break;
            default:
                break;
        }
        
    }
    return self;
}
-(void)showGiftMessageUIWithContent:(NSString*)content
{
     _contentString=[[NSMutableAttributedString alloc]initWithString:content];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:TextFontName size:14],NSFontAttributeName,[UIColor customColorWithString:@"beff77"],NSForegroundColorAttributeName, nil];
      [_contentString addAttributes:attrsDictionary range:NSMakeRange(0,_sessionModel.cardInfoModel.nickName.length)];
    
    CGFloat contentWidth=[content getWidthWithAttributeString:_contentString  labelheight:15];
    
        if (contentWidth<chatLabelMaxWidth-40) {
        
        _contentWidth=contentWidth;
        _contentHeight=13;
        _bubbleWidth=contentWidth+15+14+40;
        _bubbleHeight=_contentHeight+8+14;
        _cellRowHeight=_bubbleHeight+3;
        
        
    }else
    {
        
        
        CGFloat contentHeight=[content getHeightWithAttributeString:_contentString labelwidth:chatLabelMaxWidth-40];
        
        
        CGFloat height=contentHeight;
        _contentWidth=chatLabelMaxWidth-40;
        _contentHeight=height;
        _bubbleHeight=_contentHeight+8+14;
        _bubbleWidth=chatLabelMaxWidth+15+14;
        _cellRowHeight=_bubbleHeight+3;
        
        
    }

    


}

-(void)showMessageUIWithContent:(NSString*)content
{

    _contentString=[[NSMutableAttributedString alloc]initWithString:content];
    
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:TextFontName size:14],NSFontAttributeName,[UIColor customColorWithString:@"beff77"],NSForegroundColorAttributeName, nil];
    
    [_contentString addAttributes:attrsDictionary range:NSMakeRange(0,_sessionModel.cardInfoModel.nickName.length+1)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:3];
    
    [_contentString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    
    
    
    CGFloat contentWidth=[content getWidthWithAttributeString:_contentString  labelheight:15];
    
    //                NSLog(@"maxWidth=====%f",chatLabelMaxWidth);
    //                NSLog(@"contentWidth======%f",contentWidth);
    if (contentWidth<chatLabelMaxWidth) {
        
        _contentWidth=contentWidth;
        _contentHeight=13;
        _bubbleWidth=contentWidth+15+14;
        _bubbleHeight=_contentHeight+8+14;
        _cellRowHeight=_bubbleHeight+3;
        
        
    }else
    {
        
        
        CGFloat contentHeight=[content getHeightWithAttributeString:_contentString labelwidth:chatLabelMaxWidth];
        
        
        CGFloat height=contentHeight;
        _contentWidth=chatLabelMaxWidth;
        _contentHeight=height;
        _bubbleHeight=_contentHeight+8+14;
        _bubbleWidth=chatLabelMaxWidth+15+14;
        _cellRowHeight=_bubbleHeight+3;
        
        
    }

}
@end
