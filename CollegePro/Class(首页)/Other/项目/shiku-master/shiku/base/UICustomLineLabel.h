//
//  UICustomLineLabel.h
//  UILineLableDemo
//
//  Created by myanycam on 2014/2/25.
//  Copyright (c) 2014年 myanycam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    LineTypeNone,//没有画线
    LineTypeUp ,// 上边画线
    LineTypeMiddle,//中间画线
    LineTypeDown,//下边画线
    
} LineType ;

@interface UICustomLineLabel : UILabel

@property (assign, nonatomic) LineType lineType;
@property (assign, nonatomic) UIColor * lineColor;


@end
