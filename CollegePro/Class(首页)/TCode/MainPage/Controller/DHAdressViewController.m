//
//  DHAdressViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/7/27.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "DHAdressViewController.h"
#import "SlideNavigationController.h"

@interface DHAdressViewController ()<SlideNavigationControllerDelegate>

@end

@implementation DHAdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowleftBtn = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jieshou) name:UIApplicationUserDidTakeScreenshotNotification object:nil];

    //图片压缩
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *documentsDirectory=[paths objectAtIndex:0];
    
    NSString *savedImagePath=[documentsDirectory stringByAppendingPathComponent:@"saveFores.png"];
    NSData *d = [self compressOriginalImage:[UIImage imageNamed:@"guideImage2.jpg"] toMaxDataSizeKBytes:200.0];
    [d writeToFile:savedImagePath atomically:YES];

    // Do any additional setup after loading the view.
}
/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 
 */
- (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    //    return  [UIImage imageWithData:data];
    return  data;
}
/**
 *  压缩图片到指定尺寸大小
 *
 *  @param image 原始图片
 *  @param size  目标大小
 *
 *  @return 生成图片
 */
-(UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size{
    UIImage * resultImage = image;
    UIGraphicsBeginImageContext(size);
    [resultImage drawInRect:CGRectMake(00, 0, size.width, size.height)];
    UIGraphicsEndImageContext();
    return image;
}
- (UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;   //返回的就是已经改变的图片
}

-(BOOL)WithNameDeleteDataFile:(NSString *)name{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    
    [fileManager removeItemAtPath:name error:nil];
    
    return YES;
    
}
- (void)jieshou{
    NSLog(@"接收");
}
#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
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
