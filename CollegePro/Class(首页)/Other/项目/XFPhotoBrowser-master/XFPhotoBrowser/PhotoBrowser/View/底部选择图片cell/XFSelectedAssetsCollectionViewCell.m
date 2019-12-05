//
//  XFSelectedAssetsCollectionViewCell.m
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/5.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import "XFSelectedAssetsCollectionViewCell.h"
#import <AssetsLibrary/ALAsset.h>
#import "XFAssetsModel.h"

@interface XFSelectedAssetsCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *assetImageView;

@end

@implementation XFSelectedAssetsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(XFAssetsModel *)model {
    _model = model;
    
    self.assetImageView.image = model.thumbnailImage;
}

- (IBAction)didDeleteButtonAction:(UIButton *)sender {
    if ( self.deleteAssetBlock ) {
        self.deleteAssetBlock(self.model);
    }
}

@end
