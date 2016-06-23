//
//  DS_PhotoAlbumGroupCell.m
//  WeChat
//
//  Created by wangyang on 16/6/23.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "DS_PhotoAlbumGroupCell.h"
#import "DS_PhotoPickerGroup.h"
#import "UILabel+DSAdaptContent.h"

@interface DS_PhotoAlbumGroupCell ()

@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *numLabel;

@end

@implementation DS_PhotoAlbumGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.numLabel];
        [self.contentView setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    WEAKSELF;
    [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.mas_equalTo(weakSelf.contentView);
        make.width.mas_equalTo(weakSelf.frame.size.height);
    }];
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(weakSelf.contentView);
        make.left.mas_equalTo(weakSelf.iconImageView.mas_right).offset(15);
    }];
    [self.titleLabel setContentHuggingWithLabelContent];
    
    [self.numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(weakSelf.contentView);
        make.left.mas_equalTo(weakSelf.titleLabel.mas_right).offset(20);
        make.right.mas_equalTo(weakSelf.contentView).offset(-15);
    }];
    [super updateConstraints];
}

- (void)setGroupModel:(DS_PhotoPickerGroup *)groupModel
{
    _groupModel = groupModel;
    self.iconImageView.image  = groupModel.thumbImage;
    self.titleLabel.text = groupModel.groupName;
    self.numLabel.text = [NSString stringWithFormat:@"(%ld)",groupModel.assetsCount];
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _numLabel.textColor = [UIColor grayColor];
    }
    return _numLabel;
}
@end
