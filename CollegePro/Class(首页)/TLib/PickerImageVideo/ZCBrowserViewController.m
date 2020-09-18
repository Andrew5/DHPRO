//
//  ZCBrowserViewController.m
//  ZCAssetsPickerController
//
#import "ZCBrowserViewController.h"
#import "ZCBrowserCollectionViewCell.h"
#import "ZCSelectedAssetsManager.h"
#import "Macro.h"

@interface ZCBrowserViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)UIButton *selectedBtn;

@end

@implementation ZCBrowserViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //createUI
    [self createUI];
}

#pragma mark - Private Methods

- (void)createUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.selectedBtn];
    [self.view addSubview:self.collectionView];
}

- (BOOL)assetIsSelectedWithIndex:(NSInteger)index
{
    if (index > self.assets.count) {
        return NO;
    }
    PHAsset *asset = self.assets[index];
    if ([[ZCSelectedAssetsManager sharedInstance].allSelectedAssets containsObject:asset]) {
        return YES;
    }
    return NO;
}

#pragma mark - setter & getter
- (UIButton *)selectedBtn
{
    if (!_selectedBtn) {
        _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedBtn.frame = CGRectMake(self.view.frame.size.width-60,44, 40, 40);
        [_selectedBtn setImage:[UIImage imageNamed:@"JHFilePickResource.bundle/ic_asset_unselected"] forState:UIControlStateNormal];
       [_selectedBtn setImage:[UIImage imageNamed:@"JHFilePickResource.bundle/ic_asset_selected"] forState:UIControlStateSelected];
        _selectedBtn.selected = [self assetIsSelectedWithIndex:self.currentIndex];
        _selectedBtn.adjustsImageWhenHighlighted = NO;
        [_selectedBtn addTarget:self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedBtn;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(KItemW, KItemH);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64) collectionViewLayout:layout];
        [_collectionView registerClass:[ZCBrowserCollectionViewCell class] forCellWithReuseIdentifier:KZCBrowserCollectionViewCellId];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView setContentOffset:CGPointMake(KItemW * self.currentIndex, 0)];
    }
    return _collectionView;
}

#pragma mark - event
- (void)selectedClick:(UIButton *)sender
{
    PHAsset *asset = self.assets[self.currentIndex];
    if (!sender.selected) {
        BOOL isSuccess =  [[ZCSelectedAssetsManager sharedInstance] addAssetWithAsset:asset];
        if (!isSuccess) {
            return;
        }
    }else{
        [[ZCSelectedAssetsManager sharedInstance] removeAssetWithAsset:asset];
    }
    
    sender.selected = !sender.selected;
    if (self.assetSelectedBlock) {
        self.assetSelectedBlock(self.currentIndex);
    }
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZCBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KZCBrowserCollectionViewCellId forIndexPath:indexPath];
    PHAsset *asset = self.assets[indexPath.row];
    cell.asset = asset;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = (NSInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width);
    self.currentIndex = index;
    BOOL isSelected = [self assetIsSelectedWithIndex:index];
    self.selectedBtn.selected = isSelected;
}


@end
