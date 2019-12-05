//
//  CollectionImageView.m
//  CollectionView轮播图
//
//  Created by xiaoshi on 16/2/17.
//  Copyright © 2016年 kamy. All rights reserved.
//

#import "CollectionImageView.h"
#import "CollectionImageCell.h"

#define SELF_WIDTH self.frame.size.width
#define SELF_HEIGHT self.frame.size.height
//collection 组数，正常情况下足够，没人闲得无聊一直滑滑滑，自动滚动可以在nextPage函数调用一下resetIndexPath
static NSInteger const SectionCount = 50;
@interface CollectionImageView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, copy)selectImageBlock block;
@property (nonatomic, strong)NSArray *imageArray;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UIPageControl *pageCtrl;
@property (nonatomic, strong)NSTimer *timer;
@end
@implementation CollectionImageView

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray selectImageBlock:(selectImageBlock) block
{
    self = [super initWithFrame:frame];
    if (self) {
        self.block = block;
        self.imageArray = imageArray;
        [self addSubview:self.collectionView];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:SectionCount/2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        [self addSubview:self.pageCtrl];
        [self addTimer];
    }
    return self;
}

#pragma mark - CollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return SectionCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionImageCell" forIndexPath:indexPath];
    cell.imageName = self.imageArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.block)
    {
    self.block(indexPath.row);
    }
}

#pragma maek - scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self addTimer];
    //这个位置是你拖动结束后调用一次
    self.pageCtrl.currentPage = (NSInteger)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5) % self.imageArray.count;
}
/* 
 *这个方法只要scrollView一滑动就会调用很多次,虽然没有创建东西，但是感觉上不太爽
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageCtrl.currentPage = (NSInteger)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5) % self.imageArray.count;
}
 */
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{//这个位置是定时器让它滑动结束后调用一次
    self.pageCtrl.currentPage = (NSInteger)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5) % self.imageArray.count;
}
#pragma mark - private Method
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//重算位置，永远使用中间的那组轮播,手滑考虑过这个，不过有bug。
- (NSIndexPath *)resetIndexPath
{
    NSIndexPath *currentPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    NSIndexPath *path = [NSIndexPath indexPathForRow:currentPath.row inSection:SectionCount/2];
    [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    return path;
}

- (void)nextPage
{
    NSIndexPath *currentPath =  [self resetIndexPath];
    //NSIndexPath *currentPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    //计算下一个位置
    NSInteger nextRow = currentPath.row + 1;
    NSInteger nextSection = currentPath.section;
    if (nextRow == [self.imageArray count]) {
        nextRow = 0;
        nextSection ++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:nextRow inSection:nextSection];
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.itemSize = self.frame.size;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[CollectionImageCell class] forCellWithReuseIdentifier:@"CollectionImageCell"];
    }
    return _collectionView;
}

- (UIPageControl *)pageCtrl
{
    if (!_pageCtrl) {
        _pageCtrl = [[UIPageControl alloc]initWithFrame:CGRectMake((SELF_WIDTH - 100) * 0.5f, SELF_HEIGHT - 40, 100, 20)];
        _pageCtrl.numberOfPages = [self.imageArray count];
        _pageCtrl.currentPage = 0;
        _pageCtrl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageCtrl.pageIndicatorTintColor = [UIColor yellowColor];
    }
    return _pageCtrl;
}

@end
