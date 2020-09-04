//
//  DHHttpRequestImageUp.m
//  CollegePro
//
//  Created by admin on 2020/9/4.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHHttpRequestImageUp.h"
#import "Base64.h"
///LYNetWork
@implementation DHHttpRequestImageUp
- (instancetype)initImageWithData:(NSData *)imageData WithImage:(UIImage *)image WithBase64:(nullable NSString *)base64
{
    if (self = [super init]) {
        _imageData = imageData;
        _image = image;
//        _base64 = base64;
//        NSData *imagedata = UIImagePNGRepresentation(image);
//        NSString *image64 = [imagedata base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//        _base64 = image64;
        
//        YTKNetworkAgent *agent = [YTKNetworkAgent sharedAgent];
//        [agent setValue:[NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",@"text/html",@"text/css", nil]
//        forKeyPath:@"jsonResponseSerializer.acceptableContentTypes"];
        self.resumableDownloadProgressBlock = [self resumableUploadProgressBlock];
    }
    return self;
}

- (NSString *)requestUrl {
    return @"https://sitservice.lilyclass.com/api/user/avatar";
}
//设置请求头
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    //设置通用header 签名
    return @{
        @"did":@"CB55E0B1-AD0A-46E9-B566-F732BB478C04",
        @"os":@"1",
        @"channel":@"001",
        @"reqTime":@"1599203994",
        @"osVer":@"iPhone-13.5.1",
        @"ver":@"2.3.0",
//        @"Authorization":@"Bearer eyJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJsaWx5Q2xhc3NPbmxpbmUiLCJzdWIiOiJ7XCJsYXN0TG9naW5EYXRlXCI6XCIyMDIwLTA5LTAzIDE2OjM3OjUyLjg5N1wiLFwidXNlcklkXCI6MjMzMjAsXCJ1c2VybmFtZVwiOlwiMTMxNjY2Njg2ODZcIn0iLCJhdWQiOiJtb2JpbGUiLCJpYXQiOjE1OTkxMjIyNzIsImV4cCI6MTU5OTIwODY3Mn0.36O03UijLArrBugWUnUC9q-wuSbzz7AvGY5AJmj_lKZsoVplpCGkjvRweXPV1-P4ZYH-h-i5kmKFOG_oq7dTbA"
        @"Authorization":[NSString stringWithFormat:@"Bearer %@",[[DHTool userTokenObj] objectForKey:@"access_token"]]
    };
}
- (AFURLSessionTaskProgressBlock) resumableUploadProgressBlock
{
    __weak __typeof (self)weakSelf = self;
    AFURLSessionTaskProgressBlock block = ^void(NSProgress * progress){
        if (weakSelf.uploadProgressBlock) {
            weakSelf.uploadProgressBlock(self,progress);
        }
    };
    return block;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
- (AFConstructingBlock)constructingBodyBlock
{
    __weak __typeof (self)weakSelf = self;
    if (_imageData) {
        return ^(id<AFMultipartFormData> formData) {
            NSString *name = @"file";
            NSString *type = @"image/jpg";
            NSData *data=UIImagePNGRepresentation(weakSelf.image);
            NSDate* date = [NSDate date];
            NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
            [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *timeStr=[dateformatter stringFromDate:date];
            NSString *fileName=[NSString stringWithFormat:@"%@.png",timeStr];
//            NSString *image64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            [formData appendPartWithFileData:weakSelf.imageData name:name fileName:@"file.jpg" mimeType:type];
            //            NSURL *url = [NSURL URLWithString:self->_imageStringFile];
            //            [formData appendPartWithFileURL:url name:name fileName:fileName mimeType:type error:nil];
            //            [formData appendPartWithFileData:weakSelf.imageData name:name fileName:fileName mimeType:type];
        };
    }else {
        return nil;
    }
}
//附加参数，全部请求附加
- (id)requestArgument {
    NSString *token = @"";
    return @{@"token":token}.mutableCopy;
}
//请求成功预处理
- (void)requestCompletePreprocessor {
    NSLog(@"成功 %@", self);
}
- (void)requestFailedPreprocessor {
    NSLog(@"失败 %@", self);
}

//请求成功
- (void)requestCompleteFilter {
    NSLog(@"%@", self);
    NSLog(@"%@", self.responseObject);
//    NSLog(@"%@", self.responseObject[@"message"]);
//    if (MM_CODE_VERIFY(self.responseObject[@"code"])) {
//#pragma waring 存储token
//        [MMProgressHUD dismiss];
//    } else if (MM_CODE_LOGIN_VERIFY(self.responseObject[@"code"])) {
//
//        //隐藏hud
//        [MMProgressHUD dismiss];
//    } else {
//        if (!_isHideTips) {
//            [MMProgressHUD showTips:self.responseObject[@"message"]];
//        }
//    }
}
//请求失败
- (void)requestFailedFilter {
    //隐藏hud
//    [MMProgressHUD dismiss];
}

- (void)startWithCompletionBlockWithSuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure {
//    if (!_isHideHUD) {
//        [MMProgressHUD show];
//    }
    [super startWithCompletionBlockWithSuccess:success failure:failure];
}
@end
