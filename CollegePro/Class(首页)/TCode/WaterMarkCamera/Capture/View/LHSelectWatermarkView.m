//
//  LHSelectWatermarkView.m
//  https://github.com/Mars-Programer/LHCamera
//
//  Created by 刘欢 on 2017/2/10.
//  Copyright © 2017年 imxingzhe.com. All rights reserved.
//

#import "LHSelectWatermarkView.h"
#import "UIView+AAToolkit.h"
#import "LHWatermarkDataModel.h"
static NSString *const kWatermarkCollectionCellReuseIdentifier  = @"kWatermarkCollectionCellReuseIdentifier";

@interface LHSelectWatermarkView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *_watermarks;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *cellStatus;
@end

@implementation LHSelectWatermarkView


- (instancetype)initWithFrame:(CGRect)frame WithWatermarks:(NSArray *)watermarks
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _watermarks = watermarks;
        [self commonInit];
    }
    return self;
}
- (NSMutableArray *)cellStatus
{
    if (_cellStatus == nil) {
        _cellStatus = [NSMutableArray arrayWithArray:@[@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO]];
    }
    return _cellStatus;
}
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, SCREENWIDTH - 24, 30)];
        _titleLabel.text = @"选择水印";
        _titleLabel.textColor = [UIColor colorWithWhite:102 / 255.0 alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake( -10, 12, 0, 12);
        flowLayout.itemSize = CGSizeMake(self.height - 40, self.height - 40);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 30, SCREENWIDTH, self.height - 30)
                                            collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:kWatermarkCollectionCellReuseIdentifier];
        [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];

        [self addSubview:_collectionView];
        
    }
    return _collectionView;
}
- (void)commonInit
{
    [self titleLabel];
    [self collectionView];
    [self.cellStatus replaceObjectAtIndex:0 withObject:@(YES)];
}
- (void)defaultWatermark
{
    NSInteger statusCount = 0;
    for (NSNumber *status in self.cellStatus) {
        if (!status.boolValue) {
            statusCount ++;
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    if (statusCount == self.cellStatus.count) {
        
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor grayColor];
        [self.cellStatus replaceObjectAtIndex:0 withObject:@(YES)];
        [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];

        if (self.delegate && [self.delegate respondsToSelector:@selector(selectWatermarkWithImageIndex:WithState:)]) {
            
            [self.delegate selectWatermarkWithImageIndex:0 WithState:NO];
        }
    }
    [self.collectionView reloadData];
}
- (void)reloadCellStatusWithIndex:(NSInteger)index
{
    [self.cellStatus replaceObjectAtIndex:index withObject:@(NO)];
    [self defaultWatermark];
}
#pragma mark -- collectionViewDeletegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return kMaxWatermarkCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWatermarkCollectionCellReuseIdentifier forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, cell.bounds.size.width - 16, cell.bounds.size.height - 16)];
    imageView.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:imageView];
    
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"watermark_preview_%ld",(long)indexPath.item + 1]];

    BOOL state = [self.cellStatus[indexPath.row] boolValue];

    if (state) {
        cell.backgroundColor = [UIColor colorWithRed:24 / 255.0 green:154 / 255.0 blue:219 / 255.0 alpha:1];
    }else
        cell.backgroundColor = [UIColor colorWithWhite:204 / 255.0 alpha:1];
    
    return cell; 
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    BOOL state = [self.cellStatus[indexPath.row] boolValue];
    if (state) {
        cell.backgroundColor = [UIColor colorWithWhite:204 / 255.0 alpha:1];
    }else
        cell.backgroundColor = [UIColor colorWithRed:24 / 255.0 green:154 / 255.0 blue:219 / 255.0 alpha:1];

    [self.cellStatus replaceObjectAtIndex:indexPath.row withObject:@(!state)];

   
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectWatermarkWithImageIndex:WithState:)]) {
        [self.delegate selectWatermarkWithImageIndex:indexPath.item WithState:state];
    }

    [self defaultWatermark];
}

@end
