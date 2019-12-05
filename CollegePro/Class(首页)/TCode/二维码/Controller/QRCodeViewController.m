//
//  QRCodeViewController.m
//  Test
//
//  Created by Rillakkuma on 2016/10/14.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
#import "QRCodeViewController.h"
#import "QRCodeBacgrouView.h"
#import <AVFoundation/AVFoundation.h>
@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
    AVCaptureSession * session;//输入输出的中间桥梁
    CGPoint startPoint;
    UIButton *ImageButton;
}
@property (nonatomic, weak) CALayer *movingLayer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@end

@implementation QRCodeViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    CAKeyframeAnimation *moveLayerAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //    moveLayerAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    //    moveLayerAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(320 - self.movingLayer.bounds.size.width, 0)];
    moveLayerAnimation.values = @[[NSValue valueWithCGPoint:CGPointMake(0, 0)],
                                  [NSValue valueWithCGPoint:CGPointMake(screen_width/2 , screen_height-self.movingLayer.bounds.size.width)]];
    moveLayerAnimation.duration = 2.0;
    moveLayerAnimation.autoreverses = YES;
    moveLayerAnimation.repeatCount = INFINITY;
    moveLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self.movingLayer addAnimation:moveLayerAnimation forKey:@"move"];
}


/**
 
 
 
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    CGRect areaRect = CGRectMake((screen_width - 218)/2, (screen_height - 218)/2, 218, 218);
//    QRCodeBacgrouView *bacgrouView = [[QRCodeBacgrouView alloc]initWithFrame:self.view.bounds];
//    bacgrouView.scanFrame =areaRect;
//    
//    [self.view addSubview:bacgrouView];
    // Do any additional setup after loading the view.

    startPoint = CGPointMake(100, 100);
    ImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ImageButton setFrame:CGRectMake(110.0 ,64.0 ,80.0 ,80.0)];
    ImageButton.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.00];       //背景颜色
    [ImageButton setImage:[UIImage imageNamed:@"page"] forState:UIControlStateNormal];   //设置图片
    [ImageButton setImage:[UIImage imageNamed:@"page"] forState:UIControlStateHighlighted];
    [self.view addSubview:ImageButton];
    
    CGSize layerSize = CGSizeMake(100, 100);
    
    CALayer *movingLayer = [CALayer layer];
    movingLayer.bounds = CGRectMake(0, 0, layerSize.width, layerSize.height);
    movingLayer.anchorPoint = CGPointMake(0, 0);
    [movingLayer setBackgroundColor:[UIColor orangeColor].CGColor];
    //    movingLayer.position = CGPointMake(50, 50);
    
    [self.view.layer addSublayer:movingLayer];
    self.movingLayer = movingLayer;
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [self.view addGestureRecognizer:self.tapGesture];

    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置识别区域
    //深坑，这个值是按比例0~1设置，而且X、Y要调换位置，width、height调换位置
    output.rectOfInterest = self.view.bounds;
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [session addInput:input];
    [session addOutput:output];
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
//    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    self.view.userInteractionEnabled = YES;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    //开始捕获
    [session startRunning];

    
    
}
-(void)click:(UITapGestureRecognizer *)tapGesture {
    CGPoint touchPoint = [tapGesture locationInView:self.view];
    if ([self.movingLayer.presentationLayer hitTest:touchPoint]) {
        NSLog(@"presentationLayer");
    }
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{

        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
    [session stopRunning];//停止扫描

    
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //保存触摸起始点位置
    CGPoint point = [[touches anyObject] locationInView:ImageButton];
    startPoint = point;
    
    //该view置于最前
    [self.view bringSubviewToFront:ImageButton];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //计算位移=当前位置-起始位置
    CGPoint point = [[touches anyObject] locationInView:ImageButton];
    float dx = point.x - startPoint.x;
    float dy = point.y - startPoint.y;
    
    //计算移动后的view中心点
    CGPoint newcenter = CGPointMake(self.view.center.x + dx, self.view.center.y + dy);
    
    
    /* 限制用户不可将视图托出屏幕 */
    float halfx = CGRectGetMidX(self.view.bounds);
    //x坐标左边界
    newcenter.x = MAX(halfx, newcenter.x);
    //x坐标右边界
    newcenter.x = MIN(self.view.bounds.size.width - halfx, newcenter.x);
    
    //y坐标同理
    float halfy = CGRectGetMidY(self.view.bounds);
    newcenter.y = MAX(halfy, newcenter.y);
    newcenter.y = MIN(self.view.bounds.size.height - halfy, newcenter.y);
    
    //移动view
    ImageButton.center = newcenter;
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
