//
//  DS_PhotoAlbumCell.m
//  WeChat
//
//  Created by wangyang on 16/6/21.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "DS_PhotoAlbumCell.h"

@implementation DS_PhotoAlbumCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    WEAKSELF;
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf);
    }];
    [super updateConstraints];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
@end
