//
//  LhWatermarkDataModel.h
//  https://github.com/Mars-Programer/LHCamera
//
//  Created by 刘欢 on 2017/2/16.
//  Copyright © 2017年 imxingzhe.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define SCREENHEITH CGRectGetHeight([[UIScreen mainScreen] bounds])
#define SCREENWIDTH CGRectGetWidth([[UIScreen mainScreen] bounds])
#define SCREENRelativeHeight (SCREENHEITH - 64.)


#define SCREEN_375 (SCREENWIDTH / 375.)
#define SCREEN_667 (SCREENHEITH / 667.)
@interface LHWatermarkDataModel : NSObject
@property (nonatomic, copy) UIImage *soureImage;
@property (nonatomic, copy) UIImage *finishWatermarkImage;
@property (nonatomic, copy) UIImage *watermarkImage;
@property (nonatomic, copy) UIImage *watermarkImage2;
@end
