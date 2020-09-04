//
//  DHHttpRequestImageUp.h
//  CollegePro
//
//  Created by admin on 2020/9/4.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHHttpRequestImageUp : YTKRequest
@property (nonatomic, strong)NSData *imageData;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)NSString *base64;

@property(nonatomic,copy)void(^uploadProgressBlock)(DHHttpRequestImageUp *currentApi, NSProgress * progress);
- (instancetype)initImageWithData:(NSData *)imageData WithImage:(UIImage *)image WithBase64:(nullable NSString *)base64;
@end

NS_ASSUME_NONNULL_END
