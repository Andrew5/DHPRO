//
//  InputVertifyView.h
//  1.input
//
//  Created by cherish on 15/11/17.
//  Copyright © 2015年 杨飞龙. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ClickSearch)(NSString *string);

//物理屏幕宽度
#define KScreenWidth  [UIScreen mainScreen].bounds.size.width

//物理屏幕高度
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height



@interface InputVertifyView : UIView



//block
@property (nonatomic,copy) ClickSearch clickSearch;


@end
