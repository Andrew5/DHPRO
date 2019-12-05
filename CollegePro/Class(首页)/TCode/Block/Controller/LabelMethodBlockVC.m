//
//  LabelMethodBlockVC.m
//  Test
//
//  Created by Rillakkuma on 2016/11/29.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "LabelMethodBlockVC.h"
#import "LabelMethodBlockSubVC.h"
#import "LabelNilMethodBlockViewController.h"
#import <objc/message.h>
#import "UIViewExt.h"
#import "DHRadianLayerView.h"
#import "UIImage+compressIMG.h"

typedef void(^MyBlock)(void);
@interface LabelMethodBlockVC ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
	NSString *u;
	BOOL snState;
    DHRadianLayerView *RadianLayerView;
}
@property (nonatomic,copy)MyBlock block;//定义一个MyBlock属性
typedef void (^CustomEvent)(NSString* str);//本类测试

@end

@implementation LabelMethodBlockVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"UIBlockRuntime";
    self.view.backgroundColor = [UIColor whiteColor];

     
     RadianLayerView = [[DHRadianLayerView alloc]initWithFrame:CGRectMake(10, 350, [UIScreen mainScreen].bounds.size.width-20, 50)];
     RadianLayerView.backgroundColor = [UIColor greenColor];
     UIImage *im = [UIImage getGradientImageFromColors:@[[UIColor redColor],[UIColor blueColor]] gradientType:1 imgSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 100)];
     UIImageView *iv = [[UIImageView alloc]initWithImage:im];
     [RadianLayerView addSubview:iv];
     RadianLayerView.direction = 0;
     RadianLayerView.radian = 10;
     //    RadianLayerView.transform = CGAffineTransformMakeRotation(M_PI);
     //    RadianLayerView.alpha = 0.8;
     [self.view addSubview:RadianLayerView];

    
    NSString *url = [NSString stringWithFormat:@"%@:(%@)",@"https://www.jianshu.com/p/8b0d06bd5a01",NSStringFromClass([self class])];
    NSMutableString * urlStr = [[NSMutableString alloc] initWithString:url];
    NSRange firstRange = [urlStr rangeOfString:@"://"];
    NSRange secondRange = [urlStr rangeOfString:@":("];
    NSRange thirdRange = [urlStr rangeOfString:@")"];
    NSString * businessName = [urlStr substringWithRange:NSMakeRange(firstRange.location + firstRange.length, secondRange.location - firstRange.location - firstRange.length)];
    NSString * commandStr = [urlStr substringWithRange:NSMakeRange(secondRange.location + secondRange.length, thirdRange.location - secondRange.location - secondRange.length)];
    NSMutableDictionary * dicdict = [[NSMutableDictionary alloc] init];
    [dicdict setObject:businessName forKey:@"businessName"];
    [dicdict setObject:commandStr forKey:@"commandStr"];
    
    UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [pushButton setFrame:CGRectMake(8.0 ,100.0 ,120.0 ,20.0)];
    [pushButton setTitle:@"Block知识" forState:(UIControlStateNormal)];
//    pushButton.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.00];       //背景颜
    [pushButton addTarget:self action:@selector(pushBlockMetnod:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:pushButton];
    
    UIButton *pushNillButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushNillButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [pushNillButton setFrame:CGRectMake(8.0 ,150.0 ,120.0 ,20.0)];
    pushNillButton.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.00];
    [pushNillButton setTitle:@"Runtime" forState:(UIControlStateNormal)];
    [pushNillButton addTarget:self action:@selector(pushBlockNilMetnod) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:pushNillButton];
       
    //适配iOS13 修改placeholderLabeltextColor
    UITextField *tf = [[UITextField alloc]init];
    tf.frame = CGRectMake(10, 170, 200, 30);
    tf.textColor = [UIColor blueColor];
    tf.text = @"修改placehold";
    if (@available(iOS 13.0, *)) {
        tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor grayColor]}];
    }
    else {
        [tf setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    }
//    [tf valueForKey:@"placeholderLabel"];
//    tf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入"attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
    [self.view addSubview:tf];

    UITextView *policyTextView = [[UITextView alloc] initWithFrame:CGRectMake(8, 200, [UIScreen mainScreen].bounds.size.width-16, 100)];
    policyTextView.editable = NO;
    policyTextView.scrollEnabled = NO;
    policyTextView.delegate = self;
    policyTextView.textContainerInset = UIEdgeInsetsMake(5, 0,0,0);
    [self.view addSubview:policyTextView];
    NSString *aLink = @"Block知识";
    NSString *bLink = @"Runtime";
    NSString *link = [NSString stringWithFormat:@"请选择基础知识%@或%@",aLink,bLink];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:link];
    //设置链接文本
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"http://www.baidu.com"
                             range:[[attributedString string] rangeOfString:aLink]];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"http://www.163.com"
                             range:[[attributedString string] rangeOfString:bLink]];
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:20]
                             range:[[attributedString string] rangeOfString:link]];
    //设置链接样式
    policyTextView.linkTextAttributes = @{
                                    NSForegroundColorAttributeName: [UIColor redColor],
                                    NSUnderlineColorAttributeName: [UIColor clearColor],
                                    NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
                                    };
    policyTextView.attributedText = attributedString;
