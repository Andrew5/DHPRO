//
//  SignalControl.h
//  JHLivePlayLibrary
//
//  Created by xianjunwang on 2017/12/13.
//  Copyright © 2017年 pk. All rights reserved.
//  上面一个label,下面一个label

#import <UIKit/UIKit.h>

@interface SignalControl : UIControl
//上方的label
@property (nonatomic,strong) UILabel * aboveLabel;
//下方的label
@property (nonatomic,strong) UILabel * belowLabel;

+(float)viewWidthWithStr:(NSString *)title;

//title是上方aboveLabel显示数据；data是下方belowLabel显示数据。
-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andData:(NSString *)data;
@end
