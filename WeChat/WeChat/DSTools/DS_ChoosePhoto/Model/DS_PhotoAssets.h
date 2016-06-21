//
//  DS_PhotoAssets.h
//  WeChat
//
//  Created by wangyang on 16/6/20.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface DS_PhotoAssets : NSObject

@property (strong,nonatomic) ALAsset *asset;

//缩略图
- (UIImage *)thumbImage;

//原图
- (UIImage *)originImage;

@property (nonatomic,assign,getter=isSelected)BOOL selected;

//是否是视频
@property (assign,nonatomic) BOOL isVideoType;
@end
