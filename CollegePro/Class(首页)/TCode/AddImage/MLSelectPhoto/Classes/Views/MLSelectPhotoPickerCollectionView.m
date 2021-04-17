//  github: https://github.com/MakeZL/MLSelectPhoto
//  author: @email <120886865@qq.com>
//
//  PickerCollectionView.m
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "MLSelectPhotoPickerCollectionView.h"
#import "MLSelectPhotoPickerCollectionViewCell.h"
#import "MLPhotoPickerImageView.h"
#import "MLSelectPhotoPickerFooterCollectionReusableView.h"
#import "MLSelectPhotoCommon.h"

@interface MLSelectPhotoPickerCollectionView () <UICollectionViewDataSource,UICollectionViewDelegate,MLPhotoPickerImageViewDelegate>

@property (nonatomic , strong) MLSelectPhotoPickerFooterCollectionReusableView *footerView;

// 判断是否是第一次加载
@property (nonatomic , assign , getter=isFirstLoadding) BOOL firstLoadding;

@end

@implementation MLSelectPhotoPickerCollectionView

#pragma mark -getter
- (NSMutableArray *)selectsIndexPath{
    if (!_selectsIndexPath) {
        _selectsIndexPath = [NSMutableArray array];
    }
    return _selectsIndexPath;
}

#pragma mark -setter
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
    // 需要记录选中的值的数据
    if (self.isRecoderSelectPicker){
        NSMutableArray *selectAssets = [NSMutableArray array];
        for (MLSelectPhotoAssets *asset in self.selectAsstes) {
            for (MLSelectPhotoAssets *asset2 in self.dataArray) {
                if ([asset.asset.defaultRepresentation.url isEqual:asset2.asset.defaultRepresentation.url]) {
                    [selectAssets addObject:asset2];
                    break;
                }
            }
        }
        _selectAsstes = selectAssets;
    }
    
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.delegate = self;
        _selectAsstes = [NSMutableArray array];
    }
    return self;
}

#pragma mark -<UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MLSelectPhotoPickerCollectionViewCell *cell = [MLSelectPhotoPickerCollectionViewCell cellWithCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    MLPhotoPickerImageView *cellImgView = nil;
    if ([[cell.contentView.subviews lastObject] isKindOfClass:[MLPhotoPickerImageView class]]) {
        cellImgView = (MLPhotoPickerImageView *)[cell.contentView.subviews lastObject];        cellImgView.maskViewFlag = YES;
    }else{
        cellImgView = [[MLPhotoPickerImageView alloc] initWithFrame:cell.bounds];
        cellImgView.delegate = self;
    }
    cellImgView.index = indexPath.row;
    cellImgView.maskViewFlag = YES;
    if(indexPath.item == 0 && self.topShowPhotoPicker){
        UIImageView *imageView = [[cell.contentView subviews] lastObject];
        // 判断真实类型
        if (![imageView isKindOfClass:[UIImageView class]]) {
            imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = YES;
            [cell.contentView addSubview:imageView];
        }
        imageView.tag = indexPath.item;
        imageView.image = [UIImage imageNamed:MLSelectPhotoSrcName(@"camera")];
    }else{
        
        // 需要记录选中的值的数据
        if (self.isRecoderSelectPicker) {
//            for (MLSelectPhotoAssets *asset in self.doneAsstes) {
//                if ([asset isKindOfClass:[MLSelectPhotoAssets class]] && [asset.asset.defaultRepresentation.url isEqual:[self.dataArray[indexPath.item] asset].defaultRepresentation.url]) {
//                    [self.selectsIndexPath addObject:@(indexPath.row)];
//                }
//            }
        }
        
        [cell.contentView addSubview:cellImgView];
        
        cellImgView.maskViewFlag = ([self.selectsIndexPath containsObject:@(indexPath.row)]);
        
        MLSelectPhotoAssets *asset = self.dataArray[indexPath.item];
        cellImgView.isVideoType = asset.isVideoType;
        if ([asset isKindOfClass:[MLSelectPhotoAssets class]]) {
            cellImgView.image = asset.thumbImage;
        }
    }
    
    return cell;
}

- (void)photoPickerClickTickButton:(UIButton *)tickButton{
    if (!self.lastDataArray) {
        self.lastDataArray = [NSMutableArray array];
    }
    
    NSInteger row = tickButton.tag;
    MLSelectPhotoPickerCollectionViewCell *cell = (MLSelectPhotoPickerCollectionViewCell *) [self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:0]];
    
    MLSelectPhotoAssets *asset = self.dataArray[row];
    MLPhotoPickerImageView *pickerImageView = [cell.contentView.subviews lastObject];
    // 如果没有就添加到数组里面，存在就移除
    if (pickerImageView.isMaskViewFlag) {
        [self.selectsIndexPath removeObject:@(row)];
        [self.selectAsstes removeObject:asset];
        [self.lastDataArray removeObject:asset];
    }else{
        // 1 判断图片数超过最大数或者小于0
        NSUInteger maxCount = (self.maxCount < 0) ? KPhotoShowMaxCount :  self.maxCount;
        
        if (self.selectAsstes.count >= maxCount) {
            NSString *format = [NSString stringWithFormat:@"最多只能选择%zd张图片",maxCount];
            if (maxCount == 0) {
                format = [NSString stringWithFormat:@"您已经选满了图片呦."];
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:format delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
            [alertView show];
            return ;
        }
        
        [self.selectsIndexPath addObject:@(row)];
        [self.selectAsstes addObject:asset];
        [self.lastDataArray addObject:asset];
    }
    // 告诉代理现在被点击了!
    if ([self.collectionViewDelegate respondsToSelector:@selector(pickerCollectionViewDidSelected: deleteAsset:)]) {
        if (pickerImageView.isMaskViewFlag) {
            // 删除的情况下
            [self.collectionViewDelegate pickerCollectionViewDidSelected:self deleteAsset:asset];
        }else{
            [self.collectionViewDelegate pickerCollectionViewDidSelected:self deleteAsset:nil];
        }
    }
    
    pickerImageView.maskViewFlag = ([pickerImageView isKindOfClass:[MLPhotoPickerImageView class]]) && !pickerImageView.isMaskViewFlag;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.topShowPhotoPicker && indexPath.item == 0) {
        if ([self.collectionViewDelegate respondsToSelector:@selector(pickerCollectionViewDidCameraSelect:)]) {
            [self.collectionViewDelegate pickerCollectionViewDidCameraSelect:self];
        }
        return ;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PICKER_PUSH_BROWSERPHOTO object:nil userInfo:@{@"currentPage":@(indexPath.row),@"selectAssets":self.selectAsstes}];
}

#pragma mark 底部View
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    MLSelectPhotoPickerFooterCollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionFooter) {
        MLSelectPhotoPickerFooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerView.count = self.dataArray.count;
        reusableView = footerView;
        self.footerView = footerView;
    }else{
        
    }
    return reusableView;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // 时间置顶的话
    if (self.status == ZLPickerCollectionViewShowOrderStatusTimeDesc) {
        if (!self.firstLoadding && self.contentSize.height > [[UIScreen mainScreen] bounds].size.height) {
            // 滚动到最底部（最新的）
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            // 展示图片数
            self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y + 100);
            self.firstLoadding = YES;
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
