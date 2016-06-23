//
//  DS_PhotoAlbumCell.h
//  WeChat
//
//  Created by wangyang on 16/6/21.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DS_PhotoAssets,DS_PhotoAlbumCell;

@protocol DS_PhotoAlbumCellDelegate <NSObject>
@optional
- (void)photoAlbumCellClicked:(DS_PhotoAlbumCell *)cell withIndexPathItem:(NSInteger)item;
@end

@interface DS_PhotoAlbumCell : UICollectionViewCell
@property (nonatomic,strong)DS_PhotoAssets *assertModel;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,weak)id<DS_PhotoAlbumCellDelegate> delegate;
@end
