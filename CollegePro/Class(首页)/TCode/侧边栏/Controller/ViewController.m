//
//  ViewController.m
//  UIKit_Project
//
//  Created by 世超 王 on 12-6-12.
//  Copyright (c) 2012年 博看文思. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize moveImageView;
@synthesize showImageView;
@synthesize showImage;
@synthesize jiasujiView;
@synthesize labelX;
@synthesize labelY;
@synthesize labelZ;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.jiasujiView.hidden = YES;
    self.showImageView.hidden = YES;
}

- (void)viewDidUnload
{
    [self setLabelX:nil];
    [self setLabelY:nil];
    [self setLabelZ:nil];
    [self setJiasujiView:nil];
    [self setMoveImageView:nil];
    [self setShowImageView:nil];
    [self setShowImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - 打开照相机
- (IBAction)openCamera:(id)sender {
    self.showImageView.hidden = NO;
    //判断是否可以打开相机，模拟器此功能无法使用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //picker.allowsEditing = YES; //是否可编辑
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
}
//选择图片代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.showImage.image = image;
    //图片存入相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self dismissModalViewControllerAnimated:YES];
}
//取消按钮方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - 打开相册
- (IBAction)openPhotoLlibrary:(id)sender {
    self.showImageView.hidden = NO;
    //相册是可以用模拟器打开的
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //picker.allowsEditing = YES; //是否可编辑
        //打开相册选择照片
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
}
//选中图片进入的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.showImage.image = image;
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - 调用外部短信
- (IBAction)openSMSoutApp:(id)sender {
    self.showImageView.hidden = YES;
    //定义打开短信的url，关键字：sms:
    NSURL *numberURL = [NSURL URLWithString:[NSString stringWithFormat:@"sms:1360001234"]];
    //判断程序是否可以打开短信功能
    if ([[UIApplication sharedApplication] canOpenURL:numberURL]) {
        [[UIApplication sharedApplication] openURL:numberURL];
    } else {
        NSLog(@"无法打开短信功能");
    }
}
#pragma mark - 调用内部短信
- (IBAction)openSMSinApp:(id)sender {
    self.showImageView.hidden = YES;
    //判断是否可以发短信
    BOOL canSendSMS = [MFMessageComposeViewController canSendText];	
    if (canSendSMS) {
        //创建短信视图控制器
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        //设置代理，代理方法实现对短信发送状态的监控（成功，失败，取消）
        picker.messageComposeDelegate = self;
        //设置短信内容
        picker.body = @"test";
        //设置发送的电话，
        picker.recipients = [NSArray arrayWithObject:@"136-0000-1234"];
        //打开短信功能
        [self presentModalViewController:picker animated:YES];
        [picker release];		
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            //取消发短信功能
            NSLog(@"Result: canceled");
            break;
        case MessageComposeResultSent:
            //发送短信
            NSLog(@"Result: Sent");
            break;
        case MessageComposeResultFailed:
            //发送失败
            NSLog(@"Result: Failed");
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - 调用外部邮件
- (IBAction)openEmailoutApp:(id)sender {
    self.showImageView.hidden = YES;
    //打开系统邮件页面
    NSURL *mailURL = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@",@"bokan@163.com",@"bokan@126.com",@"ibokan",@"ibokan"]];
    //cc:抄送对象 subject:主题 body:内容
    if ([[UIApplication sharedApplication] canOpenURL:mailURL]) {
        [[UIApplication sharedApplication] openURL:mailURL]; 
    } else {
        NSLog(@"无法打开邮件功能");
    }
}
#pragma mark - 调用内部邮件
- (IBAction)openEmailinApp:(id)sender {
    self.showImageView.hidden = YES;
    //判断是否可以发送Email
    BOOL canSendMail = [MFMailComposeViewController canSendMail];	
    if (canSendMail) {
        //创建邮件视图控制器
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        //设置主题
        [picker setSubject:@"ibokan"];
        //设置发送对象
        [picker setToRecipients:[NSArray arrayWithObject:@"bokan@163.com"]];
        //设置抄送对象
        [picker setCcRecipients:[NSArray arrayWithObject:@"bokan@126.com"]];
        //设置内容
        [picker setMessageBody:@"ibokan" isHTML:YES];
        //设置代理
        [picker setMailComposeDelegate:self];
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            //取消发送
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSent:
            //发送
            NSLog(@"Result: Sent");
            break;
        case MFMailComposeResultFailed:
            //发送失败
            NSLog(@"Result: Failed");
            break;
        case MFMailComposeResultSaved:
            //保存
            NSLog(@"Result: Saved");
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - 开始加速计
- (IBAction)startJiaSuJi:(id)sender {
    self.showImageView.hidden = YES;
    self.jiasujiView.hidden = NO;
    // 设置加速计采集频率(单位:秒)
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0 / 60.0];
	// 设置委托(注意对象销毁时要将委托设置为空)
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
}
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    self.labelX.text = [NSString stringWithFormat:@"%0.2f",acceleration.x];
    self.labelY.text = [NSString stringWithFormat:@"%0.2f",acceleration.y];
    self.labelZ.text = [NSString stringWithFormat:@"%0.2f",acceleration.z];
    
    //左右挪动
    if (acceleration.x < -0.2 && acceleration.x > -1) {
        self.moveImageView.center = CGPointMake(self.moveImageView.center.x-0.5, self.moveImageView.center.y);
    }
    if (acceleration.x > 0.2 && acceleration.x < 1) {
        self.moveImageView.center = CGPointMake(self.moveImageView.center.x+0.5, self.moveImageView.center.y);
    }
    //上下挪动
    if (acceleration.y < -0.2 && acceleration.y > -1) {
        self.moveImageView.center = CGPointMake(self.moveImageView.center.x, self.moveImageView.center.y+0.5);
    }
    if (acceleration.y > 0.2 && acceleration.y < 1) {
        self.moveImageView.center = CGPointMake(self.moveImageView.center.x, self.moveImageView.center.y-0.5);
    }
}
#pragma mark - 停止加速计
- (IBAction)stopJiaSuJi:(id)sender {
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    [self.jiasujiView setHidden:YES];
}
- (void)dealloc {
    [labelX release];
    [labelY release];
    [labelZ release];
    [jiasujiView release];
    [moveImageView release];
    [showImageView release];
    [showImage release];
    [super dealloc];
}

@end
