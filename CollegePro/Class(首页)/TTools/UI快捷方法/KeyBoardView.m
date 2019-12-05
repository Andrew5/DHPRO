//
//  KeyBoardView.m
//  A6_8_1_自定义键盘
//
//  Created by Bo on 16/3/31.
//  Copyright © 2016年 Simple. All rights reserved.
//

#import "KeyBoardView.h"

static CGFloat const kMargin = 20;
static NSUInteger const kBtnCountInRow = 3;
static CGFloat const kBtnHeight = 35;

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface KeyBoardView ()

@property (copy, nonatomic) NSArray *arrBtnTitles;

@end

@implementation KeyBoardView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        CGFloat btnWidth = (SCREEN_WIDTH - (kMargin * (kBtnCountInRow + 1)))/kBtnCountInRow;
        
        //循环创建按钮，添加到当前视图中
        for (int i = 0; i < self.arrBtnTitles.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            //设置按钮标题
            [btn setTitle:self.arrBtnTitles[i] forState:UIControlStateNormal];
            //行
            int x = i % kBtnCountInRow;
            //列
            int y = i / kBtnCountInRow;
            //设置按钮的区域
            [btn setFrame:CGRectMake(kMargin + x *(kMargin + btnWidth), kMargin + y * (kMargin + kBtnHeight), btnWidth, kBtnHeight)];
            //给按钮设置个颜色
            [btn setBackgroundColor:[UIColor orangeColor]];
            //给按钮标题设置颜色
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //给按钮关联事件
            [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            //将按钮加入到视图中
            [self addSubview:btn];
        }
    }
    return self;
}
///按钮关联的事件
- (void)btnPressed:(UIButton *)btn{
    [UIView animateWithDuration:0.1 animations:^{
        btn.alpha = 1.0;
        btn.alpha = 0.2;
        btn.alpha = 1.0;
//        btn.transform = CGAffineTransformMakeScale(2.5, 2.5);
//        btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
    
    NSLog(@"%@",btn.titleLabel.text);
    //判断代理对象是否响应方法，如果响应才调用
//    if ([self.delegate respondsToSelector:@selector(sendMessageInView:backContent:)]) {
//        [self.delegate sendMessageInView:self backContent:btn.titleLabel.text];
//    }
    //使用block进行数据回传(调用myBlock)
    self.myBlock(self,btn.titleLabel.text);
    //给按钮执行动画
    
}

///让myBlock指向一个代码块
- (void)viewWithBlock:(Block)inBlock{
    self.myBlock = inBlock;
}


#pragma mark
#pragma mark  Attribute
///存储按钮标题
- (NSArray *)arrBtnTitles{
    if (!_arrBtnTitles) {
        _arrBtnTitles = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"#",@"0",@"*", nil];
    }
    return _arrBtnTitles;
}







@end
