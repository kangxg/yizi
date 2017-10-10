//
//  EnumHeader.h
//  YiziTV
//
//  Created by 梁飞 on 16/6/23.
//  Copyright © 2016年 JQ. All rights reserved.
//

#ifndef EnumHeader_h
#define EnumHeader_h


#endif /* EnumHeader_h */
typedef NS_ENUM(NSInteger, GoldCoinTag)
{
   IAP0p12=12,
   IAP1p50,
   IAP2p108,
   IAP3p518,
   IAP4p1148,
   IAP5p4998,
    
};

//购买金币的枚举


//编辑用
typedef NS_ENUM(NSInteger, ActionSheetTag){
    
    EN_EditHeadImageTag=501,
    EN_EditGrandTag,
    
} ;

//硬件权限枚举
typedef NS_ENUM(NSInteger, YZDeviceErrorStatus) {
     AVDeviceNOErrorStatus  =0,//都开了
     AudioDeviceErrorStatus = 1,//麦克风没开,相机开
     VedioDeviceErrorStatus,//相机没开，麦克风开
     AVDeviceErrorStatus, //都没开
    
  
};


//聊天室文本消息类型

typedef NS_ENUM(NSInteger, YZTVChatMessageType)
{
    //普通文字内容
    ChatMessageTypeText,
    //礼物
    ChatMessageTypeGift,
    //名片
    ChatMessageTypeCard,
    
    //加关注
    ChatMessageTypeFocus,
    
    //进图聊天室消息
    ChatMessageTypeEnter,
    
    //被禁言
    ChatMessageTypeAddMute,
    
    //解除禁言
     ChatMessageTypeRemoveMute,
    
};



//显示键盘类型

typedef NS_ENUM(NSInteger,YZKeyboardType){
    
    //无
    YZAudienceKeyboardNull,
    //键盘
    YZAudienceKeyboardNomal,
    //礼物
    YZAudienceKeyboardGift,
    //分享
    YZAudienceKeyboardShare,
    //名片
    YZAudienceKeyboardCard,
    
    

};


//编辑信息textFiled
typedef NS_ENUM(NSInteger, YZTVEeditCardInfoType)
{
    YZTVEeditCardInfoName=0,
    YZTVEeditCardInfoPhone,//1
    YZTVEeditCardInfoCity,
    YZTVEeditCardInfoSchool,
    YZTVEeditCardInfoProsession,
    YZTVEeditCardInfoTime,//5
    YZTVEeditCardInfoWantJob,
    

};

//付费类型
typedef NS_ENUM(NSInteger, YZTVPayType)
{
    YZTVPayShareType,
    YZTVPayGoldType,

};

//自定义消息类型
typedef NS_ENUM(NSInteger, YZTVCustomMessageType)

{
    //发送礼物
    GiftCustomMesaagaType=1000,
    
    //下麦消息
    CloseLiveCustomMessagefoType=1020,
    
    //发送卡片
    CardInfoCustomMessagefoType=2000,
   
    

};

//错误消息类型
typedef NS_ENUM(NSInteger, YZErrorCodeType)

{   //金币不足
    
     YZErrorOneCodeGoldShort=170,
    //批量送礼物余额不足
     YZErrorCodeGoldShort=180,
    //
    
    
};

//分享类型
typedef NS_ENUM(NSInteger, YZShareType)

{   //主播分享
    YZShareAnchorType=1,
    //观众分享
    YZShareAudienceType,
    
    //名片分享
    YZShareCardType,
    
    
};

//分享【平台

typedef NS_ENUM(NSInteger, YZSharePlatformType)
{
   YZShareWXType,
   YZShareWXFriendType,
   YZShareQQType,
   YZShareTypeQQZoneType,
   YZShareReportType,
};


//主播类型
typedef NS_ENUM(NSInteger,YZTVAnchorType) {
//普通主播
 YZTVAnchorTypeNomal,
 YZTVAnchorTypeSigned,

};


//礼物动画类型
typedef NS_ENUM(NSInteger,YZTVGiftAnimationType) {

    //默认小动画
    YZTVGiftAnimationNomal=0,
    //前途光明
    YZTVGiftAnimationBox,
    
    YZGiftAnimationMiniCooper,
    
    

};

//版本更新状态
typedef NS_ENUM(NSInteger,YZUpdateVisionType) {

    YZUpdateVisionNullType,
    YZUpdateVisionNeedType,
    YZUpdateVisionMustType,
    
};
