//
//  DS_PhotoAlbumDataModel.m
//  WeChat
//
//  Created by wangyang on 16/6/20.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "DS_PhotoAlbumDataModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

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

- (void)getGroupPicturesWithSuccess:(CallBack)result
{
    ALAssetsLibraryGroupsEnumerationResultsBlock resultBlock = ^(ALAssetsGroup *result, BOOL *stop){
        NSLog(@"%@",result);
    };
    
    [self.library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:resultBlock failureBlock:nil];
}

- (void)getGroupVideoWithSuccess:(CallBack)result
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
