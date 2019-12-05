//
//  BaseViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/7/27.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
//导航栏左边按钮
@property(nonatomic,strong) UIButton *buttonBack;

@end

@implementation BaseViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //是否显示左按钮
    if (self.isShowleftBtn==NO)
    {
        [self dh_setBackItem];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 13.0, *)){

    }
//    [[NSNotificationCenter defaultCenter]addObserver:selfselector:@selector(goDengLu:)name:@"ActionD"object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goDengLu:) name:@"ActionD" object:nil];
}
- (void)goDengLu:(NSNotification *)notification {
    NSLog(@"通知事件 %@",[notification object]);
}
- (void)setBackItem {
	[self setBackItemAction:nil];
}
- (void)setBackItemAction:(SEL)sel {
	[self setBackItem:@"返回" action:sel];
}
-(void)dh_setupUI{
	
}
-(void)dh_setupNavi{
	
}
-(void)dh_netUse4Gnet{
	
}
-(void)dh_setBackItem
{
    [self buttonBack];
}
-(void)dh_setNavbarBackgroundHidden:(BOOL)hidden{
	
}
- (void)setBackItem:(NSString *)title action:(SEL)sel {
	UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:sel];
	self.navigationItem.backBarButtonItem = backItem;
}

- (void)dh_hideBottomBarPush:(BaseViewController *)controller {
	self.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:controller animated:YES];
	self.hidesBottomBarWhenPushed = NO;
	
}


-(UIBarButtonItem *)dh_tbarBackButtonWhiteAndPopView
{
	UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
	buttonBack.frame = CGRectMake(0, 0, 20, 22);
	[buttonBack setImage:[UIImage imageNamed:@"title_back"] forState:UIControlStateNormal];
	[buttonBack setImageEdgeInsets:UIEdgeInsetsMake(4,17,5,19)];
	[buttonBack addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *leftBarBtnItem = [[UIBarButtonItem alloc]initWithCustomView:buttonBack];
	return leftBarBtnItem;
}
-(UIBarButtonItem *)dh_tBarIconButtonItem:(NSString *)text action:(SEL)selctor
{
	UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	backBtn.frame = CGRectMake(0, 0, 40, 25);
	[backBtn setTitle:text forState:UIControlStateNormal];
	backBtn.titleLabel.font = [UIFont systemFontOfSize:13];
	[backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[backBtn addTarget:self action:selctor forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
	return backItem;
}
-(UIBarButtonItem *)dh_tBarIconButtonItemWithImage:(NSString *)text action:(SEL)selctor{
	UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	backBtn.frame = CGRectMake(0, 0, 30, 35);
	[backBtn setImage:[UIImage imageNamed:text] forState:UIControlStateNormal];
	//	[backBtn setImageEdgeInsets:UIEdgeInsetsMake(4,17,5,19)];
	[backBtn addTarget:self action:selctor forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
	return backItem;
}
//左右按钮
- (void)setupNaviBtnWithTitle:(NSString *)rightStr rightImgStr:(NSString *)rightImgStr rightTextColor:(UIColor *)rightTextColor rightBlock:(void(^)(UIButton * _Nonnull btn))rightBlock
{
    //左按钮
    [self dh_tbarBackButtonWhiteAndPopView];
    //右按钮
    UIButton *btnSX = [UIButton buttonWithType:UIButtonTypeSystem];
    btnSX.frame = CGRectMake(0, 0, 35, 35);
    //回调
//    if (rightBlock)
//    {
//        [btnSX addAction:rightBlock];
//    }
    if (![DHTool IsNSStringNULL: rightStr])
    {//右按钮是文字
        [btnSX setTitle:rightStr forState:UIControlStateNormal];
        [btnSX setTitleColor:rightTextColor forState:UIControlStateNormal];
        UIBarButtonItem *btnSXItem = [[UIBarButtonItem alloc] initWithCustomView:btnSX];
        self.navigationItem.rightBarButtonItem = btnSXItem;
    }else
    {//右按钮是图片
        [btnSX setImage:[UIImage imageNamed:@"title_back"] forState:UIControlStateNormal];
        btnSX.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        UIView *viewUSX = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        [viewUSX addSubview:btnSX];
        UIBarButtonItem *btnSXItem = [[UIBarButtonItem alloc] initWithCustomView:viewUSX];
        self.navigationItem.rightBarButtonItem = btnSXItem;
    }
}
- (UIButton *)buttonBack{
    if (!_buttonBack) {
        _buttonBack = [UIButton buttonWithType:UIButtonTypeSystem];
        _buttonBack.frame = CGRectMake(0, 0, 55, 44);
        [_buttonBack setImage:[[DH_ImageNameWithBundle(@"TabbarBundle", @"whiteBack") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        _buttonBack.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 30);
        [_buttonBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_buttonBack addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
        UIView *viewU = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 55, 44)];
        [viewU addSubview:_buttonBack];
        UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:viewU];
        self.navigationItem.leftBarButtonItem = btnItem;
    }
    return _buttonBack;
}
/*
 NSLocalizedString(a, nil)
 [self presentAlertTitle:NSLocalizedString(@"Warning",nil) message:NSLocalizedString(@"Are you sure to reboot camera?",nil) alertStyle:UIAlertControllerStyleAlert actionDefaultTitle:NSLocalizedString(@"Yes",nil) actionDefaultBlock:^{
 
 [self.camera setReconnectTimes:10];
 [weakSelf.camera request:HI_P2P_SET_REBOOT dson:nil];
 weakSelf.commandType = CommandTypeReboot;
 
 } actionCancelTitle:NSLocalizedString(@"No",nil) actionCancelBlock:^{
 
 }];
 */
- (void)presentAlertTitle:(NSString *)title message:(NSString *)message alertStyle:(UIAlertControllerStyle)style actionDefaultTitle:(NSString *)defaultTitle actionDefaultBlock:(void (^)(void))defaultBlock actionCancelTitle:(NSString *)cancelTitle actionCancelBlock:(void (^)(void))cancelBlock {
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:defaultTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        defaultBlock();
    }];
    
    UIAlertAction *actionNO = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        cancelBlock();
    }];
    
    //    [actionNO setValue:LightBlueColor forKey:@"_titleTextColor"];
    //    [actionOk setValue:LightBlueColor forKey:@"_titleTextColor"];
    
    [alertController addAction:actionNO];
    [alertController addAction:actionOk];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}
//关闭页面
- (void)closeCurruntPage
{
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            UIViewController *rootVC = self.presentingViewController;
            while (rootVC.presentingViewController) {
                rootVC = rootVC.presentingViewController;
            }
            [rootVC dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
-(void)backBtnClicked{
    if (self.navigationController.topViewController == self) {
        UIViewController *rootVC = self.presentingViewController;
        while (rootVC.presentingViewController) {
            rootVC = rootVC.presentingViewController;
        }
        [rootVC dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)popBack{
	
	[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - system watches

- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"%@  dealloc",NSStringFromClass(self.class));
#endif
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

@end
