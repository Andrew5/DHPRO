//
//  TImageResizer.h
//  btc
//
//  Created by txj on 15/1/31.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    TNorthWest, TNorth, TNorthEast, TWest, TCenter, TEast, TSouthWest,
    TSouth, TSouthEast
} TGravity;

// TODO: 新增设置Gravity

@interface TResizer : NSObject
@property (strong, nonatomic) NSURL *original;
@property (assign, nonatomic) float width;
@property (assign, nonatomic) float height;
@property (assign, nonatomic) float angle;
@property (assign, nonatomic) float quality;
@property (assign, nonatomic) float scaleWidth;
@property (assign, nonatomic) float scaleHeight;
@property (assign, nonatomic) float x;
@property (assign, nonatomic) float y;
@property (assign, nonatomic) BOOL isGray;
@property (assign, nonatomic) BOOL isCrop;
@property (assign, nonatomic) BOOL isCropAndFill;
@property (strong, nonatomic) NSString *extension;
- (id)initWithURL:(NSURL *)url;
- (id)initWithString:(NSString *)url;
- (TResizer *)width:(float)width;
- (TResizer *)height:(float)height;
- (TResizer *)gray;
- (TResizer *)rotate:(float)angle;
- (TResizer *)quality:(float)number;
- (TResizer *)png;
- (TResizer *)jpg;
- (TResizer *)xbm;
- (TResizer *)gif;
- (TResizer *)scale:(float)percent;
- (TResizer *)crop:(float)widthAndHeight;
- (TResizer *)crop:(float)width height:(float)aHeight;
- (TResizer *)x:(float)x;
- (TResizer *)y:(float)y;
- (TResizer *)cropAndFill;
- (UIImage *)image;
- (NSURL *)url;
+ (instancetype)resizerWithURL:(NSURL *)url;
+ (instancetype)resizerWithString:(NSString *)url;
@end

