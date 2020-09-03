//
//  DHHttpRequest.m
//  CollegePro
//
//  Created by admin on 2020/8/28.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHHttpRequest.h"
//typedef void(^HXRequestCompletionBlock)(__kindof HXRequest *request,NSDictionary *result, BOOL success);
//typedef void(^HXRequestCompletionFailureBlock)(__kindof HXRequest *request,NSString *errorInfo);

@interface DHHttpRequest(){
    
}
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *password;

@property(nonatomic, strong) NSString * errorInfo;
@end
@implementation DHHttpRequest
- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodPOST;
}
- (NSString *)requestUrl {
//    return @"https://sitservice.lilyclass.com/api/orders/28280";
    ///api/carousels/enabled?type=4
/*
 登录
 {
     password = admin123;
     secretKey = 588c1adb403f6ce030e44ec4d182640e;
     username = 15209930772;
 }/api/auth/login
 */
    /*
     注册
     {
         pushId = 121c83f760a4cc10242;
         pushType = 1;
         username = 15209930772;
     }/api/push/register 需要token
     */
    return @"https://sitservice.lilyclass.com/api/auth/login";
//    return @"http://192.168.210.50:8080/api/auth/login";

}
- (instancetype)initWithUsername:(NSString *)username
                        password:(NSString *)password{
    self = [super init];
    if (self) {
        _username = username;
        _password = password;
    }
    return self;
}

- (NSTimeInterval)requestTimeoutInterval {
    return 10;
}
- (NSString *)description {
    //打印自己认为重要的信息
    return [NSString stringWithFormat:@"%@ \nstatusCode:%ld\nresponseJSONObject:\n%@",super.description,self.responseStatusCode,self.responseJSONObject];
}
 
- (NSString *)errorInfo {
    NSString * info = @"";
//    if (request && request.error) {
//        if (request.error.code==NSURLErrorNotConnectedToInternet) {
//            info = @"请检查网络!";
//        }else if (request.error.code==NSURLErrorTimedOut) {
//            info = @"请求超时,请重试!";
//        }else if (request.responseStatusCode == 401) {
//            info = @"401";
//        }else if (request.responseStatusCode == 403) {
//            info = @"403";
//        }else if (request.responseStatusCode == 404) {
//            info = @"404";
//        }else if (request.responseStatusCode == 500) {
//            info = @"服务器报错,请稍后再试!";
//        }else
//        {
//            info = @"获取数据失败,请重试!";
//        }
//    }
    return info;
}
-(YTKRequestSerializerType)requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (id)requestArgument {
    return @{
            @"username":_username,
            @"password":_password,
            @"secretKey":@"588c1adb403f6ce030e44ec4d182640e",
            @"access_token":@"eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJsaWx5Q2xhc3NPbmxpbmUiLCJzdWIiOiJ7XCJsYXN0TG9naW5EYXRlXCI6XCIyMDIwLTA4LTMwIDIyOjI4OjUyLjdcIixcInVzZXJJZFwiOjIzNTMxLFwidXNlcm5hbWVcIjpcIjE1MjA5OTMwNzcyXCJ9IiwiYXVkIjoibW9iaWxlIiwiaWF0IjoxNTk4Nzk3NzMyLCJleHAiOjE1OTg4ODQxMzJ9.Rt2DP_yro9FIhxG663PrSsUnlaCh3cUDbsp_MNc6PsdhkEBIn9v__Pz5dSRUggz895YN6fNkv5OASR2a5cSqJA"
            };
}

//设置请求头
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    //设置通用header 签名
    if (self.needToken) {
        NSLog(@"需要");
    }else{
        NSLog(@"不需要");
    }
    return @{
        @"did":@"144B2FE8-3EE5-4916-A0CA-66EF461FBB39",
        @"os":@"1",
        @"channel":@"001",
        @"reqTime":@"1598694276",
        @"osVer":@"iPhone-13.5.1",
        @"ver":@"2.2.0",
        @"Content-Type":@"application/json; charset=utf-8"
        
    };
}
-(NSString *)convertToJsonData:(NSDictionary *)dict

{

    NSError *error;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];

    NSString *jsonString;

    if (!jsonData) {

        NSLog(@"%@",error);

    }else{

        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    NSRange range = {0,jsonString.length};

    //去掉字符串中的空格

    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = {0,mutStr.length};

    //去掉字符串中的换行符

    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;

}
//- (NSURLRequest *)buildCustomUrlRequest {
//////    NSDictionary *para = @{@"secretKey":@"67dca3ecb1db307ea05cd3462af4af37",
//////                           @"username":_username,
//////                           @"password":_password
//////                          };
//////    NSData *gzippingData = [[para description] dataUsingEncoding:NSUTF8StringEncoding];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]];
//    [request setHTTPMethod:@"POST"];
////    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
////    [request addValue:@"raw" forHTTPHeaderField:@"Content-Type"];// 设置请求类型
////    [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
////    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    if (@available(iOS 11.0, *)) {
//        request.accessibilityContainerType = [NSSet setWithObjects:@"text/plain",@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
//    } else {
//        // Fallback on earlier versions
//    }
//
////    [request addValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
////    if (![request valueForHTTPHeaderField:@"Content-Type"]) {
////        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
////    }
////    [request setHTTPBody:gzippingData];
//    return request;
//}

//- (AFConstructingBlock)constructingBodyBlock {
//    return ^(id<AFMultipartFormData> formData) {
//        NSDictionary *para = @{@"secretKey":@"",
//                              @"username":@"13166668686",
//                              @"password":@"admin123"
//                              };
//
//        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
//    };
//}
 
//- (void)sendChainRequest {
//
//    RegisterApi *reg = [[RegisterApi alloc] initWithUsername:@"username" password:@"password"];
//    YTKChainRequest *chainReq = [[YTKChainRequest alloc] init];
//    [chainReq addRequest:reg callback:^(YTKChainRequest *chainRequest, YTKBaseRequest *baseRequest) {
//
//    RegisterApi *result = (RegisterApi *)baseRequest;
//    NSString *userId = [result userId];
//    GetUserInfoApi *api = [[GetUserInfoApi alloc] initWithUserId:userId];
//    [chainRequest addRequest:api callback:nil]; }];
//
//    chainReq.delegate = self;
//
//    // start to send request
//    [chainReq start];
//}

//- (void)chainRequestFinished:(YTKChainRequest *)chainRequest {
//
//    // all requests are done
//}
//
//- (void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest*)request {
//
//// some one of request is failed
//}
//验证返回数据
//- (id)jsonValidator {
//    return @{ @"imageId": [NSString class] };
//}
//设置一个3分钟的缓存，3分钟内调用调Api的start方法，实际上并不会发送真正的请求。
//- (NSInteger)cacheTimeInSeconds {
// cache 3 minutes, which is 60 * 3 = 180 seconds
// return 60 * 3;
// }
//使用useCDN 地址请求
//- (BOOL)useCDN {
//return YES;
//}
//- (NSString *)responseImageId {
//    NSDictionary *dict = self.responseJSONObject;
//    return dict[@"imageId"];
//}
 

///请求个人信息
- (void)httpResultUserInfo{
    
}
///请求首页banner
- (void)httpRequestBanner{
    
}

@end
