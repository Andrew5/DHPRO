//
//  ScrollChangeViewController.m
//  CollegePro
//
//  Created by jabraknight on 2019/7/16.
//  Copyright © 2019 jabrknight. All rights reserved.
//
#define TITLEVIEW_HEIGHT 44.0f
#define TITLEBUTTON_WIDTH ([UIScreen mainScreen].bounds.size.width/3)
#import "ScrollChangeViewController.h"
#import "GXButton.h"

#import "DHAdressViewController.h"
#import "DHMyInfoViewController.h"
#import "DHWorkViewController.h"
#import "InternetViewController.h"

@interface ScrollChangeViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *themeArr;
@property (nonatomic, strong) NSArray *themeBtns;
@property (nonatomic, strong) NSArray *childControllerNames;
@property (nonatomic, strong) UIScrollView *themeScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIButton *selectedBtn;

@end

@implementation ScrollChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.isShowleftBtn = NO;
    self.title = @"滑动切换视图";
    
    [self.view addSubview:self.themeScrollView];
    [self.view addSubview:self.contentScrollView];
    
    [self setupChildViewControllers];
    [self themeBtnClicked:self.themeBtns[0]];
    
}
- (NSArray *)themeArr
{
    if (!_themeArr) {
        _themeArr = @[@"ctl1",@"ctl2",@"ctl3",@"ctl4"];
    }
    
    return _themeArr;
}

- (NSArray *)themeBtns
{
    if (!_themeBtns) {
        NSMutableArray *themeBtns = [NSMutableArray arrayWithCapacity:self.themeArr.count];
        for (int i = 0 ; i < self.themeArr.count; i++) {
            GXButton *themeBtn = [GXButton buttonWithType:(UIButtonTypeCustom)];
            themeBtn.frame = CGRectMake(i * TITLEBUTTON_WIDTH, 0, TITLEBUTTON_WIDTH, TITLEVIEW_HEIGHT);
            [themeBtn setTitle:self.themeArr[i] forState:(UIControlStateNormal)];
            [themeBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            themeBtn.tag = i;
            [themeBtn addTarget:self action:@selector(themeBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
            [themeBtns addObject:themeBtn];
            
            if (i == 0) {
                themeBtn.selected = YES;
                self.selectedBtn = themeBtn;
            }
        }
        _themeBtns = themeBtns;
    }
    
    return _themeBtns;
}

- (UIScrollView *)themeScrollView
{
    if (!_themeScrollView) {
        _themeScrollView = [[UIScrollView alloc]init];
        _themeScrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, TITLEVIEW_HEIGHT);
        _themeScrollView.showsHorizontalScrollIndicator = NO;
        _themeScrollView.layer.borderWidth = 1.0;
        _themeScrollView.layer.borderColor = [UIColor blackColor].CGColor;
        for (UIButton *btn in self.themeBtns) {
            [_themeScrollView addSubview:btn];
        }
        
        _themeScrollView.contentSize = CGSizeMake(self.themeArr.count * TITLEBUTTON_WIDTH, 0);
    }
    
    return _themeScrollView;
}

- (UIScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc]init];
        CGFloat originY = CGRectGetMaxY(self.themeScrollView.frame);
        _contentScrollView.frame = CGRectMake(0, originY, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - originY);
        _contentScrollView.contentSize = CGSizeMake(self.themeArr.count * [UIScreen mainScreen].bounds.size.width, 0);
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
    }
    
    return _contentScrollView;
}

- (NSArray *)childControllerNames
{
    if (!_childControllerNames) {
        _childControllerNames = @[@"DHAdressViewController",@"DHMyInfoViewController",@"DHWorkViewController",@"InternetViewController"];
    }
    
    return _childControllerNames;
}
// 设置子控制器
- (void)setupChildViewControllers
{
    for (NSString *className in self.childControllerNames) {
        UIViewController *viewController = [[NSClassFromString(className) alloc]init];
        [self addChildViewController:viewController];
    }
}

- (void)setupChildView:(NSInteger)index
{
    UIViewController *viewController = self.childViewControllers[index];
    if (viewController.view.superview) {
        return;
    }
    
    viewController.view.frame = CGRectMake(index * [UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.contentScrollView.frame));
    [self.contentScrollView addSubview:viewController.view];
}

- (void)themeBtnClicked:(UIButton *)sender
{
    [self setupChildView:sender.tag];
    [self themeButtonScrollToCenter:sender];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.contentScrollView setContentOffset:CGPointMake(sender.tag * [UIScreen mainScreen].bounds.size.width, 0) animated:YES];
    });
}

- (void)themeButtonScrollToCenter:(UIButton *)sender
{
    self.selectedBtn.selected = NO;
    sender.selected = YES;
    self.selectedBtn = sender;
    
    // 主题居中需要的偏移量
    CGFloat offSetX = sender.center.x - [UIScreen mainScreen].bounds.size.width * 0.5;
    
    if (offSetX < 0) { // button的中线点位于屏幕中心的左侧，不需要偏移
        offSetX = 0;
    } else if (offSetX > self.themeScrollView.contentSize.width - [UIScreen mainScreen].bounds.size.width) { // 最多的可偏移量，超出这个偏移量右边会留空白
        offSetX = self.themeScrollView.contentSize.width- [UIScreen mainScreen].bounds.size.width;
    }
    
    [self.themeScrollView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    [self setupChildView:index];
    [self themeButtonScrollToCenter:self.themeBtns[index]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
