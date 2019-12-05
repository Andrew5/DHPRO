//
//  MainAnnotationView.h
//  shiku
//
//  Created by yanglele on 15/9/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <BaiduMapAPI/BMKAnnotationView.h>

@interface MainAnnotationView : BMKAnnotationView<UIGestureRecognizerDelegate>


@property (nonatomic, strong) NSMutableArray *annotationImages;

@property (nonatomic, strong) UIImage * annotationImage;
@property (nonatomic, strong) UIImageView *annotationImageView;

@end
