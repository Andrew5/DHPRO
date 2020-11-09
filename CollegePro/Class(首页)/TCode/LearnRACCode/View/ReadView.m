//
//  ReadView.m
//  TestDemo
//
//  Created by jabraknight on 2020/11/8.
//  Copyright © 2020 黄定师. All rights reserved.
//

#import "ReadView.h"

@implementation ReadView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        btn.frame = CGRectMake(10, 10, 45, 20);
        //        [btn.titleLabel setText:@"进入"];
        [btn setTitle:@"洪色" forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //    [btn addTarget:self action:@selector(addPage) forControlEvents:(UIControlEventTouchUpInside)];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:(UIControlEventTouchUpInside)];
        btn.layer.borderColor = [UIColor greenColor].CGColor;
        btn.layer.borderWidth = 1.0;
    }
    return self;
}
- (void)btnClick{
    //通知控制器处理
//    [self.btnClickSignal sendNext:@"红色View"];
}
//- (RACSubject *)btnClickSignal{
//    if (_btnClickSignal == nil) {
//        _btnClickSignal = [RACSubject subject];
//    }
//    return _btnClickSignal;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
