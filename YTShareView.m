//
//  YTShareView.m
//  78S_iOS
//
//  Created by brant on 2017/2/17.
//  Copyright © 2017年 Yanteng. All rights reserved.
//

#import "YTShareView.h"
#import "YTShareViewCell.h"
#import "YTShareModel.h"
#import <ShareSDK/ShareSDK.h>

static CGFloat YTShareItemHeight = 80;

@interface YTShareView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) YTShareModel *shareModel;

@property (nonatomic) CGFloat contentHeight;

@property (nonatomic, copy) YTShareCompletionHandler completionHandler;


@end

@implementation YTShareView

- (instancetype)initWithShareModel:(YTShareModel *)shareModel frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _shareModel = shareModel;
        
        [self calculateContent];
        
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.closeButton];
        
        [self.contentView addSubview:self.collectionView];
        
        [self layout];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.contentView];
    
    if (point.y < 0) {
        // 点在外面
        [self hide];
    }
}

#pragma mark - public

+ (void)showInView:(UIView *)view shareModel:(YTShareModel *)shareModel completeionHandler:(YTShareCompletionHandler)handler {
    YTShareView *shareView = [[YTShareView alloc] initWithShareModel:shareModel frame:view.bounds];
    shareView.completionHandler = handler;
    
    [view addSubview:shareView];
    
    [shareView showAnimation];
}

#pragma mark - private

- (void)showAnimation {
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    @weakify(self);
    [UIView animateWithDuration:0.5 animations:^{
        @strongify(self);
        [self layoutIfNeeded];
    }];
}

- (void)hide {
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(self.contentHeight);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)calculateContent {
    
    // 有定制选项
    _contentHeight = 15 + 15 + 40;
    int row = (int) self.shareModel.shareTypes.count / 4 + 1; // 行数
    _contentHeight += row * YTShareItemHeight;
    
    for (NSNumber *num in self.shareModel.shareTypes) {
        YTShareItemModel *model = [self itemModelWithType:[num integerValue]];
        [self.items addObject:model];
    }
    
}

- (void)layout {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@(self.contentHeight));
        make.bottom.equalTo(self.mas_bottom).offset(-self.contentHeight);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentView.mas_top).offset(15);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.contentView.mas_right);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.top.equalTo(self.titleLabel.mas_top).offset(40);
    }];
}

- (YTShareItemModel *)itemModelWithType:(YTShareType)type {
    YTShareItemModel *model = [[YTShareItemModel alloc] init];
    switch (type) {
        case YTShareTypeQQ:
            model.image = @"share_qq";
            model.title = @"QQ";
            break;
        case YTShareTypeCopy:
            model.image = @"share_copy";
            model.title = @"复制链接";
            break;
        case YTShareTypeQzone:
            model.image = @"share_qzone";
            model.title = @"QQ空间";
            break;
        case YTShareTypeWeibo:
            model.image = @"share_weibo";
            model.title = @"微博";
            break;
        case YTShareTypeWechat:
            model.image = @"share_wechat";
            model.title = @"微信";
            break;
        case YTShareTypeMessage:
            model.image = @"share_message";
            model.title = @"短信";
            break;
        case YTShareTypeWechatMoment:
            model.image = @"share_wechat_moment";
            model.title = @"朋友圈";
            break;
            
        default:
            break;
    }
    
    return model;
}

#pragma mark - delegate

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YTShareViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YTShareViewCell class]) forIndexPath:indexPath];
    
    YTShareItemModel *item = self.items[indexPath.row];
    cell.shareItemModel = item;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YTShareItemModel *item = self.items[indexPath.row];
    
    //分享链接
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    SSDKPlatformType platForm = SSDKPlatformTypeWechat;
    NSString *shareDesc = self.shareModel.desc;
    
    // 平台
    switch (item.type) {
            
            // 微信
        case YTShareTypeWechat:
            platForm = SSDKPlatformTypeWechat;
            if (self.shareModel.wechatFriendsDesc && self.shareModel.wechatFriendsDesc.length > 0) {
                shareDesc = self.shareModel.wechatFriendsDesc;
            }
            
            break;
            
            // 微信朋友圈
        case YTShareTypeWechatMoment:
            platForm = SSDKPlatformSubTypeWechatTimeline;
            break;
            
            // QQ平台
        case YTShareTypeQQ:
            platForm = SSDKPlatformTypeQQ;
            break;
            
            // QQ空间
        case YTShareTypeQzone:
            platForm = SSDKPlatformSubTypeQZone;
            break;
            
            // 新浪微博
        case YTShareTypeWeibo:
            platForm = SSDKPlatformTypeSinaWeibo;
            break;
            
            // 短信
        case YTShareTypeMessage:
            platForm = SSDKPlatformTypeSMS;
            break;
            
        case YTShareTypeCopy:
            platForm = SSDKPlatformTypeCopy;
            break;
    }
    
    // 分享设置
    if (platForm == SSDKPlatformTypeSMS) {
        
        NSString *text = [NSString stringWithFormat:@"%@%@", self.shareModel.title, self.shareModel.url];
        [shareParams SSDKSetupSMSParamsByText:text
                                        title:nil
                                       images:nil
                                  attachments:nil
                                   recipients:nil
                                         type:SSDKContentTypeText];
    }
    else {
        
        [shareParams SSDKSetupShareParamsByText:shareDesc
                                         images:self.shareModel.img
                                            url:[NSURL URLWithString:self.shareModel.url]
                                          title:self.shareModel.title
                                           type:SSDKContentTypeAuto];
    }
    
    
    
    // 执行分享
    @weakify(self);
    [ShareSDK share:platForm
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         DLog(@"error:%@", error);
         @strongify(self);
         switch (state) {
             case SSDKResponseStateSuccess:
                 self.completionHandler(YES, item.type);
                 break;
             case SSDKResponseStateFail:
                 self.completionHandler(NO, item.type);
                 break;
             default:
                 break;
         }
         
         [self hide];
     }];
}

#pragma mark - getters/setters

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.size.height, self.size.width, 0)];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    
    return _contentView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        // 注册cell
        [_collectionView registerClass:[YTShareViewCell class] forCellWithReuseIdentifier:NSStringFromClass([YTShareViewCell class])];
    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(YTShareItemHeight, YTShareItemHeight);
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _flowLayout.minimumLineSpacing = 5.0;
        _flowLayout.minimumInteritemSpacing = 5.0;
    }
    
    return _flowLayout;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageNamed:@"live_guanbianniu_icon"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"将直播分享到社交网络";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"222222"];
    }
    
    return _titleLabel;
}

- (NSMutableArray *)items {
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
    }
    
    return _items;
}

@end
