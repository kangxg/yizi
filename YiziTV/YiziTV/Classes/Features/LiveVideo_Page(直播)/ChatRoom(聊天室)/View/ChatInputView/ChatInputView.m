//
//  ChatInputView.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/1.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "ChatInputView.h"

@implementation ChatInputView
-(instancetype)initWithFrame:(CGRect)frame
{

    self=[super initWithFrame:frame];
    if (self) {
       
        self.maxTextLength=2000;
        self.backgroundColor=[UIColor clearColor];
        [self initUIComponents];
        
        

        
    }
    
    return self;
}


- (void)initUIComponents
{

    if (_inputView==nil) {
        _inputView=[[ChatInputTextView alloc]initWithFrame:CGRectZero];
       
        _inputView.layer.backgroundColor=[[[UIColor whiteColor]colorWithAlphaComponent:0.8]CGColor];
        _inputView.layer.masksToBounds=YES;
        _inputView.layer.borderWidth=0.5;
        _inputView.layer.borderColor=[[[UIColor blackColor]colorWithAlphaComponent:0.25] CGColor];
        _inputView.delegate=self;
        [self addSubview:_inputView];
        
    }
    
}

//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    
////    [textView becomeFirstResponder];
//}
//
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
////    [textView resignFirstResponder];
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self sendText:textView];
        return NO;
    }
    NSString *str = [textView.text stringByAppendingString:text];
    if (str.length > self.maxTextLength) {
        return NO;
    }
    return YES;
}
-(void)sendText:(UITextView *)textView
{
    
    if ([self.inputDelegate respondsToSelector:@selector(clickSendMessageButtonWithMessage:)]&& [textView.text length] > 0) {
        
        NSString * text=textView.text;
        [self.inputDelegate clickSendMessageButtonWithMessage:text];
        textView.text = @"";
//       [textView layoutIfNeeded];
        
    }
    
//    if ([self.actionDelegate respondsToSelector:@selector(onSendText:)] && [textView.text length] > 0)
//    {
//        [self.actionDelegate onSendText:textView.text];
//        textView.text = @"";
//        [textView layoutIfNeeded];
//        [self inputTextViewToHeight:[self getTextViewContentH:textView]];;
//    }
//
    
    
}
-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
