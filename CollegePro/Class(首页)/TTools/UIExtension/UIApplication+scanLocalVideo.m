//
//  UIApplication+scanLocalVideo.m
//  LocalVideo

#import "UIApplication+scanLocalVideo.h"

@implementation UIApplication (scanLocalVideo)

//相册授权
- (BOOL)authStatus
{
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    if (author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied) {
        return NO;
    }else{
        return YES;
    }
}
//获取搜索的结果
- (PHFetchResult *)assetsFetchResults
{
    return [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:[self getFetchPhotosOptions]];
}

//筛选的规则和范围
- (PHFetchOptions *)getFetchPhotosOptions
{
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc]init];
    //扫描的范围为：用户相册，iCloud分享，iTunes同步
    allPhotosOptions.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary | PHAssetSourceTypeCloudShared | PHAssetSourceTypeiTunesSynced;
    //排序的方式为：按时间排序
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    return allPhotosOptions;
}

//获取所需要的资源数组,缩略图，时长，视频名称
- (NSArray *)getVideoRelatedAttributesArray:(TFVideoAssetType)type
{
    NSMutableArray *sourceArray = [NSMutableArray arrayWithCapacity:self.assetsFetchResults.count];
    for (PHAsset *asset in self.assetsFetchResults)
    {
        NSString *videoName = [asset valueForKey:@"filename"];
        // 修复获取图片时出现的瞬间内存过高问题
        // 下面两行代码，来自hsjcom，他的github是：https://github.com/hsjcom 表示感谢
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage *result, NSDictionary *info) {
              //获取视频的缩略图
              UIImage *image = result;
              //视频时长
              NSString *timeLength = [self getVideoDurtion:[self getcalduration:asset]];
              
                switch (type) {
                    case TFVideoAssetTypeVideoImageSource:
                        [sourceArray addObject:image];      //UIImage
                        break;
                    case TFVideoAssetTypeVideoTimeLength:
                        [sourceArray addObject:timeLength]; //NSString
                        break;
                    case TFVideoAssetTypeVideoName:
                        [sourceArray addObject:videoName];  //NSString
                        break;
                    case TFVideoAssetTypeVideoSize:
                    {
                        break;
                    }
                    default:
                        break;
                }
                
             }];
        }
    return sourceArray;
}

//获取文件大小
-(void)getVideoFileSize:(PHAsset *)asset getFileSize:(void(^)(NSString * size,NSData * data))getFileSize
{
    __block NSString *size;
    PHVideoRequestOptions *option = [PHVideoRequestOptions new];
    option.version = PHImageRequestOptionsVersionOriginal;//有坑 不写有些视频会崩溃
    option.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
//    options.networkAccessAllowed = YES;//赋值 YES ，那么允许从 iCloud 中获取图片和视频，默认是 NO。
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:option resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info)
     {
         AVURLAsset *AVUrl = (AVURLAsset *)asset;
         if (AVUrl) {
             NSURL *URL = [AVUrl URL];
             // NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
             // NSLog(@"%ld",data.length);
             float M =  [self fileSizeAtPath:URL.path]/1024.0/1024.0;
             if (M<1) {
                 M =  [self fileSizeAtPath:URL.path]/1024.0;
                 size = [NSString stringWithFormat:@"%.2fKB",M];
             }else{
                 size = [NSString stringWithFormat:@"%.2fMB",M];
             }
             getFileSize(size,[[NSData alloc] initWithContentsOfURL:URL]);
         }else{
             getFileSize(@"0kB",nil);
         }
     }];
}

//获取文件路径
-(void)getCopyVideoFilepath:(PHAsset *)asset getFilePath:(void(^)(NSString * path))getFilePath
{
    PHVideoRequestOptions *option = [PHVideoRequestOptions new];
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:option resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info)
     {
         NSURL *URL = [(AVURLAsset *)asset URL];
         NSString *filePath = URL.path;
         if ([self fileSizeAtPath:URL.path]/1024.0/1024.0<30.0) {//最大支持30M
             //拷贝一份到临时路径
             NSString*tmpDir = NSTemporaryDirectory();/* tem目录*/
             NSString *timeChuoWithName = [NSString stringWithFormat:@"%@%@",[self createTimestamp],URL.path.lastPathComponent];
             filePath = [tmpDir stringByAppendingPathComponent:timeChuoWithName];
             NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
             NSError *error;
             BOOL isSuccess = [data writeToFile:filePath options:NSDataWritingAtomic error:&error];
             if (isSuccess) {
                 getFilePath(filePath);
             }else{
                 NSLog(@"写入失败");
             }
             
             //格式转换
//             AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:filePath] options:nil];
//             NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
//
//             if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality])
//             {
//                 AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetPassthrough];
//                 NSString *exportPath = [NSString stringWithFormat:@"%@/%@.mp4",
//                                         [NSHomeDirectory() stringByAppendingString:@"/tmp"],
//                                         @"1"];
//                 exportSession.outputURL = [NSURL fileURLWithPath:exportPath];
//                 NSLog(@"%@", exportPath);
//                 exportSession.outputFileType = AVFileTypeMPEG4;
//                 [exportSession exportAsynchronouslyWithCompletionHandler:^{
//
//                     switch ([exportSession status]) {
//                         case AVAssetExportSessionStatusFailed:
//                             NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
//                             break;
//                         case AVAssetExportSessionStatusCancelled:
//                             NSLog(@"Export canceled");
//                             break;
//                         case AVAssetExportSessionStatusCompleted:
//                             NSLog(@"转换成功");
//                             break;
//                         default:
//                             break;
//                     }
//                 }];
//             }
//
             
         }
     }];
}

//获取图片数据
-(void)getImageFileData:(PHAsset *)asset ImageData:(void(^)(UIImage * img))ImageData
{
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info)
    {
        //图片
        UIImage *image = result;
        ImageData(image);
    }];
}

//获取图片data
-(void)getDataImageFileWithAsset:(PHAsset *)asset ImageData:(void(^)(NSData * imgData))ImageData
{
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info)
    {
        ImageData(imageData);
    }];
}



//获取文件大小
- (long long) fileSizeAtPath:(NSString*) filePath
{
    if (filePath.length)
    {
        NSFileManager* manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:filePath])
        {
            return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        }
    }
    return 0;
}

//获取缓存路径 Caches
- (NSString*)tempImagePath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

//视频时长
- (NSInteger)getcalduration:(PHAsset *)asset
{
    NSInteger dur;
    NSInteger time = asset.duration;
    double time2 = (double)(asset.duration - time);
    if (time2 < 0.5) {
        dur = asset.duration;
    }else{
        dur = asset.duration + 1;
    }
    return dur;
}

//视频时长转换
- (NSString *)getVideoDurtion:(NSInteger)duration
{
    NSInteger h = (NSInteger)duration/3600; //总小时
    NSInteger mT = (NSInteger)duration%3600; //总分钟
    NSInteger m = mT/60; //最终分钟
    NSInteger s = mT%60; //最终秒数
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)h,(long)m,(long)s];
}

//生成时间戳
- (NSString *)createTimestamp
{
    NSDate *datenow=[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    return [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
}



@end
