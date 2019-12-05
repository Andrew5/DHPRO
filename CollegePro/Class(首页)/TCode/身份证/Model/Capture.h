//
//  Capture.h
//  idcard
//
//  Created by hxg on 16-4-10.
//  Copyright (c) 2016年 林英伟. All rights reserved.
//

#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "IdInfo.h"
#import "excards.h"

@protocol CaptureDelegate<NSObject>

@optional

- (void)idCardRecognited:(IdInfo*)idInfo;

@end


@interface Capture : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    
}

@property (strong,nonatomic) AVCaptureVideoPreviewLayer     *previewLayer;
@property (strong,nonatomic) AVCaptureSession               *captureSession;
@property (strong,nonatomic) AVCaptureStillImageOutput      *stillImageOutput;
@property (strong,nonatomic) UIImage                        *stillImage;
@property (strong,nonatomic) NSNumber                       *outPutSetting;
@property (weak, nonatomic) id<CaptureDelegate>             delegate;
@property (nonatomic)BOOL             verify;

/**
 *  @brief Add video input: front or back camera:
 *  AVCaptureDevicePositionBack
 *  AVCaptureDevicePositionFront
 */
- (void)addVideoInput:(AVCaptureDevicePosition)_campos;

/**
 *  @brief Add video output
 */
- (void)addVideoOutput;

/**
 *  @brief Add preview layer
 */
- (void)addVideoPreviewLayer;

@end