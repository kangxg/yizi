//
//  UrlConstantKey.m
//  YiziTV
//
//  Created by 梁飞 on 16/6/18.
//  Copyright © 2016年 JQ. All rights reserved.
//

#import "UrlConstantKey.h"

@implementation UrlConstantKey
//线上 正式服务器
NSString * const kBaseURL = @"http://app.yizi.tv";

//
//NSString * const kBaseURL = @"http://123.125.226.166";
//获取验证码
NSString * const kSecurityCodeUrl=@"passport/SendPhoneCode.a";
//手机登录
NSString * const kPhoneLoginActionUrl=@"passport/login/PhoneLoginAction.a";
//第三方登陆(联合登录接口)
NSString * const kJointLoginActionUrl=@"passport/login/JointLoginAction.a";

//初始化信息接口
NSString * const kShowInfoUrl=@"mobile/InitAction.a";

//上交支付凭证
NSString * const kUploadReceiptUrl=@"mobile/pay/IosPayAction.a?reportTransaction";

//获取用户信息接口
NSString * const kGetUserInfoUrl=@"mobile/user/UserInfoAction.a?getUserInfo";

//修改用户信息接口
NSString * const kEditUserInfoUrl=@"mobile/user/UserInfoAction.a?editUserInfo";

//修改用户头像
NSString * const kEditUserHeadImageUrl=@"mobile/user/UserInfoAction.a?editUserHeadPhoto";

//大厅接口
NSString * const kGetHomeDataUrl=@"mobile/HallAction.a";

//获取我的名片接口
NSString * const kGetMyCardUrl=@"mobile/card/MyBussinessCard.a?getCard";

//获取用户金币接口
NSString * const kGetMyGoldCoinUrl=@"mobile/user/UserGoldAction.a?getUserGold";

//保存我的名片
NSString * const kSaveMyCardInfoUrl=@"mobile/card/MyBussinessCard.a?saveCard";

//获取我收到的名片
NSString * const kGetMyReceiveCardsUrl=@"mobile/card/BusinessCardMailboxAction.a?receiveCardList";

//修改我的封面信息
NSString * const kEditMyCoverImageUrl=@"mobile/user/UserInfoAction.a?editUserPoppic";
//绑定手机号
NSString * const kBindPhoneUrl = @"mobile/user/UserInfoAction.a";

//我的粉丝列表
NSString * const kMyFansListUrl=@"mobile/user/FollowAction.a?myFansList";

//我的关注列表

NSString * const kMyFocusListUrl=@"mobile/user/FollowAction.a?myFollowList";


//关注 接口
NSString * const kFocusActionUrl=@"mobile/user/FollowAction.a?doFollow";

//取消关注接口
NSString * const kCancleFocusActionUrl=@"mobile/user/FollowAction.a?canelFollow";

//是否实名认证
NSString * const kIsCerIDnumUrl=@"mobile/user/UserInfoAction.a?isRealNameAuth";
//实名认证接口
NSString * const kCerIDNumUrl=@"mobile/user/UserInfoAction.a?doRealNameAuth";

//意见反馈接口
NSString * const kSuggestUrl=@"mobile/ProposeAction.a?iosReportPropose";

//开始推流地址
NSString * const kBeginPushLiveUrl=@"mobile/room/RoomAction.a?onMic";

//结束推流，下麦
NSString * const kStopPushLiveUrl=@"mobile/room/RoomAction.a?underMic";

//查询是否关注用户接口
NSString * const kQueryWheatherFocusUrl=@"mobile/user/FollowAction.a?isFollow";
//礼物列表接口
NSString * const kGiftListUrl=@"mobile/goods/GoodsAction.a?findGoodsList";

//赠送礼物
NSString * const kSendGiftUrl=@"mobile/goods/GoodsAction.a?giveGift";

//分享
NSString * const kShareUrl=@"mobile/share/ShareAction.a?iosShare";

//获取主播礼物数
NSString * const kGetAnchorGiftCountUrl=@"mobile/goods/GoodsAction.a?getAnchorReceiveGiftCount";

//发送名片
NSString * const kSenCardUrl=@"mobile/card/BusinessCardMailboxAction.a?sendCard";

//批量发送礼物
NSString * const kBatchSendGiftUrl=@"mobile/goods/GoodsAction.a?giveGiftList";

//粉丝贡献榜
NSString * const kFansContributionUrl=@"mobile/ranking/RankingAction.a?fansContributionRanking";

//按照ID查询指定用户信息接口
NSString * const kGetUserInfoWithUidUrl=@"mobile/user/UserInfoAction.a?serachUserInfo";

//版本更新
NSString * const kUpdateVision=@"mobile/version/VersionAction.a?iosUpdateVersion";


////禁言用户接口
NSString * const kAddMuteActionUrl=@"mobile/room/RoomAction.a?doMute";

//解除禁言接口
NSString * const kRemoveMuteActionUrl=@"mobile/room/RoomAction.a?cancelMute";


//位置城市信息列表
NSString * const kPositionCityListUrl=@"mobile/HallAction.a?positionCityList";


@end
