//
//  DS_PhotoAlbumViewController.m
//  WeChat
//
//  Created by wangyang on 16/6/20.
//  Copyright © 2016年 wangyang. All rights reserved.
//

#import "DS_PhotoAlbumViewController.h"
#import "DS_PhotoAlbumDataModel.h"
#import "DS_PhotoPickerGroup.h"
#import "DS_PhotoAssets.h"
#import "DS_PhotoAlbumCell.h"

static NSString *identifier = @"DS_PhotoAlbumCell";
static NSString *identifierSupplementaryView = @"UICollectionReusableView";
@interface DS_PhotoAlbumViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UINavigationBar *navigationBar;
@property (nonatomic,strong)UILabel *rightItemLabel;
@property (nonatomic,strong)DS_PhotoPickerGroup *pickerGroup;
@property (nonatomic,strong)NSMutableArray *dataSourcesArray;
@property (nonatomic,strong)UICollectionView *collectionView;
@end

@implementation DS_PhotoAlbumViewController

#pragma mark - life cricle
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBar.alpha = 0.300;
    self.navigationBar.translucent = YES;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.navigationBar];
    [self getAlbumGroupModel];
    [self setNavigationBarItem];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSourcesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DS_PhotoAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    DS_PhotoAssets *photoAssets = self.dataSourcesArray[indexPath.row];
    cell.imageView.image = photoAssets.thumbImage;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifierSupplementaryView forIndexPath:indexPath];
        view.frame = CGRectMake(0, 0, 375, 64);
    }
    return view;
}

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(375, 64);
}

#pragma mark - pravite funs
#pragma mark - 获取相册数据
- (void)getAlbumGroupModel
{
    WEAKSELF;
    [[DS_PhotoAlbumDataModel shareInstance] getAllGroupWithPhotos:^(id org) {
        NSLog(@"%@",org);
        for (DS_PhotoPickerGroup *group in org) {
            if ([group.groupName isEqualToString:@"相机胶卷"]||[group.groupName isEqualToString:@"Camera Roll"]) {
                weakSelf.pickerGroup = group;
                [weakSelf getAlbumPhotoData];
                return ;
            }
        }
    }];
}

- (void)getAlbumPhotoData
{
    if (!self.pickerGroup) {
        return;
    }
    WEAKSELF;
    [[DS_PhotoAlbumDataModel shareInstance] getGroupPicturesWithGroup:self.pickerGroup success:^(NSArray *assets) {
        [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL *stop) {
            DS_PhotoAssets *photoAssets = [[DS_PhotoAssets alloc] init];
            photoAssets.asset = asset;
            [weakSelf.dataSourcesArray addObject:photoAssets];
        }];
    }];
}

- (void)setNavigationBarItem
{
    UILabel *rightlabel = [[UILabel alloc] init];
    rightlabel.textColor = UIColorFromRGB(0x3f6847);
    self.rightItemLabel = rightlabel;
    rightlabel.frame = CGRectMake(0, 0, 80, 44);
    rightlabel.textAlignment = NSTextAlignmentRight;
    rightlabel.text = DS_CustomLocalizedString(@"cancel",nil);
    rightlabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *righttap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightItemAction)];
    [rightlabel addGestureRecognizer:righttap];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightlabel];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.frame = CGRectMake(0, 0, 100, 44);
    titleLabel.text = DS_CustomLocalizedString(@"Recently Added", nil);
    UINavigationItem *navigationBarTitle = [[UINavigationItem alloc] init];
    navigationBarTitle.titleView = titleLabel;
    navigationBarTitle.rightBarButtonItem = rightItem;
    [self.navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
}

- (void)rightItemAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = (UISCREENWIDTH - 15 ) / 4.;
        layout.itemSize = CGSizeMake(width, width);
        layout.minimumLineSpacing = 3;
        layout.minimumInteritemSpacing = 3;
        _collectionView = [[UICollectionView alloc] initWithFrame:(CGRect){0,0,UISCREENWIDTH,UISCREENHEIGHT - 64 - 50} collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[DS_PhotoAlbumCell class] forCellWithReuseIdentifier:identifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifierSupplementaryView];
    }
    return _collectionView;
}

- (UINavigationBar *)navigationBar
{
    if (!_navigationBar) {
        _navigationBar = [[UINavigationBar alloc] init];
        _navigationBar.frame = CGRectMake(0, 0, UISCREENWIDTH, 64);
    }
    return _navigationBar;
}

- (NSMutableArray *)dataSourcesArray
{
    if (!_dataSourcesArray) {
        _dataSourcesArray = [NSMutableArray array];
    }
    return _dataSourcesArray;
}
@end
