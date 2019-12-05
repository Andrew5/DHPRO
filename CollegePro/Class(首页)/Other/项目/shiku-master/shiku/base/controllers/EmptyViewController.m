//
//  EmptyViewController.m
//  btc
//
//  Created by txj on 15/3/30.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "EmptyViewController.h"

@implementation EmptyData

@end

@interface EmptyViewController ()

@end

@implementation EmptyViewController
-(instancetype)initWithIcon:(NSString *)icon andTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    self=[super init];
    if (self) {
        icontext=icon;
        titletext=title;
        subtitletext=subTitle;
    }
    return self;
}
-(IBAction)tapGoHome:(id)sender
{
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.iconLable.text=icontext;
    self.iconLable.font = [UIFont fontWithName:@"iconfont" size:60];
    //self.iconLable.backgroundColor = BG_COLOR;
    self.iconLable.textColor=[UIColor whiteColor];
    self.iconLable.layer.backgroundColor=BG_COLOR.CGColor;
    self.iconLable.layer.cornerRadius=30;
    
//    self.titleLabel.text=titletext;
//    self.subTitleLabel.text=subtitletext;
    
    [self.actionButton removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
+ (instancetype)shared
{
    static EmptyViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[EmptyViewController alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void)bind
{
    @weakify(self)
    [RACObserve(self, emptyData)
     subscribeNext:^(id x) {
         @strongify(self);
         [self render];
     }];
}
- (void)render
{
    self.iconLable.text=self.emptyData.iconText;
    self.titleLabel.text=self.emptyData.titleText;
    self.subTitleLabel.text=self.emptyData.subTitleText;
}

@end
