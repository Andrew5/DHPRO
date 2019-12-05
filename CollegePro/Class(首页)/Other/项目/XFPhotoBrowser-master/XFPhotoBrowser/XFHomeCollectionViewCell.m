//
//  XFHomeCollectionViewCell.m
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/6.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import "XFHomeCollectionViewCell.h"
#import "XFAssetsModel.h"

@interface XFHomeCollectionViewCell ()



@property (strong, nonatomic) XFAssetsModel *model;

@end

@implementation XFHomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressImageView:)];
    [self.imageView addGestureRecognizer:longPress];
}

- (void)setupModel:(XFAssetsModel *)model index:(NSInteger)index {
    self.model = model;
    self.imageView.image = model.thumbnailImage;
    self.imageView.tag = index;
}

- (void)longPressImageView:(UILongPressGestureRecognizer *)press {
    if ( self.longPressBlock ) {
        self.longPressBlock(press);
    }
}

- (IBAction)didDeleteButtonAction:(UIButton *)sender {
    if ( self.deleteBlock ) {
        self.deleteBlock(self.model);
    }
}

@end
