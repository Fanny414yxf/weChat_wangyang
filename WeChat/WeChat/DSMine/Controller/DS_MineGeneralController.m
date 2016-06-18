//
//  DS_MineGeneralController.m
//  WeChat
//
//  Created by wangyang on 16/6/18.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "DS_MineGeneralController.h"
#import "DS_LanguageController.h"

@interface DS_MineGeneralController ()<DS_LanguageControllerDelegate>

@end

@implementation DS_MineGeneralController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = DS_CustomLocalizedString(@"general", nil);
    self.dataSourceArray = @[@"languageTitle"];
    [self tableviewBlock];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableviewBlock
{
    WEAKSELF;
    [self tableViewCellBlock:^(UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath, NSString *model) {
        cell.textLabel.text = DS_CustomLocalizedString(model, nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }];
    
    [self tableViewDidClickBlock:^(UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath, id model) {
        DS_LanguageController *vc = [[DS_LanguageController alloc] init];
        vc.delegate = weakSelf;
        [weakSelf presentViewController:vc animated:YES completion:nil];
    }];
}

#pragma mark - DS_LanguageControllerDelegate
- (void)languageControllerBack:(DS_LanguageController *)languaeController
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:KLanguageSwitching object:nil];
}
@end
