//
//  MyAnimatedAnnotationView.h
//  IphoneMapSdkDemo
//
//  Created by wzy on 14-11-27.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <BaiduMapAPI/BMKAnnotationView.h>

@protocol MyAnimatedAnnotationViewDelegate <NSObject>

-(void)AnimatedAnnotationClick:(UIButton *)sender;

@end

@interface MyAnimatedAnnotationView : BMKAnnotationView<UIGestureRecognizerDelegate>


@property (nonatomic, strong) NSMutableArray *annotationImages;

@property (nonatomic, strong) UIImage * annotationImage;
@property (nonatomic, strong) UIImageView *annotationImageView;

@property(nonatomic ,assign) id<MyAnimatedAnnotationViewDelegate> delegete;

@end
