//
//  CornerViewController.m
//  CollegePro
//
//  Created by jabraknight on 2019/7/4.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "CornerViewController.h"
#import "Masonry.h"
#import "CustomView.h"
#import "MasonryCustomView.h"

#import "UIView+RandomCorner.h"
@interface CornerViewController ()
@property (nonatomic, strong) UIView *masonryView;

@end

@implementation CornerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //直接设置frame使用固定布局的view，设置完frame后就可以设置圆角
    //如果是自定义视图，可以直接在initWithFrame方法中进行设置
    
    //能正常生产圆角
    UIView *view = [[UIView alloc] init];//
    view.frame = CGRectMake(50, 50, 200, 100);
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    [view setCorners:UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    
    //自定义视图，可以把画圆角的操作封装在视图内部的initWithFrame方法中
    CustomView *frameCustomView = [[CustomView alloc] init];
    frameCustomView.frame = CGRectMake(50, 170, 200, 100);
    frameCustomView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:frameCustomView];
    
    //使用masonry自动布局
    self.masonryView = [[UIView alloc] init];
    self.masonryView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.masonryView];
    
    [self.masonryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 100));
        make.top.mas_equalTo(self.view.mas_top).offset(300);
        make.centerX.mas_equalTo(self.view);
    }];
    
    //这里加了这句之后就看不到masonryView了
    //    [self.masonryView setCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
    
    MasonryCustomView *masonryCustomView = [[MasonryCustomView alloc] init];
    masonryCustomView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:masonryCustomView];
    [masonryCustomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(100);
        make.top.mas_equalTo(self.view.mas_top).offset(430);
        make.centerX.mas_equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //这里视图布局还没有完成，masonryView的frame还是（0，0，0，0），加了这句之后就看不到masonryView了
    //    [self.masonryView setCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //加在这里是OK的，而且这之后都是ok的
    [self.masonryView setCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //加在这里是OK的
    //    [self.masonryView setCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
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
