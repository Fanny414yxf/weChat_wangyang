//
//  DS_PhotoPickerGroup.h
//  WeChat
//
//  Created by wangyang on 16/6/20.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface DS_PhotoPickerGroup : NSObject

//组名
@property (nonatomic , copy)NSString *groupName;

//缩略图
@property (nonatomic , strong)UIImage *thumbImage;

//组图片个数
@property (nonatomic , assign)NSInteger assetsCount;

//组
@property (nonatomic , strong)ALAssetsGroup *group;
@end
