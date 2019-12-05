#import "LHHttpTool.h"
#import "LHMD5.h"
#import <objc/runtime.h>

@implementation LHCache

@end

static char *NSErrorStatusCodeKey = "NSErrorStatusCodeKey";

@implementation NSError (YBHttp)

- (void)setStatusCode:(NSInteger)statusCode
{
    objc_setAssociatedObject(self, NSErrorStatusCodeKey, @(statusCode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)statusCode
{
    return [objc_getAssociatedObject(self, NSErrorStatusCodeKey) integerValue];
}

@end


@implementation LHHttpTool

//错误处理
+ (void)errorHandle:(NSURLSessionDataTask * _Nullable)task error:(NSError * _Nonnull)error failure:(void (^)(NSError *))failure
{
    
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSInteger statusCode = response.statusCode;
    
    error.statusCode = statusCode;
    
    if (statusCode == 401) {//密码错误
        
    } else if (statusCode == 0) {//没有网络
        
    } else if (statusCode == 500) {//参数错误
        
    } else if (statusCode == 404) {
        
    } else if (statusCode == 400) {
        
    }
    LHLog(@"拦截url--------->%@---%@",response.URL,GETUSERDEFAULT(@"LOGINCHECKOUT"));

    if ([self isExistStringT:response.URL.absoluteString]) {
        if ([[self existString:GETUSERDEFAULT(@"LOGINCHECKOUT")] isEqualToString:@""]||[[self existString:GETUSERDEFAULT(@"LOGINCHECKOUT")] isEqualToString:@"0"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINCHECKOUT" object:nil userInfo:@{@"loginType":@"1"}];
            SETUSERDEFAULT(@"1", @"LOGINCHECKOUT");
        }
        return;
    }
    
    
    if ([self isExistLoginString:response.URL.absoluteString]) {
        if ([[self existString:GETUSERDEFAULT(@"QUITOUTOBTNCLICK")] isEqualToString:@"1"]) {
            if ([[self existString:GETUSERDEFAULT(@"LOGINCHECKOUT")] isEqualToString:@""]||[[self existString:GETUSERDEFAULT(@"LOGINCHECKOUT")] isEqualToString:@"0"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINCHECKOUT" object:nil userInfo:@{@"loginType":@"2"}];
                SETUSERDEFAULT(@"1", @"LOGINCHECKOUT");
            }
        }
        return;

        
    }
    

    if (failure) {
        failure(error);
    }
}

+ (NSString *)existString:(NSString *)string{
    if ([string isKindOfClass:[NSNull class]] || string == nil) {
        return @"";
    }else{
        return string;
    }
}

+ (BOOL)isExistStringT:(NSString *)string {
    if ([string isKindOfClass:[NSNull class]] || string == nil) {
        return NO;
    }
    if ([string rangeOfString:@"kickout"].location == NSNotFound) {
        return NO;
    } else {
        LHLog(@"string 包含 martin");
        return YES;
    }
}


+ (BOOL)isExistLoginString:(NSString *)string {
    if ([string isKindOfClass:[NSNull class]] || string == nil) {
        return NO;
    }
    if ([string rangeOfString:@"login"].location == NSNotFound){
        return NO;
    }
    else{
        LHLog(@"string 包含 martin");
        return YES;
    }
}

+ (NSString *)fileName:(NSString *)url params:(NSDictionary *)params
{
    NSMutableString *mStr = [NSMutableString stringWithString:url];
    if (params != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [mStr appendString:str];
    }
    return mStr;
}

+ (AFHTTPSessionManager *)sessionManager
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    //设置接受的类型
//    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/html",@"text/json", nil];
    //设置请求超时
    sessionManager.requestSerializer.timeoutInterval = 10;
    //设置请求头  根据项目设置
    [sessionManager.requestSerializer setValue:@"ajSgfASewSsEhGdAsFf" forHTTPHeaderField:@"ticket"];
    return sessionManager;
}

+ (LHCache *)getCache:(YBCacheType)cacheType url:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *))success
{
    //缓存数据的文件名
    NSString *fileName = [self fileName:url params:params];
    NSData *data = [LHCacheTool getCacheFileName:fileName];
    //
    LHCache *cache = [[LHCache alloc] init];
    cache.fileName = fileName;
    
    if (data.length) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (cacheType == YBCacheTypeReloadIgnoringLocalCacheData) {//忽略缓存，重新请求
            
        } else if (cacheType == YBCacheTypeReturnCacheDataDontLoad) {//有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
            
        } else if (cacheType == YBCacheTypeReturnCacheDataElseLoad) {//有缓存就用缓存，没有缓存就重新请求(用于数据不变时)
            if (success) {
                success(dict);
            }
            cache.result = YES;
            
        } else if (cacheType == YBCacheTypeReturnCacheDataThenLoad) {///有缓存就先返回缓存，同步请求数据
            if (success) {
                success(dict);
                [LHHttpTool printObject:dict isReq:NO];
            }
        } else if (cacheType == YBCacheTypeReturnCacheDataExpireThenLoad) {//有缓存 判断是否过期了没有 没有就返回缓存
            //判断是否过期
            if (![LHCacheTool isExpire:fileName]) {
                if (success) {
                    success(dict);
                }
                cache.result = YES;
            }
        }
    }
    return cache;
}
+ (NSString *)strUTF8Encoding:(NSString *)str{
    //URLFragmentAllowedCharacterSet  stringByAddingPercentEncodingWithAllowedCharacters
//    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
}
+(void)printObject:(NSDictionary*)dic isReq:(BOOL)isReq{
    if ([NSJSONSerialization isValidJSONObject:dic])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (isReq) {
            
            LHLog(@"\n=====================\n请求参数\n==========================\n%@\n======================================================",json);
        }else {
            
            LHLog(@"\n=====================\n返回数据\n==========================\n%@\n=====================================================",json);
        }
    }
}



