//
//  DS_PhotoAlbumViewController.h
//  WeChat
//
//  Created by wangyang on 16/6/20.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DS_PhotoPickerGroup;

@interface DS_PhotoAlbumViewController : UIViewController

@property (nonatomic,strong)DS_PhotoPickerGroup *pickerGroup;

@end

@interface DS_PhotoButton : UIButton

@end