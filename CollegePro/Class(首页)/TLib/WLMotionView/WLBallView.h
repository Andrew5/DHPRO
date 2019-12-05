//
//  WLBallView.h
//  WLBallView
//
//  Created by administrator on 2017/6/15.
//  Copyright © 2017年 WL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLBallView : UIImageView

- (instancetype)initWithFrame:(CGRect)frame AndImageName:(NSString *)imageName;

- (void)starMotion;

@end
