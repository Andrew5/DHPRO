//
//  DHHttpRequestImageFile.h
//  CollegePro
//
//  Created by admin on 2020/9/3.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHHttpRequestImageFile : YTKBaseRequest
@property (nonatomic, strong)NSData *imageData;
@property (nonatomic, strong)UIImage *image;
@property(nonatomic,copy)void(^uploadProgressBlock)(DHHttpRequestImageFile *currentApi, NSProgress * progress);
- (instancetype)initImageWithData:(NSData *)imageData WithImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
