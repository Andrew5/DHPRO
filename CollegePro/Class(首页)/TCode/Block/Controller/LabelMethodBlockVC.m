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
	self.navigationItem.title = @"BlockRuntime知识";
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
    
//    NSString *urlurlurl = @"https://image.baidu.com/search/detail?ct=503316480&z=undefined&tn=baiduimagedetail&ipn=d&word=获取网络图片大小%20iOS&step_word=&ie=utf-8&in=&cl=2&lm=-1&st=undefined&hd=undefined&latest=undefined&copyright=undefined&cs=1956473801,2226886643&os=704432641,1656685615&simid=4200340769,741828620&pn=4&rn=1&di=91630&ln=1531&fr=&fmq=1579249421664_R&fm=&ic=undefined&s=undefined&se=&sme=&tab=0&width=undefined&height=undefined&face=undefined&is=0,0&istype=0&ist=&jit=&bdtype=0&spn=0&pi=0&gsm=0&objurl=http%3A%2F%2Faliyunzixunbucket.oss-cn-beijing.aliyuncs.com%2Fjpg%2F6f958960bb497cb10ebe3e71c5642e41.jpg%3Fx-oss-process%3Dimage%2Fresize%2Cp_100%2Fauto-orient%2C1%2Fquality%2Cq_90%2Fformat%2Cjpg%2Fwatermark%2Cimage_eXVuY2VzaGk%3D%2Ct_100&rpstart=0&rpnum=0&adpicid=0&force=undefined&ctd=1579249427449^3_1680X893%1";
//    UIImageView *v1 = [[UIImageView alloc]init];
//    [self.view addSubview:v1];
//    [v1 sd_setImageWithURL:[NSURL URLWithString:urlurlurl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        CGSize size = image.size;
//    CGFloat w = size.width;
//    CGFloat H = size.height;
//    NSLog(@"%f",v1.intrinsicContentSize.width);
//        printf("------");
//    }];
//    YYCache *cache = [YYCache cacheWithName:@"ResponseCache"];
//    if ([cache containsObjectForKey:url] && networkErrow) {    // 如果有缓存且网络有问题
//      id response = [cache objectForKey:url];
//      success(response);
//    return;
//    }
//    [[MNNetworkTool shareService] GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (mnnetSet.saveCache) {  // 如果需要缓存，进行缓存
//            [cache setObject:dic forKey:url];
//        }
//        success(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failed()；
//    }];
             
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
    
    
     /**
         1.type定义参考:https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
         2."v@:@",解释v-返回值void类型,@-self指针id类型,:-SEL指针SEL类型,@-函数第一个参数为id类型
         3."@@:",解释@-返回值id类型,@-self指针id类型,:-SEL指针SEL类型,
         d.注册到运行时环境
             objc_registerClassPair(kclass);
         e.实例化类
             id instance = [[kclass alloc] init];
         f.给变量赋值
            object_setInstanceVariable(instance, "expression", "1+1");
         g.获取变量值
             void * value = NULL;
             object_getInstanceVariable(instance, "expression", &value);
         h.调用函数
             [instance performSelector:@selector(getExpressionFormula)];
         */
        const char * className = "KYDog";
        Class kclass = objc_getClass(className);
        BOOL isSuccess = class_addIvar(kclass, "addVar", sizeof(NSString *), 0, "@");
        
        SEL selA = @selector(setExpressionFormula:);
        Method methodA = class_getInstanceMethod(kclass, selA);
        BOOL isSuccessMethod1 = class_addMethod(kclass, selA, method_getImplementation(methodA), method_getTypeEncoding(methodA));
        //等同于下面这行代码
    //    BOOL isSuccessMethod1 = class_addMethod(kclass, selA, (IMP)setExpressionFormula, "v@:@");
        SEL selB = @selector(getExpressionFormula);
        Method methodB = class_getInstanceMethod(kclass, @selector(getExpressionFormula));
        BOOL isSuccessMethod2 = class_addMethod(kclass, selB, class_getMethodImplementation(kclass, @selector(getExpressionFormula)), method_getTypeEncoding(methodB));
        
        isSuccessMethod1?NSLog(@"添加方法1成功"):NSLog(@"添加方法1失败");
        isSuccessMethod2?NSLog(@"添加方法2成功"):NSLog(@"添加方法2失败");
        isSuccess?NSLog(@"添加变量成功"):NSLog(@"添加变量失败");
    //    [person setValue:@"增加成了" forKey:@"addVar"];
    //    NSLog(@"addVar == %@",[person valueForKey:@"addVar"]);
    //    objc_allocateClassPair(kclass, className, 0);
    //    id per = [KYDog alloc];
    //    [per setValue:@"Lucy" forKey:@"namename"];
    //    NSLog(@"name == %@",[per valueForKey:@"namename"]);
        objc_registerClassPair(kclass);
    //    [person loadNameValue:@"name"];
    //    [person performSelector:@selector(loadNameValue:) withObject:@"minzhe"];
