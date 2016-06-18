//
//  DSMineController.m
//  WeChat
//
//  Created by wangyang on 15/11/5.
//  Copyright © 2015年 wangyang. All rights reserved.
//

#import "DSMineController.h"
#import "DS_FindCell.h"
#import "DSMineControllerManager.h"
#import "DS_FindCellModel.h"
#import "DS_MineSettingController.h"

static NSString *identifier = @"DS_FindCell";
@interface DSMineController ()

@end

@implementation DSMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourceArray = [DSMineControllerManager dataSources];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeLanguageSwtich) name:KLanguageSwitching object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]  removeObserver:self forKeyPath:KLanguageSwitching];
}

#pragma mark  - overwrite
- (UITableView *)allocTableView
{
    return [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
}

- (CGFloat)footerHeight
{
    return 0.f;
}

- (void)registerTableViewCellClass
{
    [self.tableView registerClass:[DS_FindCell class] forCellReuseIdentifier:identifier];
}

#pragma mark - UITableViewDataSource and UItableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourceArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DS_FindCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.cellModel = self.dataSourceArray[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DS_FindCellModel *model = self.dataSourceArray[indexPath.section][indexPath.row];
    if (!model.icon) {
        return 90.f;
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? CGFLOAT_MIN:20.;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DS_FindCellModel *model = self.dataSourceArray[indexPath.section][indexPath.row];
    //跳转设置
    if ([model.title isEqualToString:DS_CustomLocalizedString(@"setting", nil)]) {
        DS_MineSettingController *setVc = [[DS_MineSettingController alloc] init];
        [self.navigationController pushViewController:setVc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma markk - pravite funs
//监听到应用内切换语言
- (void)noticeLanguageSwtich
{
    self.title = DS_CustomLocalizedString(@"mine", nil);
    self.dataSourceArray = [DSMineControllerManager dataSources];
    [self.tableView reloadData];
    DS_MineSettingController *setVc = [[DS_MineSettingController alloc] init];
    [self.navigationController pushViewController:setVc animated:YES];
}

@end
