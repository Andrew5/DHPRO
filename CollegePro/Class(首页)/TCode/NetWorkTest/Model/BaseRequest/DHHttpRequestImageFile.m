//
//  DHHttpRequestImageFile.m
//  CollegePro
//
//  Created by admin on 2020/9/3.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHHttpRequestImageFile.h"

@implementation DHHttpRequestImageFile

- (NSString *)requestUrl {
    return @"https://sitservice.lilyclass.com/api/user/avatar";
}
- (instancetype)initImageWithData:(NSData *)imageData WithImage:(UIImage *)image
{
    if (self = [super init]) {
        _imageData = imageData;
        _image = image;
        self.resumableDownloadProgressBlock = [self resumableUploadProgressBlock];
    }
    return self;
}
- (YTKRequestMethod)requestMethod {
   return YTKRequestMethodPOST;
}
- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeJSON;
}
//请求成功预处理
- (void)requestCompletePreprocessor {
    NSLog(@"%@", self);
}

//请求成功
- (void)requestCompleteFilter {
    NSLog(@"%@", self);
    NSLog(@"%@", self.responseObject);
    NSLog(@"%@", self.responseObject[@"message"]);
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

//请求失败预处理
- (void)requestFailedPreprocessor {
    NSLog(@"%@", self.error);
}

//请求失败
- (void)requestFailedFilter {
    //隐藏hud
NSLog(@"%@", self);
}

- (void)startWithCompletionBlockWithSuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure {
//    if (!_isHideHUD) {
//        [MMProgressHUD show];
//    }
    [super startWithCompletionBlockWithSuccess:success failure:failure];
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
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:type];
            //            NSURL *url = [NSURL URLWithString:self->_imageStringFile];
            //            [formData appendPartWithFileURL:url name:name fileName:fileName mimeType:type error:nil];
            //            [formData appendPartWithFileData:weakSelf.imageData name:name fileName:fileName mimeType:type];
        };
    }else {
        return nil;
    }
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
//设置请求头
- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    //设置通用header 签名
    return @{
        @"did":@"CB55E0B1-AD0A-46E9-B566-F732BB478C04",
        @"os":@"1",
        @"channel":@"001",
        @"reqTime":@"1599126093",
        @"osVer":@"iPhone-13.5.1",
        @"ver":@"2.3.0",
        @"Authorization":[NSString stringWithFormat:@"Bearer %@",[[DHTool userTokenObj] objectForKey:@"access_token"]]
    };
}
@end
