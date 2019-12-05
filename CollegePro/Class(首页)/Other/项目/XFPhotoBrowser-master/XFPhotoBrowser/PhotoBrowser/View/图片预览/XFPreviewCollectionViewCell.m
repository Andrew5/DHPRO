//
//  XFPreviewCollectionViewCell.m
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/20.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import "XFPreviewCollectionViewCell.h"

@interface XFPreviewCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation XFPreviewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
    [self.imageView addGestureRecognizer:tapGesture];

}

- (void)tapImageView:(UITapGestureRecognizer *)recognizer {
    if ( self.tapImageViewBlock ) {
        self.tapImageViewBlock();
    }
}

- (void)setupWithImage:(UIImage *)image {
    self.imageView.image = image;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
