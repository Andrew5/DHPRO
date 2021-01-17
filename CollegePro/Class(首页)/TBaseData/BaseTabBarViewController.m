//
//  BaseTabBarViewController.m
//  LBJH
//
//  Created by 创投天下 on 15/9/2.
//  Copyright (c) 2015年 cttx. All rights reserved.
//

#import "BaseTabBarViewController.h"

#import "BaseNavigationController.h"

#define DH_TitleKey      @"title"
#define DH_ClassKey      @"rootVCName"
#define DH_ImaeNormalKey @"imageNameNormal"
#define DH_ImaeSelectKey @"imageNameSelect"
#define DH_TitleColorKey @"titleColor"


@interface BaseTabBarViewController ()<UITabBarControllerDelegate>
{
    UILabel *_redLab;
    UILabel *_bottomAdLB;
}

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //解决hidesBottomBarWhenPushed 跳转闪屏问题
    [[UITabBar appearance] setTranslucent:NO];
    [self myTabbar];
//    [self.view addSubview:self.customerService];
//    [self.view addSubview:self.visitorLabel];
    [self.view addSubview:self.bottomADView];
    [self addAnimation];
//    [self addScaleAnimationOnView:self.bottomADView];

    // Do any additional setup after loading the view.
}

///MARK:加动画
- (void)addAnimation{

    [_bottomAdLB.layer removeAllAnimations];
    CGRect frame = _bottomAdLB.frame;
    frame.origin.x = self.bottomADView.frame.size.width;
    _bottomAdLB.frame = frame;
    float interval = _bottomAdLB.frame.size.width/35;
    [UIView beginAnimations:@"Animation"context:NULL];
    [UIView setAnimationDuration:interval];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:9999999];
    frame = _bottomAdLB.frame;
    frame.origin.x = - _bottomAdLB.frame.size.width;
    _bottomAdLB.frame = frame;
    [UIView commitAnimations];
    _bottomAdLB.layer.borderColor = [UIColor redColor].CGColor;
    _bottomAdLB.layer.borderWidth = 1.0;
}
//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0, @1.3, @0.9, @1.02, @1.0];
    animation.duration = 0.5;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}
- (void)myTabbar
{  
 
	NSArray *dataArray = @[
						@{DH_ClassKey      : @"DHMainViewController",
						  DH_TitleKey      : @"消息",
						  DH_ImaeNormalKey : @"TabbarBundle.bundle/tabbar_mainframe",
						  DH_ImaeSelectKey : @"TabbarBundle.bundle/tabbar_mainframeHL",
						  DH_TitleColorKey : [UIColor greenColor]
						  },
						@{DH_ClassKey      : @"DHAdressViewController",
						  DH_TitleKey      : @"地址管理",
						  DH_ImaeNormalKey : @"TabbarBundle.bundle/tabbar_contacts",
						  DH_ImaeSelectKey : @"TabbarBundle.bundle/tabbar_contactsHL",
						  DH_TitleColorKey : [UIColor greenColor]
						  },
						@{DH_ClassKey      : @"DHWorkViewController",
						  DH_TitleKey      : @"工作",
						  DH_ImaeNormalKey : @"TabbarBundle.bundle/tabbar_discover",
						  DH_ImaeSelectKey : @"TabbarBundle.bundle/tabbar_discoverHL",
						  DH_TitleColorKey : [UIColor greenColor]
						  },
						@{DH_ClassKey      : @"DHMyInfoViewController",
						  DH_TitleKey      : @"我的",
						  DH_ImaeNormalKey : @"TabbarBundle.bundle/tabbar_me",
						  DH_ImaeSelectKey : @"TabbarBundle.bundle/tabbar_meHL",
						  DH_TitleColorKey : [UIColor greenColor]
						  }
						];
	DH_WEAKSELF;
	[dataArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
		UIViewController *vc = [NSClassFromString(dict[DH_ClassKey]) new];
		vc.title = dict[DH_TitleKey];
		
		BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:vc];
		UITabBarItem *item = navi.tabBarItem;
		item.title = dict[DH_TitleKey];
		item.image = [UIImage imageNamed:dict[DH_ImaeNormalKey]];
		item.selectedImage = [[UIImage imageNamed:dict[DH_ImaeSelectKey]]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		[item setTitleTextAttributes:@{NSUnderlineColorAttributeName:dict[DH_TitleColorKey], NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle), NSForegroundColorAttributeName : dict[DH_TitleColorKey]} forState:UIControlStateSelected];
		
		[weakSelf addChildViewController:navi];
	}];
	//显示第几个
	self.selectedIndex = 0;

}
//#define iPhoneX (IS_IOS_11 && IS_IPHONE && (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 375 && MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 812))
#define isIPhone        [[UIDevice currentDevice].model isEqualToString:@"iPhone"]

