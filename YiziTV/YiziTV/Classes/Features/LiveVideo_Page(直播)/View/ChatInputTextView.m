//
//  ChatInputTextView.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/1.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "ChatInputTextView.h"

@implementation ChatInputTextView
- (void)setPlaceHolder:(NSString *)placeHolder {
    if([placeHolder isEqualToString:_placeHolder]) {
        return;
    }
    _placeHolder = placeHolder;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customUI];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveTextDidChangeNotification:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
    }
    return self;
}
- (void)setFrame:(CGRect)frame{
    if (self.frame.size.width != frame.size.width) {
        [self setNeedsDisplay];
    }
    [super setFrame:frame];
}

- (void)customUI
{
    self.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 8.0f, 10.0f, 0.0f);
    self.contentInset = UIEdgeInsetsZero;
    self.scrollEnabled = YES;
    self.scrollsToTop = NO;
    self.userInteractionEnabled = YES;
    self.font = [UIFont fontWithName:TextFontName size:12];
    self.textColor = [UIColor customColorWithString:@"0d0e0d"];
    self.backgroundColor = [UIColor clearColor];
    self.keyboardAppearance = UIKeyboardAppearanceDark;
    self.keyboardType = UIKeyboardTypeDefault;
    self.returnKeyType = UIReturnKeySend;
    self.textAlignment = NSTextAlignmentLeft;
}

#pragma mark - Notifications

- (void)didReceiveTextDidChangeNotification:(NSNotification *)notification {
    
    if ((UITextView*)notification.object==self) {
        
        NSLog(@"+++++(UITextView*)notification.object+++++++++");
          [self setNeedsDisplay];
    }
  
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect
{
    
    [super drawRect:rect];
    
    
    if([self.text length] == 0 && self.placeHolder.length) {
        CGRect placeHolderRect = CGRectMake(10.0f,
                                            9.0f,
                                            rect.size.width,
                                            rect.size.height);
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = self.textAlignment;
        
        [self.placeHolder drawInRect:placeHolderRect
                      withAttributes:@{ NSFontAttributeName : self.font,
                                        NSForegroundColorAttributeName : [UIColor customColorWithString:@"555655"],
                                        NSParagraphStyleAttributeName : paragraphStyle }];
    }
}


- (void)dealloc {
    _placeHolder = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
