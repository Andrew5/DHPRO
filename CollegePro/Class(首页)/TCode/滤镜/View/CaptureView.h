//
//  CaptureView.h
//  15
//
//  Created by jabraknight on 2018/11/29.
//  Copyright © 2018 大爷公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  CaptureViewDelegate<NSObject>

- (void)captureAuthorizationFail;
- (void)shutterCameraWithImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_BEGIN

@interface CaptureView : UIView

@property (nonatomic, weak) id <CaptureViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame WithDelegate:(id <CaptureViewDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
