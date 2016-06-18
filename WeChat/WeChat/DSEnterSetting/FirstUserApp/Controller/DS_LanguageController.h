//
//  DS_LanguageController.h
//  WeChat
//
//  Created by wangyang on 16/5/14.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "DS_BaseTableViewController.h"
@class DS_LanguageController;

@protocol DS_LanguageControllerDelegate <NSObject>
@optional
- (void)languageControllerBack:(DS_LanguageController *)languaeController;

@end

@interface DS_LanguageController : DS_BaseTableViewController
@property (nonatomic,weak)id<DS_LanguageControllerDelegate>delegate;
@end