//
//  PhotoClipViewController.m
//  CollegePro
//
//  Created by jabraknight on 2019/7/15.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "PhotoClipViewController.h"
#import "PhotoTweaksViewController.h"

@interface PhotoClipViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoTweaksViewControllerDelegate>

@end

@implementation PhotoClipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowleftBtn = NO;
    self.title= @"图片裁剪";
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.navigationBarHidden = YES;
    [self presentViewController:picker animated:YES completion:nil];

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    PhotoTweaksViewController *photoTweaksViewController = [[PhotoTweaksViewController alloc] initWithImage:image];
    photoTweaksViewController.delegate = self;
    photoTweaksViewController.autoSaveToLibray = YES;
    photoTweaksViewController.maxRotationAngle = M_PI_4;
    [picker pushViewController:photoTweaksViewController animated:YES];
}

- (void)photoTweaksController:(PhotoTweaksViewController *)controller didFinishWithCroppedImage:(UIImage *)croppedImage
{
    [controller.navigationController popViewControllerAnimated:YES];
}

- (void)photoTweaksControllerDidCancel:(PhotoTweaksViewController *)controller
{
    [controller.navigationController popViewControllerAnimated:YES];
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
