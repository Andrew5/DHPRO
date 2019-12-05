//
//  XFPreviewViewController.m
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/8/12.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import "XFPreviewViewController.h"
#import "XFPreviewCollectionViewCell.h"
#import "XFAssetsModel.h"

@interface XFPreviewViewController ()
@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger currentItem;

@property (assign, nonatomic) BOOL navHid;
@end

@implementation XFPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self.collectionView registerNib:[UINib nibWithNibName:ReuseIdentifier bundle:nil] forCellWithReuseIdentifier:ReuseIdentifier];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(didDeleteImageAction)];
    
    self.navHid = false;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self.dataArray removeAllObjects];
    for ( XFAssetsModel *model in self.assetsArray ) {
        [self.dataArray addObject:[UIImage imageWithCGImage:model.asset.defaultRepresentation.fullScreenImage]];
    }
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.showIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    self.title = [NSString stringWithFormat:@"%.0ld/%ld",(long)self.showIndex + 1,self.dataArray.count];
    
    self.currentItem = self.showIndex;
}

- (void)didDeleteImageAction {
    XFWeakSelf;
    
    [self.collectionView performBatchUpdates:^{
        [wself.assetsArray removeObjectAtIndex:wself.currentItem];
        [wself.dataArray removeObjectAtIndex:wself.currentItem];
        if ( wself.deleteImageBlock ) {
            wself.deleteImageBlock(wself.currentItem);
        }
        [wself.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:wself.currentItem inSection:0]]];
    } completion:^(BOOL finished) {
        if ( wself.dataArray.count ) {
            [wself.collectionView reloadData];
            wself.currentItem = wself.currentItem == wself.dataArray.count?wself.currentItem - 1:wself.currentItem;
            wself.title = [NSString stringWithFormat:@"%.0ld/%ld",(long)wself.currentItem + 1,wself.dataArray.count];
        }else {
            [wself.navigationController popViewControllerAnimated:true];
        }
    }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XFPreviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    [cell setupWithImage:self.dataArray[indexPath.item]];
    XFWeakSelf;
    cell.tapImageViewBlock = ^() {
        wself.navHid = !wself.navHid;
        [wself.navigationController setNavigationBarHidden:wself.navHid animated:true];
        [[UIApplication sharedApplication] setStatusBarHidden:wself.navHid withAnimation:true];
    };
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    NSLog(@"%@======%@",NSStringFromCGPoint(velocity),NSStringFromCGPoint(*targetContentOffset));
    
    NSInteger currentIndex = targetContentOffset->x/XFScreenWidth;
    self.title = [NSString stringWithFormat:@"%.0ld/%ld",(long)currentIndex + 1,self.dataArray.count];
    self.currentItem = currentIndex;
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if ( !_dataArray ) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UICollectionView *)collectionView {
    if ( !_collectionView ) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(XFScreenWidth, XFScreenHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = 0.f;
        layout.minimumInteritemSpacing = 0.f;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.f, 0.f, XFScreenWidth, XFScreenHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.pagingEnabled = true;
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
