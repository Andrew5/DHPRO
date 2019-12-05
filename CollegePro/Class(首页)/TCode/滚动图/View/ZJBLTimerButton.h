//
//  ZJBLTimerButton.h
//  ZJBL-SJ
//
//  Created by 郭军 on 2017/4/20.
//  Copyright © 2017年 ZJNY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickCountDownButtonBlock)();


@interface ZJBLTimerButton : UIButton

@property(nonatomic , assign) int second; //开始时间数
@property(nonatomic , copy) ClickCountDownButtonBlock countDownButtonBlock; //点击按钮

@end
