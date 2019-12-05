//
//  JSTextView.h
//  LeBangProject
//
//  Created by Rillakkuma on 16/6/15.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSTextView : UITextView
@property(nonatomic,copy) NSString *myPlaceholder;  //文字

@property(nonatomic,strong) UIColor *myPlaceholderColor; //文字颜色
@end
