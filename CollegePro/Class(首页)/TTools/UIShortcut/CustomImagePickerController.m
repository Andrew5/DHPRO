 //
//  CustomImagePickerController.m
//  MeiJiaLove
//
//  Created by Wu.weibin on 13-7-9.
//  Copyright (c) 2013年 Wu.weibin. All rights reserved.
//

#import "CustomImagePickerController.h"
#import "UIImage+Cut.h"

@interface CustomImagePickerController ()

@end

@implementation CustomImagePickerController

//@synthesize customDelegate = _customDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark get/show the UIView we want
- (UIView *)findView:(UIView *)aView withName:(NSString *)name {
	Class cl = [aView class];
	NSString *desc = [cl description];
	
	if ([name isEqualToString:desc])
		return aView;
	
	for (NSUInteger i = 0; i < [aView.subviews count]; i++) {
		UIView *subView = [aView.subviews objectAtIndex:i];
		subView = [self findView:subView withName:name];
		if (subView)
			return subView;
	}
	return nil;
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    UIImage *backgroundImage = [UIImage imageNamed:@"bg_header.png"];
    if (version >= 5.0) {
        [navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
        [navigationController.navigationBar insertSubview:[[UIImageView alloc] initWithImage:backgroundImage]  atIndex:1];
    }
    
    if(self.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImage *deviceImage = [UIImage imageNamed:@"camera_button_switch_camera.png"];
        UIButton *deviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deviceBtn setBackgroundImage:deviceImage forState:UIControlStateNormal];
        [deviceBtn addTarget:self action:@selector(swapFrontAndBackCameras:) forControlEvents:UIControlEventTouchUpInside];
        [deviceBtn setFrame:CGRectMake(250, 20, deviceImage.size.width, deviceImage.size.height)];
        
        UIView *PLCameraView=[self findView:viewController.view withName:@"PLCameraView"];
        [PLCameraView addSubview:deviceBtn];
        
        [self setShowsCameraControls:NO];
        
        UIView *overlyView = [[UIView alloc] initWithFrame:CGRectMake(0, DH_DeviceHeight - 34, DH_DeviceWidth, 44)];
        [overlyView setBackgroundColor:[UIColor clearColor]];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backImage = [UIImage imageNamed:@"camera_cancel.png"];
        [backBtn setImage: backImage forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setFrame:CGRectMake(8, 5, backImage.size.width, backImage.size.height)];
        [overlyView addSubview:backBtn];
        
        UIImage *camerImage = [UIImage imageNamed:@"camera_shoot.png"];
        UIButton *cameraBtn = [[UIButton alloc] initWithFrame:
                               CGRectMake(110, 5, camerImage.size.width, camerImage.size.height)];
        [cameraBtn setImage:camerImage forState:UIControlStateNormal];
        [cameraBtn addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
        [overlyView addSubview:cameraBtn];
        
        UIImage *photoImage = [UIImage imageNamed:@"camera_album.png"];
        UIButton *photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(260, 5, 70, 40)];
        [photoBtn setImage:photoImage forState:UIControlStateNormal];
        [photoBtn addTarget:self action:@selector(showPhoto) forControlEvents:UIControlEventTouchUpInside];
        [overlyView addSubview:photoBtn];
        
        self.cameraOverlayView = overlyView;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
//    [super dealloc];
}
#pragma mark - ButtonAction Methods

- (IBAction)swapFrontAndBackCameras:(id)sender {
    if (self.cameraDevice ==UIImagePickerControllerCameraDeviceRear ) {
        self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }else {
        self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}


- (void)closeView
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)takePicture
{
    [super takePicture];
}

- (void)showPhoto
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [image clipImageWithScaleWithsize:CGSizeMake(DH_DeviceWidth, DH_DeviceHeight)] ;
    [picker dismissViewControllerAnimated:NO completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
        [self.customDelegate cameraPhoto:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    if(_isSingle){
        [picker dismissModalViewControllerAnimated:YES];
    }else{
        if(picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
            [picker dismissModalViewControllerAnimated:YES];

//            self.sourceType = UIImagePickerControllerSourceTypeCamera;
//        }else{
//            [picker dismissModalViewControllerAnimated:YES];
        }
    }
}

@end
