//
//  DS_PhotoAlbumCell.m
//  WeChat
//
//  Created by wangyang on 16/6/21.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "DS_PhotoAlbumCell.h"
#import "DS_PhotoAssets.h"

@interface DS_PhotoAlbumCell ()
@property (nonatomic,strong)UIImageView *selectedImageView;
@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation DS_PhotoAlbumCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.selectedImageView];
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
    
    [self.selectedImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(27, 27));
        make.top.mas_equalTo(weakSelf.contentView).offset(3);
        make.right.mas_equalTo(weakSelf.contentView).offset(-3);
    }];
    [super updateConstraints];
}

- (void)selectedClicked
{
    if ([self.delegate respondsToSelector:@selector(photoAlbumCellClicked:withIndexPathItem:)]) {
        [self.delegate photoAlbumCellClicked:self withIndexPathItem:_index];
    }
}

#pragma mark - setter and getter
- (void)setAssertModel:(DS_PhotoAssets *)assertModel
{
    _assertModel = assertModel;
    self.imageView.image = assertModel.thumbImage;
    if (assertModel.isSelected) {
        self.selectedImageView.image = [UIImage imageNamed:@"DS_ChoosePhotoHL.png"];
    }else {
        self.selectedImageView.image = [UIImage imageNamed:@"DS_ChoosePhoto.png"];
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIImageView *)selectedImageView
{
    if (!_selectedImageView) {
        _selectedImageView = [[UIImageView alloc] init];
        _selectedImageView.image = [UIImage imageNamed:@"DS_ChoosePhoto.png"];
        _selectedImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedClicked)];
        [_selectedImageView addGestureRecognizer:tap];
    }
    return _selectedImageView;
}
@end
