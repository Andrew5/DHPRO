//
//  ILGLKImageView.m
//  ILVideoEdit
//
//  Created by zhuyongqing on 2017/3/23.
//  Copyright © 2017年 zhuyongqing. All rights reserved.
//

#import "ILGLKImageView.h"
#import <GLKit/GLKit.h>
@interface ILGLKImageView()<GLKViewDelegate>

@property(nonatomic,strong) CIContext *ciContext;

@property(nonatomic,strong) GLKView *glkView;

@property(nonatomic,strong) dispatch_queue_t drawQueue;


@end


@implementation ILGLKImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.opaque = YES;
        
        EAGLContext *egalContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        
        _glkView = [[GLKView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) context:egalContext];
//        _glkView.enableSetNeedsDisplay = NO;
//        [_glkView bindDrawable];
        _glkView.delegate = self;
        [self addSubview:_glkView];

        _glkView.frame = self.bounds;
        _ciContext = [CIContext contextWithEAGLContext:egalContext options:@{kCIContextUseSoftwareRenderer:@false}];
        [EAGLContext setCurrentContext:egalContext];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    @autoreleasepool {
        glClearColor(0, 0, 0, 0);
        glClear(GL_COLOR_BUFFER_BIT);
        
//        CGFloat width = self.z_width * KScreenScale;
//        CGFloat height = self.z_height * KScreenScale;
//    
//        CGSize videoSize = [ILVideoManager shareInstance].currentVideoInfo.videoSize;
//        if ([ILVideoManager shareInstance].currentVideoInfo.sizeOrientation == ILVideoOrientationPortrait) {
//            videoSize = CGSizeMake(videoSize.height, videoSize.width);
//        }
        
        CGRect drawRect = CGRectMake(0, 0, _glkView.drawableWidth, _glkView.drawableHeight);
        [_ciContext drawImage:self.ciImage inRect:drawRect fromRect:[self.ciImage extent]];
    }
    
}

- (void)setCiImage:(CIImage *)ciImage{
    _ciImage = ciImage;
    [_glkView setNeedsDisplay];
    
}

@end
