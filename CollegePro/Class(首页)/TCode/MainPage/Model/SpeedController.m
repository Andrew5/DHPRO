//
//  SpeedController.m
//  JHLivePlayLibrary
//
//  Created by xianjunwang on 2017/12/8.
//  Copyright © 2017年 pk. All rights reserved.
//  实现方式：信号强度取得是statusBar的_wifiStrengthBars；下行速度通过下载一张图片所需时间来计算；上行速度通过上传一张图片所需时间来计算。

#import "SpeedController.h"

typedef void(^ResultBlock)(float downstreamSpeed,float upstreamSpeed);

@interface SpeedController ()<NSURLSessionDelegate>{
    
    //下行速度（单位 MB/S）
    float downstreamSpeed;
    //上行速度（单位 MB/S）
    float upstreamSpeed;
    //已上传时间
    NSTimeInterval uploadTimeInterval;
}

@property (nonatomic,strong) ResultBlock resultBlock;
//上传开始时间
@property (nonatomic,strong) NSDate * uploadStartDate;
//上传阶段结束时间
@property (nonatomic,strong) NSDate * uploadEndDate;
//资源
@property (nonatomic,strong) NSData * imageData;
@end


@implementation SpeedController


#pragma mark  ----  生命周期函数
+(SpeedController *)sharedManager{
    
    static SpeedController * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[SpeedController alloc] init];
        NSData * imageData = [[NSUserDefaults standardUserDefaults] valueForKey:@"ImageData"];
        if (imageData) {
            
            manager.imageData = imageData;
        }
    });
    return manager;
}


#pragma mark  ----  代理函数

#pragma mark NSURLSessionDataDelegate
/*
 bytesSent:本次上传的数据大小
 totalBytesSent:已经上传数据的总大小
 totalBytesExpectedToSend:文件的总大小
 */
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    self.uploadEndDate = [NSDate date];
    //已上传的文件大小：MB
    float size = totalBytesSent / 1000.0 / 1000.0;
    //耗时 S
    float time = [self.uploadEndDate timeIntervalSinceDate:self.uploadStartDate];
    
    //回调频繁，有时时间差是0.01以下
    if (time - uploadTimeInterval >= 0.01 || totalBytesSent == self.imageData.length) {
     
        upstreamSpeed =  size / time;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.resultBlock(downstreamSpeed, upstreamSpeed);
        });
        //NSLog(@"文件大小：%.2f，时间：%.2f,上传速度：%.2f,带宽：%.2f",size,time,upstreamSpeed,upstreamSpeed * 8);
    }
    uploadTimeInterval = time;
}


#pragma mark  ----  自定义函数
//获取信号强度
+(void)getSignalStrength:(void(^)(float signalStrength))resultBlock{
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews;
//    if ([JHLiveAdaptUI isPhoneX]) {
//
//        //如果是Iphone X
//        subviews = [[[[app valueForKeyPath:@"_statusBar"] valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
//    }
//    else{
    
        subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
//    }
    
    
    NSString *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            
            dataNetworkItemView = subview;
            break;
        }
    }
    
    
    int signalStrength;
    if (dataNetworkItemView) {
        
        signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] intValue];
    }
    else{
        
        signalStrength = 3;
    }
    
    
    
    //获取到的信号强度最大值为3，所以除3得到百分比
    float signalStrengthTwo = signalStrength / 3.00;
    
    resultBlock(signalStrengthTwo);
}

-(id)valueForUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"foregroundView"]) {
        
        return [[UIView alloc] init];
    }
    return nil;
}

