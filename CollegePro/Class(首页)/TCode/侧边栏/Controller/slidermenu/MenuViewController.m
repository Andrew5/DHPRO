//
//  MenuViewController.m
//  CollegePro
//
//  Created by jabraknight on 2019/5/14.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()
#pragma mark -  UIView 新增属性
@property(nonatomic,readonly,strong) UILayoutGuide *safeAreaLayoutGuide API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic,readonly) UIEdgeInsets safeAreaInsets API_AVAILABLE(ios(11.0),tvos(11.0));
#pragma mark - UIViewController 新增方法
@property(nonatomic) UIEdgeInsets additionalSafeAreaInsets API_AVAILABLE(ios(11.0), tvos(11.0));
// safeAreaInsets属性改变的时候回调用该方法
- (void)viewSafeAreaInsetsDidChange NS_REQUIRES_SUPER API_AVAILABLE(ios(11.0), tvos(11.0));

@property (nonatomic, strong) UILabel *testLabel;

@end

@implementation MenuViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if (@available(iOS 11.0, *)) {
//        UIEdgeInsets newSafeAreaInsets = self.view.safeAreaInsets;
//        CGFloat rightViewWidth = 40;
//        CGFloat bottomViewHeight = 49;
//        newSafeAreaInsets.right += rightViewWidth;
//        newSafeAreaInsets.bottom += bottomViewHeight;
//        self.additionalSafeAreaInsets = newSafeAreaInsets;
//    } else {
//        // Fallback on earlier versions
//    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UILabel *label = [[UILabel alloc] init];
//    label.text = @"SafeArea";
//    label.textAlignment = NSTextAlignmentCenter;
//    label.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:label];
//    self.testLabel = label;
//
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
//            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
//            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
//            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
//            make.height.equalTo(@20);
////            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
//        } else {
//            make.top.equalTo(self.mas_topLayoutGuideBottom);
//            make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
//            make.left.mas_equalTo(0);
//            make.right.mas_equalTo(0);
//        }
//
//    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.title = @"门店整改管理";
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"SafeArea";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.backgroundColor = [UIColor greenColor];
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        }
        else{
            make.top.equalTo(self.mas_topLayoutGuideBottom);
        }
        

    }];
//注意：safeAreaInsets的值在-viewDidLoad中获取不到真实的值，可以在-viewSafeAreaInsetsDidChange或则-viewDidAppear:方法中获取到真实的值。
    
//    label.translatesAutoresizingMaskIntoConstraints = NO;
//    if (@available(iOS 11.0, *)) {
//        UILayoutGuide *safeGuide = self.view.safeAreaLayoutGuide;
//        NSLayoutConstraint *topCon = [label.topAnchor constraintEqualToAnchor:safeGuide.topAnchor];
//        NSLayoutConstraint *bottomCon = [label.bottomAnchor constraintEqualToAnchor:safeGuide.bottomAnchor];
//        NSLayoutConstraint *leftCon = [label.leftAnchor constraintEqualToAnchor:safeGuide.leftAnchor constant:0];
//        NSLayoutConstraint * rightCon = [label.rightAnchor constraintEqualToAnchor:safeGuide.rightAnchor constant:0];
//        [NSLayoutConstraint activateConstraints:@[topCon, bottomCon, leftCon, rightCon]];
//
//    } else {
//        // Fallback on earlier versions
//    }
}

// safeAreaInsets改变的时候回调用该方法
//- (void)viewSafeAreaInsetsDidChange {
//    [super viewSafeAreaInsetsDidChange];
//    UIEdgeInsets insets = self.view.safeAreaInsets;
//    self.testLabel.frame = CGRectMake(insets.left, insets.top, self.view.frame.size.width - (insets.right + insets.left), self.view.frame.size.height - (insets.top + insets.bottom));
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
