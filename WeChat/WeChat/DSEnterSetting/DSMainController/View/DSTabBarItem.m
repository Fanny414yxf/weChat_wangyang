//
//  DSTabBarItem.m
//  WeChat
//
//  Created by wangyang on 15/11/4.
//  Copyright © 2015年 wangyang. All rights reserved.
//

#import "DSTabBarItem.h"
#import "DSGlobal.h"

@interface DSTabBarItem () {
    struct {
        unsigned int TabBarSeletecdState : 1;
    }_tabBarSeletecd;
}
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
@end

@implementation DSTabBarItem
- (instancetype)init
{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"DSTabBarItem" owner:nil options:nil] lastObject];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClicked)];
        [self addGestureRecognizer:tap];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeLanguageSwtich) name:KLanguageSwitching object:nil];
        self.selected = NO;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)noticeLanguageSwtich
{
    if ([self.titleLabel.text isEqualToString:DS_CustomLocalizedOldString(@"weChat",nil)]) {
        self.titleLabel.text = DS_CustomLocalizedString(@"weChat", nil);
    }else if ([self.titleLabel.text isEqualToString:DS_CustomLocalizedOldString(@"address",nil)]) {
        self.titleLabel.text = DS_CustomLocalizedString(@"address", nil);
    }else if ([self.titleLabel.text isEqualToString:DS_CustomLocalizedOldString(@"find",nil)]) {
        self.titleLabel.text = DS_CustomLocalizedString(@"find", nil);
    }else if ([self.titleLabel.text isEqualToString:DS_CustomLocalizedOldString(@"mine",nil)]) {
        self.titleLabel.text = DS_CustomLocalizedString(@"mine", nil);
    }
    
}

- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    self.titleLabel.text = item.title;
    self.iconImage.image = item.image;
}

- (void)setDelegate:(id<DSTabBarItemDlegate>)delegate
{
    _delegate = delegate;
    _tabBarSeletecd.TabBarSeletecdState = [delegate respondsToSelector:@selector(tabBarItemSelectedWithItem:)];
}

- (void)itemClicked
{
    if (_tabBarSeletecd.TabBarSeletecdState) {
        [_delegate tabBarItemSelectedWithItem:self];
    }
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (selected) {
        self.titleLabel.textColor = [UIColor greenColor];
        self.iconImage.image = self.item.selectedImage;
    }else {
        self.titleLabel.textColor = [UIColor blackColor];
        self.iconImage.image = self.item.image;
    }
}

@end
