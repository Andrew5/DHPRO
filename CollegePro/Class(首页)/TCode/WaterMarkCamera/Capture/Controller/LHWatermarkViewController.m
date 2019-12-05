//
//  LHWatermarkViewController.m
//  https://github.com/Mars-Programer/LHCamera
//
//  Created by 刘欢 on 2017/2/10.
//  Copyright © 2017年 imxingzhe.com. All rights reserved.
//

#import "LHWatermarkViewController.h"
#import "LHSelectWatermarkView.h"
#import "LHCaptureView.h"
#import "LHStickerView.h"
#import "UIImage+Watermark.h"
#import "UIImage+Resize.h"
#import "UIImage+Filter.h"
#import "UIImage+Watermark.h"
#import "UIView+AAToolkit.h"


#define KBlueColor [UIColor colorWithRed:24 / 255.0 green:154 / 255.0 blue:219 / 255.0 alpha:1]

@interface LHWatermarkViewController ()<LHSelectWatermarkViewDelegate,LHStickerViewDelegate>

{
    
    NSInteger _guideIndex;
}
@property (nonatomic, strong) UIButton *selectedUpload;
@property (nonatomic, strong) LHSelectWatermarkView *selectWatermarkView;
@property (nonatomic, strong) UIView *basicView;
@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) UIImageView *holdedView;
@end

@implementation LHWatermarkViewController