-(UIButton *)customerService{
    
    if (!_customerService) {
        
        _customerService = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_customerService setImage:[UIImage imageNamed:@"icon_kefu_home"] forState:UIControlStateNormal];
        
        [_customerService addTarget:self action:@selector(customerServiceClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_customerService];
        [_customerService mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-15);
            
            make.bottom.mas_equalTo(-(49.00 + (isIPhone ? 12+40 : 16+40)));
            
            make.size.mas_equalTo(isIPhone ? CGSizeMake(40, 40) : CGSizeMake(60, 60));
        }];
        
    }
    
    return _customerService;
}

//联系客服
- (void)customerServiceClick{
    
    UINavigationController *nav = self.selectedViewController;
    [DHTool pushChatController:nav.topViewController];
    
}
-(UIButton *)visitorLabel{
    
    if (!_visitorLabel) {
        
        NSString *string = @"当前为游客模式，快去登录学习吧！!";
        NSMutableAttributedString *mutAtt = [[NSMutableAttributedString alloc]initWithString:string];
        
        [mutAtt addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xfe7652) range:[string rangeOfString:@"登录"]];
        
        _visitorLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_visitorLabel setTitle:nil forState:UIControlStateNormal];
        [_visitorLabel setAttributedTitle:mutAtt forState:(UIControlStateNormal)];
        CGFloat h = isIPhone ? 33 : 43;
        
        _visitorLabel.frame = CGRectMake(0, DH_DeviceHeight - kTabBarHeight - h, DH_DeviceWidth, h);
        _visitorLabel.backgroundColor = UIColorFromRGBA(0x000000, 0.6);
        _visitorLabel.titleLabel.textColor = UIColorFromRGBA(0xffffff, 1.0);
        _visitorLabel.titleLabel.font = isIPhone ? kFont(13) : kFont(18);

        [_visitorLabel addTarget:self action:@selector(visitorLabelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _visitorLabel;
}
- (UIView *)bottomADView{
    if (_bottomADView == nil) {
        _bottomADView = [[UIView alloc]init];
        _bottomADView.backgroundColor = [UIColor greenColor];
        [self.view addSubview:_bottomADView];
        [_bottomADView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            } else {
                // Fallback on earlier versions
            }
            make.bottom.equalTo(self.view);
            make.height.offset(34);
        }];
        
        _bottomAdLB = [[UILabel alloc]init];
        _bottomAdLB.textColor = [UIColor blackColor];
        _bottomAdLB.text = @"大海专属";
        _bottomAdLB.textAlignment = NSTextAlignmentCenter;
        [_bottomADView addSubview:_bottomAdLB];
        [_bottomAdLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomADView.mas_top);
            make.centerX.equalTo(_bottomADView);
            make.width.offset(15*5);
        }];
        [self.view layoutIfNeeded];
        NSLog(@"--%@--%@",_bottomAdLB.description,_bottomADView.description);
    }
    return _bottomADView;
}
- (void)visitorLabelClick{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"eLLToLoginViewController" object:@{@"eLLToLoginViewController" : @"1"}];

}
//- (void)addOneChildVC:(UIViewController *)childVC title:(NSString *)title backgroundColor:(UIColor *)color imageName:(NSString *)imageName selectedName:(NSString *)selectImageName
//{
//    childVC.navigationItem.title = title;
//    UIImage *image = [UIImage imageNamed:imageName];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    childVC.tabBarItem.image = image;
//    
//    UIImage *selectImage = [UIImage imageNamed:selectImageName];
//    selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//   childVC.tabBarItem.selectedImage = selectImage;
//	
////    UIView *tabBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 460-48,375, 48)] ;
////    [self.view addSubview:tabBarView];
////    //    UIImageView *backGroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabBar_background.png"]];
////    tabBarView.backgroundColor = IWColor(255,155,0);    [tabBarView addSubview:tabBarView];
//
//    BaseNavigationController *childNav = [[BaseNavigationController alloc]initWithRootViewController:childVC];
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor greenColor],NSForegroundColorAttributeName, nil] forState:(UIControlStateNormal)];
//    
////    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
////    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
//    //背景色
//    self.tabBar.barTintColor = [UIColor whiteColor];
//    [self addChildViewController:childNav];
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end








