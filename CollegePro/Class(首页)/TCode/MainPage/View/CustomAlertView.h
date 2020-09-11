//
//  CustomAlertView.h
//  SpeedAcquisitionloan
//
//  Created by Uwaysoft on 2018/6/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickMethodBlock)(void);

@interface CustomAlertView : UIView
@property (nonatomic,copy)ClickMethodBlock clickFuntion;
- (void)showInView:(UIView *)view withFaceInfo: (NSDictionary *)info advertisementImage: (NSString *)imageurl borderColor: (UIColor *)color;

@end
