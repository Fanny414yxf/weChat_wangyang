//
//  DS_PhotoAlbumGroupViewController.m
//  WeChat
//
//  Created by wangyang on 16/6/23.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "DS_PhotoAlbumGroupViewController.h"
#import "DS_PhotoAlbumGroupCell.h"
#import "DS_PhotoAlbumDataModel.h"
#import "DS_PhotoAlbumViewController.h"

static NSString *identifier = @"UITableViewCell";

@interface DS_PhotoAlbumGroupViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSourcesArray;

@end

@implementation DS_PhotoAlbumGroupViewController

#pragma mark - life cricle
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = DS_CustomLocalizedString(@"PhotoAlbum", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self firstJoinPushNextController];
    [self requestDataSourcesModel];
}

#pragma mark - UITableViewDataSource and UItableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourcesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DS_PhotoAlbumGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.groupModel = self.dataSourcesArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DS_PhotoAlbumViewController *controller = [[DS_PhotoAlbumViewController alloc] init];
    controller.pickerGroup = self.dataSourcesArray[indexPath.row];
    //设置返回按钮文字
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = DS_CustomLocalizedString(@"Back", nil);
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - pravite funs
/**
 * 数据源
 */
- (void)requestDataSourcesModel
{
    WEAKSELF;
    [[DS_PhotoAlbumDataModel shareInstance] getAllGroupWithPhotos:^(NSArray *org) {
        weakSelf.dataSourcesArray = (NSMutableArray *)org;
        [weakSelf.tableView reloadData];
    }];
}

- (void)firstJoinPushNextController
{
    if (!self.isFirstFlag) {
        return;
    }
    _firstFlag = NO;
    DS_PhotoAlbumViewController *controller = [[DS_PhotoAlbumViewController alloc] init];
    //设置返回按钮文字
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = DS_CustomLocalizedString(@"Back", nil);
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:controller animated:NO];
}

#pragma mark - setter and getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT - 64) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[DS_PhotoAlbumGroupCell class] forCellReuseIdentifier:identifier];
        _tableView.rowHeight = 60.f;
    }
    return _tableView;
}

- (NSMutableArray *)dataSourcesArray
{
    if (!_dataSourcesArray) {
        _dataSourcesArray = [NSMutableArray array];
    }
    return _dataSourcesArray;
}

@end
