//
//  NSString+TResizable.h
//  btc
//
//  Created by txj on 15/1/31.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TResizer.h"

@interface NSString (TResizable)

- (TResizer *)TRSetWidth:(NSInteger)width;
- (TResizer *)TRSetHeight:(NSInteger)height;
- (TResizer *)TRGray;
- (TResizer *)TRRotate:(float)angle;
- (TResizer *)TRQuality:(float)number;
- (TResizer *)TRPng;
- (TResizer *)TRJpg;
- (TResizer *)TRXbm;
- (TResizer *)TRGif;
- (TResizer *)TRScale:(float)percent;
- (TResizer *)TRCrop:(float)widthAndHeight;
- (TResizer *)TRCrop:(float)width height:(float)aHeight;
- (TResizer *)TRSetX:(float)x;
- (TResizer *)TRSetY:(float)y;
- (TResizer *)TRCropAndFill;
@end

