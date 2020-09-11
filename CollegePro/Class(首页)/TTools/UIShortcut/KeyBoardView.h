//
//  KeyBoardView.h
//  A6_8_1_自定义键盘
//
//  Created by Bo on 16/3/31.
//  Copyright © 2016年 Simple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KeyBoardView;

@protocol KeyBoardViewDelegate <NSObject>
//代理方法，用来回传点击按钮上的数据
- (void)sendMessageInView:(KeyBoardView *)bView
              backContent:(NSString *)content;
@end

//1
typedef void(^Block)(KeyBoardView *,NSString *);


@interface KeyBoardView : UIView
///代理对象
@property (assign, nonatomic) id <KeyBoardViewDelegate>delegate;
///2block 属性
@property (copy, nonatomic) Block myBlock;

//给myBlock指向一个代码块的方法
- (void)viewWithBlock:(Block)inBlock;


@end
