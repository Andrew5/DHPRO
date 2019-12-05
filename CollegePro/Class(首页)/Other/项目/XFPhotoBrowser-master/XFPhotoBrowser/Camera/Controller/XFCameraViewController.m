//
//  XFCameraViewController.m
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/11.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import "XFCameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "XFAssetsModel.h"

@interface XFCameraViewController ()
/**
 *  AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
 */
@property (nonatomic, strong) AVCaptureSession* session;
/**
 *  输入设备
 */
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;
/**
 *  照片输出流
 */
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;
/**
 *  预览图层
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;
/**
 *  记录开始的缩放比例
 */
@property(nonatomic,assign)CGFloat beginGestureScale;
/**
 * 最后的缩放比例
 */
@property(nonatomic,assign)CGFloat effectiveScale;

@property (assign, nonatomic) BOOL isUsingFrontFacingCamera;;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *buttonLayerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lastPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *takePhotosNumberLabel;
@property (strong, nonatomic) NSMutableArray<XFAssetsModel *> *photosArray;
@end

@implementation XFCameraViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    if ( self.session ) {
        
        [self.session startRunning];
        
        [self updateDeviceScrale:self.beginEffectiveScale];
    }
    
    /**
     *  监听相机的对焦事件
     */
    AVCaptureDevice *camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    int flags = NSKeyValueObservingOptionNew;
    [camDevice addObserver:self forKeyPath:@"adjustingFocus" options:flags context:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ( self.beginEffectiveScale == 0.f ) {
        self.effectiveScale = self.beginGestureScale = 1.0f;
    }else {
        self.effectiveScale = self.beginEffectiveScale;
        self.beginGestureScale = self.beginEffectiveScale;
    }
    
    if ( self.maxEffectiveScale == 0.f ) {
        self.maxEffectiveScale = 4.f;
    }
    
    [self initAVCaptureSession];
    
    self.buttonLayerLabel.layer.borderWidth = 4.f;
    self.buttonLayerLabel.layer.borderColor = HEX(@"F2F2F2").CGColor;
    
    [self setUpGesture];
    
    self.isUsingFrontFacingCamera = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    
    if ( self.session ) {
        
        [self.session stopRunning];
    }
    
    AVCaptureDevice*camDevice =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [camDevice removeObserver:self forKeyPath:@"adjustingFocus"];
}

-(void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context {
    if ( [keyPath isEqual:@"adjustingFocus"] ) {
        
    }
}

#pragma mark - 返回按钮
- (IBAction)didBackButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 初始化照相机
- (void)initAVCaptureSession{
    
    self.session = [[AVCaptureSession alloc] init];
    
    NSError *error;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    self.previewLayer.frame = CGRectMake(0, 0,XFScreenWidth, XFScreenWidth);
    self.contentView.layer.masksToBounds = YES;
    [self.contentView.layer addSublayer:self.previewLayer];
}

#pragma mark - 获取设备方向的方法，再配置图片
-(AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
    
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft ) {
        result = AVCaptureVideoOrientationLandscapeRight;
    }else if ( deviceOrientation == UIDeviceOrientationLandscapeRight ) {
        result = AVCaptureVideoOrientationLandscapeLeft;
    }
    return result;
}

#pragma mark - 照相按钮
- (IBAction)takePhotoButtonClick:(UIButton *)sender {
    
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:1];
    
    XFWeakSelf;
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if ( imageDataSampleBuffer ) {
            
            NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, imageDataSampleBuffer, kCMAttachmentMode_ShouldPropagate);
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeImageDataToSavedPhotosAlbum:jpegData metadata:(__bridge id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
                if ( assetURL ) {
                    [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"TAKEPHOTOS_REFRESHLIBRARY" object:nil];
                        
                        XFAssetsModel *model = [XFAssetsModel getModelWithData:asset];
                        [wself.photosArray addObject:model];
                        
                        wself.lastPhotoImageView.image = [UIImage imageWithCGImage:asset.thumbnail];
                        wself.takePhotosNumberLabel.text = wself.photosArray.count?@(wself.photosArray.count).stringValue:@"";
                        
                        if ( wself.takePhotosBlock ) {
                            wself.takePhotosBlock(model);
                        }
                    } failureBlock:^(NSError *error) {
                        NSLog(@"%@",error.domain);
                    }];
                } else {
                    NSLog(@"%@",error.domain);
                }
            }];
        }else {
            NSLog(@"%@",error.domain);
        }
    }];
}

