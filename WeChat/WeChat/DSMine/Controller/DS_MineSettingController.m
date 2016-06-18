//
//  DS_MineSettingController.m
//  WeChat
//
//  Created by wangyang on 16/6/17.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "DS_MineSettingController.h"
#import "DS_MineSettingControllerManager.h"
#import "UIImage+DSImage.h"
#import "DS_ActionSheetView.h"
#import "DS_MineGeneralController.h"

static NSString *identifier = @"DS_MineSettingCell";
@interface DS_MineSettingController ()<DS_ActionSheetViewDelegate>
@property (nonatomic,strong)UIButton *logOutButton;
@end

@implementation DS_MineSettingController

#pragma mark - life cricle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = DS_CustomLocalizedString(@"setting", nil);
    self.dataSourceArray = [DS_MineSettingControllerManager dataSources];
    [self.tableView setTableFooterView:self.logOutButton];
    [self tableViewBlock];
}

- (void)tableViewBlock
{
    WEAKSELF;
    [self tableViewCellBlock:^(UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath, id model) {
        NSString *text = weakSelf.dataSourceArray[indexPath.section][indexPath.row];
        cell.textLabel.text = DS_CustomLocalizedString(text, nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }];
    
    [self tableViewDidClickBlock:^(UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath, id model) {
        NSString *text = weakSelf.dataSourceArray[indexPath.section][indexPath.row];
        if ([text isEqualToString:@"general"]) {
            DS_MineGeneralController *generalVc = [[DS_MineGeneralController alloc] init];
            [weakSelf.navigationController pushViewController:generalVc animated:YES];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

#pragma mark - UITabelViewDataSource and UITabelViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourceArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? CGFLOAT_MIN:20.;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.dataSourceArray.count - 1) {
        return 20.;
    }
    return 0.f;
}

#pragma mark - DS_ActionSheetViewDelegate
- (void)ActionSheetView:(DS_ActionSheetView *)actionSheetView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"点击退出登录");
}

#pragma mark - 退出登录
- (void)logOutAction
{
    DS_ActionSheetView *view = [[DS_ActionSheetView alloc] initWithTitles:@[@"退出登录"] delegate:self cancelButtonTitle:@"取消"];
    view.otherButtonTextColor = [UIColor redColor];
    [view showInView:self.view];
}

#pragma mark - getter
- (UIButton *)logOutButton
{
    if (!_logOutButton) {
        _logOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logOutButton setTitle:DS_CustomLocalizedString(@"LogOut", nil) forState:UIControlStateNormal];
        _logOutButton.frame = CGRectMake(0, 0, UISCREENWIDTH, 44);
        [_logOutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_logOutButton setBackgroundColor:[UIColor whiteColor]];
        [_logOutButton setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
        [_logOutButton addTarget:self action:@selector(logOutAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logOutButton;
}

@end
