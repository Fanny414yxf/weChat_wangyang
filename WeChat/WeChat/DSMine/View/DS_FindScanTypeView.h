//
//  DS_FindScanTypeView.h
//  WeChat
//
//  Created by wangyang on 16/6/18.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat KFrameSizeHeight;

typedef NS_ENUM(NSInteger,DS_FindScanType) {
    DS_FindScanTypeScan,  //扫码
    DS_FindScanTypecover,  //封面
    DS_FindScanTypeStreet,  //街景
    DS_FindScanTypetranslation //翻译
};

@interface DS_FindScanTypeView : UIView
@property (nonatomic,assign)DS_FindScanType scanType;
@end
