//
//  GuideViews.m
//  shiku
//
//  Created by  on 15/9/13.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "GuideViews.h"

@implementation GuideViews

- (void)drawRect:(CGRect)rect
{
}

- (void)makeGuideViewWithComplete:(GuideCompleteBlock)block
{
    _imageIndex = 0;

    _imageArr = [NSArray arrayWithObjects:@"ic_lead_1.jpg",@"ic_lead_2.jpg",@"ic_lead_3.jpg",@"ic_lead_4.jpg",@"ic_lead_5.jpg",nil];
    
    _imageView = [[UIImageView alloc]initWithFrame:self.frame];
    [_imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    _imageView.image = [UIImage imageNamed:_imageArr[_imageIndex]];
    
    _imageView.contentMode = UIViewContentModeRedraw;
//    _imageView.backgroundColor =[ UIColor whiteColor];
    _imageView.userInteractionEnabled = YES;
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _imageView.clipsToBounds = YES;

    
    
    [self addSubview:_imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextImage)];
    
    [_imageView addGestureRecognizer:tap];
    self.block = block;
}
- (void)nextImage
{
    _imageIndex++;
    
    if (_imageIndex==MAX_NUM) {
        self.block();
        return;
    }
    _imageView.image = [UIImage imageNamed:_imageArr[_imageIndex]];
    
}
@end
