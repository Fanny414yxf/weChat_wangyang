//
//  DS_PhotoAlbumViewController.m
//  WeChat
//
//  Created by wangyang on 16/6/20.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "DS_PhotoAlbumViewController.h"
#import "DS_PhotoAlbumDataModel.h"

@interface DS_PhotoAlbumViewController ()
@property (nonatomic,strong)UINavigationBar *navigationBar;
@property (nonatomic,strong)UILabel *rightItemLabel;
@end

@implementation DS_PhotoAlbumViewController

#pragma mark - life cricle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationBar];
    [self getAlbumData];
    [self setNavigationBarItem];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 获取相册数据
- (void)getAlbumData
{
    [[DS_PhotoAlbumDataModel shareInstance] getGroupPicturesWithSuccess:^(id org) {
        
    }];
}

#pragma mark - pravite funs
- (void)setNavigationBarItem
{
    UILabel *rightlabel = [[UILabel alloc] init];
    rightlabel.textColor = UIColorFromRGB(0x3f6847);
    self.rightItemLabel = rightlabel;
    rightlabel.frame = CGRectMake(0, 0, 80, 44);
    rightlabel.textAlignment = NSTextAlignmentRight;
    rightlabel.text = DS_CustomLocalizedString(@"cancel",nil);
    rightlabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *righttap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightItemAction)];
    [rightlabel addGestureRecognizer:righttap];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightlabel];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.frame = CGRectMake(0, 0, 100, 44);
    titleLabel.text = DS_CustomLocalizedString(@"Recently Added", nil);
    UINavigationItem *navigationBarTitle = [[UINavigationItem alloc] init];
    navigationBarTitle.titleView = titleLabel;
    navigationBarTitle.rightBarButtonItem = rightItem;
    [self.navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
}

- (void)rightItemAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter
- (UINavigationBar *)navigationBar
{
    if (!_navigationBar) {
        _navigationBar = [[UINavigationBar alloc] init];
        _navigationBar.frame = CGRectMake(0, 0, UISCREENWIDTH, 64);
    }
    return _navigationBar;
}
@end