#pragma 创建手势
- (void)setUpGesture{
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
    [self.contentView addGestureRecognizer:pinch];
}

#pragma mark - 让照相机重新对焦
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.contentView];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        [self updateDeviceScrale:recognizer.scale];
    }
}

- (void)updateDeviceScrale:(CGFloat)scale {
    self.effectiveScale = self.beginGestureScale * scale;
    if (self.effectiveScale < 1.0){
        self.effectiveScale = 1.0;
    }else if ( self.effectiveScale >= self.maxEffectiveScale ) {
        self.effectiveScale = self.maxEffectiveScale;
    }
    
//    NSLog(@"%f-------------->%f------------recognizerScale%f",self.effectiveScale,self.beginGestureScale,scale);
    
    CGFloat maxScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
    
//    NSLog(@"%f",maxScaleAndCropFactor);
    if (self.effectiveScale > maxScaleAndCropFactor)
        self.effectiveScale = maxScaleAndCropFactor;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:.025];
    [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
    [CATransaction commit];
}

#pragma mark - 切换镜头
- (IBAction)switchCameraSegmentedControlClick:(UISegmentedControl *)sender {
    
//    NSLog(@"%ld",(long)sender.selectedSegmentIndex);
    
    AVCaptureDevicePosition desiredPosition;
    if ( sender.selectedSegmentIndex == 0 ){
        desiredPosition = AVCaptureDevicePositionBack;
    }else{
        desiredPosition = AVCaptureDevicePositionFront;
    }
    
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ( [device position] == desiredPosition) {
            [self.previewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            [self.previewLayer.session addInput:input];
            [self.previewLayer.session commitConfiguration];
            break;
        }
    }
}

#pragma mark - 闪光灯设置
- (IBAction)flashButtonClick:(UIButton *)sender {
    
//    NSLog(@"flashButtonClick");
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //修改前必须先锁定
    [device lockForConfiguration:nil];
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ( [device hasFlash] ) {
        if ( device.flashMode == AVCaptureFlashModeOff ) {
            [self.session beginConfiguration];
            [device setTorchMode:AVCaptureTorchModeOn];
            [device setFlashMode:AVCaptureFlashModeOn];
            [self.session commitConfiguration];
            
            [sender setTitle:@"flashOn" forState:UIControlStateNormal];
        }else if ( device.flashMode == AVCaptureFlashModeOn ) {
            [self.session beginConfiguration];
            [device setTorchMode:AVCaptureTorchModeAuto];
            [device setFlashMode:AVCaptureFlashModeAuto];
            [self.session commitConfiguration];
            
            [sender setTitle:@"flashAuto" forState:UIControlStateNormal];
        }else {
            //关闭闪光灯
            [self.session beginConfiguration];
            [device setTorchMode:AVCaptureTorchModeOff];
            [device setFlashMode:AVCaptureFlashModeOff];
            [self.session commitConfiguration];
            
            [sender setTitle:@"flashOff" forState:UIControlStateNormal];
        }
    } else {
        
        NSLog(@"设备不支持闪光灯");
    }
    [device unlockForConfiguration];
}

#pragma mark - 处理点击对焦事件
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

#pragma mark - 懒加载
- (NSMutableArray *)photosArray {
    if ( !_photosArray ) {
        _photosArray = [NSMutableArray array];
    }
    return _photosArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
