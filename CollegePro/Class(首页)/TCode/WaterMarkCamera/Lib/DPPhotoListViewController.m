//
//  DPPhotoListViewController.m
//  DPPictureSelector
//
//  Created by boombox on 15/9/1.
//  Copyright (c) 2015年 lidaipeng. All rights reserved.
//

#import "DPPhotoListViewController.h"

#define ALERT_MSG(msg) static UIAlertView *alert; alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];\
[alert show];\


const CGFloat imageSpacing = 2.0f;  /**< 图片间距 */
const NSInteger maxCountInLine = 3; /**< 每行显示图片张数 */

#pragma mark - ---------------------- cell
@implementation DPPhotoListCell{
    UIButton *_selecedBtn;  /**< 是否选中按钮 */
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_imageView];
        
        _selecedBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 23, 5, 18, 18)];
        [_selecedBtn setImage:[UIImage imageNamed:@"gallery_chs_normal"] forState:UIControlStateNormal];
        [_selecedBtn setImage:[UIImage imageNamed:@"gallery_chs_seleceted"] forState:UIControlStateSelected];
        _selecedBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_selecedBtn];
    }
    return self;
}

- (void)setIsChoose:(BOOL)isChoose{
    _isChoose = isChoose;
    _selecedBtn.selected = isChoose;
}

@end

#pragma mark - ---------------------- controller
@interface DPPhotoListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView  *collectionView;    /**< asset列表 */
@property (strong, nonatomic) NSMutableArray    *selectedAssets;    /**< 已选asset集合 */
@property (strong, nonatomic) UIButton          *finishButton;      /**< 完成按钮 */

@end

@implementation DPPhotoListViewController{
    NSMutableArray *_selectedFalgList;  /**< 是否选中标记 */
    NSMutableArray *_assetList;         /**< 当前相薄所有asset */
    NSInteger       _selectedCount;     /**< 已选asset总数 */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickCancel)];
    
    _selectedCount = 0;
    
    [self.view addSubview:self.collectionView];
    [self getAllPhoto];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ---------------------- getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        //每张图片宽度
        CGFloat width = (self.view.frame.size.width - imageSpacing * (maxCountInLine - 1)) / maxCountInLine;
        layout.itemSize = CGSizeMake(width, width);
        layout.minimumLineSpacing      = imageSpacing;
        layout.minimumInteritemSpacing = imageSpacing;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate        = self;
        _collectionView.dataSource      = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[DPPhotoListCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (NSMutableArray *)selectedAssets{
    if (!_selectedAssets) {
        _selectedAssets = [NSMutableArray new];
    }
    return _selectedAssets;
}

- (UIButton *)finishButton{
    if (!_finishButton) {
        _finishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 49)];
        [_finishButton addTarget:self action:@selector(clickFinish) forControlEvents:UIControlEventTouchUpInside];
        [_finishButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _finishButton.backgroundColor     = [UIColor whiteColor];
        _finishButton.titleLabel.font     = [UIFont systemFontOfSize:15];
        _finishButton.layer.shadowColor   = [UIColor blackColor].CGColor;
        _finishButton.layer.shadowOffset  = CGSizeMake(0, -3);
        _finishButton.layer.shadowOpacity = 0.5;
        [self.view addSubview:_finishButton];
        [self.view bringSubviewToFront:_finishButton];
    }
    return _finishButton;
}

- (void)getAllPhoto{
    _assetList = [NSMutableArray array];
    _selectedFalgList = [NSMutableArray new];
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if (asset){
            NSString *type = [asset valueForProperty:ALAssetPropertyType];
            //当asset类型为照片时，添加到数组
            if ([type isEqual:ALAssetTypePhoto]){
                [_assetList addObject:asset];
                [_selectedFalgList addObject:@0];
            }
        }else{
            //asset为nil时代表枚举完成，重新加载collectionView
            [self.collectionView reloadData];
            
            //滚动到底部
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_assetList.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
        }
    };
    
    [self.group enumerateAssetsUsingBlock:resultsBlock];
}

#pragma mark - ---------------------- animation
- (void)showFinishButton{
    self.finishButton.hidden = NO;
    [UIView animateWithDuration:.25 animations:^{
        CGRect frame = _finishButton.frame;
        frame.origin.y = self.view.frame.size.height - frame.size.height;
        _finishButton.frame = frame;
        
        frame = _collectionView.frame;
        frame.size.height = _finishButton.frame.origin.y;
        _collectionView.frame = frame;
    }];
    [_finishButton setTitle:[NSString stringWithFormat:@"完成（%li/%ld张）",_selectedCount,(long)self.groupVC.maxSelectionCount] forState:UIControlStateNormal];
}

- (void)hideFinishButton{
    [UIView animateWithDuration:.25 animations:^{
        CGRect frame = _finishButton.frame;
        frame.origin.y = self.view.frame.size.height;
        _finishButton.frame = frame;
        
        frame = _collectionView.frame;
        frame.size.height = _finishButton.frame.origin.y;
        _collectionView.frame = frame;
    } completion:^(BOOL finished) {
        self.finishButton.hidden = YES;
    }];
}

#pragma mark - ---------------------- UICollectionViewDataSource/delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _assetList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DPPhotoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [DPPhotoListCell new];
    }
    cell.imageView.image = [UIImage imageWithCGImage:([_assetList[indexPath.row] thumbnail])];
    cell.isChoose = [_selectedFalgList[indexPath.row] boolValue];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //bool值取反
    _selectedFalgList[indexPath.row] = [NSNumber numberWithBool:![_selectedFalgList[indexPath.row] boolValue]];
    
    //如果已选总数大于等于可选总数，并且当前cell为选中状态，return
    if (_selectedCount >= self.groupVC.maxSelectionCount && [_selectedFalgList[indexPath.row] boolValue]) {
        NSString *msg = [NSString stringWithFormat:@"最多选择%li张图片",self.groupVC.maxSelectionCount];
        _selectedFalgList[indexPath.row] = [NSNumber numberWithBool:![_selectedFalgList[indexPath.row] boolValue]];
        ALERT_MSG(msg);
        return;
    }
    
    //设置cell选中状态
    DPPhotoListCell *cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
    cell.isChoose = [_selectedFalgList[indexPath.row] boolValue];
    
    ALAsset *asset = _assetList[indexPath.row];
    if (cell.isChoose) {
        //选中时，添加到数组，已选总数+1
        [self.selectedAssets addObject:asset];
        _selectedCount++;
    }else{
        //取消选中时，从数组中删除，已选总数-1
        if ([self.selectedAssets containsObject:asset]) {
            [self.selectedAssets removeObject:asset];
        }
        _selectedCount--;
    }
    
    if (_selectedCount > 0) {
        //已选总数大于0，显示完成按钮
        [self showFinishButton];
    }else{
        //已选总数小于等于0，隐藏完成按钮
        [self hideFinishButton];
    }
}

#pragma mark - ---------------------- action
- (void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickFinish{
    if (self.groupVC.delegate && [self.groupVC.delegate respondsToSelector:@selector(didSelectPhotos:)]) {
        NSMutableArray *photos = [NSMutableArray new];
        for (ALAsset *asset in _selectedAssets) {
            [photos addObject:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
        }
        [self.groupVC.delegate didSelectPhotos:photos];
    }
    [self clickCancel];
}

@end
