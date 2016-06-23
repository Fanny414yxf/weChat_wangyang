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
#import "UILabel+DSAdaptContent.h"
#import "DS_PhotoAlbumSignPhotoController.h"

static NSString *identifier = @"DS_PhotoAlbumCell";
static NSString *identifierSupplementaryView = @"UICollectionReusableView";
//发送按钮高度
const CGFloat KBottomHeight = 50.f;
//默认最多选择照片最大数
const NSInteger KSelectedMaxNums = 9;

@interface DS_PhotoAlbumViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DS_PhotoAlbumCellDelegate> {
    //记录sendButton真实宽度为了进行多语言适配
    CGRect _sendRealRect;
}
@property (nonatomic,strong)UILabel *rightItemLabel;
@property (nonatomic,strong)NSMutableArray *dataSourcesArray;
@property (nonatomic,strong)UICollectionView *collectionView;
//预览
@property (nonatomic,strong)UILabel *previewLabel;
//发送 用button目的是为了实现按压效果
@property (nonatomic,strong)DS_PhotoButton *sendButton;
//选择照片数
@property (nonatomic,strong)UILabel *selectedPictureLabel;

@property (nonatomic,strong)NSMutableArray *selectedDataArray;
@end

@implementation DS_PhotoAlbumViewController

#pragma mark - life cricle
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f4);
    self.title = self.pickerGroup.groupName;
    self.navigationController.navigationBar.alpha = 0.8f;
    self.navigationController.navigationBar.translucent = YES;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.previewLabel];
    [self.view addSubview:self.sendButton];
    [self getAlbumGroupModel];
    [self.view setNeedsUpdateConstraints];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateViewConstraints
{
    WEAKSELF;
    [self.previewLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(KBottomHeight);
        make.bottom.mas_equalTo(weakSelf.view);
        make.left.mas_equalTo(weakSelf.view).offset(10);
    }];
    [self.previewLabel setContentHuggingWithLabelContent];
    
     _sendRealRect = [self.sendButton.titleLabel.text boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.sendButton.titleLabel.font} context:nil];
    [self.sendButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(KBottomHeight);
        make.right.mas_equalTo(weakSelf.view).offset(-10);
        make.bottom.mas_equalTo(weakSelf.view);
        make.width.mas_equalTo(_sendRealRect.size.width);
    }];
    [super updateViewConstraints];
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
    cell.assertModel = photoAssets;
    cell.index = indexPath.row;
    cell.delegate = self;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifierSupplementaryView forIndexPath:indexPath];
        view.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return view;
}

-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(UISCREENWIDTH, 64);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - DS_PhotoAlbumCellDelegate
- (void)photoAlbumCellClicked:(DS_PhotoAlbumCell *)cell withIndexPathItem:(NSInteger)item
{
    DS_PhotoAssets *photoAssets = self.dataSourcesArray[item];
    photoAssets.selected = !photoAssets.isSelected;
    if (photoAssets.selected) {
        if (self.selectedDataArray.count >= 9) {
            photoAssets.selected = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:DS_CustomLocalizedString(@"You can only choose 9 picture", nil) message:@"" delegate:nil cancelButtonTitle:DS_CustomLocalizedString(@"I know", nil) otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        [self.selectedDataArray addObject:photoAssets];
    }else {
        [self.selectedDataArray removeObject:photoAssets];
    }
    [self.collectionView reloadData];
}

#pragma mark - pravite funs
#pragma mark - 获取相册数据
- (void)getAlbumGroupModel
{
    WEAKSELF;
    if (self.pickerGroup) {
        [self getAlbumPhotoData];
        return;
    }
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
        weakSelf.title = weakSelf.pickerGroup.groupName;
        [weakSelf.collectionView reloadData];
    }];
}

#pragma mark - pravite funs
////设置右上角按钮
//- (void)setNavigationBarItem
//{
//    UILabel *rightlabel = [[UILabel alloc] init];
//    rightlabel.textColor = UIColorFromRGB(0xffffff);
//    self.rightItemLabel = rightlabel;
//    rightlabel.frame = CGRectMake(0, 0, 80, 44);
//    rightlabel.textAlignment = NSTextAlignmentRight;
//    rightlabel.text = DS_CustomLocalizedString(@"cancel",nil);
//    rightlabel.userInteractionEnabled = YES;
//    UITapGestureRecognizer *righttap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightItemAction)];
//    [rightlabel addGestureRecognizer:righttap];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightlabel];
//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.frame = CGRectMake(0, 0, 100, 44);
//    titleLabel.text = DS_CustomLocalizedString(@"Recently Added", nil);
//    UINavigationItem *navigationBarTitle = [[UINavigationItem alloc] init];
//    navigationBarTitle.titleView = titleLabel;
//    navigationBarTitle.rightBarButtonItem = rightItem;
//    [self.navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
//}

- (void)rightItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = (UISCREENWIDTH - 15 ) / 4.0;
        layout.itemSize = CGSizeMake(width, width);
        layout.minimumLineSpacing = 3.;
        layout.minimumInteritemSpacing = 3.;
        layout.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3);
        _collectionView = [[UICollectionView alloc] initWithFrame:(CGRect){0,-64,UISCREENWIDTH,UISCREENHEIGHT - KBottomHeight} collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[DS_PhotoAlbumCell class] forCellWithReuseIdentifier:identifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifierSupplementaryView];
    }
    return _collectionView;
}

- (UILabel *)previewLabel
{
    if (!_previewLabel) {
        _previewLabel = [[UILabel alloc] init];
        _previewLabel.text = DS_CustomLocalizedString(@"Preview", nil);
    }
    return _previewLabel;
}

- (DS_PhotoButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [DS_PhotoButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:DS_CustomLocalizedString(@"Send", nil) forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor colorWithRed:0 green:1. blue:0 alpha:0.6] forState:UIControlStateNormal];
    }
    return _sendButton;
}

- (NSMutableArray *)dataSourcesArray
{
    if (!_dataSourcesArray) {
        _dataSourcesArray = [NSMutableArray array];
    }
    return _dataSourcesArray;
}

- (NSMutableArray *)selectedDataArray
{
    if (!_selectedDataArray) {
        _selectedDataArray = [NSMutableArray array];
    }
    return _selectedDataArray;
}

@end

@implementation DS_PhotoButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width, KBottomHeight);
}

@end
