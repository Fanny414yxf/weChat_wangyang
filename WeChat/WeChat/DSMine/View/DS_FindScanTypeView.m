//
//  DS_FindScanTypeView.m
//  WeChat
//
//  Created by wangyang on 16/6/18.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "DS_FindScanTypeView.h"

@implementation DS_FindScanTypeView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    CGFloat x = 0;
    CGFloat h = 100;
    CGFloat y = UISCREENHEIGHT - h;
    CGFloat w = UISCREENWIDTH;
    self.frame = CGRectMake(x, y, w, h);
}

@end
