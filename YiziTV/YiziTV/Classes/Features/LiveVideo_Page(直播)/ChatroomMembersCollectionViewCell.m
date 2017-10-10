//
//  ChatroomMembersCollectionViewCell.m
//  YZJOB-2
//
//  Created by 梁飞 on 16/3/5.
//  Copyright © 2016年 lfh. All rights reserved.
//

#import "ChatroomMembersCollectionViewCell.h"

@implementation ChatroomMembersCollectionViewCell
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        
        self.headImageView=[[UIImageView alloc]initWithFrame:self.bounds];
        self.headImageView.layer.masksToBounds=YES;
        self.headImageView.layer.cornerRadius=self.frame.size.width/2;
        self.headImageView.backgroundColor=[UIColor redColor];
        [self addSubview:self.headImageView];
        
//       self.assistantIcon=[[UIImageView alloc]initWithFrame:CGRectMake(25, 25, 11, 11)];
//        [self addSubview:self.assistantIcon];

        
    }
    
    return self;

}
@end
