//
//  ADView.h
//  09-04UISrollViewRepeate
//
//  Created by 郝海圣 on 15/9/24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
//使用方法：初始化时传过一个存有图片地址的数组，必须使用initWithArray这个方法初始化ADView

typedef void(^GoBackBlock)();
@interface ADView : UIView
@property (nonatomic,retain) NSArray *imageArray;
-(id)initWithArray:(NSArray *)array andFrame:(CGRect)frame andBlock:(GoBackBlock)back;


@end