//        SEL selector = NSSelectorFromString(@"loadNameValue:");
//        IMP imp = [person methodForSelector:selector];
//        void (*func)(id, SEL,NSString *) = (void *)imp;
//        func(person, selector,@"namamam");
    ///TODO:动态调用方法(模仿组件、动态路由配置等)
    //    [[ViewController alloc]abc];
        NSString *className = NSStringFromClass([self class]);
        NSString *mth = @"setExpressionFormula:";///实例方法
        SEL methFunc = NSSelectorFromString(mth);
        Class _Nullable class = NSClassFromString(className);
    //    objc_msgSend([class alloc], methFunc);///无参调用
    /* 之所以会崩溃
    - (int) doSomething:(int) x { ... }
    - (void) doSomethingElse {
        int (*action)(id, SEL, int) = (int (*)(id, SEL, int)) objc_msgSend;
        action(self, @selector(doSomething:), 0);
    }
    所以必须先定义原型才可以使用，这样才不会发生崩溃，调用的时候则如下：
     void (*glt_msgsend)(id, SEL, NSString *, NSString *) = (void (*)(id, SEL, NSString *, NSString *))objc_msgSend;
    glt_msgsend(cls, @selector(eat:say:), @"123", @"456");
        */
        ((void(*)(id,SEL,id))objc_msgSend)([class alloc], methFunc,@"我是参数");///多参调用
        NSLog(@"侧喝牛奶");
    /*
     [self test:arg1 arg2:arg2];
     objc_msgSend(self, @selector(test), arg1, arg2);
     或者(因为selector找不到对应的方法，所以要用下面这种)：

     SEL testFunc = NSSelectorFromString(@"test:arg2:");

     objc_msgSend(self, testFunc, arg1, arg2);
     最近在ios8时，发现如下报错：

     Too many arguments to function call, expected 0, have 3
     解决方法：

     ((void(*)(id,SEL, id,id))objc_msgSend)(self, testFunc, arg1, arg2);
     */
    
        Class XYClass = objc_allocateClassPair([NSObject class], "XYClass", 0);
        NSString*namename =@"namename";
        class_addIvar(XYClass, namename.UTF8String,sizeof(id),log2(sizeof(id)),@encode(id));
        objc_registerClassPair(XYClass);
        id p = [XYClass alloc];
        [p setValue:@"Lucy" forKey:@"namename"];
        NSLog(@"name == %@",[p valueForKey:@"namename"]);

        //对私有变量的更改
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList(kclass, &count);
        Ivar namevar = ivars[1];
        object_setIvar(XYClass, namevar, @"456");
        NSString *privateName = object_getIvar(XYClass, namevar);
        NSLog(@"privateName : %@",privateName);
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(namevar)];
        ivarName = [ivarName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        ivarName = [ivarName stringByReplacingOccurrencesOfString:@"@" withString:@""];
        if ([ivarName containsString:@"privateName"]) {
            object_setIvar(XYClass, namevar, @"我的名字");
            NSString *privateName = object_getIvar(XYClass, namevar);
            NSLog(@"privateName %@",privateName);
        }
    
    [self.navigationController pushViewController:viewController animated:NO];
}
//static void setExpressionFormula(id self, SEL cmd, id value)
//{
//    // 获取类中指定名称实例成员变量的信息
//    Ivar ivar = class_getInstanceVariable([self class], "test");
//    // 获取整个成员变量列表
//    //   Ivar * class_copyIvarList ( Class cls, unsigned intint * outCount );
//    // 获取类中指定名称实例成员变量的信息
//    //   Ivar class_getInstanceVariable ( Class cls, const charchar *name );
//    // 获取类成员变量的信息
//    //   Ivar class_getClassVariable ( Class cls, const charchar *name );
//    
//    // 返回名为test的ivar变量的值
//    id obj = object_getIvar(self, ivar);
//    NSLog(@"%@",obj);
//    NSLog(@"addMethodForMyClass:参数：%@",value);
//    NSLog(@"ClassName：%@",NSStringFromClass([self class]));
//    NSLog(@"call setExpressionFormula");
//}
- (void)getExpressionFormula
{
    NSLog(@"call getExpressionFormula");
}
- (void)setExpressionFormula:(NSString *)string {
    NSLog(@"string %@--ClassName:%@",string,NSStringFromClass([self class]));
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
