//
//  OneViewController.m
//  NavBar
//
//  Created by MissWan on 2016/10/19.
//  Copyright © 2016年  wangyu. All rights reserved.
//

#import "OneViewController.h"
#import "NSString+Hex.h"


#define  kCornerRadiusOfImage 10
@interface OneViewController ()<CAAnimationDelegate>
{
	UIImageView *imgView;
}
@property (strong, nonatomic) UIImageView *imgVAnimation;
@end

@implementation OneViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

//    NSString *msg = [NSString stringWithFormat:@"满园春色关不住，乐帮手又更新啦！\n别犹豫快来更新，和乐帮粉们一起度过炎热的夏天！"];
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"升级提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"现在升级" style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action) {
//        
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        // 取消按键
//        //                self.userOutput.text = @"Clicked 'OK'";
//    }];
//    [alertController addAction:cancelAction];
//    [alertController addAction:otherAction];
//    [self presentViewController:alertController animated:YES completion:nil];

    
    _imgVAnimation = [[UIImageView alloc]init];
    _imgVAnimation.frame = CGRectMake(100, 100, 100, 100);
    [_imgVAnimation setImage:[UIImage imageNamed:@"ling1"]];
    [self.view addSubview:_imgVAnimation];
    [self demo1];
    
    
    //宽度 * 高度 * bytesPerPixel/8
    UIImage *image = [UIImage imageNamed:@"_MG_5586.JPG"];//8M
//    //1.1 压缩图片质量
//    NSData *data = UIImageJPEGRepresentation(image, 0.5);
//    UIImage *resultImage = [UIImage imageWithData:data];
//    NSData *blockData = [data subdataWithRange:NSMakeRange(0, data.length)];
//    NSLog(@"blockData %ld",(long)[self hexStringFromHexData:blockData]);
//
//
//    //压缩图片尺寸
//    UIGraphicsBeginImageContext(CGSizeMake(90, 90));
//    [image drawInRect:CGRectMake(0, 0, 90 ,90)];
//    image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    
    //二
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName]];
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(93,93)];// 图片进行尺寸压缩

    [UIImageJPEGRepresentation(smallImage,0.3) writeToFile:imageFilePath atomically:YES];// 图片进行质量压缩
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    NSData *ImageData =UIImagePNGRepresentation(selfPhoto);
    NSLog(@"ImageData %lu",(unsigned long)ImageData.length);

}
// 改变图片尺寸
-(UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y =0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x =0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context =UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0,0, asize.width, asize.height));//clear background
        [image drawInRect:rect];//压缩图片h指定尺寸
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

    }
    return newimage;
}
////这样循环次数多，效率低，耗时长。
//- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength WithoutImage:(UIImage *)image{
//    CGFloat compression = 1;
//    NSData *data = UIImageJPEGRepresentation(image, compression);
//    while (data.length > maxLength && compression > 0) {
//        compression -= 0.02;
//        data = UIImageJPEGRepresentation(image, compression); // When compression less than a value, this code dose not work
//    }
//    return data;
//}
////二分法来优化
/*
 当图片大小小于 maxLength，大于 maxLength * 0.9 时，不再继续压缩。最多压缩 6 次，1/(2^6) = 0.015625 < 0.02，也能达到每次循环 compression减小 0.02 的效果。这样的压缩次数比循环减小 compression少，耗时短。需要注意的是，当图片质量低于一定程度时，继续压缩没有效果。也就是说，compression继续减小，data 也不再继续减小。
 */
- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength WithoutImage:(UIImage *)image{
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
    /*
     //方法结合计算
     // Compress by quality
     CGFloat compression = 1;
     NSData *data = UIImageJPEGRepresentation(self, compression);
     //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
     if (data.length < maxLength) return data;
     
     CGFloat max = 1;
     CGFloat min = 0;
     for (int i = 0; i < 6; ++i) {
     compression = (max + min) / 2;
     data = UIImageJPEGRepresentation(self, compression);
     //NSLog(@"Compression = %.1f", compression);
     //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
     if (data.length < maxLength * 0.9) {
     min = compression;
     } else if (data.length > maxLength) {
     max = compression;
     } else {
     break;
     }
     }
     //NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
     if (data.length < maxLength) return data;
     UIImage *resultImage = [UIImage imageWithData:data];
     // Compress by size
     NSUInteger lastDataLength = 0;
     while (data.length > maxLength && data.length != lastDataLength) {
     lastDataLength = data.length;
     CGFloat ratio = (CGFloat)maxLength / data.length;
     //NSLog(@"Ratio = %.1f", ratio);
     CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
     (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
     UIGraphicsBeginImageContext(size);
     [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
     resultImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     data = UIImageJPEGRepresentation(resultImage, compression);
     //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
     }
     //NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
     return data;
     */
}
- (NSInteger )hexStringFromHexData:(NSData*)data {
    NSString *hexString = [[[[NSString stringWithFormat:@"%@",data]
                             stringByReplacingOccurrencesOfString: @"<" withString: @""]
                            stringByReplacingOccurrencesOfString: @">" withString: @""]
                           stringByReplacingOccurrencesOfString: @" " withString: @""];
    unsigned long long value = 0;
    if (![[NSScanner scannerWithString:hexString] scanHexLongLong:&value]) {
        value = strtoul([@"ff01" UTF8String],0,16);
    }
    return value;
}

