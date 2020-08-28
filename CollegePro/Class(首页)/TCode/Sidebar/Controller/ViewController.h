//
//  ViewController.h
//  UIKit_Project
//
//  Created by 世超 王 on 12-6-12.
//  Copyright (c) 2012年 博看文思. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface ViewController : UIViewController <UIAccelerometerDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
- (IBAction)openCamera:(id)sender;
- (IBAction)openPhotoLlibrary:(id)sender;
- (IBAction)openSMSoutApp:(id)sender;
- (IBAction)openSMSinApp:(id)sender;
- (IBAction)openEmailoutApp:(id)sender;
- (IBAction)openEmailinApp:(id)sender;
- (IBAction)startJiaSuJi:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *showImageView;
@property (retain, nonatomic) IBOutlet UIImageView *showImage;

@property (retain, nonatomic) IBOutlet UIView *jiasujiView;
@property (retain, nonatomic) IBOutlet UILabel *labelX;
@property (retain, nonatomic) IBOutlet UILabel *labelY;
@property (retain, nonatomic) IBOutlet UILabel *labelZ;
- (IBAction)stopJiaSuJi:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *moveImageView;
@end
