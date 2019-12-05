//
//  MyCreView.h
//  CollegePro
//
//  Created by jabraknight on 2019/9/5.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import <UIKit/UIKit.h>
#define space 30
#define radius1 (self.frame.size.width-space*2)/2
#define radius2 radius1-10
#define radius3 radius2-radius1/2
#define radius4 10
#define number 101
//弧度转角度
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
//角度转弧度
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

NS_ASSUME_NONNULL_BEGIN

@interface MyCreView : UIView
//进度颜色
@property (nonatomic,strong)UIColor* progressColor;

- (void)progress:(CGFloat)value;
@end

NS_ASSUME_NONNULL_END
