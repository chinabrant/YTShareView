//
//  YTShareModel.m
//  78S_iOS
//
//  Created by brant on 2017/2/17.
//  Copyright © 2017年 Yanteng. All rights reserved.
//

#import "YTShareModel.h"

@implementation YTShareModel

- (NSArray *)shareTypes {
    if (!_shareTypes) {
        _shareTypes = @[@(YTShareTypeWechat), @(YTShareTypeWeibo), @(YTShareTypeWechatMoment), @(YTShareTypeQQ), @(YTShareTypeQzone), @(YTShareTypeMessage), @(YTShareTypeCopy)];
    }
    
    return _shareTypes;
}

@end
