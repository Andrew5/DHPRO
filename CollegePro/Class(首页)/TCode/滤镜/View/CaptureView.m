//
//  CaptureView.m
//  15
//
//  Created by jabraknight on 2018/11/29.
//  Copyright © 2018 大爷公司. All rights reserved.
//
#import <GPUImage/GPUImage.h>
//#import <GPUImageOutput/GPUImageOutput.h>
#import <GLKit/GLKit.h>

#import <CoreMotion/CoreMotion.h>
//首先需要引入AVFoundation 头文件  这个框架是音视频的框架 相机功能的API也是
#import <AVFoundation/AVFoundation.h>
//这里拍照时判断手机的方向需要打开陀螺仪 需要这个框架
#import <CoreMotion/CoreMotion.h>

#import "CaptureView.h"

#import "ILGLKImageView.h"

@interface CaptureView ()
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
@property(nonatomic,strong)CMMotionManager  *cmmotionManager;
//GPU
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
//屏幕上显示的View
@property (nonatomic, strong) GPUImageView *filterView;

@property(nonatomic,strong) dispatch_queue_t renderQueue;
@property(nonatomic,strong) AVPlayerItemVideoOutput *videoOutPut;
@property(nonatomic,strong) ILGLKImageView *glkImageView;

@end
@implementation CaptureView
-(instancetype)initWithFrame:(CGRect)frame WithDelegate:(id<CaptureViewDelegate>)delegate
{
    if (self = [super initWithFrame:frame]){
        self.delegate = delegate;
        [self commonInit];

    }
    return self;
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
//        _capturePreviewLayer.backgroundColor = [UIColor blackColor].CGColor;
        CGRect layerRect = [[self layer] bounds];
        [_capturePreviewLayer setBounds:layerRect];
        [_capturePreviewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),CGRectGetMidY(layerRect))];
        _capturePreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _capturePreviewLayer;
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
- (void)customCamera{
    
    [self.layer addSublayer:self.capturePreviewLayer];
    
    if ([self.captureDevice lockForConfiguration:nil]) {
        
//        [self flashSwitch:self.flashState];
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
#pragma mark - 取出每一帧 渲染
- (void)renderCIImageWithCIFilter{
    _renderQueue = dispatch_queue_create("com.renderQueue", DISPATCH_QUEUE_SERIAL);

    dispatch_async(_renderQueue,^{
        dispatch_async(dispatch_get_main_queue(), ^{
            glClear(GL_COLOR_BUFFER_BIT);
        });
        CMTime time = [_videoOutPut itemTimeForHostTime:CACurrentMediaTime()];
        if ([_videoOutPut hasNewPixelBufferForItemTime:time]) {
            CVPixelBufferRef pixelBuffer = NULL;
            pixelBuffer = [_videoOutPut copyPixelBufferForItemTime:time itemTimeForDisplay:nil];
            if (!pixelBuffer) {
                return ;
            }
            __block CIImage *ciLimage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
            CVPixelBufferRelease(pixelBuffer);
            //添加滤镜等效果
            [self renderCIImageWithCIImage:ciLimage];
        }
    });
}
- (void)renderCIImageWithCIImage:(CIImage *)ciImage{

    CIContext *content = [CIContext contextWithOptions:nil];
    CGImageRef img = [content createCGImage:ciImage fromRect:[ciImage extent]];
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:[[UIImage alloc] initWithCGImage:img]];
    CGImageRelease(img);
    
    GPUImageSharpenFilter *scaleFilter = [[GPUImageSharpenFilter alloc] init];
    
//    _scaleCount += 0.005;
//    if (_scaleCount >= 1.2) {
//        _scaleCount = 1.1;
//    }
//    scaleFilter.scale = _scaleCount;
    
    [scaleFilter useNextFrameForImageCapture];
    [picture addTarget:scaleFilter];
    
    [picture processImageWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.glkImageView.ciImage = [[CIImage alloc] initWithCGImage:[scaleFilter imageFromCurrentFramebuffer].CGImage];
//            CIFilter *filter = [CIFilter filterWithName:@"" keysAndValues:kCIInputImageKey, ciImage, nil];
//            [filter setDefaults];
//            CIContext *context = [CIContext contextWithOptions:nil];
//            CIImage *outputImage = [filter outputImage];
//            CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
//            UIImage *effetImage = [UIImage imageWithCGImage:cgImage];
//
//            CGImageRelease(cgImage);
            
        });
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)commonInit
{
    [self customCamera];
    [self renderCIImageWithCIFilter];

}
@end
