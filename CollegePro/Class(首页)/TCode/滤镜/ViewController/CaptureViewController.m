//
//  CaptureViewController.m
//  15
//
//  Created by jabraknight on 2018/11/28.
//  Copyright © 2018 大爷公司. All rights reserved.
//

#import "CaptureViewController.h"

#import "CaptureView.h"
#define SCREENHEITH CGRectGetHeight([[UIScreen mainScreen] bounds])
#define SCREENWIDTH CGRectGetWidth([[UIScreen mainScreen] bounds])
#define SCREEN_667 (SCREENHEITH / 667.)
#define kCameraToolsViewHeight 128 * SCREEN_667

@interface CaptureViewController ()<UITableViewDelegate,UITableViewDataSource,CaptureViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) NSMutableArray *ljNamesArray;
@property (strong, nonatomic) NSMutableArray *effectNameArray;
@property (strong, nonatomic) NSMutableArray *ljImagesArray;
@property (strong, nonatomic) UIImageView *imageView;

@property (nonatomic) CAShapeLayer *shapeLayer;
@property (strong, nonatomic) CaptureView *captureView;
@property (nonatomic,strong) UIView *toolsView;


@end

@implementation CaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sharedInit];
//    [self customCaptureView];
    // Do any additional setup after loading the view.
}

- (CaptureView *)captureView
{
    if (_captureView == nil) {
        _captureView = [[CaptureView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEITH - kCameraToolsViewHeight)
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
- (void)customCaptureView{
//    [self.view addSubview:self.captureView];

    [self.view addSubview:self.toolsView];
    
}
- (void)captureAutonManager{
}
- (CAShapeLayer *)shapeLayer
{
    if (_shapeLayer == nil) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        _shapeLayer.fillColor = nil;
        _shapeLayer.path = [UIBezierPath bezierPathWithRect:_imageView.bounds].CGPath;
        _shapeLayer.frame = _imageView.bounds;
        _shapeLayer.lineWidth = 2.f;
        _shapeLayer.lineCap = @"square";
        _shapeLayer.lineDashPattern = @[@10, @10];
    }
    return _shapeLayer;
}

- (void)sharedInit {
    [self customCaptureView];
    // 定义效果
    self.ljNamesArray = @[@"Original",@"CILinearToSRGBToneCurve",@"CIPhotoEffectChrome",@"CIPhotoEffectFade",@"CIPhotoEffectInstant",@"CIPhotoEffectMono",@"CIPhotoEffectProcess",@"CIPhotoEffectTonal",@"CIPhotoEffectTransfer",@"CIPhotoEffectNoir",@"CIPhotoEffectTonal",@"CISRGBToneCurveToLinear",@"CIVignetteEffect"].mutableCopy;//@"CIGaussianBlur",@"CIBoxBlur",@"CIDiscBlur",@"CISepiaTone",@"CIDepthOfField"
    self.effectNameArray = @[@"Original",@"Curve",@"Chrome",@"Fade",@"Instant",@"Mono",@"Process",@"Tonal",@"Transfer",@"黑白",@"色调",@"线性加深",@"晕影"].mutableCopy;//,@"晕影",@"晕影",@"晕影",@"晕影",@"晕影"
    
    self.originalImage = [UIImage imageNamed:@"_MG_5586.JPG"];

    for (int i = 0; i < self.ljNamesArray.count; i++) {
        UIImage *image = [CaptureViewController changeImage:self.originalImage withIndex:i effectArray:self.ljNamesArray.copy];
        [self.ljImagesArray addObject:image];
    }
 
    UIImageView *im = [[UIImageView alloc]init];
//    im.contentMode = UIViewContentModeCenter;
    im.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEITH - kCameraToolsViewHeight-64);
    [im setImage:self.originalImage];
    [self.view addSubview:im];
    self.imageView = im;
    [self.imageView.layer addSublayer:self.shapeLayer];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame), 80, CGRectGetWidth([[UIScreen mainScreen] bounds])) style:UITableViewStylePlain];
    self.tableView.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height - 100);
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.transform        = CGAffineTransformMakeRotation(-M_PI / 2);
    self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView   = nil;
    [self.view addSubview:self.tableView];
}
#pragma mark - tableViewDelegate&DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.effectNameArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    static NSString *CellIndentifier = @"Contact";
    //
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    //    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    cell.textLabel.text = self.effectNameArray[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.transform = CGAffineTransformMakeRotation(M_PI / 2);

    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetWidth(self.imageView.frame);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.imageView.image = [CaptureViewController changeImage:self.originalImage withIndex:(int)indexPath.row effectArray:self.ljNamesArray.copy];
    
}
- (void)shutterCameraWithImage:(UIImage *)image {
//    image = [CaptureViewController changeImage:self.originalImage withIndex:(int)indexPath.row effectArray:self.ljNamesArray.copy]
}
+ (UIImage *)changeImage:(UIImage *)originalImage withIndex:(int)index effectArray:(NSArray *)effectArray {
    switch (index) {
        case 0:
        {
            return originalImage;
        }
            break;
        default:
        {
            return  [self Image:originalImage withEffect:effectArray[index]];
        }
            break;
    }
    
}

+ (UIImage *)Image:(UIImage *)image withEffect:(NSString *)effect {
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:effect keysAndValues:kCIInputImageKey, ciImage, nil];
    
    [filter setDefaults];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *effetImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    return effetImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/*
- (void)captureAuthorizationFail {
    <#code#>
}



- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    <#code#>
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    <#code#>
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    <#code#>
}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    <#code#>
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    <#code#>
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    <#code#>
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    <#code#>
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    <#code#>
}

- (void)setNeedsFocusUpdate {
    <#code#>
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
    <#code#>
}

- (void)updateFocusIfNeeded {
    <#code#>
}
*/
@end
