//
//  ZSDPaymentForm.h
//  demo
//
//  Created by shaw on 15/4/11.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSDPaymentForm : UIView

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *goodsName;
@property (nonatomic,assign) CGFloat amount;

@property (nonatomic,copy) NSString *inputPassword;
@property (nonatomic,copy) void (^completeHandle)(NSString *inputPwd);

-(void)fieldBecomeFirstResponder;
-(CGSize)viewSize;

@end
