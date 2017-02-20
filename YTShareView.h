//
//  YTShareView.h
//  78S_iOS
//
//  Created by brant on 2017/2/17.
//  Copyright © 2017年 Yanteng. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YTShareModel.h"

typedef void(^YTShareCompletionHandler)(bool isSuccess, YTShareType type); // 是否成功

@interface YTShareView : UIView

+ (void)showInView:(UIView *)view shareModel:(YTShareModel *)shareModel completeionHandler:(YTShareCompletionHandler)handler;

@end