- (void)demo1 {
    
     //移到右下角；使用关键帧动画，移动路径为预定的贝塞尔曲线路径
     CGPoint fromPoint= _imgVAnimation.center;
     CGFloat toPointX = self.view.frame.size.width - kCornerRadiusOfImage;
     CGFloat toPointY = self.view.frame.size.height - kCornerRadiusOfImage;
     CGPoint toPoint  = CGPointMake(toPointX, toPointY);
     CGPoint controlPoint = CGPointMake(toPointX, 0.0);

     UIBezierPath *path = [UIBezierPath bezierPath];
     [path moveToPoint:fromPoint];
     [path addQuadCurveToPoint:toPoint controlPoint:controlPoint];

     CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
     positionAnimation.path = path.CGPath;
     positionAnimation.removedOnCompletion = YES;

     //变小；使用基础动画
     CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
     transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
     transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]; //设置 X 轴和 Y 轴缩放比例都为1.0，而 Z 轴不变
     transformAnimation.removedOnCompletion = YES;

    
    //透明；使用基础动画
     CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
     opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
     opacityAnimation.toValue = [NSNumber numberWithFloat:0.1];
     opacityAnimation.removedOnCompletion = YES;

     //组合效果；使用动画组
     CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
     animationGroup.animations = @[ positionAnimation, transformAnimation, opacityAnimation ];
     animationGroup.duration = 1.0; //设置动画执行时间；这里设置为1.0秒
     animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    //设置媒体调速运动；默认为 kCAMediaTimingFunctionLinear，即为线型间隔；这里设置为 kCAMediaTimingFunctionEaseIn，即先慢后快，相当于有个加速度
    animationGroup.autoreverses = YES; //设置自动倒退，即动画回放；默认值为NO
    [_imgVAnimation.layer addAnimation:animationGroup forKey:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = IWColor(255,155,0);
    //设置导航条的背景色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    
    
//	imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 70, (self.view.frame.size.width/2), (self.view.frame.size.width/2))];
//	imgView.hidden = YES;
//	imgView.layer.borderColor = [UIColor redColor].CGColor;
//	imgView.layer.borderWidth = 1.0;
//	[self.view addSubview:imgView];

	//[self registerTakeScreenShotNotice];
    // Do any additional setup after loading the view.
}


//- (void)registerTakeScreenShotNotice
//{
//	__weak typeof(self) weakSelf = self;
//	//	NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
//	[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification
//													  object:nil
//													   queue:nil
//												  usingBlock:^(NSNotification *note) {
//													  // executes after screenshot
//													 // NSLog(@"截屏咯");
//													  [weakSelf userDidTakeScreenshot];
//												  }];
//}
////截屏响应
//- (void)userDidTakeScreenshot
//{
//	NSLog(@"检测到截屏");
//	
//	//人为截屏, 模拟用户截屏行为, 获取所截图片
//	UIImage *image = [OneViewController imageWithScreenshot];
//	imgView.hidden = NO;
//	[imgView setImage:image];
//	NSLog(@"image %@",image);
//}
///**
// *  返回截取到的图片
// *
// *  @return UIImage *
// */
//+ (UIImage *)imageWithScreenshot
//{
//	NSData *imageData = [OneViewController dataWithScreenshotInPNGFormat];
//	return [UIImage imageWithData:imageData];
//}
//
///**
// *  截取当前屏幕
// *
// *  @return NSData *
// */
//+ (NSData *)dataWithScreenshotInPNGFormat
//{
//	CGSize imageSize = CGSizeZero;
//	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//	if (UIInterfaceOrientationIsPortrait(orientation))
//		imageSize = [UIScreen mainScreen].bounds.size;
//	else
//		imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
//	
//	UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	for (UIWindow *window in [[UIApplication sharedApplication] windows])
//	{
//		CGContextSaveGState(context);
//		CGContextTranslateCTM(context, window.center.x, window.center.y);
//		CGContextConcatCTM(context, window.transform);
//		CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
//		if (orientation == UIInterfaceOrientationLandscapeLeft)
//		{
//			CGContextRotateCTM(context, M_PI_2);
//			CGContextTranslateCTM(context, 0, -imageSize.width);
//		}
//		else if (orientation == UIInterfaceOrientationLandscapeRight)
//		{
//			CGContextRotateCTM(context, -M_PI_2);
//			CGContextTranslateCTM(context, -imageSize.height, 0);
//		} else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
//			CGContextRotateCTM(context, M_PI);
//			CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
//		}
//		if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
//		{
//			[window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
//		}
//		else
//		{
//			[window.layer renderInContext:context];
//		}
//		CGContextRestoreGState(context);
//	}
//	
//	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//	
//	return UIImagePNGRepresentation(image);
//}
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
