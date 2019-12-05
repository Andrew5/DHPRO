//
//  LHCaptureView.h
//******************************************
//gitHub 地址
//  https://github.com/Mars-Programer/LHCamera
//简书地址
//http://www.jianshu.com/p/73d8a7bc44b4

//  Created by LH on 2017/2/9.
//  Copyright © 2017年 imxingzhe.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LHCaptureViewFlashModeOff,
    LHCaptureViewFlashModeOn,
    LHCaptureViewFlashModeAuto,
    
} LHCaptureViewFlashSwitch;

@protocol  LHCaptureViewDelegate<NSObject>

- (void)captureAuthorizationFail;
- (void)shutterCameraWithImage:(UIImage *)image;
@end

@interface LHCaptureView : UIView

@property (nonatomic, weak) id <LHCaptureViewDelegate> delegate;
@property (nonatomic,assign) LHCaptureViewFlashSwitch flashState;

- (instancetype)initWithFrame:(CGRect)frame WithDelegate:(id <LHCaptureViewDelegate>)delegate;
/**
 闪光灯开关模式

 @param switchModel 关、开、自动
 */
- (void)flashSwitch:(LHCaptureViewFlashSwitch)switchModel;

/**
 改变前后摄像头
 */
- (void)changeCamera;

/**
 抓取照片
 */
- (void)shutterCamera;

/**
 保存image 到相册
 */
+ (void)saveImageToPhotoAlbum:(UIImage*)savedImage;

//开启加速计
- (void)startAccelerometerUpdates;
//停止加速计
- (void)endAccelerometerUpdates;

//检查相机权限
- (BOOL)canUserCamear;
//检测相册权限
- (BOOL)canUsePhotos;
@end
