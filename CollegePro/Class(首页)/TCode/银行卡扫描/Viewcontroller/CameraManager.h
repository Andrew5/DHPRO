//
//  CameraManager.h
//  BankCard
//
//  Created by XAYQ-FanXL on 16/7/8.
//  Copyright © 2016年 AN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol CameraManagerDelegate <NSObject>
@optional
- (void)deviceConfigurationFailedWithError:(NSError*)error;
- (void)didEndRecNumber:(NSString*)number bank:(NSString *)bank image:(UIImage*)image;
@end

@interface CameraManager : NSObject

@property (nonatomic, weak) id <CameraManagerDelegate> delegate;

//AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic, strong) AVCaptureSession *captureSession;
//AVCaptureDeviceInput对象是输入流
@property (nonatomic, strong) AVCaptureDeviceInput *activeVideoInput;
//出流对象
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;

@property (nonatomic, strong) NSMutableDictionary *videoSettings;

//图片质量大小
@property (nonatomic, copy) NSString *sessionPreset;


@property (nonatomic, assign, readonly) BOOL cameraHasTorch;
@property (nonatomic, assign, readonly) BOOL cameraHasFlash;
@property (nonatomic, assign, readonly) BOOL cameraSupportsTapToFocus;
@property (nonatomic, assign, readonly) BOOL cameraSupportsTapToExpose;
@property (nonatomic, assign) AVCaptureTorchMode torchMode;
@property (nonatomic, assign) AVCaptureFlashMode flashMode;

- (void)resetParams;

- (BOOL)setupSession:(NSError **)error;

- (void)startSession;
- (void)stopSession;

- (BOOL)switchCameras;

- (void)focusAtPoint:(CGPoint)point;

- (void)exposeAtPoint:(CGPoint)point;


@end
