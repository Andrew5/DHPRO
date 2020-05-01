//
//  LHCaptureView.m
// https://github.com/Mars-Programer/LHCamera
//
//  Created by 刘欢 on 2017/2/9.
//  Copyright © 2017年 imxingzhe.com. All rights reserved.
//

#import "LHCaptureView.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+Resize.h"
@interface LHCaptureView ()<UIGestureRecognizerDelegate>
{
    BOOL _isflashOn;
    
    CGFloat _effectiveScale;
    CGFloat _beginGestureScale;
}
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic) AVCaptureDevice *captureDevice;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic) AVCaptureDeviceInput *captureDeviceInput;

@property (nonatomic) AVCaptureStillImageOutput *imageOutPut;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic) AVCaptureSession *captureSession;

//图像预览层，实时显示捕获的图像
@property(nonatomic) AVCaptureVideoPreviewLayer *capturePreviewLayer;

@property (nonatomic) UIView *focusView;
@property(nonatomic,strong)CMMotionManager  *cmmotionManager;
@property (nonatomic,assign) UIDeviceOrientation orientation;
@end

@implementation LHCaptureView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];

        [self commonInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
                 WithDelegate:(id<LHCaptureViewDelegate>)delegate{
    
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        self.backgroundColor = [UIColor whiteColor];
        [self commonInit];
    }
    return self;
}
- (CMMotionManager *)cmmotionManager
{
    if (_cmmotionManager == nil) {
        _cmmotionManager = [[CMMotionManager alloc]init];
    }
    return _cmmotionManager;
}
- (AVCaptureDevice *)captureDevice
{
    if (_captureDevice == nil) {
        //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
        _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _captureDevice;
}
- (AVCaptureDeviceInput *)captureDeviceInput
{
    if (_captureDeviceInput == nil) {
        //使用设备初始化输入
        _captureDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:self.captureDevice
                                                                    error:nil];
    }
    return _captureDeviceInput;
}
- (AVCaptureStillImageOutput *)imageOutPut
{
    if (_imageOutPut == nil) {
        //生成输出对象
        _imageOutPut = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *myOutputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
        [_imageOutPut setOutputSettings:myOutputSettings];
    }
    return _imageOutPut;
}
- (AVCaptureVideoPreviewLayer *)capturePreviewLayer
{
    if (_capturePreviewLayer == nil) {
        _capturePreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
        _capturePreviewLayer.backgroundColor = [UIColor blackColor].CGColor;
        CGRect layerRect = [[self layer] bounds];
        [_capturePreviewLayer setBounds:layerRect];
        [_capturePreviewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
        _capturePreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _capturePreviewLayer;
}

- (UIView *)focusView
{
    if (_focusView == nil) {
        _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _focusView.layer.borderWidth = 1.0;
        _focusView.layer.borderColor =[UIColor greenColor].CGColor;
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.hidden = YES;
    }
    return _focusView;
}
- (AVCaptureSession *)captureSession
{
    if (_captureSession == nil) {
        //生成会话，用来结合输入输出
        _captureSession = [[AVCaptureSession alloc]init];
    
        if ([_captureSession canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
            _captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
            
        }
        if ([_captureSession canAddInput:self.captureDeviceInput]) {
            [_captureSession addInput:self.captureDeviceInput];
        }
        
        if ([_captureSession canAddOutput:self.imageOutPut]) {
            [_captureSession addOutput:self.imageOutPut];
        }
    }
    return _captureSession;
}

- (void)commonInit
{
    
    _effectiveScale = 1.0;
    _beginGestureScale = 1.0;
    
    if (![self canUserCamear]) return;
    
    [self customCamera];
    [self addSubview:self.focusView];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGesture];
    
    UIPinchGestureRecognizer *pich = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinchGesture:)];
    [self addGestureRecognizer:pich];
}
// 使用陀螺仪来判定拍照时是横屏还是竖屏
- (void)startAccelerometerUpdates
{
    
    if([self.cmmotionManager isDeviceMotionAvailable]) {

       __weak typeof(self) weakSelf = self;
        
        [self.cmmotionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            
            CGFloat xx = accelerometerData.acceleration.x;
            CGFloat yy = -accelerometerData.acceleration.y;
            CGFloat zz = accelerometerData.acceleration.z;
            CGFloat device_angle = M_PI / 2.0f - atan2(yy, xx);
            
            if (device_angle > M_PI){
                device_angle -= 2 * M_PI;
            }
            
            if ((zz < -.60f) || (zz > .60f)) {
                weakSelf.orientation = UIDeviceOrientationUnknown;
            }else{
                if ( (device_angle > -M_PI_4) && (device_angle < M_PI_4) ){
                    weakSelf.orientation = UIDeviceOrientationPortrait;
                }
                else if ((device_angle < -M_PI_4) && (device_angle > -3 * M_PI_4)){
                    weakSelf.orientation = UIDeviceOrientationLandscapeLeft;
                }
                else if ((device_angle > M_PI_4) && (device_angle < 3 * M_PI_4)){
                    weakSelf.orientation = UIDeviceOrientationLandscapeRight;
                }
                else{
                    weakSelf.orientation = UIDeviceOrientationPortraitUpsideDown;
                }
            }
            //NSLog(@"============= %f %ld",device_angle,(long)weakSelf.orientation);
        }];

    }
}
- (void)endAccelerometerUpdates
{
    [self.cmmotionManager stopAccelerometerUpdates];
    self.cmmotionManager = nil;
    
    _effectiveScale = 1.0;
    [self changeEffectiveScale];
}
- (void)customCamera{
        
    [self.layer addSublayer:self.capturePreviewLayer];

    if ([self.captureDevice lockForConfiguration:nil]) {
        
        [self flashSwitch:self.flashState];
        //自动白平衡
        if ([self.captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [self.captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [self.captureDevice unlockForConfiguration];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //开始启动
        [self.captureSession startRunning];
    });
   
}
#pragma mark -- 聚焦框
- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}
- (void)focusAtPoint:(CGPoint)point{
    
    CGSize size = self.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.captureDevice lockForConfiguration:&error]) {
        
        if ([self.captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.captureDevice setFocusPointOfInterest:focusPoint];
            [self.captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.captureDevice setExposurePointOfInterest:focusPoint];
            [self.captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.captureDevice unlockForConfiguration];
        self.focusView.center = point;
        self.focusView.hidden = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self.focusView.hidden = YES;
            }];
        }];
    }
    
}
#pragma mark -- 闪光灯开关
- (void)flashSwitch:(LHCaptureViewFlashSwitch)switchModel{
    AVCaptureFlashMode flashModel = (AVCaptureFlashMode)switchModel;
    if ([self.captureDevice lockForConfiguration:nil]) {
        
        if ([self.captureDevice isFlashModeSupported:flashModel]) {
            [self.captureDevice setFlashMode:flashModel];
        }
        [self.captureDevice unlockForConfiguration];
    }
}
#pragma mark -- 改变前后摄像头
- (void)changeCamera{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        
        CATransition *animation = [CATransition animation];
        animation.duration = .5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = @"oglFlip";
        
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        AVCaptureDevicePosition position = [[self.captureDeviceInput device] position];
        if (position == AVCaptureDevicePositionFront){
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            animation.subtype = kCATransitionFromLeft;
        }
        else {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;
        }
        
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        [self.capturePreviewLayer addAnimation:animation forKey:nil];
        if (newInput != nil) {
            
            [self.captureSession beginConfiguration];
            [self.captureSession removeInput:self.captureDeviceInput];
            if ([self.captureSession canAddInput:newInput]) {
                [self.captureSession addInput:newInput];
                self.captureDeviceInput = newInput;
                
            } else {
                [self.captureSession addInput:self.captureDeviceInput];
            }
            
            [self.captureSession commitConfiguration];
            
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
        
    }
}
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}
#pragma mark - 拍照 截取照片
- (void)shutterCamera
{
    AVCaptureConnection * videoConnection = [self.imageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }

    [videoConnection setVideoScaleAndCropFactor:_effectiveScale];

    __weak typeof(self) weakSelf = self;
    [self.imageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection
                                                  completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        UIImage *originImage = [[UIImage alloc] initWithData:imageData];
        CGSize size = CGSizeMake(weakSelf.capturePreviewLayer.bounds.size.width * 2,
                                 weakSelf.capturePreviewLayer.bounds.size.height * 2);
        
        UIImage *scaledImage = [originImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                                 bounds:size
                                                   interpolationQuality:kCGInterpolationHigh];
        
        CGRect cropFrame = CGRectMake((scaledImage.size.width - size.width) / 2,
                                      (scaledImage.size.height - size.height) / 2,
                                      size.width, size.height);
        UIImage *croppedImage = nil;
        if (weakSelf.captureDeviceInput.device.position == AVCaptureDevicePositionFront) {
            croppedImage = [scaledImage croppedImage:cropFrame
                                     WithOrientation:UIImageOrientationUpMirrored];
        }else
        {
            croppedImage = [scaledImage croppedImage:cropFrame];
        }
        //横屏时旋转image
        croppedImage = [croppedImage changeImageWithOrientation:_orientation];
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(shutterCameraWithImage:)]) {
            [weakSelf.delegate shutterCameraWithImage:croppedImage];
        }
    }];
}
#pragma mark --缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:recognizer.view];
        CGPoint convertedLocation = [self.capturePreviewLayer convertPoint:location
                                                                 fromLayer:self.layer];
        if ( ! [self.capturePreviewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        
        _effectiveScale = _beginGestureScale * recognizer.scale;
        _effectiveScale = MAX(_effectiveScale, 1.0);

        CGFloat maxScaleAndCropFactor = [[self.imageOutPut connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        if (_effectiveScale > maxScaleAndCropFactor)
            _effectiveScale = maxScaleAndCropFactor;
        
        [self changeEffectiveScale];
    }
}
- (void)changeEffectiveScale
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:.025];
    [self.capturePreviewLayer setAffineTransform:CGAffineTransformMakeScale(_effectiveScale, _effectiveScale)];
    [CATransaction commit];

}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        _beginGestureScale = _effectiveScale;
    }
    return YES;
}
#pragma - 保存至相册
+ (void)saveImageToPhotoAlbum:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, nil, NULL);
}
#pragma mark - 检查相机权限
- (BOOL)canUserCamear{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted ||
        authStatus ==AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"前往设置" otherButtonTitles:@"取消", nil];
        alertView.tag = 100;
        [alertView show];
        return NO;
    }else{
        return YES;
    }
    return YES;
}
- (BOOL)canUsePhotos {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
        if (
            author == kCLAuthorizationStatusDenied) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相册权限" message:@"设置-隐私-相册" delegate:self cancelButtonTitle:@"前往设置" otherButtonTitles:@"取消", nil];
            alertView.tag = 100;
            [alertView show];
            //无权限
            return NO;
        }else if (author == kCLAuthorizationStatusNotDetermined)
            return NO;
    }
    else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted ||
            status == PHAuthorizationStatusDenied) {
            //无权限
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相册权限" message:@"设置-隐私-相册" delegate:self cancelButtonTitle:@"前往设置" otherButtonTitles:@"取消", nil];
            alertView.tag = 100;
            [alertView show];
            return NO;
        }else if (status == PHAuthorizationStatusNotDetermined)
            return NO;
    }
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 100) {
        
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(captureAuthorizationFail)]) {
        [self.delegate captureAuthorizationFail];
    }

}
#pragma mark -- 记录闪光灯开关状态
- (LHCaptureViewFlashSwitch)flashState
{
   return  [[NSUserDefaults standardUserDefaults]integerForKey:@"AACaptureViewFlashSwitch"];
}
- (void)setFlashState:(LHCaptureViewFlashSwitch)flashState
{
    [[NSUserDefaults standardUserDefaults]setInteger:flashState
                                              forKey:@"AACaptureViewFlashSwitch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self flashSwitch:flashState];
}
- (void)dealloc
{
    if ([self.captureSession isRunning] || self.cmmotionManager.isAccelerometerActive) {
        [self.captureSession stopRunning];
        self.captureSession = nil;
        [self endAccelerometerUpdates];
    }
}
@end
