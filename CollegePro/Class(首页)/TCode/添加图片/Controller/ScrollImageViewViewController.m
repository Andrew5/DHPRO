//
//  ScrollImageViewViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/6/29.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//
#define ScreenSize      [UIScreen mainScreen].bounds.size
#define ScrollWidth     ScreenSize.width
#define ScrollHeight    450

#import "CollectionImageView.h"
#import "CricleScrollViewController.h"
#import "ScrollImageViewViewController.h"
#import "ScrollImageView.h"

@interface ScrollImageViewViewController ()<UIScrollViewDelegate,ScrollImageViewDelegate,CAAnimationDelegate>
{
    UIImageView *_imgVAnimation;
}
@property (nonatomic, strong)ScrollImageView *scrollImageView;


@end

@implementation ScrollImageViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"轮播图（无限循环）";
	self.automaticallyAdjustsScrollViewInsets = NO;
	
	
//    NSArray *images = @[@"icc1.jpg",@"icc1.jpg",@"icc1.jpg",@"icc1.jpg",@"icc1.jpg"];
//    CollectionImageView *view = [[CollectionImageView alloc]initWithFrame:CGRectMake(0, 64, ScreenSize.width, 100) imageArray:images selectImageBlock:^(NSInteger index) {
//        NSLog(@"点击的是第%ld个",(long)index);
//    }];
//    [self.view addSubview:view];
//
//    [self.view addSubview:self.scrollImageView];
    
    _imgVAnimation = [[UIImageView alloc]init];
    _imgVAnimation.frame = CGRectMake(14, [UIApplication sharedApplication].statusBarFrame.size.height+44, 60, 60);
    _imgVAnimation.layer.borderColor = [UIColor redColor].CGColor;
    _imgVAnimation.layer.borderWidth = 1.0;
    [_imgVAnimation setImage:[UIImage imageNamed:@"大师球"]];
    [self.view addSubview:_imgVAnimation];

    [self demo1];
    [self demo2];
    // Do any additional setup after loading the view.
}

- (ScrollImageView *)scrollImageView
{
	if (!_scrollImageView) {
		// 定义好宽高即可，这里用的屏幕宽高
		NSArray * dataUrls = @[@"http://",@"http://",@"http://",@"http://"];
		NSArray * dataPics = @[@"icc2.jpg",@"icc2.jpg",@"icc2.jpg",@"icc2.jpg",@"icc2.jpg"];
		_scrollImageView = [[ScrollImageView alloc] initWithFrame:CGRectMake(0, 164, ScrollWidth, ScrollHeight)andPictureUrls:dataUrls andPlaceHolderImages:dataPics];
		_scrollImageView.delegate = self;
	}
	return _scrollImageView;
}
#pragma mark -----scrollImageViewDelegate
-(void)scrollImageView:(ScrollImageView *)srollImageView didTapImageView:(UIImageView *)image atIndex:(NSInteger)index
{
	NSLog(@"点击的是第%zd个图片，该图片是:%@",index,image);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    //移动的点
    CGFloat toPointX = self.view.frame.size.width - 10;
    CGFloat toPointY = self.view.frame.size.height - 10;
    CGPoint toPoint  = CGPointMake(toPointX, toPointY);
    CGPoint controlPoint = CGPointMake(toPointX, 0.0);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:fromPoint];
    //C(t) = (1 - t)^2 * P(0) + 2 * t * (1 - t) * P(1) + t^2 * P(2)
    //ToPoint：终点   controlPoint：控制曲线的弯曲程度
    [path addQuadCurveToPoint:toPoint controlPoint:controlPoint];
    ////创建动画对象
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
    
    //    旋转动画
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 50;
    
    //组合效果；使用动画组
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[ positionAnimation, transformAnimation, rotationAnimation, opacityAnimation ];
    animationGroup.duration = 1.0; //设置动画执行时间；这里设置为1.0秒
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    //设置媒体调速运动；默认为 kCAMediaTimingFunctionLinear，即为线型间隔；这里设置为 kCAMediaTimingFunctionEaseIn，即先慢后快，相当于有个加速度
    animationGroup.autoreverses = YES; //设置自动倒退，即动画回放；默认值为NO
    [_imgVAnimation.layer addAnimation:animationGroup forKey:nil];
}
- (void)demo2{
    UIImageView *imageView0 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"组-3"]];
    imageView0.frame = CGRectMake(0, 0, self.view.bounds.size.width, 200);
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0"]];
    imageView1.frame = CGRectMake(0, 0, self.view.bounds.size.width, 200);
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell"]];
    imageView2.frame = CGRectMake(0, 0, self.view.bounds.size.width, 200);
    
    NSArray *imageArray = [NSArray arrayWithObjects:imageView0, imageView1, imageView2, nil];
    CricleScrollViewController *cricleScrollerView = [[CricleScrollViewController alloc] initWithFrame:CGRectMake(0.0, 200.0, self.view.bounds.size.width, 200) andImagesArray:imageArray];
    [self.view addSubview:cricleScrollerView.view];
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
