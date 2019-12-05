//
//  XFHomeCollectionViewCell.h
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/6.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFAssetsModel;

typedef void(^DeleteBlock)(XFAssetsModel *model);
typedef void(^LongPressBlock)(UILongPressGestureRecognizer *longPress);

@interface XFHomeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (copy, nonatomic) DeleteBlock deleteBlock;
@property (copy, nonatomic) LongPressBlock longPressBlock;

- (void)setupModel:(XFAssetsModel *)model index:(NSInteger)index;
@end
