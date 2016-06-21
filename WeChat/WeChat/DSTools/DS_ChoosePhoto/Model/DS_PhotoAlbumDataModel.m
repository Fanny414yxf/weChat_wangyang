//
//  DS_PhotoAlbumDataModel.m
//  WeChat
//
//  Created by wangyang on 16/6/20.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "DS_PhotoAlbumDataModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DS_PhotoPickerGroup.h"

@interface DS_PhotoAlbumDataModel ()
@property (nonatomic,strong)ALAssetsLibrary *library;
@end

@implementation DS_PhotoAlbumDataModel

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static DS_PhotoAlbumDataModel *albumData = nil;
    dispatch_once(&onceToken, ^{
        albumData = [self new];
    });
    return albumData;
}

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred,^
                  {
                      library = [[ALAssetsLibrary alloc] init];
                  });
    return library;
}

#pragma mark -获取所有组
- (void)getAllGroupWithPhotos:(CallBack)callBack
{
    [self getAllGroupAllPhotos:YES withResource:callBack];
}

- (void)getAllGroupAllPhotos:(BOOL)allPhotos
                withResource:(CallBack)callBack
{
    NSMutableArray *groups = [NSMutableArray array];
    ALAssetsLibraryGroupsEnumerationResultsBlock resultBlock = ^(ALAssetsGroup *group, BOOL *stop){
        if (group) {
            if (allPhotos){
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            }else{
                [group setAssetsFilter:[ALAssetsFilter allVideos]];
            }
            // 包装一个模型来赋值
            DS_PhotoPickerGroup *pickerGroup = [[DS_PhotoPickerGroup alloc] init];
            pickerGroup.group = group;
            pickerGroup.groupName = [group valueForProperty:@"ALAssetsGroupPropertyName"];
            pickerGroup.thumbImage = [UIImage imageWithCGImage:[group posterImage]];
            pickerGroup.assetsCount = [group numberOfAssets];
            [groups addObject:pickerGroup];
        }else{
            callBack(groups);
        }
    };
    [self.library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:resultBlock failureBlock:nil];
}

//获取组照片
- (void)getGroupPicturesWithGroup:(DS_PhotoPickerGroup *)photoPickerGroup success:(CallBack)resultCallBack
{
    NSMutableArray *assertArray = [NSMutableArray array];
    ALAssetsGroupEnumerationResultsBlock resultBlock = ^(ALAsset *assert, NSUInteger index, BOOL *stop){
        if (assert) {
            [assertArray addObject:assert];
        }else {
            resultCallBack(assertArray);
        }
    };
    [photoPickerGroup.group enumerateAssetsUsingBlock:resultBlock];
}

//获取组视频
- (void)getGroupVideoWithGroup:(DS_PhotoPickerGroup *)group success:(CallBack)result
{
}

- (ALAssetsLibrary *)library
{
    if (!_library) {
        _library = [self.class defaultAssetsLibrary];
    }
    return _library;
}
@end
