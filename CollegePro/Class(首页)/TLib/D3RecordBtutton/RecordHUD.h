//
//  RecordHUD.h
//  D3RecordButtonDemo
//
//  Created by bmind on 15/7/29.
//  Copyright (c) 2015年 bmind. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordHUD : UIView{
    UIImageView *imgView;
    UILabel *titleLabel;
    UILabel *timeLabel;
}
@property (nonatomic, strong, readonly) UIWindow *overlayWindow;

+ (void)show;

+ (void)dismiss;

+ (void)setTitle:(NSString*)title;

+ (void)setTimeTitle:(NSString*)time;

+ (void)setImage:(NSString*)imgName;
@end
