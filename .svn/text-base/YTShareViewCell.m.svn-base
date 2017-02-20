//
//  YTShareViewCell.m
//  78S_iOS
//
//  Created by brant on 2017/2/17.
//  Copyright © 2017年 Yanteng. All rights reserved.
//

#import "YTShareViewCell.h"

@interface YTShareViewCell ()

@property (nonatomic, strong) UIImageView *logoImageView;;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YTShareViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.logoImageView];
        [self addSubview:self.titleLabel];
        [self layout];
    }
    
    return self;
}

- (void)layout {
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.width.equalTo(@36);
        make.height.equalTo(@36);
//        make.centerX.equalTo(@40);
        make.left.equalTo(@22);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.logoImageView.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
}

- (void)setShareItemModel:(YTShareItemModel *)shareItemModel {
    _shareItemModel = shareItemModel;
    
    self.logoImageView.image = [UIImage imageNamed:shareItemModel.image];
    self.titleLabel.text = shareItemModel.title;
}

#pragma mark - setters/getters

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [UIImageView new];
    }
    
    return _logoImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    }
    
    return _titleLabel;
}

@end
