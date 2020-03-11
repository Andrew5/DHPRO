//
//  SFHttpSessionReq.m
//  CollegePro
//
//  Created by jabraknight on 2019/6/12.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "SFHttpSessionReq.h"

@implementation SFHttpSessionReq
static SFHttpSessionReq *HttpSessionReq = nil;
static dispatch_once_t onceToken;//成为全局的
+ (instancetype) shareInstance
{
    dispatch_once(&onceToken, ^{
        HttpSessionReq = [[SFHttpSessionReq alloc] init];
    });
    return HttpSessionReq;
}
//重写allocWithZone,里面实现跟方法一,方法二一致就行.
+(id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(HttpSessionReq == nil)
            HttpSessionReq = [[SFHttpSessionReq alloc] init];
    });
    return HttpSessionReq;
}
//保证copy时相同
-(id)copyWithZone:(NSZone *)zone{
    return HttpSessionReq;
}
//单例释放
+(void)attempDealloc{
    onceToken = 0; // 只有置成0,GCD才会认为它从未执行过.它默认为0.这样才能保证下次再次调用shareInstance的时候,再次创建对象.
//    [HttpSessionReq release];
    HttpSessionReq = nil;
}

- (void)POSTRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters resHander:(ResponseHander) hander resError:(ResErrHander) errHander{
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    configuration.timeoutIntervalForRequest = 10;
//    NSURLSession *session = [NSURLSession sessionWithConfiguration: configuration delegate: nil delegateQueue: [NSOperationQueue mainQueue]];

    NSString *requestURL;
    
    requestURL = url;

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
//    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"content-Type"];
    if (parameters) {
        NSDictionary *json = parameters;
        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
        [request setHTTPBody:data];
    }
    
    [request setTimeoutInterval:30.0];
    // 实例化网络会话.
    NSURLSession *session = [NSURLSession sharedSession];
    // 根据请求对象创建请求任务
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error)
        {
            //请求成功  对请求的数据做初步的json解析
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //回调代理方法，并传入请求结果
            hander(object);
        }else {
            
            //请求失败   回调代理方法，并传入错误信息
            errHander(error.localizedDescription);
        }
    }];
    
    // 开启任务.
    [task resume];
}

//url方式
- (void)GETRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters resHander:(ResponseHander) hander resError:(ResErrHander) errHander
{
    //GET请求需要将参数拼接在url后面
    //网络接口和参数 以“?”分隔. 参数和参数之间以“&”符号分隔。
    // 拼接url及参数
    NSMutableString * str = [NSMutableString string];
    [str appendString:url];
    
    //当有参数时将参数拼接上去（在此做的是url没有拼接参数情况下，如果url已经拼接了参数，这里还传入了一些参数，那么此处的判断需要更改，具体的大家可以来实现）
    if (parameters.count > 0)
    {
        //在此对url时候以"?"结尾做了判断，有的话就不需要再拼接"?"
        if (![str hasSuffix:@"?"])
        {
            [str appendString:@"?"];
        }
        //拼接参数
        for (NSString * key in parameters)
        {
            [str appendFormat:@"%@=%@&", key, parameters[key]];
        }
        //注意最后一个"&"符号需要去掉
        [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
    }
    
    // 设置URL
    NSURL * URL = [NSURL URLWithString:str];
    // 实例化网络会话.
    NSURLSession * session = [NSURLSession sharedSession];
    //根据URL创建请求任务
    NSURLSessionDataTask * task = [session dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            //请求成功  对请求的数据做初步的json解析
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //回调代理方法，并传入请求结果
            hander(object);
        }else {
            //请求失败  回调代理方法，并传入错误信息
            errHander(error.localizedDescription);
        }
    }];
    
    // 开启任务.
    [task resume];
}

//--------------------------------------------方式二------------------------------------------------------

//NSMutableURLRequest 方式
+(void)GET:(NSString *)URL parameters:(NSDictionary *)dic success:(ResponseHander)success failure:(ResErrHander)failure
{
    //创建配置信息
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //设置请求超时时间：5秒
    configuration.timeoutIntervalForRequest = 10;
    //创建会话
    NSURLSession *session = [NSURLSession sessionWithConfiguration: configuration delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]];
    //设置请求方式：POST
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-Type"];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Accept"];
    
    //data的字典形式转化为data
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //设置请求体
    [request setHTTPBody:jsonData];
    
    NSURLSessionDataTask * dataTask =[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            success(responseObject);
        }else{
            NSLog(@"%@",error);
            failure(error.localizedDescription);
        }
    }];
    
    [dataTask resume];
}

+(void)POST:(NSString *)URL parameters:(NSDictionary *)dic success:(ResponseHander)success failure:(ResErrHander)failure
{
    //创建配置信息
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //设置请求超时时间：5秒
    configuration.timeoutIntervalForRequest = 10;
    //创建会话
    NSURLSession *session = [NSURLSession sessionWithConfiguration: configuration delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]];
    //设置请求方式：POST
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-Type"];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Accept"];
    
    //data的字典形式转化为data
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //设置请求体
    [request setHTTPBody:jsonData];
    
    NSURLSessionDataTask * dataTask =[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            success(responseObject);
        }else{
            NSLog(@"%@",error);
            failure(error.localizedDescription);
        }
    }];
    
    [dataTask resume];
}
@end
