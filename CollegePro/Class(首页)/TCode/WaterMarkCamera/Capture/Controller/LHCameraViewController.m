//
//  LHCameraViewController.m
//  https://github.com/Mars-Programer/LHCamera
//
//  Created by 刘欢 on 2017/2/8.
//  Copyright © 2017年 imxingzhe.com. All rights reserved.
//

#import "LHCameraViewController.h"
#import "LHCaptureView.h"
#import "DPPhotoListViewController.h"
#import "PHAsset+Method.h"
#import "LHWatermarkViewController.h"
#import "UIImage+Watermark.h"
#import "UIView+AAToolkit.h"
#import "LHWatermarkDataModel.h"

@interface LHCameraViewController () <LHCaptureViewDelegate,DPPhotoGroupViewControllerDelegate>

@property (nonatomic, strong) LHCaptureView *captureView;
@property (nonatomic) UIButton *captureButton;
@property (nonatomic,strong) UIView *toolsView;

@end

@implementation LHCameraViewController
- (UIButton *)captureButton
{
    if (_captureButton == nil) {
        _captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _captureButton.frame = CGRectMake(0, 0, 72 * SCREEN_667, 72 * SCREEN_667);
        _captureButton.center = CGPointMake(SCREENWIDTH / 2, kCameraToolsViewHeight / 2);
        [_captureButton setImage:[UIImage imageNamed:@"xz_capture_click"]
                        forState: UIControlStateNormal];
        [_captureButton addTarget:self action:@selector(shutterCamera)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _captureButton;
}
- (LHCaptureView *)captureView
{
    if (_captureView == nil) {
        _captureView = [[LHCaptureView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEITH - kCameraToolsViewHeight)
                                              WithDelegate:self];
    }
    return _captureView;
}
- (UIView *)toolsView
{
    if (_toolsView == nil) {
        _toolsView = [[UIView alloc]initWithFrame:CGRectMake(0,SCREENHEITH - kCameraToolsViewHeight,SCREENWIDTH,kCameraToolsViewHeight)];
        _toolsView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_toolsView];
    }
    return _toolsView;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.isShowleftBtn = NO;
    [self customUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.captureView startAccelerometerUpdates];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.captureView endAccelerometerUpdates];
}

#pragma mark -- 相机相关功能
- (void)shutterCamera
{
    [self.captureView shutterCamera];
    
}
- (void)changeCamera
{
    [self.captureView changeCamera];
}
- (void)flashSwitch:(UIButton *)button
{
    LHCaptureViewFlashSwitch type = self.captureView.flashState;

    if (type < LHCaptureViewFlashModeAuto) {
        type ++;
    }else
        type = LHCaptureViewFlashModeOff;
    
    self.captureView.flashState = type;

    NSString *imageName = @"xz_camera_flashlight_auto";
    if (type == LHCaptureViewFlashModeOff) {
        imageName = @"xz_camera_flashlight_off";
    }else if (type == LHCaptureViewFlashModeOn){
        imageName = @"xz_camera_flashlight_on";
    }else{
        imageName = @"xz_camera_flashlight_auto";
    }
    [button setImage:[UIImage imageNamed:imageName]
            forState:UIControlStateNormal];
}
#pragma mark -- UI 相关
- (void)customUI{
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.captureView];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    title.textColor = [UIColor colorWithWhite:51 / 255.0 alpha:1];
    title.font = [UIFont systemFontOfSize:18];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"水印相机";
    
    self.navigationItem.titleView = title;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 0, 48, 48);
    LHCaptureViewFlashSwitch type = self.captureView.flashState;
    
    NSString *imageName = @"xz_camera_flashlight_auto";
    if (type == LHCaptureViewFlashModeOff) {
        imageName = @"xz_camera_flashlight_off";
    }else if (type == LHCaptureViewFlashModeOn){
        imageName = @"xz_camera_flashlight_on";
    }else{
        imageName = @"xz_camera_flashlight_auto";
    }
    [button setImage:[UIImage imageNamed:imageName]
            forState:UIControlStateNormal];
    [button addTarget:self action:@selector(flashSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    
    
    [self cameraToolsBottomView];
}

- (void)cameraToolsBottomView{
    
    UIImageView *albumImageView = [[UIImageView alloc]initWithFrame:CGRectMake(24, 0, 60, 60)];
    albumImageView.centerY = kCameraToolsViewHeight / 2;
    albumImageView.userInteractionEnabled = YES;
    albumImageView.contentMode = UIViewContentModeScaleAspectFill;
    albumImageView.clipsToBounds = YES;
    [self.toolsView addSubview:albumImageView];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(selectedPhotoClick)];
    [albumImageView addGestureRecognizer:tap];
    PHAsset *asset = [PHAsset latestAsset];

    if ([self.captureView canUsePhotos]) {
        //获取系统相册最后一张图片并显示在button上
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        [imageManager requestImageForAsset:asset targetSize:CGSizeZero contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) {
                albumImageView.image = result;
            }
        }];
    }
    
    
    UIButton *changeCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    changeCameraButton.frame = CGRectMake(SCREENWIDTH * 3/4.0, 0, 32, 32);
    changeCameraButton.centerY = kCameraToolsViewHeight / 2;
    [changeCameraButton setImage:[UIImage imageNamed:@"xz_changeCamera_click"]
                        forState:UIControlStateNormal];
    [changeCameraButton addTarget:self
                           action:@selector(changeCamera)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.toolsView addSubview:changeCameraButton];
    
    [self.toolsView addSubview:self.captureButton];
    
}
#pragma mark -- 事件相关
- (void)selectedPhotoClick
{
    DPPhotoGroupViewController *groupVC = [DPPhotoGroupViewController new];
    groupVC.maxSelectionCount = 1;
    groupVC.delegate = self;
    [self presentViewController:[[UINavigationController alloc]
                                 initWithRootViewController:groupVC]
                       animated:YES
                     completion:nil];
}
#pragma mark -- DPPhotoGroupViewControllerDelegate
- (void)didSelectPhotos:(NSMutableArray *)photos
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self enterWatermarkWithImage:photos.lastObject];
 
    });
}
- (void)backClick{
    [self captureAuthorizationFail];
}
#pragma mark -- LHCaptureViewDelegate
- (void)captureAuthorizationFail
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)shutterCameraWithImage:(UIImage *)image
{
    [self enterWatermarkWithImage:image];
}
- (void)enterWatermarkWithImage:(UIImage *)image
{
  
    LHWatermarkDataModel *model = [[LHWatermarkDataModel alloc]init];
    model.watermarkImage = image;
    model.soureImage = image;
    LHWatermarkViewController *watermark = [[LHWatermarkViewController alloc]init];
    watermark.model = model;
    [self presentViewController:watermark animated:YES completion:nil];
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