//    [url systemLayoutSizeFittingSize:UILayoutFittingExpandedSize]
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(nonnull NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction API_AVAILABLE(ios(10.0)){
    if (characterRange.location == 7 && characterRange.length == 7) {
        [self blockMethod];
       }else if (characterRange.location == 15 && characterRange.length == 7){
        [self runtimeBlockMethod];
       }
    return NO;
}
- (void)blockMethod {
    LabelMethodBlockSubVC *subVC = [[LabelMethodBlockSubVC alloc]init];
    [subVC returnText:^(NSString *showText) {
        NSLog(@"--传值--%@",showText);
        
    }];
    [self.navigationController pushViewController:subVC animated:NO];
}

/*
- (UIPanGestureRecognizer *)tz_popGestureRecognizer {
	UIPanGestureRecognizer *pan = objc_getAssociatedObject(self, _cmd);
	if (!pan) {
		// 侧滑返回手势 手势触发的时候，让target执行action
		id target = self.navigationController.delegate;
		SEL action = NSSelectorFromString(@"handleNavigationTransition:");
		pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
		pan.maximumNumberOfTouches = 1;
		pan.delegate = self;
		self.navigationController.interactivePopGestureRecognizer.enabled = NO;
		objc_setAssociatedObject(self, _cmd, pan, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return pan;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
	if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
		return NO;
	}
	if (self.childViewControllers.count <= 1) {
		return NO;
	}
	// 侧滑手势触发位置
	CGPoint location = [gestureRecognizer locationInView:self.view];
	CGPoint offSet = [gestureRecognizer translationInView:gestureRecognizer.view];
	BOOL ret = (0 < offSet.x && location.x <= 40);
	NSLog(@"%@ %@",NSStringFromCGPoint(location),NSStringFromCGPoint(offSet));
	return ret;
}

/// 只有当系统侧滑手势失败了，才去触发ScrollView的滑动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}
- (void)tz_addPopGestureToView:(UIView *)view{
	[self tz_addPopGestureToView:self.view];
}
 */
- (void)pushBlockMetnod:(UIButton *)sender{
    [self blockMethod];
}

- (void)runtimeBlockMethod {
    Class cls =  NSClassFromString(@"LabelNilMethodBlockViewController");
    UIViewController *viewController = [[cls alloc] init];
    //没有参数 类方法  返回值为BOOL
    SEL selector1 = NSSelectorFromString(@"isWXAppInstalled");
    IMP imp1 = [cls methodForSelector:selector1];
    BOOL (*func1)(Class, SEL) = (BOOL (*)(Class,SEL))imp1;
    BOOL flag =  func1(cls,selector1);
    NSLog(@"--返回值：%d--",flag);
    
    // 调用实例化函数 有返回值
    typedef void(^voidmethod)(NSString *dic);
    SEL selector5 = NSSelectorFromString(@"textValueFunction:");
    IMP imp = [viewController methodForSelector:selector5];
    void (*func)(Class, SEL,voidmethod) = (void*)imp;
    if (viewController && [viewController respondsToSelector:selector5]) {
        func(cls,selector5,^(NSString *string){
            NSLog(@"%@",string);
        });
    }
    NSString* str =  ((NSString* (*)(id,SEL,NSString*))objc_msgSend)(viewController, NSSelectorFromString(@"textFunction:"),@"字符串参数");
    NSLog(@"----%@",str);
    //    void(^block)(void) = ^{
    //        NSLog(@"----");
    //    };
    //    weakSelf.block = block;
    //调用类函数 一个参数
    void(^infoBlock)(NSString *dic) = ^(NSString * infor){
        NSLog(@"%@",infor);
        infor = @"工程师";
        NSLog(@"%@",infor);
    };
    ((void(*)(id,SEL,id))objc_msgSend)([viewController class], NSSelectorFromString(@"numberInfor:"), infoBlock);
    
    //调用block属性
    void(^block)(NSString * infor) = self.occupation;
    
    ((void(*)(id,SEL,id))objc_msgSend)(viewController, NSSelectorFromString(@"setReception:"),block);
    
    ((void(*)(id,SEL,id))objc_msgSend)(viewController, NSSelectorFromString(@"setMyReturnTextBlock:"),block);
    NSLog(@"occupation %@",self.occupation);

    BOOL isWhiteSkinColor = ((BOOL(*)(id, SEL))objc_msgSend)(cls, @selector(isWhiteSkinColor));
    //等同于下面
    SEL selector = NSSelectorFromString(@"isWhiteSkinColor"); //类方法
    ((void (*)(id, SEL))[cls methodForSelector:selector])(cls, selector);
    //    if (!_controller) { return; }
    //    SEL selector = NSSelectorFromString(@"someMethod");
    //    IMP imp = [_controller methodForSelector:selector];
    //    void (*func)(id, SEL) = (void *)imp;
    //    func(_controller, selector);
    //等同于
    ((void (*)(id, SEL))[cls methodForSelector:selector])(viewController, selector);
    NSLog(@"isWhiteSkinColor %d",isWhiteSkinColor);
    
    id(*ins)(id, SEL) = (id(*)(id, SEL))objc_msgSend;
    id gm = ins([viewController class], NSSelectorFromString(@"isWhiteSkinColor"));
    //set方法
    ((id (*)(id, SEL, id))objc_msgSend)(gm, NSSelectorFromString(@"setNameP"),@"属性赋值");
    //get方法
    ((NSString* (*)(id, SEL,id ))objc_msgSend)(viewController,NSSelectorFromString(@"nameP:"),@"asdf");
    
    //调用类方法带block多参数的函数
    CustomEvent finishCall = ^(NSString* str){
        NSLog(@"block 新增方法回调值 %@",str);
    };
    ((void(*)(id,SEL,NSString *,CustomEvent)) objc_msgSend)(NSClassFromString(@"LabelNilMethodBlockViewController"),NSSelectorFromString(@"loadDetailCallBack:callBack:"),@"名字",finishCall);
    
    NSArray *a = @[@"https://rgslb.rtc.aliyuncs.com"];
    NSDictionary *dictInfo = @{
        @"userid":@"00009c29-df77-4402-87e1-8641cc0ce4ef",
        @"callid":@"0b5d5478-c1e3-43b1-b82f-26bbec451a05",
        @"appid":@"zz2skc04",
        @"sysappid":@"df336665-c22b-4270-b9ff-3f602f758e80",
        @"channelid":@"d4a6b288-1230-4b4a-a62b-c368eb16440c",
        @"nonce":@"CK-7b6ae612898396e8c25b3ecf0d1b424d",
        @"timestamp":@"1561691423",
        @"token":@"259c262ca1b8e967c91e2f07658074b79d416ddf89ad0cbf8ca408762ce14474",
        @"calltype":@"0",
        @"gslb":a,
        @"turn":@{@"username":@"测试5",@"adminid":@"00009c29-df77-4402-87e1-8641cc0ce4ef",@"adminame":@"张三",@"adminphoto":@"1",@"photo":@"1",@"password":@"444"},
        @"Total":@0,
        @"Ret":[NSNumber numberWithBool:true],
        @"Msg":@"获取成功",
        @"Obj":@"200"
    };
    
    ((void(*)(id,SEL,NSDictionary*))objc_msgSend)(viewController, NSSelectorFromString(@"setCommunicationMessage:"),dictInfo);
    /**
     [NSArray copy] 浅拷贝 还是那个对象
     [NSArray mutableCopy] 深拷贝 得到NSMutableArray
     [NSMutableArray copy] 深拷贝 得到 NSArray
     [NSMutableArray mutableCopy] 深拷贝 得到 NSMutableArray
     */
    
    [self.navigationController pushViewController:viewController animated:NO];
}

- (void)pushBlockNilMetnod{
//    __weak typeof(self) weakSelf = self;
//    id library = [[NSClassFromString(@"LabelNilMethodBlockViewController") alloc] init];
    [self runtimeBlockMethod];

}
- (void(^)(NSString *str))occupation {
    return ^(NSString *str){//在此获取值
        NSLog(@"职业：%@",str);//在此重新赋值
    };
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
