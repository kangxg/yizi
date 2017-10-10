//
//  ChatRoomSessionView.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/30.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "ChatRoomSessionView.h"
#import "ChatTableViewCell.h"
#import "ChatCellData.h"



@interface ChatRoomSessionView ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView * chatgradiedView;
}

@end


@implementation ChatRoomSessionView






-(instancetype)initWithRoomID:(NSString *)roomId
{
    CGRect sessionFrame=CGRectMake(0, kScreenHeight-(ChatScreenHeight+kTabBarHeight), kScreenWidth, ChatScreenHeight+ChatGiftView_Height+kTabBarHeight);
    NSLog(@" kScreenHeight-(ChatScreenHeight+kTabBarHeight)%f", kScreenHeight-(ChatScreenHeight+kTabBarHeight));
    self=[super initWithFrame:sessionFrame];
    if (self) {
        
        _roomID=roomId;
        
        chatgradiedView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ChatScreenWidth,ChatScreenHeight)];
        [self addSubview:chatgradiedView];
        
         [self setGrayView];
        
        self.cellDataArray=[NSMutableArray array];
        self.sessionArray=[NSMutableArray array];
        
       
        
        chatTableView=[[UITableView alloc]initWithFrame:chatgradiedView.bounds style:UITableViewStylePlain];
        chatTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        chatTableView.backgroundColor=[UIColor clearColor];
        chatTableView.delegate=self;
        chatTableView.dataSource=self;
        chatTableView.showsVerticalScrollIndicator=NO;
        chatTableView.userInteractionEnabled=YES;
        //反转
        chatTableView.transform = CGAffineTransformMakeScale (1,-1);
        [chatgradiedView addSubview:chatTableView];
        
        
        

       
        
    }
    
    return self;
}
-(void)setGrayView
{
    
    // Add Shine
    CAGradientLayer *gradiedtLayer = [[CAGradientLayer alloc] init];
    gradiedtLayer.frame = CGRectMake(0, 0, chatgradiedView.width, chatgradiedView.height);
    gradiedtLayer.colors = [NSArray arrayWithObjects:(id)[[[UIColor blackColor] colorWithAlphaComponent:0] CGColor],
                            (id)[[[UIColor blackColor] colorWithAlphaComponent:1] CGColor],
                            nil];
    
    gradiedtLayer.locations =
    [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
     [NSNumber numberWithFloat:1],
     nil];
    
    gradiedtLayer.startPoint = CGPointMake(0, 0);
    gradiedtLayer.endPoint = CGPointMake(0, 0.2);
    chatgradiedView.layer.mask=gradiedtLayer;
   
    
    
    


}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sessionArray.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[ChatTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
    }
    cell.transform = CGAffineTransformMakeScale (1,-1);
    NSInteger index=self.cellDataArray.count-1-indexPath.row;
    ChatCellData * cellModel=[self.cellDataArray objectAtIndex:index];
    [cell setCellData:cellModel];
    
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSInteger index=self.cellDataArray.count-1-indexPath.row;
    ChatCellData * cellModel=[self.cellDataArray objectAtIndex:index];
    return cellModel.cellRowHeight;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 0.0000000001;
}

-(void)refreshUI
{
    
    if (self.cellDataArray.count) {
        
    [chatTableView reloadData];
        
    [chatTableView  scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        

    
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}
-(YZKeyboardType)getKeyboardType
{
    return keyboardType;
}
-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    
}

-(void)showNomalKeyBoardWithKeyBoardHeight:(CGFloat)keyBoardHeight
{
    
    

}


-(void)hideNomalKeyBoard
{

    

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
