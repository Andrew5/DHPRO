//
//  ZQVariableMenuControl.m
//  ZQVariableMenuDemo
//
//  Created by 肖兆强 on 2017/12/1.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//

#import "ZQVariableMenuControl.h"
#import "ZQVariableMenuView.h"

@interface ZQVariableMenuControl ()
{
    UINavigationController *_nav;
    
    ZQVariableMenuView *_variableMenu;
    
    ChannelBlock _block;
}
@end
@implementation ZQVariableMenuControl


+(ZQVariableMenuControl*)shareControl{
    static ZQVariableMenuControl *control = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        control = [[ZQVariableMenuControl alloc] init];
    });
    return control;
}

-(instancetype)init
{
    if (self = [super init]) {
        [self buildChannelView];
    }
    return self;
}

-(void)buildChannelView{
    
    _variableMenu = [[ZQVariableMenuView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    _nav = [[UINavigationController alloc] initWithRootViewController:[UIViewController new]];
    _nav.navigationBar.tintColor = [UIColor blackColor];
    _nav.topViewController.title = @"频道管理";
    _nav.topViewController.view = _variableMenu;
    _nav.topViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backMethod)];
}

-(void)backMethod
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _nav.view.frame;
        frame.origin.y = - _nav.view.bounds.size.height;
        _nav.view.frame = frame;
    }completion:^(BOOL finished) {
        [_nav.view removeFromSuperview];
    }];
    _block(_variableMenu.inUseTitles,_variableMenu.unUseTitles);
}

-(void)showChannelViewWithInUseTitles:(NSArray *)inUseTitles unUseTitles:(NSArray *)unUseTitles fixedNum:(NSInteger)fixedNum finish:(ChannelBlock)block
{
    _block = block;
    _variableMenu.inUseTitles = [NSMutableArray arrayWithArray:inUseTitles];
    _variableMenu.unUseTitles = [NSMutableArray arrayWithArray:unUseTitles];
    _variableMenu.fixedNum = fixedNum;
    [_variableMenu reloadData];
    
    CGRect frame = _nav.view.frame;
    frame.origin.y = - _nav.view.bounds.size.height;
    _nav.view.frame = frame;
    _nav.view.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:_nav.view];
    [UIView animateWithDuration:0.3 animations:^{
        _nav.view.alpha = 1;
        _nav.view.frame = [UIScreen mainScreen].bounds;
    }];
}




@end
