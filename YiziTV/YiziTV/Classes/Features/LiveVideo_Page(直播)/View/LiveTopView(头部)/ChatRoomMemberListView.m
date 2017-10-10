//
//  ChatRoomMemberListView.m
//  YiziTV
//
//  Created by 梁飞 on 16/7/14.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "ChatRoomMemberListView.h"
#import "ChatroomMembersCollectionViewCell.h"
#import "ChatRoomManager.h"
#import "NIMChatroomMember.h"
#import "ShowMemberInfoView.h"

@interface ChatRoomMemberListView ()<UICollectionViewDelegate,UICollectionViewDataSource>

{
    UICollectionView * memberListView;
    
    NSMutableArray * memberArr;
    
    NSString * _roomID;
   
    UIActivityIndicatorView *indicatorView;
    
}

@end

@implementation ChatRoomMemberListView
-(instancetype)initWithRoomId:(NSString *)roomId
{
    CGRect newRect=CGRectMake(0, -59, kScreenWidth, 59);
    self=[super initWithFrame:newRect];
    if (self) {
        _roomID=roomId;
        memberArr=[NSMutableArray array];
        [self refreshRoomMemberList];
        [self createUI];
    }
    return self;
    
}
-(void)setIsAnchorAction:(BOOL)isAnchorAction
{
    _isAnchorAction=isAnchorAction;
}
-(void)refreshRoomMemberList
{
    [[ChatRoomManager shareManager]getChatroomMemberInblock:^(NSMutableArray *returnMembers) {
        
        if (returnMembers.count>1) {
            [returnMembers removeObjectAtIndex:0];
            memberArr=returnMembers;
            [memberListView reloadData];
        }
       
        
        
    } RoomID:_roomID];
}
-(void)refreshRoomMemberList:(NSMutableArray *)roomMemberArray
{
    if (roomMemberArray.count>1) {
        [roomMemberArray removeObjectAtIndex:0];
        memberArr=roomMemberArray;
        [memberListView reloadData];
    }


}
-(void)createUI
{
    
    
    // 1.创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    // 2.设置每个格子的尺寸
    layout.itemSize = CGSizeMake(35 , 35);
    
    [layout setSectionInset:UIEdgeInsetsMake(0,15, 0, 0)];
    
    //设置最小行间距
    layout.minimumLineSpacing = 15.f;
    //设置最小列间距
    layout.minimumInteritemSpacing = 12.0;

    
    memberListView=[[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    memberListView.backgroundColor=[UIColor clearColor];
    [memberListView registerClass:[ChatroomMembersCollectionViewCell
                                   class] forCellWithReuseIdentifier:@"mmCell"];
    memberListView.delegate=self;
    memberListView.dataSource=self;
    memberListView.showsHorizontalScrollIndicator=NO;
    [self addSubview:memberListView];
    

    
    
}
#pragma mark 加载更多
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==memberListView) {
        
         if(scrollView.contentOffset.x +scrollView.width - scrollView.contentSize.width >30){
             
             
             if (indicatorView==nil) {
                 
                 indicatorView=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(scrollView.width-20, scrollView.height/2-20/2, 20, 20)];
                 indicatorView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
                 indicatorView.hidesWhenStopped=YES;
//                 [indicatorView stopAnimating];
                 [self addSubview:indicatorView];
                 
                 
             }
             
             
             if (!indicatorView.isAnimating) {
              
                  scrollView.x = -30;
                 [indicatorView startAnimating];
                 NSLog(@"成员加载更多");
                 [[ChatRoomManager shareManager]loadMoreMemberListWithRoomID:_roomID returnInblock:^(NSMutableArray *returnMembers) {

                    if (returnMembers.count>1&&returnMembers.count!=memberArr.count) {
                         NSLog(@"indicatorView stopAnimating");
                         [indicatorView stopAnimating];
                         [returnMembers removeObjectAtIndex:0];
                         memberArr=returnMembers;
                         [memberListView reloadData];
                     }else
                     {
                         scrollView.x=0;
                         [indicatorView removeFromSuperview];
                         
                     }
                     
                     
                     
                 }];
                 
             }
             
             
             
             
             
         }
        
        
    }


}
#pragma ----collectionDelegate-------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return memberArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"mmCell";
    
    ChatroomMembersCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NIMChatroomMember * member=[memberArr objectAtIndex:indexPath.row];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:member.roomAvatar] placeholderImage:nil];
    return cell;

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     NIMChatroomMember * member=[memberArr objectAtIndex:indexPath.row];
    
//    if (member.roomExt.length) {
    
    
    ChatroomMembersCollectionViewCell * cell=(ChatroomMembersCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    UIImageView * headImageView=[[UIImageView alloc]initWithFrame:cell.headImageView.bounds];
    
    headImageView.center = [[cell.headImageView superview] convertPoint:cell.headImageView.center toView:[[[UIApplication sharedApplication] delegate] window]];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:member.roomAvatar] placeholderImage:nil];
    
    
    
    ShowMemberInfoView * showInfoView=[[ShowMemberInfoView alloc]init];
    showInfoView.headImageView=headImageView;
    
    NSLog(@"isAnchorAction++++++++%d",self.isAnchorAction);
    showInfoView.uid=member.roomExt;
    showInfoView.yxUid=member.userId;
    showInfoView.isOpenSilentAction=self.isAnchorAction;
    showInfoView.isMuted=member.isTempMuted;
    showInfoView.roomID=_roomID;
    [self.superview addSubview:showInfoView];
    [showInfoView createUI];
        
//    }
    

    
    

}
-(void)showInView
{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame=CGRectMake(0, 0, self.width, self.height);
    }];
    
    
}
-(void)hiddenInView
{

    [UIView animateWithDuration:0.25 animations:^{
        self.frame=CGRectMake(0, -self.height, self.width, self.height);
    }];


}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