//获取下行速度,上行速度（单位是 MB/S）
-(void)getDownstreamSpeedAndUpstreamSpeed:(void(^)(float downstreamSpeed,float upstreamSpeed))resultBlock{
    
   
    self.resultBlock = resultBlock;
    downstreamSpeed = 0;
    upstreamSpeed = 0;
    uploadTimeInterval = 0;

    NSData * imageData = [[NSUserDefaults standardUserDefaults] valueForKey:@"ImageData"];
    if (!imageData) {
     
        //要下载的图片的地址
        NSString * urlStr = @"https://lvpfileserver.iuoooo.com/Jinher.JAP.BaseApp.FileServer.UI/FileManage/GetFile?fileURL=49e54e46-3e17-4ca4-8f03-db71fb8f9655/2017113016/3a0b3c06-4fc3-4539-83bf-02ab858fd526_20171130040441-6499.png";
        NSURL* URL = [NSURL URLWithString:urlStr];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
        // Headers
        [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        request.HTTPMethod = @"GET";
        // Connection
        NSURLSession * urlSession = [NSURLSession  sessionWithConfiguration:[NSURLSessionConfiguration
                                                                             defaultSessionConfiguration]];
        //下载开始时间
        NSDate * downloadStartDate = [NSDate date];
        NSURLSessionTask * task = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (!error && data) {
                
                //下载结束时间
                NSDate * downloadEndDate = [[NSDate alloc] init];
                //时间，单位 S
                NSTimeInterval timeInterval = [downloadEndDate timeIntervalSinceDate:downloadStartDate];
                //大小，单位 MB
                float length = data.length / 1000.00 / 1000.00;
                downstreamSpeed = length / timeInterval;
                
                if (!self.imageData) {
                    
                    self.imageData = data;
                }
                
                NSLog(@"下载速度：%.2f,带宽：%.2f",downstreamSpeed,downstreamSpeed * 8);
                
                
                //data写入本地
                [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"ImageData"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //测试上行速度
                    [self upload];
                });
            }
        }];
        [task resume];
    }
    else{

        dispatch_async(dispatch_get_main_queue(), ^{

            //测试上行速度
            [self upload];
        });
    }
    
}

//新上传
-(void)upload{
    
    //01 确定请求路径
    NSURL *url = [NSURL URLWithString:@"http://lvpfileserver.iuoooo.com"];
    
    //02 创建"可变"请求对象
    NSMutableURLRequest *request  =[NSMutableURLRequest requestWithURL:url];
    
    //03 修改请求方法"POST"
    request.HTTPMethod = @"POST";
    
    //'设置请求头:告诉服务器这是一个文件上传请求,请准备接受我的数据
    //Content-Type:multipart/form-data; boundary=分隔符
    NSString * Kboundary = @"----WebKitFormBoundaryjh7urS5p3OcvqXAT";
    NSString *headerStr = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",Kboundary];
    
    [request setValue:headerStr forHTTPHeaderField:@"Content-Type"];
    //04 拼接参数-(设置请求体)
    //'按照固定的格式来拼接'
    //NSData *data = [self getBodyData];
    //!!!! request.HTTPBody = data;
    
    //05 创建会话对象
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    //06 根据会话对象创建uploadTask请求
    /*
     第一个参数:请求对象
     第二个参数:要传递的是本应该设置为请求体的参数
     第三个参数:completionHandler 当上传完成的时候调用
     data:响应体
     response:响应头信息
     */
    
    self.uploadStartDate = [NSDate date];
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:self.imageData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        self.uploadEndDate = [NSDate date];
        NSTimeInterval time = [self.uploadEndDate timeIntervalSinceDate:self.uploadStartDate];
        
        float length = self.imageData.length / 1000.00 / 1000.00;
        
        upstreamSpeed = length / time;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.resultBlock(1.0, upstreamSpeed);
        });
        
        // 08 解析服务器返回的数据
        //NSLog(@"文件大小：%.2f,耗时：%.2f,平均上传速度:%.2f,带宽：%.2f",length,time,upstreamSpeed,upstreamSpeed * 8);
    }];
    
    //07 发送请求
    [uploadTask resume];
}
//停止测速
-(void)stop{
    
}

@end
