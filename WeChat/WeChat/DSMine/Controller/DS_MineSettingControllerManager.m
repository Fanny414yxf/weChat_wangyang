//
//  DS_MineSettingControllerManager.m
//  WeChat
//
//  Created by wangyang on 16/6/18.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "DS_MineSettingControllerManager.h"

@implementation DS_MineSettingControllerManager
+ (NSArray *)dataSources
{
    NSArray *section0 = @[@"AccountSecurity"];
    NSArray *section1 = @[@"newNotice",@"privacy",@"general"];
    NSArray *section2 = @[@"HelpAndFeedback",@"aboutWeChat"];
    return @[section0,section1,section2];
}
@end
