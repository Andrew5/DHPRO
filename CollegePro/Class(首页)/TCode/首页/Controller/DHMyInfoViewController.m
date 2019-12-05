//
//  DHMyInfoViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/7/27.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "DHMyInfoViewController.h"
#import "InternetViewController.h"
#import "SDImageCache.h"
#import "UIViewController+RTCSampleAlert.h"

@interface DHMyInfoViewController ()

@end

@implementation DHMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowleftBtn = YES;
    [self fileMpSizeAtPath];
    float fCatch = [[SDImageCache sharedImageCache] totalDiskSize];
    if (fCatch>0) {
        [self showAlertWithMessage:[NSString stringWithFormat:@"(%.1fM)",fCatch /1024/1024 ] handler:^(UIAlertAction * _Nonnull action) {
            //清理
            [self clearTmpPics];
        }];
    }
//    InternetViewController *interVC = [[InternetViewController alloc]init];
//    [self.navigationController pushViewController:interVC animated:YES];
    // Do any additional setup after loading the view.
}
- (void)clearTmpPics
{
    NSUInteger tmpSize = [[SDImageCache sharedImageCache] totalDiskSize];
    
    NSString *clearCacheName;
    if (tmpSize >= 1024*1024*1024) {
        clearCacheName = [NSString stringWithFormat:@"清理缓存(%0.2fG)",tmpSize /(1024.f*1024.f*1024.f)];
    }else if (tmpSize >= 1024*1024) {
        clearCacheName = [NSString stringWithFormat:@"清理缓存(%0.2fM)",tmpSize /(1024.f*1024.f)];
    }else{
        clearCacheName = [NSString stringWithFormat:@"清理缓存(%0.2fK)",tmpSize / 1024.f];
    }
    
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [self showAlertWithMessage:clearCacheName handler:^(UIAlertAction * _Nonnull action) {
            
        }];
    }];
    
}
//计算缓存文件的大小
- (float) fileMpSizeAtPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *baseSavePath = [paths objectAtIndex:0];
    NSFileManager* manager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *myDirectoryEnumerator = [manager enumeratorAtPath:baseSavePath];
    
    NSMutableArray *filePathArray = [[NSMutableArray alloc] init];   //用来存目录名字的数组
    NSString *file;
    
    while((file=[myDirectoryEnumerator nextObject]))     //遍历当前目录
    {
        if([[file pathExtension] isEqualToString:@"mp4"])  //取得后缀名为.mp4的文件名
        {
            [filePathArray addObject:[baseSavePath stringByAppendingPathComponent:file]];//存到数组
        }
    }
    
    float totalSize = 0;
    
    if (filePathArray.count > 0) {
        for (NSString *strMPFile in filePathArray) {
            unsigned long long length = [[manager attributesOfItemAtPath:strMPFile error:nil] fileSize];
            totalSize += length / 1024.0 / 1024.0;
        }
    }
    
    return totalSize;
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
