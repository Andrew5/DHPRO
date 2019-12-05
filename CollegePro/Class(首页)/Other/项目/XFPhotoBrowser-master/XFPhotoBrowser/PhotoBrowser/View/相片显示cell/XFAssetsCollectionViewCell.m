//
//  XFAssetsCollectionViewCell.m
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/5.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import "XFAssetsCollectionViewCell.h"
#import "XFAssetsModel.h"

@interface XFAssetsCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UIImageView *assetsImageView;

@end

@implementation XFAssetsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(XFAssetsModel *)model {
    _model = model;
    
    self.statusImageView.hidden = !model.selected;
    self.assetsImageView.image = model.thumbnailImage;
}

@end
