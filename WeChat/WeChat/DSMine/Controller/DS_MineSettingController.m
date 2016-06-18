//
//  DS_MineSettingController.m
//  WeChat
//
//  Created by wangyang on 16/6/17.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "DS_MineSettingController.h"
#import "DS_MineSettingControllerManager.h"

static NSString *identifier = @"DS_MineSettingCell";
@interface DS_MineSettingController ()

@end

@implementation DS_MineSettingController

#pragma mark - life cricle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = DS_CustomLocalizedString(@"setting", nil);
    self.dataSourceArray = [DS_MineSettingControllerManager dataSources];
    [self tableViewCellBlock:^(UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath, id model) {
        NSString *text = self.dataSourceArray[indexPath.section][indexPath.row];
        cell.textLabel.text = DS_CustomLocalizedString(text, nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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


@end