- (LHSelectWatermarkView *)selectWatermarkView
{
    if (_selectWatermarkView == nil) {
        _selectWatermarkView = [[LHSelectWatermarkView alloc]initWithFrame:CGRectMake(0, SCREENHEITH - kCameraToolsViewHeight, SCREENWIDTH, kCameraToolsViewHeight) WithWatermarks:nil];
        _selectWatermarkView.delegate = self;
    }
    return _selectWatermarkView;
}
- (UIView *)basicView
{
    if (_basicView == nil) {
        _basicView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEITH - kCameraToolsViewHeight)];
        _basicView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenStickerBorder)];
        [_basicView addGestureRecognizer:tap];
        [self.view addSubview:_basicView];
    }
    return _basicView;
}
- (UIImageView *)showImageView
{
    if (_showImageView == nil) {
        _showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.basicView.height)];
        _showImageView.contentMode = UIViewContentModeScaleAspectFit;
        _showImageView.tag = 214;
        [self.basicView addSubview:_showImageView];
    }
    return _showImageView;
}
- (UIImageView *)holdedView
{
    if (_holdedView == nil) {
        _holdedView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEITH)];
        _holdedView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(holdedViewClick)];
        [_holdedView addGestureRecognizer:tap];
        [self.tabBarController.view addSubview:_holdedView];
        
    }
    return _holdedView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL rect = [[NSUserDefaults standardUserDefaults] boolForKey:@"xz_watermark_guide"];
    if (!rect) {
        _guideIndex = 1;
        self.holdedView.image = [UIImage imageNamed:@"xz_watermark_guide1.jpg"];
    }
    
    self.view.backgroundColor = [UIColor colorWithWhite:243 / 255.0 alpha:1];
    [self commonInit];
    [self openFilter];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)commonInit
{
    self.title = @"添加水印";
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.basicView.height)];
    imageView.image = self.model.watermarkImage;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tag = 214;
    [self.basicView addSubview:imageView];
    
    [self.view addSubview:self.selectWatermarkView];
    self.showImageView.image = self.model.watermarkImage;
    
}
- (void)openFilter
{
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(SCREENWIDTH - 70, 20, 70, 32);
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:KBlueColor forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [rightButton addTarget:self
                    action:@selector(shareImageClick)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREENWIDTH - 130, 20, 40, 32);
    [button setTitle:@"滤镜" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [button setTitleColor:KBlueColor forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(changeFiter) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(12, 20, 40, 32);
    [backButton setTitle:@"<返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [backButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [backButton setTitleColor:KBlueColor forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
}
- (void)backButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)changeFiter
{
    NSDictionary *filter = @{@"怀旧":@"CIPhotoEffectInstant",
                             @"黑白":@"CIPhotoEffectNoir",
                             @"单色":@"CIPhotoEffectMono",
                             @"色调":@"CIPhotoEffectTonal",
                             @"褪色":@"CIPhotoEffectFade",
                             @"冲印":@"CIPhotoEffectProcess",
                             @"岁月":@"CIPhotoEffectTransfer",
                             @"珞璜":@"CIPhotoEffectChrome"};
    NSInteger index = arc4random() % 8;
    self.showImageView.image = self.model.watermarkImage;
    self.showImageView.image = [UIImage filterWithOriginalImage:self.showImageView.image
                                                     filterName:filter.allValues[index]];
    
    self.title = filter.allValues[index];
    
}
#pragma mark -- button click
- (void)backClick
{
    self.model.watermarkImage2 = nil;
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)shareImageClick
{
    [LHStickerView setActiveStickerView:nil];
    UIImage *image = [UIImage croppedImageFromView:self.basicView];
    CGSize size = [self imageSizeFromBasicView];
    image = [image croppedImage:CGRectMake((image.size.width - size.width) / 2 * 3,
                                           (image.size.height - size.height) / 2 * 3,
                                           size.width * 3,
                                           size.height * 3)];
    [LHCaptureView saveImageToPhotoAlbum:image];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 20)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.centerX = self.view.centerX;
    label.center = CGPointMake(SCREENWIDTH / 2, SCREENHEITH / 2);
    label.text = @"已保存到相册";
    label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self.view addSubview:label];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [label removeFromSuperview];
    });
}
- (void)clearWatermark
{
    for (UIView *view in self.basicView.subviews) {
        if (view.tag != 214) {
            [view removeFromSuperview];
        }
    }
}
- (void)hiddenStickerBorder
{
    [LHStickerView setActiveStickerView:nil];
}
#pragma mark -- LHSelectWatermarkViewDelegate
- (void)selectWatermarkWithImageIndex:(NSInteger)index WithState:(BOOL)state
{
    //    [self clearWatermark];
    
    LHStickerView *stick = [self.basicView viewWithTag:100 + index];
    [stick removeFromSuperview];
    
    
    UIImage *stickImage = [UIImage imageNamed:[NSString stringWithFormat:@"watermark_chartlet_%ld",(long)index + 1]];
    
    LHStickerView *view = [[LHStickerView alloc] initWithImage:stickImage];
    view.center = CGPointMake(self.basicView.width/2, self.basicView.height/2);
    CGFloat ratio = MIN( (0.3 * self.basicView.width) / view.width,
                        (0.3 * self.basicView.height) / view.height);
    [view setScale:ratio];
    view.delegate = self;
    view.tag = 100 + index;
    [self.basicView addSubview:view];
    [LHStickerView setActiveStickerView:view];
}
#pragma mark -- LHStickerViewDelegate
- (void)deleteStickerView:(LHStickerView *)stickerView
{
    [stickerView removeFromSuperview];
    [self.selectWatermarkView reloadCellStatusWithIndex:stickerView.tag - 100];
    //    [self clearWatermark];
}

- (NSString *)imageLeng{
    
    NSInteger kb = UIImageJPEGRepresentation(self.model.soureImage, 0.8).length / 1000;
    if (kb <= 1024) {
        return [NSString stringWithFormat:@"%ldKB",(long)kb];
    }else
        return [NSString stringWithFormat:@"%.1fM",kb / 1024.0];
}
- (CGSize)imageSizeFromBasicView
{
    CGFloat w = self.model.watermarkImage.size.width;
    CGFloat h = self.model.watermarkImage.size.height;
    
    CGFloat ww = self.basicView.width;
    CGFloat hh = self.basicView.height;
    if (w >= h) {
        hh = ww * h / w;
    }else if(h > w){
        ww = hh * w / h;
    }
    
    CGSize size = CGSizeMake(ww, hh);
    return size;
}

- (void)holdedViewClick
{
    _guideIndex ++;
    self.holdedView.image = [UIImage imageNamed:[NSString stringWithFormat:@"xz_watermark_guide%ld.jpg",_guideIndex]];
    if (_guideIndex > 4) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"xz_watermark_guide"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.holdedView removeFromSuperview];
    }
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
