//
//  ScanCardViewController.m
//  OCR_SavingCard
//
//  Created by linyingwei on 16/5/5.
//  Copyright © 2016年 linyingwei. All rights reserved.
//

#import "ScanCardViewController.h"
#import "CameraManager.h"
#import "OverlayView.h"
#import "RectManager.h"

@interface ScanCardViewController ()<CameraManagerDelegate>

@property (nonatomic, strong) CameraManager *cameraManager;
@property (strong, nonatomic) OverlayView *overlayView;

@property (copy,nonatomic) ResultBlock block;

@end

@implementation ScanCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view insertSubview:self.overlayView atIndex:0];
    
    self.cameraManager.delegate = self;
    
    self.cameraManager.sessionPreset = AVCaptureSessionPreset1280x720;
    
    NSError *error;
    if ([self.cameraManager setupSession:&error]) {
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view insertSubview:view atIndex:0];
        AVCaptureVideoPreviewLayer *preLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.cameraManager.captureSession];
        preLayer.frame = [UIScreen mainScreen].bounds;
        
        preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [view.layer addSublayer:preLayer];

        [self.cameraManager startSession];
    }
    else {
        NSLog(@"打开相机失败");
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.cameraManager.captureSession isRunning]) {
        [self.cameraManager stopSession];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([self.cameraManager.captureSession isRunning] == NO) {
        [self.cameraManager startSession];
        [self.cameraManager resetParams];
    }
}

- (CameraManager *)cameraManager {
    if (!_cameraManager) {
        _cameraManager = [[CameraManager alloc] init];
    }
    return _cameraManager;
}

-(OverlayView *)overlayView {
    if(!_overlayView) {
        CGRect rect = [OverlayView getOverlayFrame:[UIScreen mainScreen].bounds];
        _overlayView = [[OverlayView alloc] initWithFrame:rect];
    }
    return _overlayView;
}

- (void)achieveResult:(ResultBlock)block {
    self.block = block;
}

#pragma mark - CameraManagerDelegate
- (void)didEndRecNumber:(NSString *)number bank:(NSString *)bank image:(UIImage *)image {
    self.block(number, bank, image);
    [self.cameraManager stopSession];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
