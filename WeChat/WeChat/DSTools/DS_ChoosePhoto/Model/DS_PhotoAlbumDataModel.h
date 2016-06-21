//
//  DS_PhotoAlbumDataModel.h
//  WeChat
//
//  Created by wangyang on 16/6/20.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DS_PhotoAlbumDataModel,DS_PhotoPickerGroup;

typedef void (^CallBack)(id org);
@interface DS_PhotoAlbumDataModel : NSObject

+ (instancetype)shareInstance;

/**
 * 获取一组照片
 */
- (void)getGroupPicturesWithGroup:(DS_PhotoPickerGroup *)photoPickerGroup success:(CallBack)result;

/**
 * 获取一组视频
 */
- (void)getGroupVideoWithGroup:(DS_PhotoPickerGroup *)group success:(CallBack)result;

/**
 * 获取相册文件组
 */
- (void)getAllGroupWithPhotos:(CallBack)callBack;

@end
