//
//  XZImageCropperViewController.h
//  DigitalCalendar
//
//  Created by txj on 14/12/9.
//
//

#import <UIKit/UIKit.h>

@class XZImageCropperViewController;

@protocol XZImageCropperDelegate <NSObject>

- (void)imageCropper:(XZImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(XZImageCropperViewController *)cropperViewController;

@end

@interface XZImageCropperViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<XZImageCropperDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end

