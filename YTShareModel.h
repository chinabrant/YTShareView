//
//  YTShareModel.h
//  78S_iOS
//
//  Created by brant on 2017/2/17.
//  Copyright © 2017年 Yanteng. All rights reserved.
//

#import <Foundation/Foundation.h>

// 定制分享项，定制各项的位置，各项分享方案可能不同
typedef NS_ENUM(NSInteger, YTShareType) {
    YTShareTypeWechat = 0,
    YTShareTypeWechatMoment,
    YTShareTypeQQ,
    YTShareTypeWeibo,
    YTShareTypeMessage,
    YTShareTypeQzone,
    YTShareTypeCopy
};

@interface YTShareModel : NSObject

@property (nonatomic, copy) NSString *title;    // 分享的标题
@property (nonatomic, copy) NSString *desc;     // 分享的描述
@property (nonatomic, copy) NSString *url;      // 分享的url
@property (nonatomic, copy) NSString *img;      // 分享的图片

@property (nonatomic, copy) NSString *wechatFriendsDesc;    // 微信好友定制分享描述，设置了这个项，当分享到微信好友时，desc属性不起做用

// 定制分享项, 会按传值的顺序放置图标 例如： @[@(YTShareTypeWechat), @(YTShareTypeWeibo), @(YTShareTypeWechatMoment), @(YTShareTypeQQ), @(YTShareTypeQzone), @(YTShareTypeMessage), @(YTShareTypeCopy)]
@property (nonatomic, strong) NSArray *shareTypes;

@end