+ (void)get:(NSString *)url params:(NSDictionary *)params cacheType:(YBCacheType)cacheType success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *sessionManager = [self sessionManager];
    
    //    NSString *httpStr = [[kAPI_URL stringByAppendingString:url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //检查地址中是否有中文
    NSString *urlStr=[NSURL URLWithString:url]?url:[self strUTF8Encoding:url];
    //缓存数据的文件名 data
    LHCache *cache = [self getCache:cacheType url:url params:params success:success];
    NSString *fileName = cache.fileName;
    if (cache.result) return;
    LHWeakSelf
    [sessionManager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        LHLog(@"%lld", downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [LHHttpTool printObject:responseObject isReq:NO];
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        LHLog(@"allHeard======%@",allHeaders);
        if (success) {
           
            //缓存数据
            if (responseObject != nil) {
                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                [LHCacheTool cacheForData:data fileName:fileName];
            }
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf errorHandle:task error:error failure:failure];
        failure(error);
    }];
}

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [self get:url params:params cacheType:YBCacheTypeReloadIgnoringLocalCacheData success:success failure:failure];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params cacheType:(YBCacheType)cacheType success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *sessionManager = [self sessionManager];
    
//    NSString *httpStr = [[LHAPI_URL stringByAppendingString:url] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    
    //缓存数据的文件名 data
    LHCache *cache = [self getCache:cacheType url:url params:params success:success];
    NSString *fileName = cache.fileName;
    if (cache.result) return;
    
    LHWeakSelf
    [sessionManager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSURL *allHeaders = response.URL;
        LHLog(@"allHeard======%@",allHeaders);
        if (success) {
            //缓存数据
            if (responseObject != nil) {
                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                [LHCacheTool cacheForData:data fileName:fileName];

            }
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [weakSelf errorHandle:task error:error failure:failure];
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [self post:url params:params cacheType:YBCacheTypeReloadIgnoringLocalCacheData success:success failure:failure];
}

+ (void)uploadImageWithImage:(NSData *)image success:(void (^)(NSDictionary *obj))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *sessionManager = [self sessionManager];
    [sessionManager.requestSerializer setValue:@"image/jpg" forHTTPHeaderField:@"Content-Type"];
    NSString *httpStr = [[@"" stringByAppendingString:@"pic/fileupload"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    LHWeakSelf
    [sessionManager POST:httpStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //upfile 是参数名 根据项目修改
        [formData appendPartWithFileData:image name:@"upfile" fileName:[NSString stringWithFormat:@"%.0f.jpg", [[NSDate date] timeIntervalSince1970]] mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf errorHandle:task error:error failure:failure];
    }];
}

+ (void)uploadImageArrayWithImages:(NSArray<NSData *> *)images success:(void (^)(NSDictionary *obj))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *sessionManager = [self sessionManager];
    [sessionManager.requestSerializer setValue:@"image/jpg" forHTTPHeaderField:@"Content-Type"];
    NSString *httpStr = [[@"" stringByAppendingString:@"pic/fileuploadArr"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    /*
     NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
     NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
     NSString *encodedUrl = [kAPI_URL stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
     LHLog(@"\n%@\n%@",encodedUrl,kAPI_URL);
     */
    
    LHWeakSelf
    [sessionManager POST:httpStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [images enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //upfiles 是参数名 根据项目修改
            [formData appendPartWithFileData:obj name:@"upfiles" fileName:[NSString stringWithFormat:@"%.0f.jpg", [[NSDate date] timeIntervalSince1970]] mimeType:@"image/jpg"];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            [weakSelf errorHandle:task error:error failure:failure];
        }
    }];
}

@end
