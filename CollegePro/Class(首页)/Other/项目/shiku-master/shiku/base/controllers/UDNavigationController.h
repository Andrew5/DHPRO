//
//  UDNavigationController.h
//  test
//
//  Created by UDi on 15-1-7.
//  Copyright (c) 2015年 Mango Media Network Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *基类NavigationController，可以设置透明度
 */

@interface UDNavigationController : UINavigationController{
    BOOL _changing;
}
@property(nonatomic, retain)UIView *alphaView;
//-(void)setAlph;
/**
 *  设置透明度
 *
 *  @param value 0-1之间的数值，数值越大，透明度越高
 */
-(void)setAlph:(double)value;



@end
