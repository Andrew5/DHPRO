//
//  LabelMethodBlockSubVC.m
//  Test
//
//  Created by Rillakkuma on 2016/11/29.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "LabelMethodBlockSubVC.h"
#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
#import <malloc/malloc.h>
#import <objc/message.h>
#import <CommonCrypto/CommonCrypto.h>

#import "NSObject+Swizzling.h"//kvo监听不到数组的变化，因为kvo监听的是set方法
#import "CancelableObject.h"
#import "WeakProxy.h"

#import "KYDog.h"
#import "Persion.h"
#import "TempTarget.h"
#import "SFTextView.h"

#pragma pack(2)//1 代表不进行内存对齐
struct StructOne {
    char a;         //1字节
    double b;       //8字节
    int c;          //4字节
    short d;        //2字节
} MyStruct1;

struct StructTwo {
    double b;       //8字节
    char a;         //1字节
    short d;        //2字节
    int c;         //4字节
} MyStruct2;

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

//定义获取全局队列方法
#define KYS_GLOBAL_QUEUE(block) \
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ \
    while (1) { \
        block();\
    }\
})

@interface LabelMethodBlockSubVC ()
{
    //成员变量
    /*
    变量声明出来存放在栈上面
    而block，默认存放在NSGlobalBlock 全局的block；我们常常把block和C中的函数做对比，此时也类似，NSGlobalBlock类似于函数，存放在代码段
    
    当block内部使用了外部的变量时，block的存放位置变成了NSMallockBlock（堆）
    
    __block 修饰以后，会类似于桥接，将被修饰的变量被block所持有，此时该变量也转存到堆空间，所以此时Block内部就可以对外部的变量进行修改
    
    （还有NSStatckBlock位于栈内存）
     */
    int numC;
    __block BOOL chooseState;
    NSString *_someString;
    BOOL gcdIsStope;
    UILabel *labelName;//显示名称
    int count1;///计时器
}
// 属性声明的block都是全局的__NSGlobalBlock__
@property (nonatomic, copy) void (^copyBlock)(void);
//@property (nonatomic, weak) void (^weakBlock)(void);

//测试字符串⬇️⬇️⬇️
@property(nonatomic,copy)    NSString*str1;
@property(nonatomic,strong)  NSString*str2;
@property(nonatomic,strong)  NSString*rtcMessageID;
//测试字符串⬆️⬆️⬆️

@property(nonatomic, strong)SFTextView *textF;

@property (nonatomic, strong)KYUser *user;

@property(nonatomic,strong)Persion* p;

//解除timer循环引用
//@property (nonatomic, weak) NSTimer *timer;
//GCD解除timer循环引用
@property (nonatomic, strong) dispatch_source_t timer;
// 使用 id 类型可以避免编译器警告
@property (nonatomic,strong) id observerManager;
@end

@implementation LabelMethodBlockSubVC

/*
 1. + (id)alloc 分配内存；
 
 2. - (id)init 方法（包括其他-(id)init...方法），只允许调用一次，并且要与 alloc方法 写在一起，在init方法中申请的内存，要在dealloc方法中释放（或者其他地方）；
 
 3. - (void)awakeFromNib 使用Xib初始化后会调用此方法，一般不会重写此方法；
 
 4. - (void)loadView 如果使用Xib创建ViewController，就不要重写该方法。一般不会修改此方法；
 
 5. - (void)viewDidLoad 视图加载完成之后被调用，这个方法很重要，可以在此增加一些自己定义的控件，注意此时view的frame不一定是显示时候的frame，真实的frame会在 - (void)viewDidAppear: 后。
 在iOS6.0+版本中在对象的整个生命周期中只会被调用一次，
 这里要注意在iOS3.0~iOS5.X版本中可能会被重复调用，当ViewController收到内存警告后，会释放View，并调用viewDidUnload，之后会重新调用viewDidLoad，所以要支持iOS6.0以前版本的童鞋要注意这里的内存管理。
 6. - (void)viewWillAppear:(BOOL)animated view 将要显示的时候，可以在此加载一些图片，和一些其他占内存的资源；
 7. - (void)viewDidAppear:(BOOL)animated view 已经显示的时候；
 8. - (void)viewWillDisappear:(BOOL)animated view 将要隐藏的时候，可以在此将一些占用内存比较大的资源先释放掉，在 viewWillAppear: 中重新加载。如：图片/声音/视频。如果View已经隐藏而又在内存中保留这些在显示前不会被调用的资源，那么App闪退的几率会增加，尤其是ViewController比较多的时候；
 
 9. - (void)viewDidAppear:(BOOL)animated view 已经隐藏的时候；
 
 10. - (void)dealloc，不要手动调用此方法，当引用计数值为0的时候，系统会自动调用此方法。
 二、使用 NavigationController 去 Push 切换显示的View的时候，调用的顺序：
 
 例如 从 A 控制器 Push 显示 B 控制器，
 
 [(A *)self.navigationController pushViewController:B animated:YES]
 
 1. 加载B控制器的View（如果没有的话）；
 
 2. 调用 A 的 - (void)viewWillDisappear:(BOOL)animated；
 
 3. 调用 B 的 - (void)viewWillAppear:(BOOL)animated；
 
 4. 调用 A 的 - (void)viewDidDisappear:(BOOL)animated；
 
 5. 调用 B 的 - (void)viewDidAppear:(BOOL)animated；
 
 总结来说，ViewController 的切换是先调用 隐藏的方法，再调用显示的方法；先调用Will，再调用Did。
 //加载A界面
 1、调用 A 的 viewDidLoad
 2、调用 A 的 viewWillAppear
 3、调用 A 的 viewDidAppear
 A -> B
 4、调用 B 的 viewDidLoad
 5、调用 A 的 viewWillDisappear
 6、调用 B 的 viewWillAppear
 7、调用 B 的 viewDidAppear
 8、调用 A 的 viewDidDisappear
 B -> A
 9、 调用 A 的 viewWillAppear
 10、调用 A 的 viewDidAppear
 11、调用 B 的 dealloc
 
 三、重新布局View的子View
 
 - (void)viewWillLayoutSubviews
 
 - (void)viewDidLayoutSubviews
 */
//自定义View的init方法会默认调用initWithFrame方法
//1、动态查找到CustomView的init方法
//2、调用[super init]方法
//3、super init方法内部执行的的是[super initWithFrame:CGRectZero]
//4、若super发现CustomView实现了initWithFrame方法
//5、转而执行self(CustomView)的initWithFrame方法
//6、最后在执行init的其余部分
//OC中的super实际上是让某个类去调用父类的方法，而不是父类去调用某个方法，方法动态调用过程顺序是由下而上的（这也是为什么在init方法中进行createUI不会执行多次的原因，因为父类的initWithFrame没做createUI操作）。
//createUI方法最好在initWithFrame中调用，外部使用init或initWithFrame均可以正常执行createUI方法.
//addSubview的文档描述
//This method establishes a strong reference to view and sets its next responder to the receiver, which is its new superview.
//Views can have only one superview. If view already has a superview and that view is not the receiver, this method removes the previous superview before making the receiver its new superview.
//View有且仅有一个父视图，如果新的父视图与原父视图不一样，会将View在原视图中移除，添加到新视图上。

- (void)loadViewIfNeeded{//1
    [super loadViewIfNeeded];
}
- (void)loadView{//2
    [super loadView];
}
//将要显示的时候
-(void)viewWillAppear:(BOOL)animated{//4
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
}
-(void)viewLayoutMarginsDidChange{//directionalLayoutMargins
    [super viewLayoutMarginsDidChange];//5
    //    if ([UIView userInterfaceLayoutDirectionForSemanticContentAttribute:self.view.semanticContentAttribute] == UIUserInterfaceLayoutDirectionRightToLeft)
    //    {
    //        // Right to left 语言下每行尾部在左边
    //        self.view.layoutMargins.left == 30.0;
    //    }
    //    else
    //    {
    //        self.view.layoutMargins.right == 30.0;
    //    }
    self.view.directionalLayoutMargins = NSDirectionalEdgeInsetsMake(0, 0, 0, 30);
}
-(void)viewWillLayoutSubviews{////将要布局子视图
    [super viewWillLayoutSubviews];//6
}
-(void)viewDidLayoutSubviews{//已经布局子视图
    [super viewDidLayoutSubviews];//7
//    [btn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self.view);
//        // 初始宽、高为100，优先级最低
//        make.width.height.mas_equalTo(100 * self.scacle).priorityLow();
//        // 最大放大到整个view
//        make.width.height.lessThanOrEqualTo(self.view);
//    }];
}
//已经显示的时候  真实的frame会在这之后调用
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];//8

    //    [UIView animateWithDuration:100.0 animations:^{
    //        ThreeViewController *three = [[ThreeViewController alloc]init];
    //        three.modalPresentationStyle = UIModalPresentationFormSheet;
    //        three.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    //        [self presentViewController:three animated:YES completion:^{
    //
    //        }];
    //    }];
    if (@available(iOS 11.0, *)) {
        NSString *edgeStr = NSStringFromUIEdgeInsets(self.view.safeAreaInsets);
        NSString *layoutFrmStr = NSStringFromCGRect(self.view.safeAreaLayoutGuide.layoutFrame);
        NSLog(@"viewDidAppear safeAreaInsets = %@, layoutFrame = %@", edgeStr, layoutFrmStr);
    } else {
        // Fallback on earlier versions
    }
    
}

- (void)safeAreaInsetsDidChange
{
    //写入变更安全区域后的代码...
    NSLog(@"safeAreaInsetsDidChange ");
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
    //本地日志打印
    [DHTool writeLocalCacheDataToCachesFolderWithKey:[NSString stringWithFormat:@"Block_%@.log",[DHTool getCurrectTimeWithPar:@"yyyy-MM-dd-HH-mm-ss-SSS"]] fileName:@"Block"];
//    self.timer.fireDate = [NSDate distantFuture];
//    [self.timer invalidate];
//    self.timer = nil;
   
    if (self.returnTextBlock != nil) {
        self.returnTextBlock(@"backBlockNilMetnod");
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

- (void)viewDidLoad {//3//将要加载视图
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"多线程处理知识";

    if (@available(iOS 11.0, *)) {
        NSString *edgeStr = NSStringFromUIEdgeInsets(self.view.safeAreaInsets);
        NSString *layoutFrmStr = NSStringFromCGRect(self.view.safeAreaLayoutGuide.layoutFrame);
        NSLog(@"viewDidLoad safeAreaInsets = %@, layoutFrame = %@", edgeStr, layoutFrmStr);
    } else {
        // Fallback on earlier versions
    }
    
	UIButton *pushNillButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[pushNillButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	[pushNillButton setFrame:CGRectMake(10.0 ,80.0 ,120.0 ,20.0)];
	pushNillButton.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.00]; //背景颜
	[pushNillButton setTitle:@"回去" forState:(UIControlStateNormal)];
	[pushNillButton addTarget:self action:@selector(backBlockNilMetnod) forControlEvents:(UIControlEventTouchUpInside)];
//    [self.view addSubview:pushNillButton];
    labelName = [[UILabel alloc]init];
    labelName.textAlignment = NSTextAlignmentCenter;
    labelName.textColor = [UIColor blackColor];
    labelName.font = DH_FontSize(14);
    labelName.frame = CGRectMake(0, 0, 15*10, 30);
    labelName.center = CGPointMake(self.view.centerX, 100);
    [self.view addSubview:labelName];
    count1 = 0;

    //函数式编程、链式编程优缺点
    //Block的底层实现原理
    [self baseBlock];
    
    void (^ MtTestBlock)(int,int)=^(int a,int b){
        int v= a+b;
        NSLog(@"本地传值内容:%d",v);
    };
    MtTestBlock(10,20);
    
    // 创建消息观察者集合
//    NSSet  *observers = [NSSet setWithObjects:[KYDog new],[KYDog new], nil];
//    // 创建 RNObserverManager 蹦床
//    NSString *className = @"DHObserverManager";
//    self.observerManager = [[NSClassFromString(className) alloc]
//                            initWithProtocol:@protocol(MyProtocol) observers:observers];
//    // 给 RNObserverManager 发送 doSomething 消息，实际上都会被转发到 MyClass 的 doSomething 方法
//    [self.observerManager doSomething];

}

///TODO:NSTimer
- (void)getquoteof{
    //@property NSTimeInterval tolerance;这是7.0之后新增的一个属性，因为NSTimer并不完全精准，通过这个值设置误差范围。
    /**
     NSTimer会准时触发事件吗
     
     答案是否定的，而且有时候你会发现实际的触发时间跟你想象的差距还比较大。NSTimer不是一个实时系统，因此不管是一次性的还是周期性的timer的实际触发事件的时间可能都会跟我们预想的会有出入。差距的大小跟当前我们程序的执行情况有关系，比如可能程序是多线程的，而你的timer只是添加在某一个线程的runloop的某一种指定的runloopmode中，由于多线程通常都是分时执行的，而且每次执行的mode也可能随着实际情况发生变化。
     假设你添加了一个timer指定2秒后触发某一个事件，但是签好那个时候当前线程在执行一个连续运算(例如大数据块的处理等)，这个时候timer就会延迟到该连续运算执行完以后才会执行。重复性的timer遇到这种情况，如果延迟超过了一个周期，则会和后面的触发进行合并，即在一个周期内只会触发一次。但是不管该timer的触发时间延迟的有多离谱，他后面的timer的触发时间总是倍数于第一次添加timer的间隙。
     */
    /**
     + (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;
     
     Interval:设置时间间隔,以秒为单位,一个>0的浮点类型的值，如果该值<0,系统会默认为0.1
     
     target:表示发送的对象，如self
     
     selector:方法选择器，在时间间隔内，选择调用一个实例方法
     
     userInfo:此参数可以为nil，当定时器失效时，由你指定的对象保留和释放该定时器。
     
     repeats:当YES时，定时器会不断循环直至失效或被释放，当NO时，定时器会循环发送一次就失效。
     */
    
    //    timer1 = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerRequest) userInfo:nil repeats:YES];
    //    [[NSRunLoop currentRunLoop] addTimer:timer1 forMode:NSRunLoopCommonModes];
    /**
     使用block的方法就直接在block里面写延时后要执行的代码
     + (NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block
     */
    //    timer2 = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //        NSLog(@"定时器开始。。。");
    //        count2 ++;
    //        labelName.text = [NSString stringWithFormat:@"计时器当前计数:%d",count2];
    //    }];
    //    [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:NSRunLoopCommonModes];
    
    /**
     invocation:需要执行的方法
     + (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo;
     */
    //    NSMethodSignature *sgn = [self methodSignatureForSelector:@selector(timerRequest)];
    //    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature: sgn];
    //    [invocation setTarget: self];
    //    [invocation setSelector:@selector(timerRequest)];
    //    timer3 = [NSTimer timerWithTimeInterval:1.0 invocation:invocation repeats:YES];
    //    [[NSRunLoop currentRunLoop] addTimer:timer3 forMode:NSRunLoopCommonModes];
    
    /**
     scheduledTimerWithTimeInterval 自动加入到RunLoop自动执行
     + (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;
     */
    //    timer4 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRequest) userInfo:nil repeats:YES];
    
    /**
     自动加入到RunLoop自动执行
     + (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;
     */
    //    timer5 = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //        NSLog(@"定时器开始。。。");
    //        count5 ++;
    //        labelName.text = [NSString stringWithFormat:@"计时器当前计数:%d",count5];
    //    }];
    /**
     自动加入到RunLoop自动执行
     + (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo;
     */
    //    NSMethodSignature *sgn = [self methodSignatureForSelector:@selector(timerRequest)];
    //    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature: sgn];
    //    [invocation setTarget: self];
    //    [invocation setSelector:@selector(timerRequest)];
    //    timer6 = [NSTimer scheduledTimerWithTimeInterval:1.0 invocation:invocation repeats:YES];
    
    /**
     启动定时器
     [NSDate distantPast];
     停止定时器
     [NSDate distantFuture];
     //暂时停止定时器
     //[timer setFireDate:[NSDate distantFuture]];
     //重新开启定时器
     //[timer setFireDate:[NSDate distantPast]];
     //永久通知定时器
     //[timer invalidate];
     //timer = nil;
     - (instancetype)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)ti target:(id)t selector:(SEL)s userInfo:(nullable id)ui repeats:(BOOL)rep;
     */
    //    timer7 = [[NSTimer alloc]initWithFireDate:[NSDate distantPast] interval:1.0 target:self selector:@selector(timerRequest) userInfo:nil repeats:YES];
    //    [[NSRunLoop mainRunLoop]addTimer:timer7 forMode:NSDefaultRunLoopMode];
    
    
    /**
     - (instancetype)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;
     */
    //    timer8 = [[NSTimer alloc]initWithFireDate:[NSDate distantPast] interval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //        NSLog(@"定时器开始。。。");
    //        count8 ++;
    //        labelName.text = [NSString stringWithFormat:@"计时器当前计数:%d",count8];
    //    }];
    //    [[NSRunLoop mainRunLoop]addTimer:timer8 forMode:NSDefaultRunLoopMode];
    //测试
    //    NSTimer *timeTest = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRequest) userInfo:nil repeats:YES];
    //    [self performSelector:@selector(simulateBusy:) withObject:@"ojbcet" afterDelay:3];
    
    //    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:[WeakProxy proxyWithTarget:self] selector:@selector(timerStart:) userInfo:nil repeats:YES];
    //    self.timer = [TempTarget scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
    //GCD解除
    __weak typeof(self) ws = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), 0.1*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"timer执行了");
            //结束计时
            dispatch_source_cancel(ws.timer);
        });
    });
    //开启计时器
    dispatch_resume(_timer);
    
    //分类实现timer循环引用
    //    self.timer = [NSTimer mxScheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer *timer) {
    //        NSLog(@"执行了");
    //    }];
}
- (void)timerStart:(NSTimer *)ti{
    
}
//GCD取消
//static BOOL gcdIsStope;
- (void)baseBlock{
    numC = 100;
    //    [self testDataA];
    //    [self testDataB];
    //    [self testDataC];
    //    [self testDataD];
    //    [self testDataE];
    //    [self testDataF];
    //    [self testDataG];//深、浅拷贝
    //    [self testDataH];//交换
    //    [self testDataL];//排序方式
    //    [self testDataM];//排序
    //    [self testDataK];
    [self testDataN];//KVO进阶
    //    [self testDataO];
    //    [self testDataT];//访问私有变量
    //    [self testDataQ];
    //    [self testDataR];
    //    [self testDataSS];//顺序执行网络请求
    //    [self getquoteof];//NSTimer循环引用解决方案
    
    //GCD停止正在执行的任务
    gcdIsStope = NO;
    //    _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    [self asyncGlobalQueue];//异步
    //    [self asyncSerialQueue];//同步
    
    //异步执行线程
    dispatch_queue_t serialQueue = dispatch_queue_create("com.tian.lawrence",DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"1 - %@",[NSThread currentThread]);
    dispatch_async(serialQueue,^{
        NSLog(@"2 - %@",[NSThread currentThread]);
        [self asyncSemaphore];
        [self asyncBarrier];
        [self pthreadLock];//线程锁‘
        [self asyncGroup];
    });
}
- (void)getIMPFromSelector:(SEL)aSelector {
    NSLog(@"第一种 IMP class_getMethodImplementation(Class cls, SEL name)")
    NSLog(@"实例方法")
    IMP insttanceIMP1 = class_getMethodImplementation(objc_getClass("LabelMethodBlockSubVC"), aSelector);
    NSLog(@"类方法")
    IMP classIMP1 = class_getMethodImplementation(objc_getMetaClass("LabelMethodBlockSubVC"), aSelector);

    NSLog(@"第二种 IMP method_getImplementation(Method m)")
    NSLog(@"实例方法")
    Method insttanceMethod = class_getInstanceMethod(objc_getClass("LabelMethodBlockSubVC"), aSelector);
    IMP insttanceIMP2 = method_getImplementation(insttanceMethod);
    NSLog(@"类方法")
    Method classMethod1 = class_getClassMethod(objc_getClass("LabelMethodBlockSubVC"), aSelector);
    IMP classIMP2 = method_getImplementation(classMethod1);
    NSLog(@"类方法")
    Method classMethod2 = class_getClassMethod(objc_getMetaClass("LabelMethodBlockSubVC"), aSelector);
    IMP classIMP3 = method_getImplementation(classMethod2);
    
    NSLog(@"insttanceIMP1:%p insttanceIMP2:%p classIMP1:%p classIMP2:%p classIMP3:%p", insttanceIMP1, insttanceIMP2, classIMP1, classIMP2, classIMP3);
}

/*
 内存管理语义
 
 1.关键词
 strong：表示指向并拥有该对象。其修饰的对象引用计数会 +1 ，该对象只要引用计数不为 0 就不会销毁，强行置空可以销毁它。一般用于修饰对象类型、字符串和集合类的可变版本。
 copy：与strong类似，设置方法会拷贝一份副本。一般用于修饰字符串和集合类的不可变版， block用copy修饰。
 weak：表示指向但不拥有该对象。其修饰的对象引用计数不会增加，属性所指的对象遭到摧毁时属性值会清空。ARC环境下一般用于修饰可能会引起循环引用的对象，delegate用weak修饰，xib控件也用weak修饰。
 assign：主要用于修饰基本数据类型，如NSIteger、CGFloat等，这些数值主要存在于栈中。
 unsafe_unretained：与weak类似，但是销毁时不自动清空，容易形成野指针。
 
 2.比较 copy 与 strong
 copy与strong：相同之处是用于修饰表示拥有关系的对象。不同之处是strong复制是多个指针指向同一个地址，而copy的复制是每次会在内存中复制一份对象，指针指向不同的地址。NSString、NSArray、NSDictionary等不可变对象用copy修饰，因为有可能传入一个可变的版本，此时能保证属性值不会受外界影响。
 注意：若用strong修饰NSArray，当数组接收一个可变数组，可变数组若发生变化，被修饰的属性数组也会发生变化，也就是说属性值容易被篡改；若用copy修饰NSMutableArray，当试图修改属性数组里的值时，程序会崩溃，因为数组被复制成了一个不可变的版本。
 
 3.比较 assign、weak、unsafe_unretain
 
 相同点：都不是强引用。
 不同点：weak引用的 OC 对象被销毁时, 指针会被自动清空，不再指向销毁的对象，不会产生野指针错误；unsafe_unretain引用的 OC 对象被销毁时, 指针并不会被自动清空, 依然指向销毁的对象，很容易产生野指针错误:EXC_BAD_ACCESS；assign修饰基本数据类型，内存在栈上由系统自动回收。
 
 Property的默认设置
 
 基本数据类型：atomic, readwrite, assign
 对象类型：atomic, readwrite, strong
 注意：考虑到代码可读性以及日常代码修改频率，规范的编码风格中关键词的顺序是：原子性、读写权限、内存管理语义、getter/getter。
 
 延伸
 
 我们已经知道 @property 会使编译器自动编写访问这些属性所需的方法，此过程在编译期完成，称为 自动合成 (autosynthesis)。与此相关的还有两个关键词：@dynamic 和 @synthesize。
 
 @dynamic：告诉编译器不要自动创建实现属性所用的实例变量，也不要为其创建存取方法。即使编译器发现没有定义存取方法也不会报错，运行期会导致崩溃。
 @synthesize：在类的实现文件里可以通过 @synthesize 指定实例变量的名称。
 注意：在Xcode4.4之前，@property 配合 @synthesize使用，@property 负责声明属性，@synthesize 负责让编译器生成 带下划线的实例变量并且自动生成setter、getter方法。Xcode4.4 之后 @property 得到增强，直接一并替代了 @synthesize 的工作。
 
 函数参数是以数据结构:栈的形式存取,从右至左入栈。
 首先是参数的内存存放格式：参数存放在内存的堆栈段中，在执行函数的时候，从最后一个开始入栈。因此栈底高地址，栈顶低地址。
 举个例子如下：void func(int x, float y, char z);
 那么，调用函数的时候，实参 char z 先进栈，然后是 float y，最后是 int x，因此在内存中变量的存放次序是 x->y->z，因此，从理论上说，我们只要探测到任意一个变量的地址，并且知道其他变量的类型，通过指针移位运算，则总可以顺藤摸瓜找到其他的输入变量。
 */

- (void)testDataA{
    __weak typeof(self) ws = self;
    void (^TestNumberC)(int)=^(int x){
        __strong typeof(ws) ss = ws;
        ss -> numC = 1000;
        NSLog(@"C2、num的h值是 %d",self->numC);
        
    };
    NSLog(@"C1、num的h值是 %d",numC);
    TestNumberC(86);
    NSLog(@"C3、num的h值是 %d",numC);
    
    //    __weak typeof(self) weakSelf = self;
    //    [previewVc setDoneButtonClickBlockWithPreviewType:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
    //        __strong typeof(weakSelf) strongSelf = weakSelf;
    //        [strongSelf dismissViewControllerAnimated:YES completion:^{
    //            if (!strongSelf) return;
    //            if (strongSelf.didFinishPickingPhotosHandle) {
    //                strongSelf.didFinishPickingPhotosHandle(photos,assets,isSelectOriginalPhoto);
    //            }
    //        }];
    //    }]
}

//局部变量加__block
- (void)testDataB{
    __block int numA = 100;//在栈区
    void (^number)(int)=^(int x){
        numA = numA + x;
        NSLog(@"2、num的h值是 %d",numA);
        
    };//在堆区
    NSLog(@"1、num的h值是 %d",numA);
    number(2);
    NSLog(@"3、num的h值是 %d",numA);
    
}

//全局静态变量
static int numB = 100;
- (void)testDataC{
    void (^TestNumber)(int)=^(int x){
        numB = 1000;
        NSLog(@"S2、num的h值是 %d",numB);
    };
    NSLog(@"S1、num的h值是 %d",numB);
    TestNumber(86);
    NSLog(@"S3、num的h值是 %d",numB);
}


// 静态全局变量
static int global_var = 5;

typedef void (^blockSave)(void);

typedef void (^typedefBlock)(void);

void (^outFuncBlock)(void) = ^{
    NSLog(@"someBlock");
};

- (void)testDataD{
    //    1.编译时刻:宏是预编译（编译之前处理），const是编译阶段。
    //    2.编译检查:宏不做检查，不会报编译错误，只是替换，const会编译检查，会报编译错误。
    //    3.宏的好处:宏能定义一些函数，方法。 const不能。
    //    4.宏的坏处:使用大量宏，容易造成编译时间久，每次都需要重新替换。
        
    //    // 定义变量
    //    int a = 1;
    //    // 允许修改值
    //    a = 20;
    //    // const两种用法
    //    // const:修饰基本变量p
    //    // 这两种写法是一样的，const只修饰右边的基本变量b
    //    const int b = 20; // b:只读变量
    //    int const b = 20; // b:只读变量
    //    // 不允许修改值
    //    b = 1;
    //    // const:修饰指针变量*p，带*的变量，就是指针变量.
    //    // 定义一个指向int类型的指针变量，指向a的地址
    //    int *p = &a;
    //    int c = 10;
    //    p = &c;
    //    // 允许修改p指向的地址
    //    // 允许修改p访问内存空间的值
    //    *p = 20;
    //    // const修饰指针变量访问的内存空间，修饰的是右边*p1，
    //    // 两种方式一样
    //    const int *p1; // *p1：常量 p1:变量
    //    int const *p1; // *p1：常量 p1:变量
    //    // const修饰指针变量p1
    //    int * const p1; // *p1:变量 p1:常量
    //    // 第一个const修饰*p1 第二个const修饰 p1
    //    // 两种方式一样
    //    const int * const p1; // *p1：常量 p1：常量
    //    int const * const p1; // *p1：常量 p1：常量
    //    静态方法在堆上分配内存，实例方法在堆栈上
    //    静态的速度快，占内存。动态的速度相对慢些，但调用完后，立即释放类，可以节省内存
    //    static修饰局部变量
    //    在局部变量之前加上关键字static，局部变量就被定义成为一个局部静态变量。
    //    特点如下:
    //    1）存储区：有栈变为静态存储区rw data，生存期为整个源程序，只能在定义该变量的函数内使用。退出该函数后， 尽管该变量还继续存在，
    //    但不能使用它；
    //    2）作用域：作用域仍为局部作用域，当定义它的函数或者语句块结束的时候，作用域随之结束。
//        static NSString *str = @"123";
        //跨文件访问extern
        //extern则必须是全局变量（静态+非静态）
        //在不通过.h的情况下去访问全局变量，可以通过extern实现
        //extern声明，仅适于修饰全局变量，不能去修饰其他的变量
        //实例方法：首字母大写，实例方法往往首字母小写-实例方法在堆栈上
        //静态方法：首字母小写，静态方法往往首字母大写+静态方法在堆上
        //当你给一个类写一个方法，如果该方法需要访问某个实例的成员变量时，那么方法该被定义为实例方法。 一个类的实例通常有一些成员变量，其中含有该实例的状态信息。而该方法需要改变这些状态，那么该方法需要声明成实例方法
        //堆中的静态区
//        extern NSString *lhString;
//        NSLog(@"%@-%@",lhString,str);
//        extern NSString *StringSwiftUseOC;
//        NSLog(@"StringSwiftUseOC--%@",StringSwiftUseOC);
    //    int multiplier = 6;
    //    int(^Block)(int) = ^int(int num)
    //    {
    //        return num * multiplier;
    //    };
    //    multiplier = 4;
    //    NSLog(@"result is %d", Block(2));
    int var = 1;
    __unsafe_unretained id unsafe_obj = nil;
    __strong id strong_obj = nil;
    static int static_var = 3 ;
    void(^block)(void) = ^{
        
        NSLog(@"局部变量<基本数据类型> var %d",var);
        NSLog(@"局部变量<__unsafe_unretained 对象类型> var %@",unsafe_obj);
        NSLog(@"局部变量< __strong 对象类型> var %@",strong_obj);
        NSLog(@"静态局部变量 %d",static_var);
        NSLog(@"全局变量 %d",global_var);
        self->chooseState = YES;
        NSLog(@"静态全局变量 %d",global_var);
    };
    NSLog(@"外部调用 %@",block);
    
//    32位无符号整数 ，  其表示范围是2的32次方，最大整数为 2的32次方-1
//    有符号数则要去除一个符号位，正数最大为2的31次方-1 , 负数最小为负  2的31次方
//
//    16位整数同理。
//
//    int  在32位系统中为  4字节，也就是32位。在一些16位系统中，int 为2字节,在64位系统中int为8字节。
    
    NSLog(@"block : %@", ^{NSLog(@"block");});      // __NSGlobalBlock__
    
    NSString *str3 = @"1234";
    NSLog(@"block is %@", ^{NSLog(@":%@", str3);});     // __NSStackBlock__
    
#pragma mark - 当全局block引用了外部变量，ARC机制优化会将Global的block,转为Malloc（堆）的block进行调用。
    __block int age = 20;
    int *ptr = &age;
    // ARC下
    blockSave x = ^{
        NSLog(@"(++age):%d", ++age);    // 变量前不加__block的情况下，会报错，变量的值只能获取，不能更改
    };
    blockSave y = [x copy];
    y();
    NSLog(@"x():%@, y():%@ , (*ptr):%d", x, y, *ptr);
    
    
    /**总结：
     ARC下：(++age):21   (*ptr):20    // blockSave在堆中，*ptr在栈中
     MRC下：(++age):21   (*ptr):21    // blockSave和*ptr都在栈中
     */
    
    
#pragma mark - copyBlock（未使用函数内变量） __NSGlobalBlock__
    
    self.copyBlock = ^{
        
    };
    NSLog(@"1：%@", self.copyBlock);
    
#pragma mark - weakBlock（未使用函数内变量） __NSGlobalBlock__
    
//    self.weakBlock = ^{
//
//    };
//    NSLog(@"2：%@", self.weakBlock);
    
#pragma mark - copyBlock （使用函数内变量） __NSMallocBlock__
    
    self.copyBlock = ^{
        age = age+1-1;
    };
    NSLog(@"3：%@", self.copyBlock);
    
#pragma mark - weakBlock（使用函数内变量） __NSStackBlock__
    
//    self.weakBlock = ^{
//        age = age+1-1;
//    };
//    NSLog(@"4：%@", self.weakBlock);
    
#pragma mark - someBlock（定义在函数体外） __NSGlobalBlock__
    
    NSLog(@"5：%@", outFuncBlock);
    
#pragma mark - typedefBlock（函数体外自定义的Block） __NSGlobalBlock__
    
    typedefBlock b = ^{
        
    };
    NSLog(@"6：%@", b);
    
#pragma mark - 对栈中的block进行copy
    // 不引用外部变量，定义在全局区、表达式没有使用到外部变量时，生成的block都是__NSGlobalBlock__类型
    void (^testBlock1)(void) = ^(){
        
    };
    NSLog(@"testBlock1: %@", testBlock1);
    
    // 引用外部变量 -- ARC下默认对block进行了copy操作，所以这里是__NSMallocBlock__类型
    void (^testBlock2)(void) = ^(){
        age = age+1-1;
    };
    NSLog(@"testBlock2: %@", testBlock2);
    
    
    // Blocks提供了将Block和__block变量从栈上复制到堆上的方法来解决变量作用域结束时销毁的问题，堆上的Block会依然存在。
    
    
    /*那么什么时候栈上的Block会复制到堆上呢？
     1.调用Block的copy实例方法时
     2.Block作为函数返回值返回时（作为参数则不会）
     3.将Block赋值给附有__strong修饰符id类型的类或Block类型成员变量时
     4.将方法名中含有usingBlock的Cocoa框架方法或GCD的API中传递Block时
     
     在使用__block变量的Block从栈上复制到堆上时，__block变量也被从栈复制到堆上并被Block所持有。
     */
    
    
    /*block里面使用self会造成循环引用吗？
     
     1.很显然答案不都是，有些情况下是可以直接使用self的，比如调用系统的方法：
     [UIView animateWithDuration:0.5 animations:^{
     NSLog(@"%@", self);
     }];
     因为这个block存在于静态方法中，虽然block对self强引用着，但是self却不持有这个静态方法，所以完全可以在block内部使用self。
     
     2.当block不是self的属性时，self并不持有这个block，所以也不存在循环引用
     void(^block)(void) = ^() {
     NSLog(@"%@", self);
     };
     block();
     
     3.大部分GCD方法:
     dispatch_async(dispatch_get_main_queue(), ^{
     [self doSomething];
     });
     因为self并没有对GCD的block进行持有，没有形成循环引用。
     
     4.……
     
     只要我们抓住循环引用的本质，就不难理解这些东西。
     */
    #pragma mark - MallocBlock
    

    
}

- (void)testDataE{
    
}

- (void)testDataF{
 
    
}

-(void)testDataG{
    //对于不可变字符串来说 srong和copy 指向的地址都是一样的
    //对于可变字符串来说 copy的地址已不在指向原有的地址了，深拷贝了testStr字符串，并让copyStr对象指向这个字符串，反之strong是同一地址
    //当原字符串是NSString时，不管是strong还是copy属性的对象，都是指向原对象，copy操作只是做了次浅拷贝
    //当原字符串是NSMutableString时,copy操作只是做了次深拷贝，产生了一个新对象且copy的对象指向了这个新对象，这个copy属性对象类型始终是不可变的，所以是不可变得；
    NSMutableString*str=[NSMutableString stringWithFormat:@"helloworld"];
    //    NSString*str=[NSString stringWithFormat:@"helloworld"];
    
    self.str1=str;//copy
    
    self.str2=str;//strong
    
    //    [str appendString:@"hry"];
    
    NSLog(@"****************%@",self.str1);
    
    NSLog(@"****************%@",self.str2);
    
    NSLog(@"str:%p--%p",str,&str);
    
    NSLog(@"copy_str:%p--%p",_str1,&_str1);
    
    NSLog(@"strong_str:%p--%p",_str2,&_str2);
    
    [self getEqualStr:@"dczewfwef"];
    [self getEqualStr:@"dczewfwef"];
    
    NSLog(@"1==================================");
    // 2. (遵循了NSCopying和NSMutableCopying协议的)不可变的copy就是copy一个指针, 不可变的mutableCopy就是重新mutableCopy一份内存; 可变的copy和mutableCopy就是重新创建一个内存.
    NSString* string = @"ABC";//NSCFConstantString
    NSLog(@"%p, %p, %p", string, string.copy, string.mutableCopy);
    NSString* string1 = [[NSString alloc] initWithFormat:@"ABCD"];//NSTaggedPointerString
    NSLog(@"%p, %p, %p", string1, string1.copy, string1.mutableCopy);
    
    NSMutableString* mString = [[NSMutableString alloc] initWithFormat:@"ABCDE"];//NSCFString
    NSLog(@"%p, %p, %p", mString, mString.copy, mString.mutableCopy);
    
    NSLog(@"2==================================");
    /*
     0x101d83198, 0x101d83198, 0x6000033e33c0
     0x6000033e8780, 0x6000033e8780, 0x6000033e87e0
     0x6000033f3300, 0x600001e93520, 0x6000033f39f0
     
    从上面的结果可以看出:

    1. string的地址是在常量区的(先当成栈区,用做字面量，存放在文本区), 而string.copy指向的同样也是栈区, 而且和string的地址是同一个0x101d83198, 而string的mutableCopy指向的是一个堆区的地址0x6000033e33c0, 这是在堆区里面重新开辟了一块内存.

    2. string1的地址是在堆区里面开辟出来的, 同样的string1也是inmutable类型的, 而string1.copy同样的也是和string1的地址是同一个0x6000033e8780, 同样的string1.mutableCopy指向了0x6000033e87e0也是在堆区里面重新开辟出一块内存.

    不可变类型(inmutable)的copy指向的还是原来的地址(不论是在堆区还是在栈区), 而不可变类型(inmutable)的mutableCopy是在堆区里面重新开辟出一块新内存来拷贝.
    
    1. mString的地址是在堆区里面开辟出的一块内存, mString是mutable类型的, 但是mString.copy和mString.mutableCopy都是在堆区里面重新开辟出一块内存来拷贝.

    可变类型(mutable)的copy和mutableCopy都是在堆区里面开辟出一块内存.
    */
    NSLog(@"2==================================");
    NSArray* array = @[@"ABCDF", @"ABCDEFG"];
    NSArray* array1 = array.copy;
    NSArray* array2 = array.mutableCopy;
    NSLog(@"%p, %p, %p", array, array1, array2);
    for (NSString* string in array) {
        NSLog(@"%p", string);
    }
    NSLog(@"3==================================");
    for (NSString* string in array1) {
        NSLog(@"%p", string);
    }
    NSLog(@"4==================================");
    for (NSString* string in array2) {
        NSLog(@"%p", string);
    }
    NSLog(@"5==================================");
    NSLog(@"mutableCopy");
    NSMutableArray* mutableArray = [NSMutableArray arrayWithObjects:@"ABCDEFGH", @"ABCDEFGHL", nil];
    NSMutableArray* mutableArray1 = mutableArray.copy;
    NSMutableArray* mutableArray2 = mutableArray.mutableCopy;
    NSLog(@"%p, %p, %p", mutableArray, mutableArray1, mutableArray2);
    for (NSString* string in mutableArray) {
        NSLog(@"%p", string);
    }
    NSLog(@"6==================================");
    for (NSString* string in mutableArray1) {
        NSLog(@"%p", string);
    }
    NSLog(@"7==================================");
    for (NSString* string in mutableArray2) {
        NSLog(@"%p", string);
    }
    NSLog(@"8==================================");
    //对于他们里面的元素就不是了, 元素指向的还是之前的内存地址
}
//多次调用只加载一次
- (void)getEqualStr:(NSString *)str{
    if ([self.rtcMessageID isEqualToString:str] ) {
        NSLog(@"只加载一次");
    }else{
        self.rtcMessageID = str;
    }
}
- (void)testDataH{
    int a = 9;
    int b = 10;
    int c;
    //    a = b + 0 * ( b = a);//a=12;b=10
    //    NSLog(@"%d",a);
    a = b - a; //a=2;b=12
    b = b - a; //a=2;b=10
    a = a + b; //a=10;b=10
    NSLog(@"%d",a);
    
    //    c=(++a==b--)?++a:b--;
    /**
     ++a后  a的值为10
     （++a(10)==b(10)）,执行++a==b--)中的b- -（9）然后在求++a(11)，同时将其赋值给c
     */
    //++a整体和b--整体相等，所以三目运算，选择等号=前面的,再计算出等号前面的++a整体就得到c的值了
    //++a整体是11，加了两次，所以c = 11,++写在前面和写在后面对整体的值有影响，对a的值都是+1操作，
    //
    //
    if (++a==b--) {
        c = ++a;
    }else{
        c =b--;
    }
    NSLog(@"%d,%d,%d",a,b,c);//11，9，11
}


- (void)testDataL{
    //    NSMutableArray *arr = [@[@"24", @"17", @"85", @"13", @"9", @"54", @"76", @"45", @"5", @"63"]mutableCopy];
    //    for (int i = 0; i<arr.count-1; i++) {
    //        for (int j = 0; (j < arr.count-1-i); j++) {
    //            if ([arr[j] intValue]<[arr[j+1] intValue]){
    //                int tmp = [arr[j] intValue];
    //                NSLog(@"----<<>>%d",tmp);
    ////                arr[j] = arr[j+1];
    ////                arr[j+1] = tmp;
    //            }
    //        }
    //    }
    //冒泡排序
    //    int array[10] = {24, 17, 85, 13, 9, 54, 76, 45, 5, 63};
    //    int numcount = sizeof(array)/sizeof(int);
    //    for (int i = 0; i<numcount; i++) {
    //        NSLog(@"-第一层读数-%d",array[i]);
    //        for (int j = 0; j<numcount-i; j++) {
    //            NSLog(@"-第二层读数-%d",array[j]);
    //            //如果一个元素比另一个元素大，交换这两个元素的位置
    //            if (array[j]<array[j+1]) {
    //                int tmp = array[j];
    //                array[j]=array[j+1];
    //                array[j+1] = tmp;
    //            }
    //        }
    //
    //    }
    //    for(int i = 0; i < numcount; i++) {
    //        printf("最终结果--%d\t", array[i]);
    //    }
    //冒泡排序
    NSMutableArray *arrNum = [NSMutableArray arrayWithObjects:@"10",@"23",@"34",@"12",@"2",@"16", nil];
    for (int i = 0; i<arrNum.count; i++) {
        NSLog(@"外层冒泡排序循环：%@",arrNum[i]);
        for (int j = 0; j<arrNum.count-1-i; j++) {
            NSLog(@"内层冒泡排序循环：%@-%@-%lu",arrNum[j],arrNum[j+1],arrNum.count-1-i);
            if ([arrNum[j]intValue]<[arrNum[j+1]intValue]) {
                NSLog(@"冒泡排序判断：%@-%@-%@",arrNum[i],arrNum[j],arrNum[j+1]);
                int tmp = [arrNum[j]intValue];
                arrNum[j] = arrNum[j+1];
                arrNum[j+1] = [NSNumber numberWithInt:tmp];
                NSLog(@"冒泡排序判断：%@-%@-%@",arrNum[i],arrNum[j],arrNum[j+1]);
            }
        }
    }
    
    //    //选择排序 先设arr[1]为最小，逐一比较，若遇到比之小的则交换,
    //    for (int i = 0;i<arrNum.count; i++) {
    //        NSLog(@"i 选择排序：%@",arrNum[i]);
    //        for (int j = i+1;j<arrNum.count; j++) {
    //            NSLog(@"选择排序：%@",arrNum[j]);
    //            if ([arrNum[i]intValue] > [arrNum[j]intValue]) {// 将上一步找到的最小元素和第i位元素交换。
    //                NSLog(@"选择排序：%@--%@",arrNum[i],arrNum[j]);
    //                int tmp = [arrNum[i]intValue];
    //                arrNum[i] = arrNum[j];//exchange
    //                arrNum[j] = [NSNumber numberWithInt:tmp];
    //                NSLog(@"选择排序：%@--%@",arrNum[i],arrNum[j]);
    //            }
    //
    //        }
    //    }
    
    for(int i = 0; i < arrNum.count; i++) {
        printf("最终结果--%d\t", [arrNum[i]intValue]);
    }
}
- (void)testDataM
{
    //冒泡排序
    //    1, 最差时间复杂度 O(n^2)
    //    2, 平均时间复杂度 O(n^2)
    //    NSMutableArray *mutableArray = [@[@"12",@"45",@"1",@"5",@"18",@"35",@"7"]mutableCopy];
    //    for (int i = 0; i < mutableArray.count-1; i++) {
    //
    //        for (int j = 0; j < mutableArray.count-1-i; j++) {
    //
    //            if ([mutableArray[j] integerValue] > [mutableArray[j+1] integerValue]) {
    //                NSString *temp = mutableArray[j];
    //                mutableArray[j] = mutableArray[j+1];
    //                mutableArray[j+1] = temp;
    //            }
    //        }
    //    }
    //
    //    NSLog(@"冒泡排序结果：%@",mutableArray);
    
    NSMutableArray *numarrar = [@[@"4",@"2",@"7",@"12",@"9",@"1"]mutableCopy];
    //    for (int i = 0; i<numarrar.count-1; i++) {
    ////        NSLog(@"输出的数据 %@",numarrar[i]);
    //        for (int j = 0; j<numarrar.count-1-i;j++){
    ////            NSLog(@"输出的数据 %@",numarrar[j]);
    //            NSLog(@"输出的数据 %@-%@",numarrar[j],numarrar[j+1]);
    //            if ([numarrar[j] integerValue]>[numarrar[j+1] integerValue]) {
    //                NSLog(@"输出的数据 %@",numarrar[j]);
    //                NSString *tem = numarrar[j];
    //                numarrar[j]  = numarrar[j+1];
    //                numarrar[j+1]  = tem;
    //            }
    //        }
    //    }
    //选择排序
    //    平均时间复杂度：O(n^2)
    //    平均空间复杂度：O(1)
    //    struct utsname systemInfo;
    //    uname(&systemInfo);
    //    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //    NSLog(@"deviceString: %@",deviceString);
    //4 2 7 12 9 1
    for (int i = 0; i<numarrar.count-1; i++) {
        int index = i;//0
        for (int j= i+1; j<numarrar.count; j++) {//2 7 12 9 1;        2 4 7 12 9 1  j=2
            if ([numarrar[index]integerValue]>[numarrar[j]integerValue]) {//numarrar[index]=4，numarrar[j]=2  7
                index = j;//index = j = 1;
            }
            if (index != i) {//1 != 0;
                NSString *temp = numarrar[i];//temp = 4
                numarrar[i] = numarrar[index];//numarrar[i] = numarrar[index]=2
                numarrar[index] = temp;// numarrar[index] = 4
            }//2 4 7 12 9 1;4 2 7 12 9 1
            NSLog(@"选择排序结果：%@",numarrar);
        }
    }
    
    
    NSInteger num1 = 10,num2 = 30;
    NSInteger gcd = [self gcdWithNumber1:num1 Number2:num2];
    // 最小公倍数 = 两整数的乘积 ÷ 最大公约数
    NSLog(@"---%ld",num1 * num2 / gcd);
    int a = 1;
    int b = a++;
    int c = ++a;
    NSLog(@"---%d--%d--%d",a ,b ,c);

//    __block UIImage *image;
//    dispatch_sync_on_main_queue(^{
//        image = [UIImage imageNamed:@"Resource/img"];
//    });
    NSLog(@"内联函数 %@",testPathForKey(@"123",@"789"));
    NSLog(@"内联函数 %@",intToString(123));
    NSString *phoneRegex = @"1\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    NSLog(@"手机号BOOL %d",[phoneTest evaluateWithObject:@"手机号1234"]);
    NSLog(@"----%D ",CalcMemLen("sdf", 1000));
    NSDictionary *dict = @{@"name":isNull(@"123")?@"":@"123"};
    NSLog(@"%@",dict);

}
- (NSInteger)gcdWithNumber1:(NSInteger)num1 Number2:(NSInteger)num2{
    
    while(num1 != num2){
        if(num1 > num2){
            num1 = num1-num2;
        } else {
            num2 = num2-num1;
        }
    }
    return num1;
}
- (void)testDataO{
    int x = 42;
    void (^foo)(void) = ^ {
        NSLog(@"%d", x);
    };
    x = 17;
    foo ();
    //830,831,834,835,831,832,833,837
}
static void extracted(CAShapeLayer *cornerLayer, UIImageView *userHeaderImgView) {
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:userHeaderImgView.bounds cornerRadius:39];
    cornerLayer.path = cornerPath.CGPath;
    cornerLayer.frame = userHeaderImgView.bounds;
    userHeaderImgView.layer.mask = cornerLayer;
}

- (void)testDataP{
    //这样做的好处：切割的圆角不会产生混合图层，提高效率。
    //这样做的坏处：代码量偏多，且很多 UIView 都是使用约束布局，必须搭配 dispatch_after 函数来设置自身的 mask。因为只有在此时，才能把 UIView 的正确的 bounds 设置到 CAShapeLayer 的 frame 上。
    UIImageView *userHeaderImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header"]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CAShapeLayer *cornerLayer = [CAShapeLayer layer];
        extracted(cornerLayer, userHeaderImgView);
    });
    
}
static inline NSString* testPathForKey(NSString* directory, NSString* key) {
    //  stringByAppendingString 字符串拼接
    //    stringByAppendingPathComponent 路径拼接
    return [directory stringByAppendingString:key];
}

NSString* (^intToString)(NSUInteger) = ^(NSUInteger paramInteger){
    NSString *result = [NSString stringWithFormat:@"%lu",(unsigned long)paramInteger];
    return result;
};
static inline int CalcMemLen(void *pSrc, long findRange){
    return 10;
}
static BOOL isNull(NSString *stirng) {
    if (stirng == nil || stirng == NULL) {
        return YES;
    }
    if ([stirng isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[stirng stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    
    if(![stirng isKindOfClass:[NSString class]]) return YES;
    
    if(stirng == nil) return YES;
    if([stirng isEqualToString:@"(null)"]) return YES;
    if([stirng isEqualToString:@"NULL"]) return YES;
    if([stirng isEqualToString:@"<null>"]) return YES;
    if([stirng isEqualToString:@"null"]) return YES;
    
    if(stirng == nil || stirng == NULL) return YES;
    NSString * string1 = [stirng stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSUInteger len=[string1 length];
    if (len <= 0) return YES;
    return NO;
}
///TODO:KVO 高级用法
static UILabel *myLabel;
- (void)testDataN{
    
    /**KVO 高级用法
     doubleValue.intValue double转Int类型
     uppercaseString 小写变大写
     length 求各个元素的长度
     数学元素 @sum.self  @avg.self @max.self @min.self  @distinctUnionOfObjects.self(过滤)
     
     >>KVC setter方法
     通过setValue:forKeyPath:设置UI控件的属性：
     
     [self.label setValue:[UIColor greenColor] forKeyPath:@"textColor"];
     [self.button setValue:[UIColor orangeColor] forKeyPath:@"backgroundColor"];
     [self.textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
     
     */
    
    NSArray *dataSource = @[@{@"name":@"mike", @"sex":@"man", @"age":@"12"},
                                 @{@"name":@"jine", @"sex":@"women", @"age":@"10"},
                                 @{@"name":@"marry", @"sex":@"women", @"age":@"12"},
                                 @{@"name":@"mike", @"sex":@"man", @"age":@"11"},
                                 @{@"name":@"selly", @"sex":@"women", @"age":@"12"}];
    //KVC keyPath的getter方法：
    NSLog(@"name = %@",[dataSource valueForKeyPath:@"name"]);
    NSArray *array1 = @[@"apple",@"banana",@"pineapple",@"orange"];
    NSLog(@"%@",[array1 valueForKeyPath:@"uppercaseString"]);
    
    NSLog(@"filterName = %@",[dataSource valueForKeyPath:@"@distinctUnionOfObjects.sex"]);
    
    
    self.user = [[KYUser alloc] init];
    self.user.dog = [[KYDog alloc] init];
    self.user.dog.age = 12;
    self.user.dog.name = @"大大";
    self.user.sex = @"35325";
    // MRC下
    Persion *test = [[Persion alloc] init];
    [test test];
    [self getPrivateVarWithClass:self.user.dog];

    // 1、添加KVO监听
    //NSKeyValueObservingOptionInitial 观察最初的值 在注册观察服务时会调用一次
    //NSKeyValueObservingOptionPrior 分别在被观察值的前后触发一次 一次修改两次触发
    [self.user addObserver:self forKeyPath:@"dog.name" options:NSKeyValueObservingOptionNew context:nil];
//    [self.user addObserver:self forKeyPath:@"dog.can_not_observer_name" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    //kvo监听不到数组的变化，因为kvo监听的是set方法
    [self.user dh_addObserver:self forKey:@"_can_not_observer_name" options:NSKeyValueObservingOptionNew block:^(id  _Nonnull observedObject, NSString * _Nonnull keyPath, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSLog(@"监听到了");
    }];

    
    myLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 150, 100, 30 )];
    myLabel.textColor = [UIColor redColor];
    myLabel.text = self.user.dog.name;
    //    myLabel.text = [self.user.dog valueForKeyPath:@"name"];
    [self.view addSubview:myLabel];
    
    
    UIViewController *vc = [UIViewController new];
    NSDictionary *dic = @{@"vc":vc,@"item":test};
    NSDictionary *dic1 = @{@"vc":vc,@"item":test};
    //    NSArray *dic1 = @[@"vcc",@"2"];
    NSDictionary *dic2 = @{@"vc":vc,@"item":test,@"vcc":@"3"};
    
    NSLog(@"dic %p",dic);
    NSLog(@"dic1 %p",dic1);
    NSMutableArray *tmpArray = [NSMutableArray new];
    [tmpArray addObject:dic];
    //    数组会直接忽略掉，不会崩溃，不会删除，无任何反应，无效果，而且不会崩溃
    [tmpArray removeObject:dic2];
    [tmpArray removeObject:dic2];
    
    KYDog *person = [KYDog alloc];
    NSLog(@"%zd", class_getInstanceSize([KYDog class])); // 输出为56
    NSLog(@"%zd", malloc_size((__bridge const void *)(person))); // 输出为 64
    //    NSLog(@"%zd",malloc(person));
    NSLog(@"%ld",sizeof(person));
    //malloc() 函数和calloc ()函数的主要区别是前者不能初始化所分配的内存空间，而后者能
    NSLog(@"%zd", class_getInstanceSize([KYDog class])); // 输出为8
    NSLog(@"%zd", malloc_size((__bridge const void *)(person))); // 输出为 16
    NSLog(@"%lu",sizeof(person)); // 输出为8

   
//    UIViewController *vc = [UIViewController new];
//    NSDictionary *dic = @{@"vc":vc,@"item":person};
//    NSDictionary *dic1 = @{@"vc":vc,@"item":person};
//    //    NSArray *dic1 = @[@"vcc",@"2"];
//    NSDictionary *dic2 = @{@"vc":vc,@"item":person,@"vcc":@"3"};
//    
//    NSLog(@"%zd", class_getInstanceSize([KYDog class])); // 输出为8
//    NSLog(@"%zd", malloc_size((__bridge const void *)(person))); // 输出为 16
//    
//    NSLog(@"dic %p",dic);
//    NSLog(@"dic1 %p",dic1);
//    NSMutableArray *tmpArray = [NSMutableArray new];
//    [tmpArray addObject:dic];
//    NSLog(@"tmpArray指针地址:%p,tmpArray指针指向的对象内存地址:%p",&tmpArray,tmpArray);
//    //    数组会直接忽略掉，不会崩溃，不会删除，无任何反应，无效果，而且不会崩溃
//    [tmpArray removeObject:dic2];
//    NSLog(@"tmpArray指针地址:%p,tmpArray指针指向的对象内存地址:%p",&tmpArray,tmpArray);
//    
//    [tmpArray removeObject:dic2];
//    NSLog(@"tmpArray指针地址:%p,tmpArray指针指向的对象内存地址:%p",&tmpArray,tmpArray);
    
    
    NSString *name;
    if ([name isEqualToString:@"走尼玛币"]) {
        NSLog(@"此方法只执行一次");
    }
    else{
        name = @"走尼玛币";
    }
    
}
//手动实现键值观察时会用到
- (void)willChangeValueForKey:(NSString *)key{
    
}
- (void)didChangeValueForKey:(NSString *)key{
    
}

// 1、设置属性
// 返回一个容器，里面放字符串类型，监听容器中的属性
+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    if ([key isEqualToString:@"dog"]) {
        NSArray *arr = @[@"_dog.name", @"_dog.age"];
        keyPaths = [keyPaths setByAddingObjectsFromArray:arr];
    }
    return keyPaths;
}

// 2、接收监听
/**
 KVO 必须实现
 
 @param keyPath 被观察的属性
 @param object 被观察对象
 @param change 添加监听时传过来的上下文信息
 @param context 字典，keys有以下五种：
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"--------------%@",change);
    NSLog(@"%@", keyPath);
    NSLog(@"%@", object);
    /*
     NSKeyValueChangeNewKey;新值
     NSKeyValueChangeOldKey;旧值
     NSKeyValueChangeIndexesKey;观察容器属性时会返回的索引值
     NSKeyValueChangeKindKey;
     
     NSKeyValueChangeSetting = 1 赋值 SET
     NSKeyValueChangeInsertion = 2 插入 insert
     NSKeyValueChangeRemoval = 3 移除 remove
     NSKeyValueChangeReplacement = 4 替换 replace
     
     */
    //    NSKeyValueChangeNotificationIsPriorKey
    NSLog(@"%@", change[NSKeyValueChangeNewKey]);
    NSLog(@"%@", (__bridge id)(context));
    myLabel.text = [self.user.dog valueForKeyPath:@"name"];
    //自定义KVO 不监听_can_not_observer_name
    NSLog(@"%@",change);
    Class class = object_getClass(_user);
    Class superClass = class_getSuperclass(class);
    NSLog(@"class---%@",_user.class);
    NSLog(@"superClass:%@",superClass);
    
    //else   若当前类无法捕捉到这个KVO，那很有可能是在他的superClass，或者super-superClass...中
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
}
// 3、触发修改属性值
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.user.sex = @"123456789";
    //    self.user.dog.name = @"肖";
    self.user.dog.age = 15;
    [self.user.dog setValue:@"20.0" forKey:@"name"];
    self.user.sex = @"set is a new value";
    //自定义KVO
    [_user setValue:@"aa" forKey:@"_can_not_observer_name"];

}

/*
 // 获取 该view与window 交叉的 Rect
 CGRect screenRect = [UIScreen mainScreen].bounds;
 CGRect intersectionRect = CGRectIntersection(rect, screenRect);
 if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
 return FALSE;

*/
//YYKit中提供了一个同步扔任务到主线程的安全方法：
//static inline void dispatch_sync_on_main_queue(void (^block)(void)) {
//    NSLog(@"1、执行");
//    //    if (pthread_main_np()) {
//    //        block();
//    //    } else {
//    //        dispatch_sync(dispatch_get_main_queue(), block);
//    //    }
//    //    dispatch_sync(dispatch_get_main_queue(), ^{
//    //        NSLog(@"2、执行");
//    //    });
//    //    NSLog(@"3、执行");
//};
////  3秒钟后改变当前button的enabled状态
//dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    self.button.enabled = YES;
//});

///TODO:多请求顺序执行 结束后统一操作
//例：如一个页面多个网络请求后刷新UI
- (void)testDataQ {
    //模拟并发后统一操作数据
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求1
        NSLog(@"RequestDataQ_1");
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        //模拟网络请求
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSLog(@"请求开始");
            sleep(2);
            NSLog(@"请求完成");
            //请求完成信号量+1，信号量为1，通过
            dispatch_semaphore_signal(sema);
        });
        NSLog(@"我是测试");
        //信号量为0，进行等待
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求2
        NSLog(@"RequestDataQ_2");
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求3
        NSLog(@"RequestDataQ_3");
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //界面刷新
        NSLog(@"任务均完成，刷新界面");
    });
}
//例：如第二个请求需要第一个请求的数据来操作
- (void)testDataR {
    // 1.任务一：获取用户信息
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"RequestDataR_1");
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSLog(@"请求1开始");
            sleep(3);
            NSLog(@"请求1完成");
            //请求完成信号量+1，信号量为1，通过
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }];
    
    // 2.任务二：请求相关数据
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"RequestDataR_2");
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSLog(@"请求2开始");
            sleep(2);
            NSLog(@"请求2完成");
            //请求完成信号量+1，信号量为1，通过
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }];
    
    // 3.设置依赖
    [operation2 addDependency:operation1];// 任务二依赖任务一
    
    // 4.创建队列并加入任务
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation2, operation1] waitUntilFinished:NO];
}
///NSOperation需要在NSOperationQueue中使用，通过queue可以实现先进先出的队列任务，可以添加或取消任务，NSOperation有2个重要的子类，分别是：NSInvocationOperation，NSBlockOperation，分别表示调用一个方法或调用一个block的任务。 NSOperation是比GCD更高层次的api，相同的线程操作如果能用NSOperation操作就尽量用，不能实现的线程操作才使用GCD.相比GCD，NSOperation还有个好处，就是任务可以被取消，而GCD不可以。
- (void)OperationFunction{
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    //设置队列最大同时进行的任务数量，1为串行队列
    [queue setMaxConcurrentOperationCount:1];
    //添加一个block任务
    [queue addOperationWithBlock:^{
        sleep(2);
        NSLog(@"block task 1");
    }];
    [queue addOperationWithBlock:^{
        sleep(2);
        NSLog(@"block task 2");
    }];
    //显示添加一个block任务
    NSBlockOperation *block1 = [NSBlockOperation blockOperationWithBlock:^{
        sleep(2);
        NSLog(@"block task 3");
    }];
    //设置任务优先级
    //说明：优先级高的任务，调用的几率会更大,但不表示一定先调用
    [block1 setQueuePriority:NSOperationQueuePriorityHigh];
    [queue addOperation:block1];
    
    NSBlockOperation *block2 = [NSBlockOperation blockOperationWithBlock:^{
        sleep(2);
        NSLog(@"block task 4，任务3依赖4");
    }];
    [queue addOperation:block2];
    //任务3依赖4
    [block1 addDependency:block2];
    //设置任务完成的回调
    [block2 setCompletionBlock:^{
        NSLog(@"block task 4 comlpete");
    }];
    
    //设置block1完成后才会继续往下走
    [block1 waitUntilFinished];
    NSLog(@"block task 3 is waitUntilFinished!");
    
    //初始化一个子任务
    NSInvocationOperation *oper1 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(function1) object:nil];
    [queue addOperation:oper1];
    ///queue也有对应的方法，叫做waitUntilAllOperationsAreFinished
    [queue waitUntilAllOperationsAreFinished];
    NSLog(@"queue comlpeted");
    
    //    取消全部操作
    //    [queue cancelAllOperations];
    //    暂停操作/恢复操作/是否暂定状态
    //    [queue setSuspended:YES];[queue setSuspended:NO];[queue isSuspended];
    
    //操作优先级
    
    //      [queue waitUntilAllOperationsAreFinished];
    
}
- (void)function1{
    
}
- (void)operationA{
    //blockOperationWithBlock在不同的线程中并发执行的
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"task0---%@", [NSThread currentThread]);
    }];
    //为 NSBlockOperation 添加额外的操作
    [op addExecutionBlock:^{
        NSLog(@"task1----%@", [NSThread currentThread]);
    }];
    
    [op addExecutionBlock:^{
        NSLog(@"task2----%@", [NSThread currentThread]);
    }];
    
    // 开始必须在添加其他操作之后
    [op start];
}
//enter leave
- (void)testDataSS {
    [self testAAA];
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    dispatch_group_enter(group);

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"Request__1");
        sleep(3);
        NSLog(@"Request1完成");
        dispatch_group_leave(group);
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"Request__2");
        sleep(1);
        NSLog(@"Request2完成");
        dispatch_group_leave(group);
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"Request__3");
        sleep(2);
        NSLog(@"Request3完成");
        dispatch_group_leave(group);
    });
    dispatch_group_notify(group,  dispatch_get_main_queue(), ^{
        NSLog(@"全部完成.%@",[NSThread currentThread]);
        CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
        NSLog(@"正常使用enter和leave耗时: %f ms", endTime * 1000.0);
    });
}
///TODO:dispatch_queue_t
- (void)testAAA{
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, globalQueue, ^{
        NSLog(@"请求11");
        sleep(3);
        NSLog(@"请求11完成");
    });
    dispatch_group_async(group, globalQueue, ^{
        NSLog(@"请求12");
        sleep(1);
        NSLog(@"请求12完成");
    });
    dispatch_group_async(group, globalQueue, ^{
        NSLog(@"请求13");
        sleep(2);
        NSLog(@"请求13完成");
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"请求完成");
        CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
        NSLog(@"不使用enter和leave耗时: %f ms", endTime * 1000.0);
    });
    
}

/*
 *使用GCD 的多线程
 *优点：有很多串行并线队列多线程，block实现线程方法，高级，好用，方法多。
 *缺点：在很多不需要高级控制线程的场景可以不用使用GCD
 
 同步、非阻塞执行
 异步非阻塞执行
 一次性执行
 延迟执行
 线程队列串行执行
 线程队列控制（屏障，同步等待，线程暂停和恢复，线程信号量控制等）
 
 在主队列不允许开新的线程且在主线程中负责调度任务，不会再子线程中调度，再异步执行中会开启新线程，且会在新线程中执行，但不会马上就执行，异步主队列只会把新任务放在主队列，但不会马上执行，等线程有空了才执行
 
 atomic 与 nonatomic
 
 问题：什么是原子性？ 说明并比较atomic和nonatomic。 atomic是百分之百安全的吗？
 
 原子性：并发编程中确保其操作具备整体性，系统其它部分无法观察到中间步骤，只能看到操作前后的结果。
 atomic：原子性的，编译器会通过锁定机制确保setter和getter的完整性。
 nonatomic：非原子性的，不保证setter和getter的完整性。
 区别：由于要保证操作完整，atomic速度比较慢，线程相对安全；nonatomic速度比较快，但是线程不安全。atomic也不是绝对的线程安全，当多个线程同时调用set和get时，就会导致获取的值不一样。由于锁定机制开销较大，一般iOS开发中会使用nonatomic，而macOS中使用atomic通常不会有性能瓶颈。
 拓展：要想线程绝对安全，就要使用 @synchronized同步锁。但是由于同步锁有等待操作，会降低代码效率。为了兼顾线程安全和提升效率，可采用GCD并发队列进行优化改进。get使用同步派发，set使用异步栅栏。
 
 async -- 并发队列（最常用）
 会不会创建线程：会，一般同时开多条
 任务的执行方式：并发执行
 
 */
-(void)GCDFunction{

    NSLog(@"GCDFunction start");

    //获取一个队列
    dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    //dispatch_async：异步方式执行方法（最常用）
    //    dispatch_async(defaultQueue, ^{
    //        [self function1];
    //    });

    //dispatch_sync：同步方式使用场景，比较少用，一般与异步方式进行调用
    //    dispatch_async(defaultQueue, ^{
    //       NSMutableArray *array = [self GCD_sync_Function];
    //       dispatch_async(dispatch_get_main_queue(), ^{
    //           //利用获取的arry在主线程中更新UI
    //
    //       });
    //    });

    //dispatch_once：一次性执行，常常用户单例模式.这种单例模式更安全
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    //        // code to be executed once
    //        NSLog(@"dispatch_once");
    //    });

    //dispatch_after 延迟异步执行
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC);
    //    dispatch_after(popTime, defaultQueue, ^{
    //        NSLog(@"dispatch_after");
    //    });

    //dispatch_group_async 组线程可以实现线程之间的串联和并联操作
    //    dispatch_group_t group = dispatch_group_create();
    //    NSDate *now = [NSDate date];
    //    //做第一件事 2秒
    //    dispatch_group_async(group, defaultQueue, ^{
    //        [NSThread sleepForTimeInterval:2];
    //         NSLog(@"work 1 done");
    //    });
    //    //做第二件事 5秒
    //    dispatch_group_async(group, defaultQueue, ^{
    //        [NSThread sleepForTimeInterval:5];
    //        NSLog(@"work 2 done");
    //    });
    //
    //    //两件事都完成后会进入方法进行通知
    //    dispatch_group_notify(group, defaultQueue, ^{
    //        NSLog(@"dispatch_group_notify");
    //        NSLog(@"%f",[[NSDate date]timeIntervalSinceDate:now]);//总共用时5秒，因为2个线程同时进行
    //    });

    //dispatch_barrier_async :作用是在并行队列中，等待前面的队列执行完成后在继续往下执行
    //    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    //    dispatch_async(concurrentQueue, ^{
    //        [NSThread sleepForTimeInterval:2];
    //        NSLog(@"work 1 done");
    //    });
    //    dispatch_async(concurrentQueue, ^{
    //        [NSThread sleepForTimeInterval:2];
    //        NSLog(@"work 2 done");
    //    });
    //    //等待前面的线程完成后执行
    //    dispatch_barrier_async(concurrentQueue, ^{
    //         NSLog(@"dispatch_barrier_async");
    //    });
    //
    //    dispatch_async(concurrentQueue, ^{
    //        [NSThread sleepForTimeInterval:3];
    //        NSLog(@"work 3 done");
    //    });

    //dispatch_semaphore 信号量的使用，串行异步操作
    //    dispatch_semaphore_create　　　创建一个semaphore
    //　　 dispatch_semaphore_signal　　　发送一个信号
    //　　 dispatch_semaphore_wait　　　　等待信号

    /*应用场景1：马路有2股道，3辆车通过 ，每辆车通过需要2秒
     *条件分解:
        马路有2股道 <=>  dispatch_semaphore_create(2) //创建两个信号
        三楼车通过 <=> dispatch_async(defaultQueue, ^{ } 执行三次
        车通过需要2秒 <=>  [NSThread sleepForTimeInterval:2];//线程暂停两秒
     */

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);

        dispatch_async(defaultQueue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            [NSThread sleepForTimeInterval:2];
            NSLog(@"carA pass the road");
            dispatch_semaphore_signal(semaphore);
        });
        dispatch_async(defaultQueue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            [NSThread sleepForTimeInterval:2];
            NSLog(@"carB pass the road");
            dispatch_semaphore_signal(semaphore);
        });
        dispatch_async(defaultQueue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            [NSThread sleepForTimeInterval:2];
            NSLog(@"carC pass the road");
            dispatch_semaphore_signal(semaphore);
        });

    //应用场景2 ：原子性保护，保证同时只有一个线程进入操作
    //    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    //    for(int i=0 ;i< 10000 ;i++){
    //        dispatch_async(defaultQueue, ^{
    //            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    //            NSLog(@"i:%d",i);
    //            dispatch_semaphore_signal(semaphore);
    //        });
    //    }

    NSLog(@"GCDFunction end");
}
- (void)asyncGlobalQueue
{
    // 获得全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 将 任务 添加 全局队列 中去 异步 执行
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片1---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片2---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片3---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片4---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片5---%@", [NSThread currentThread]);
    });
/*通常我们会用for循环遍历，但是GCD给我们提供了快速迭代的方法dispatch_apply，使我们可以同时遍历。比如说遍历0~5这6个数字，for循环的做法是每次取出一个元素，逐个遍历。dispatch_apply可以同时遍历多个数字。
     */
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"GCD快速迭代 //%zd------%@",index, [NSThread currentThread]);
    });
 
}
/**
 *  async -- 串行队列（有时候用）
 *  会不会创建线程：会，一般只开1条线程
 *  任务的执行方式：串行执行（一个任务执行完毕后再执行下一个任务）
 */
- (void)asyncSerialQueue
{
    // 1.创建一个串行队列
    dispatch_queue_t queue = dispatch_queue_create("cn.heima.queue", NULL);
    
    // 2.将任务添加到串行队列中 异步 执行
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片10---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片20---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片30---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片40---%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"-----下载图片50---%@", [NSThread currentThread]);
    });
    
}
- (void)getPrivateVarWithClass:(KYDog *)object{
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList([object class], &count);
    for (int i = 0 ; i<count ; i++) {
        //从数组中获取成员变量（iVar成员变量是“_开头的”）
        Ivar ivar = ivarList[i];
        //获取成员变量
        NSString *ivarname = [NSString stringWithUTF8String:ivar_getName(ivar)];
        //获取成员变量的类型
        NSString *ivartype = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        
        ivarname = [ivarname stringByReplacingOccurrencesOfString:@"_" withString:@""];
        ivartype = [ivartype stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        ivartype = [ivartype stringByReplacingOccurrencesOfString:@"@" withString:@""];
        // 打印成员变量的数据类型 成员变量名字
        NSLog(@"%@ *%@", ivartype,ivarname);
        //修改对应的值
//        if ([ivarname containsString:@"privateName"]) {
//            object_setIvar(object, ivar, @"我的名字");
//            NSString *privateName = object_getIvar(object, ivar);
//            NSLog(@"privateName %@",privateName);
//        }
//        object_setIvar(object, ivarList[2], @"456");
//        NSString *privateName = object_getIvar(object, ivar);
//        NSLog(@"privateName : %@",privateName);

        
//        NSString *key = [ivarname substringFromIndex:1];
        //根据成员属性名去字典查找对应的value
//        id value = dict[key];
        // 判断值是否是数组
//        if ([value isKindOfClass:[NSArray class]]) {
        // 判断对应类有没有实现字典数组转模型数组的协议, 协议名称自己可以随便定义, 返回的字典里key对应的类的名称字符串
        // arrayContainModelClass 提供一个协议，只要遵守这个协议的类，都能把数组中的字典转模型
//        　　　　　　if ([self respondsToSelector:@selector(arrayContainModelClass)]) {
//            　　　　　　　　// 转换成id类型，就能调用任何对象的方法
//            　　　　　　　　id idSelf = self;
//            　　　　　　　　// 获取数组中字典对应的模型
//            　　　　　　　　NSString *type = [idSelf arrayContainModelClass][key];
//            　　　　　　　　// 生成模型
//            　　　　　　　　Class classModel = NSClassFromString(type);
//            　　　　　　　　NSMutableArray *arrM = [NSMutableArray array];
//            　　　　　　　　// 遍历字典数组，生成模型数组
//            　　　　　　　　for (NSDictionary *dict in value) {
//                　　　　　　　　　　// 字典转模型
//                　　　　　　　　　　id model = [classModel modelWithDict3:dict];
//                　　　　　　　　　　 [arrM addObject:model];
//                　　　　　　　　 }
//            　　　　　　　　 // 把模型数组赋值给value
//            　　　　　　　　value = arrM;
//            　　　　　　}
//        　　　　}
//    　　　　// 如果模型属性数量大于字典键值对数理，模型属性会被赋值为nil,而报错
//    　　　　if (value) {
//        　　　　// 给模型中属性赋值
//        　　　　 [objc setValue:value forKey:key];
//
//        　　　　 }
    }
    
}
- (void)testDataT{
    //函数式编程
    //把Block当做函数的参数，可以把我们的逻辑和函数放在调用时候的block里面，而不是方法内部。这样会让我们在写代码的时候，把相关的逻辑都放在一起，提高了开发效率和程序的可读性。这其实就是函数式编程思想。函数式编程在很多第三方框架中都有明显的体现，比如说我们频繁使用的AFNetWorking、Masonry
    [self eatWith:^(NSDictionary *dic) {
        NSLog(@"dic %@",dic);
    }];
    
    void(^block)(int i) = self.run;
    block(1);
    //上面这两行代码可以合并为下面这一行
    self.run(10);//有没有发现这个调用和block作为属性时是一样的，下面会继续分析
    
    //链式调用
    self.travel(@"重庆").travel(@"北京");
    
    int (^myBlock)(void);
    int x;
    x = 10;
    myBlock = ^(void)
    {
        return x;
    };
    logBlock(myBlock);
    
    NSLog(@"--筛选数字：%@--",[self findNumFromStr:@"adsfadfe213234阿斯蒂芬"]);
}
//block作为方法参数
//Block作为参数时，blockname不需要写在^后面，直接写在括号后面
- (void)eatWith:(void (^)(NSDictionary *dic))block {
    block(@{@"name":@"234"});
}
//block作为方法的返回值
//Block作为返回值(block作为方法的返回值)
- (void (^)(int i))run {
    return ^(int i){
        NSLog(@"我走了%d米",i);
    };
}
//链式调用方法

//后面带括号，说明方法的返回值是一个Block。
//调用方法肯定是对象才可以进行调用，说明Block的返回值是一个对象。
//点语法则说明这个方法没有参数。

//结合以上三点思考，我们可以得出一个结论，一个没有参数&有返回值&返回值是Block&Block的返回值是方法的调用者的方法，就可以实现链式调用：
- (LabelMethodBlockSubVC *(^)(NSString *))travel {
    return ^(NSString *city){
        NSLog(@"我去了%@",city);
        return self;
    };
}
void logBlock(int(^theBlock)(void))
{
    NSLog( @"Closure var X: %i", theBlock() );
}
- (void)acb:(id)data,...NS_REQUIRES_NIL_TERMINATION{
    [self acb:nil,@"配置管理", nil];
}
+ (instancetype)arrayWithObjects:(id)firstObj, ...{
    
    NSMutableArray* arrays = [NSMutableArray array];
    //VA_LIST 是在C语言中解决变参问题的一组宏
    va_list argList;
    
    if (firstObj) {
        [arrays addObject:firstObj];
        // VA_START宏，获取可变参数列表的第一个参数的地址,在这里是获取firstObj的内存地址,这时argList的指针 指向firstObj
        va_start(argList, firstObj);
        // 临时指针变量
        id temp;
        // VA_ARG宏，获取可变参数的当前参数，返回指定类型并将指针指向下一参数
        // 首先 argList的内存地址指向的fristObj将对应储存的值取出,如果不为nil则判断为真,将取出的值存在数组中,
        // 并且将指针指向下一个参数,这样每次循环argList所代表的指针偏移量就不断下移直到取出nil
        while ((temp = va_arg(argList, id))) {
            [arrays addObject:temp];
            NSLog(@"%@",arrays);
        }
        //如果在使用 + (instancetype)arrayWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;方法中不传入nil值在(temp = va_arg(argList, id))这个函数中便会一直取出值,在C语言中指针指向的即便是一个空内存地址未初始化也是会取出值的,那么一个基本数据类型的随机数则赋值给了 temp 在添加到数组中,则造成将未初始化的内存空间赋值给可变数组的问题程序出现了崩溃.所以我们在使用+ (instancetype)arrayWithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;方法时在多参数的结尾一定要加上nil
    }
    // 清空列表
    va_end(argList);
    return [arrays mutableCopy];
}
- (NSString *)findNumFromStr:(NSString *)originalString{
    NSMutableString *numberString = [[NSMutableString alloc] init];
    NSString *tempStr;
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    while(![scanner isAtEnd]){
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        [scanner scanCharactersFromSet:numbers intoString:&tempStr];
        [numberString appendString:tempStr];tempStr = @"";
    }
    //    return [numberString integerValue];
    return numberString;
}
- (void)testNormalBlock{
    NSInteger n = 20;
    static NSInteger sn = 40;
    __block NSInteger bn = 50;
    /*最普通的用法了吧，和lambda一样了*/
    void (^NormalBlock1)(NSInteger) = ^(NSInteger avalue)
    {
        NSLog(@"%ld", avalue);
    };
    NormalBlock1(n);
    /*注意，这个算是个坑了吧，静态的变量除外啊
     在其主体中用到的outA这个变量值的时候做了一个copy的动作，把outA的值copy下来
     这个说法我没理解，按照lambda的语法，这个应该是等于类型的，加上__block就是引用类型的了*/
    void (^NormalBlock3)(NSInteger) = ^void(NSInteger avalue)
    {
        NSLog(@"%ld", (long)n);//20
        NSLog(@"%ld", (long)sn);//60
    };
    n=30;
    sn = 60;
    NormalBlock3(n);
    NSLog(@"%ld", (long)n);//30
    /*改变变量值呢?Variable is not assignable (missing __block type specifier)
     得加关键字__block*/
    void (^NormalBlock4)(NSInteger) = ^void(NSInteger avalue)
    {
        bn++;
        NSLog(@"%ld", (long)bn);//51
    };
    n=30;
    NormalBlock4(bn);
    /*先声明后定义的形式*/
    void(^NormalBlock5)(NSInteger);
    NormalBlock5 = ^void(NSInteger avlue)
    {
        NSLog(@"%ld", (long)avlue);
    };
    /*定义两遍，应该用后者吧*/
    NormalBlock5 = ^void(NSInteger avlue)
    {
        NSInteger nb = avlue * 2;
        NSLog(@"%ld", (long)nb);
    };
    NormalBlock5(25);
    
}
static  BOOL y;
- (void)semaphore{

    dispatch_queue_t queueMovies = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphoreMovies = dispatch_semaphore_create(5);//创建信号量
    
        dispatch_semaphore_wait(semaphoreMovies, DISPATCH_TIME_FOREVER);//等待信号量 有闲置的信号量就让新的任务进来，如果没有就按照顺序等待闲置的信号量 可以设置等待时间
        dispatch_async(queueMovies, ^{
            //模拟下载任务
            sleep(3);//假设下载一集需要10+i*2秒
            y = NO;
            if (y == YES) {
              return ;
            }
            else{
                [self testtest];
            }
            NSLog(@"A完成");
            dispatch_semaphore_signal(semaphoreMovies);//发送信号量 发送完成进度
        });
}
- (void)testtest{
    //创建一个调度组
    dispatch_group_t group = dispatch_group_create();
    
    //进入调度组
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //模拟请求耗时
        sleep(2);
        y = NO;
        if (y == YES) {
            return ;
        }
        else{
//            [self test];
        }
        NSLog(@"B完成");
        //事件完成 离开调度组
        dispatch_group_leave(group);
    });
    
}
/**
 调度组异步执行
 */
- (void)asyncGroup{
    
    //创建一个调度组
    dispatch_group_t group = dispatch_group_create();
    
    //进入调度组
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //模拟请求耗时
        sleep(2);
        NSLog(@"A");
        //事件完成 离开调度组
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(2);
        NSLog(@"B");
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(2);
        NSLog(@"C");
        dispatch_group_leave(group);
    });
    /*
     参数1:调度组
     参数2:队列
     参数3:任务
     */
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        sleep(1);
        NSLog(@"下载第1首歌曲");
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        sleep(1);
        NSLog(@"下载第2首歌曲");
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        sleep(1);
        NSLog(@"下载第3首歌曲");
    });
    //所有任务从调度组里面拿出来 调用通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"歌曲下载完成");
    });
}
#pragma mark GCD 演练
/*
 串行队列：顺序，一个一个执行。
 同步：在当前线程执行，不会开辟新线程。
 dispatch：调度，GCD里面的函数都是以dispatch开头的。
 */
-(void)gcdTest1
{
    // 1. 创建一个串行队列
    // 参数：1.队列标签(纯c语言)   2.队列的属性
    dispatch_queue_t  queue =  dispatch_queue_create("itcast", DISPATCH_QUEUE_SERIAL);
    
    // 2. 同步执行任务
    // 一般只要使用“同步” 执行，串行队列对添加的任务，会立马执行。
    dispatch_sync(queue, ^{
        NSLog(@"%@", [NSThread currentThread]);
    });
    NSLog(@"完成！");
}

/**
 串行队列：任务必须要一个一个先后执行。
 异步执行：肯定会开新线程，在新线程执行。
 结果：只会开辟一个线程，而且所有任务都在这个新的线程里面执行。
 */
-(void)gcdTest2
{
    // 1. 串行队列
    dispatch_queue_t queue = dispatch_queue_create("itcast", DISPATCH_QUEUE_SERIAL);
    // 按住command进入， #define DISPATCH_QUEUE_SERIAL NULL
    //  DISPATCH_QUEUE_SERIAL 等于直接写NULL， 且开发的时候都使用NULL
    // 2. 异步执行
    for (int i=0 ; i<10 ; i++) {
        dispatch_async(queue, ^{
            NSLog(@"%@  %d", [NSThread currentThread], i);
        });
    }
}

/**
 并发队列：可以同时执行多个任务，
 异步执行：肯定会开新线程，在新线程执行。
 结果：会开很多个线程，同时执行。
 */
-(void)gcdTest3
{
    // 1. 并发队列
    dispatch_queue_t queue = dispatch_queue_create("cz", DISPATCH_QUEUE_CONCURRENT);
    
    // 异步执行任务
    for (int i=0 ; i<5 ; i++) {
        dispatch_async(queue, ^{
            NSLog(@"A开始 %@",[NSThread currentThread]);
            //模拟请求耗时
            sleep(1);
            NSLog(@"-%d-完成:%@",i, [NSThread currentThread]);
        });
    }
}

/**
 并发队列：可以同时执行多个任务
 同步执行：不会开辟新线程，是在当前线程执行。
 结果：不开新线程，顺序执行。
 */
-(void)gcdTest4
{
    // 并发队列
    dispatch_queue_t queue = dispatch_queue_create("itcast", DISPATCH_QUEUE_CONCURRENT);
    for (int i=0 ; i< 10; i++) {
        dispatch_sync(queue, ^{
            NSLog(@"%@  %d", [NSThread currentThread], i);
        });
    }
    
}
/**
 解析如下：
 串行队列：即要求按顺序挨个执行队列内的任务，即一次只执行一个。
 并行队列：即要求同时执行队列内的任务。即一次要执行一个或多个队列内的任务。
 同步执行：即只在当前线程执行队列内的任务，不会另外开辟新的线程。
 异步执行：即开辟一个或多个新的线程来执行队列内的任务，让新的线程来执行。
 
 串行队列同步执行：即由当前线程按顺序执行队列内的任务，不会开辟新的线程。
 串行队列异步执行：即另外开辟一个新的线程（仅仅一个），并由这个新的线程来顺序执行队列内的任务，因为异步就是另外开辟线程，又因为串行队列一次只要求执行一个，所以只开辟一个新的线程来顺序执行即可。
 并行队列同步执行：即由当前线程同时执行队列内的任务。由于当前单线程是无法实现同时执行多个任务即无法一次执行多个任务，所以只会由当前线程顺序执行队列内的任务。
 并行队列异步执行：另外开辟多个线程来同时执行队列内的任务。因为队列内的任务要求同时执行多个，又可以开辟新的线程。所以会开辟多个新的线程来同时执行队列内的任务。但执行任务的顺序不确定，且开辟新线程的个数不确定。
 需要注意的是：同步只在当前线程执行。异步只在别的线程执行。
 */

/*****************************************************************************************/
#pragma mark - 主队列
/**
 主队列：专门负责在主线程上调度任务，不会在子线程调度任务，在主队列不允许开新线程。
 主队列特点：不允许开新线程。
 异步执行：会开新线程，在新线程执行。
 异步特点：异步任务不需要马上执行，只是把任务放到主队列，等线程有空再去执行，也就是等gcdTest5执行完毕，主线程就有空了。
 结果：不开线程，只能在主线程上，顺序执行。
 */
-(void) gcdTest5
{
    // 1. 获得主队列—> 程序启动以后至少有一个主线程—> 一开始就会创建主队列。
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    NSLog(@"开始------------------------");
    // 2. 异步执行任务
    for(int i=0; i<10; i++){
        NSLog(@"调度前");
        // 异步：把任务放到主队列里，但是不需要马上执行。
        dispatch_async(queue, ^{  // 也就是说，把{}内的任务先放到队列里面，等主线程别的任务完成之后才执行。
            NSLog(@"%@  %d", [NSThread currentThread], i);
        });
        NSLog(@"睡会");
        [NSThread sleepForTimeInterval:1.0];
    }
    NSLog(@"完成------------------------");
    /**
     之所以将放到主队列内的任务最后执行，是因为当前队列所在的gcdTest5方法正由主线程进行执行，只有将先调度的gcdTest5执行完毕，才会执行加在队列内的任务。注意在执行方法过程中只是先把任务加到队列中。
     */
}

/**
 主队列：专门负责在主线程上调度任务，不会在子线程调度任务，在主队列不允许开新线程。
 同步执行：要马上执行。
 结果：死锁。
 */
-(void)gcdTest6
{
    
    // 1. 获得主队列—> 程序启动以后至少有一个主线程—> 一开始就会创建主队列。
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    NSLog(@"开始------------------------");
    // 2. 同步执行任务
    for(int i=0; i<10; i++){
        NSLog(@"调度前");
        // 同步：把任务放到主队列里，但是需要马上执行。
        dispatch_sync(queue, ^{
            NSLog(@"%@  %d", [NSThread currentThread], i);
        });
        NSLog(@"睡会");
        [NSThread sleepForTimeInterval:1.0];
    }
    NSLog(@"完成------------------------");
    /**
     同步任务需要马上执行，但是主线程上面正在执行gcdTest6。所以需要等gcdTest6执行完毕，但是gcdTest6也在等主队列内的任务执行完毕。相互等待造成主线程阻塞。产生死锁。
     */
}

/******************************************************************************************/

#pragma mark GCD- 同步任务的所用
-(void)gcdTest7
{
    // 并发队列
    dispatch_queue_t queue = dispatch_queue_create("cz", DISPATCH_QUEUE_CONCURRENT);
    /**
     例子：有一个小说下载网站
     - 必须登录，才能下载小说
     
     有三个任务：
     1. 下载任务
     2. 下载小说A
     3. 下载小说B
     */
    // 添加任务
    // 同步任务：需要马上执行，不会开辟新线程。
    dispatch_sync(queue, ^{
        NSLog(@"用户登录 %@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载小说A%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载小说B %@", [NSThread currentThread]);
    });
}

/***************************************************************************************/
#pragma mark- GCD全局队列
/**
 全局队列与并发队列的区别：
 1. 全局队列没有名称，并发队列有名称。
 2. 全局队列，是供所有的应用程序共享。
 3. 在MRC开发中，全局队列不需要释放，但并发队列需要释放。
 对比：调度任务的方式相同。
 */
-(void)gcdTest8
{
    // 获得全局队列
    /**  一般不修改优先级
     第一个参数，一般写0 （可以适配IOS7或IOS8）
     第二个参数，保留参数，0
     IOS7
     DISPATCH_QUEUE_PRIORITY_HIGH 2   高优先级
     DISPATCH_QUEUE_PRIORITY_DEFAULT 0  默认优先级
     DISPATCH_QUEUE_PRIORITY_LOW (-2)   低优先级
     DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN 后台优先级（最低）
     
     IOS8   左边与IOS7对照
     DISPATCH_QUEUE_PRIORITY_HIGH:         QOS_CLASS_USER_INITIATED
     DISPATCH_QUEUE_PRIORITY_DEFAULT:      QOS_CLASS_DEFAULT
     DISPATCH_QUEUE_PRIORITY_LOW:          QOS_CLASS_UTILITY
     DISPATCH_QUEUE_PRIORITY_BACKGROUND:   QOS_CLASS_BACKGROUND
     
     为了对IOS7或8都使用，所以写0即可
     设置一个停止的标记，当我们需要停止已经执行的任务时，可以根据标记直接return
     
     全局队列与并发队列的区别：
     https://www.jianshu.com/p/44d84e275962
     1. 全局队列没有名称，并发队列有名称。
     2. 全局队列能供所有的应用程序共享。
     3. 在MRC开发中，全局队列不需要释放，但是并发队列需要释放。
     二者调度任务的方式相同。
     注意：并发队列有名称，可以方便系统运行出错时根据队列名称在日志中进行查找。
     GCD默认已经提供了全局的并发队列，供整个应用使用，不需要手动创建。使用dispatch_get_global_queue函数获取全局的并发队列。
     
        dispatch_queue_t dispatch_get_global_queue(dispatch_queue_priority_t  priority, unsigned long flags);
         priority: 队列的优先级设为0即可  flags：此参数暂时无用，用0即可。举例如下：
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);  // 获得全局并发队列
        全局并发队列的优先级：
        #define DISPATCH_QUEUE_PRIORITY_HIGH 2 // 高
        #define DISPATCH_QUEUE_PRIORITY_DEFAULT 0 // 默认（中）
        #define DISPATCH_QUEUE_PRIORITY_LOW (-2) // 低
        #define DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN // 后台
        使用dispatch_queue_create函数创建串行队dispatch_queue_t
        dispatch_queue_create(const char *label, // 队列名称
        dispatch_queue_attr_t attr // 队列属性，如果是串行就传NULL
        );具体使用如下：
        dispatch_queue_t queue =dispatch_queue_create(“aaa”,NULL); // 创建串行队列
        dispatch_release(queue); // 非ARC需要释放手动创建的队列。
        主队列是GCD自带的一种特殊的串行队列。
        放到主队列中的任务，都会放到主线程中执行。
        使用dispatch_get_main_queue()获得主队列
        dispatch_queue_t queue = dispatch_get_main_queue();
     
                       全局并行队列      手动创建串行队列
         同步(sync)  | 没有开启新线程 | 没有开启新线程  | 会死锁
            并行           串行执行任务     串行执行任务
         异步(async) | 有开启新线程   | 有开启新线程      | 没有开启新线程
            并行       并行执行任务       | 串行执行任务      | 串行执行任务
     */
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 异步执行任务
    for (int i=0 ; i<10 ; i++) {
        dispatch_async(queue, ^{
            if (self->gcdIsStope) {
                return ;
            }
            sleep(1);
            NSLog(@"%@  %d", [NSThread currentThread], i);
        });
    }
}
#pragma mark- GCD信号量
- (void)asyncSemaphore{
    
    NSArray*moviesArray = [NSArray arrayWithObjects:
                           @"第1集", @"第2集",@"第3集",@"第4集",@"第5集",
                           @"第6集",@"第7集",@"第8集",@"第9集",@"第10集",
                           @"第11集", @"第12集",@"第13集",@"第14集",@"第15集",
                           @"第16集",@"第17集",@"第18集",@"第19集",@"第20集",
                           nil];
    
    dispatch_queue_t queueMovies = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphoreMovies = dispatch_semaphore_create(5);//创建信号量
    
    for (int i = 0 ; i<moviesArray.count; i++) {
        dispatch_semaphore_wait(semaphoreMovies, DISPATCH_TIME_FOREVER);//等待信号量 有闲置的信号量就让新的任务进来，如果没有就按照顺序等待闲置的信号量 可以设置等待时间
        dispatch_async(queueMovies, ^{
            //模拟下载任务
            NSLog(@"%@开始下载",moviesArray[i]);
            sleep(10+i*2);//假设下载一集需要10+i*2秒
            NSLog(@"%@下载完成",moviesArray[i]);
            dispatch_semaphore_signal(semaphoreMovies);//发送信号量 发送完成进度
        });
    }
    dispatch_queue_t queueshili = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphoreshili = dispatch_semaphore_create(5);
    
    for (int i = 0 ; i<20; i++) {
        dispatch_semaphore_wait(semaphoreshili, DISPATCH_TIME_FOREVER);
        dispatch_async(queueshili, ^{
            NSLog(@"任务%d开始",i);
            sleep(i);
            NSLog(@"任务%d结束",i);
            dispatch_semaphore_signal(semaphoreshili);
        });
    }
}
#pragma mark- asyncBarrier栅栏函数
/**
 栅栏函数
 <一>什么是dispatch_barrier_async函数
 毫无疑问,dispatch_barrier_async函数的作用与barrier的意思相同,在进程管理中起到一个栅栏的作用,它等待所有位于barrier函数之前的操作执行完毕后执行,并且在barrier函数执行之后,barrier函数之后的操作才会得到执行,该函数需要同dispatch_queue_create函数生成的concurrent Dispatch Queue队列一起使用
 
 <二>dispatch_barrier_async函数的作用
 
 1.实现高效率的数据库访问和文件访问
 
 2.避免数据竞争
 */
- (void)asyncBarrier{
    //同dispatch_queue_create函数生成的concurrent Dispatch Queue队列一起使用
    dispatch_queue_t queuezhalan = dispatch_queue_create("zhalanqueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queuezhalan, ^{
        NSLog(@"栅栏函数----1-----%@", [NSThread currentThread]);
    });
    
    dispatch_async(queuezhalan, ^{
        NSLog(@"栅栏函数----2-----%@", [NSThread currentThread]);
    });
    
    dispatch_async(queuezhalan, ^{
        NSLog(@"栅栏函数----3-----%@", [NSThread currentThread]);
    });
    
    dispatch_async(queuezhalan, ^{
        NSLog(@"栅栏函数----4-----%@", [NSThread currentThread]);
    });
    
    dispatch_barrier_async(queuezhalan, ^{
        NSLog(@"栅栏函数----barrier-----%@", [NSThread currentThread]);
    });
    
    dispatch_async(queuezhalan, ^{
        NSLog(@"栅栏函数----5-----%@", [NSThread currentThread]);
    });
    dispatch_async(queuezhalan, ^{
        NSLog(@"栅栏函数----6-----%@", [NSThread currentThread]);
    });
}

// 模拟当前线程正好繁忙的情况
- (void)simulateBusy:(NSString *)str{
    NSLog(@"str %@",str);

    NSLog(@"定时器开始创建");
    NSTimer *timer1 = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerRequest) userInfo:nil repeats:YES];
    //没有把定时器添加到RunLoop中
    /**
     我们前面自己动手添加runloop的时候，可以看到有一个参数runloopMode，这个参数是干嘛的呢？
     前面提到了要想timer生效，我们就得把它添加到指定runloop的指定mode中去，通常是主线程的defalut mode。但有时我们这样做了，却仍然发现timer还是没有触发事件。这是为什么呢？
     这是因为timer添加的时候，我们需要指定一个mode，因为同一线程的runloop在运行的时候，任意时刻只能处于一种mode。所以只能当程序处于这种mode的时候，timer才能得到触发事件的机会。
     举个不恰当的例子，我们说兄弟几个分别代表runloop的mode，timer代表他们自己的才水桶，然后一群人去排队打水，只有一个水龙头，那么同一时刻，肯定只能有一个人处于接水的状态。也就是说你虽然给了老二一个桶，但是还没轮到它，那么你就得等，只有轮到他的时候你的水桶才能碰上用场。
     */
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //创建定时器
    //    [[NSRunLoop currentRunLoop] addTimer:timer3 forMode:NSRunLoopCommonModes];

//        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];
//
//    });
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //创建定时器
//        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];
//    });
    timer1 = timer1;
    NSLog(@"定时器创建完成");
    
    
//    NSLog(@"start simulate busy!");
//    NSUInteger caculateCount = 0x0FFFFFFF;
//    CGFloat uselessValue = 0;
//    for (NSUInteger i = 0; i < caculateCount; ++i) {
//        uselessValue = i / 0.3333;
//    }
//    NSLog(@"finish simulate busy!");
}
- (void)timerRequest{
    count1 ++;
    labelName.text = [NSString stringWithFormat:@"计时器当前计数:%d",count1];
    NSLog(@"定时器开始。。。");
}

///TODO:设置 MaxConcurrentOperationCount（最大并发操作数）
/// NSOperationQueue
- (void)setMaxConcurrentOperationCount {

    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    // 2.设置最大并发操作数
    queue.maxConcurrentOperationCount = 1; // 串行队列
// queue.maxConcurrentOperationCount = 2; // 并发队列
// queue.maxConcurrentOperationCount = 8; // 并发队列

    // 3.添加操作
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
}
/**
 * 使用 addOperation: 将操作加入到操作队列中
 * 使用 NSOperation 子类创建操作，并使用 addOperation: 将操作加入到操作队列后能够开启新线程，进行并发执行
 */
- (void)operationQueue{
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 2.创建操作
    // 使用 NSInvocationOperation 创建操作1
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(other) object:nil];
    
    // 使用 NSInvocationOperation 创建操作2
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(other) object:nil];
    
    // 使用 NSBlockOperation 创建操作3
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op3 addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    // 3.使用 addOperation: 添加所有操作到队列中
    [queue addOperation:op1]; // [op1 start]
    [queue addOperation:op2]; // [op2 start]
    [queue addOperation:op3]; // [op3 start]
}

////并发队列
//- (NSString *)someString {
//    __block NSString *localSomeString;
//    dispatch_sync(_queue, ^{
//        localSomeString = _someString;
//    });
//    return localSomeString;
//}
//- (void)setSomeString:(NSString *)someString {
//    dispatch_barrier_async(_queue, ^{
//        _someString = someString;
//    });
//}

///TODO:线程间通信  可以看到：通过线程间的通信，先在其他线程中执行操作，等操作执行完了之后再回到主线程执行主线程的相应操作。

- (void)communication {
    
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    // 2.添加操作
    [queue addOperationWithBlock:^{
        // 异步进行耗时操作
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
        
        // 回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 进行一些 UI 刷新等操作
            for (int i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
                NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
            }
        }];
    }];
}
//定义block类型
typedef void(^KYSBlock)(void);
///TODO:线程锁
- (void)pthreadLock{
    CFTimeInterval timeBefore;
    CFTimeInterval timeCurrent;
    NSUInteger i;
    NSUInteger count = 1000*10000;//执行一千万次
    //@synchronized
    id obj = [[NSObject alloc]init];;
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++){
        @synchronized(obj){
        }
    }
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("@synchronized used : %f\n", timeCurrent-timeBefore);
    //NSLock
    NSLock *lock = [[NSLock alloc]init];
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++){
        [lock lock];
        [lock unlock];
    }
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("NSLock used : %f\n", timeCurrent-timeBefore);
    //NSCondition
    NSCondition *condition = [[NSCondition alloc]init];
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++){
        [condition lock];
        [condition unlock];
    }
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("NSCondition used : %f\n", timeCurrent-timeBefore);
    //NSConditionLock
    NSConditionLock *conditionLock = [[NSConditionLock alloc]init];
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++){
        [conditionLock lock];
        [conditionLock unlock];
    }
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("NSConditionLock used : %f\n", timeCurrent-timeBefore);
    //NSRecursiveLock
    NSRecursiveLock *recursiveLock = [[NSRecursiveLock alloc]init];
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++){
        [recursiveLock lock];
        [recursiveLock unlock];
    }
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("NSRecursiveLock1 used : %f\n", timeCurrent-timeBefore);
    
    timeBefore = CFAbsoluteTimeGetCurrent();
    KYS_GLOBAL_QUEUE(^{
        static void (^RecursiveBlock)(int);
        RecursiveBlock = ^(int value) {
            [recursiveLock lock];
            if (value > 0) {
                NSLog(@"加锁层数 %d", value);
                sleep(1);
                RecursiveBlock(--value);
            }
            [recursiveLock unlock];
        };
        RecursiveBlock(3);
    });
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("NSRecursiveLock2 used : %f\n", timeCurrent-timeBefore);

    //pthread_mutex
    pthread_mutex_t mutex =PTHREAD_MUTEX_INITIALIZER;
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++){
        pthread_mutex_lock(&mutex);
        pthread_mutex_unlock(&mutex);
    }
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("pthread_mutex used : %f\n", timeCurrent-timeBefore);
    //dispatch_semaphore
    dispatch_semaphore_t semaphore =dispatch_semaphore_create(1);
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++){
        dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);
        dispatch_semaphore_signal(semaphore);
    }
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("dispatch_semaphore used : %f\n", timeCurrent-timeBefore);
    //参数可以理解为信号的总量，传入的值必须大于或等于0，否则，返回NULL
    //dispatch_semaphore_signal +1
    //dispatch_semaphore_wait等待信号，当<=0时会进入等待状态，否则，-1
    __block dispatch_semaphore_t semaphoree = dispatch_semaphore_create(1);
    KYS_GLOBAL_QUEUE(^{
        dispatch_semaphore_wait(semaphoree, DISPATCH_TIME_FOREVER);
        NSLog(@"这里简单写一下用法，可自行实现生产者、消费者");
        sleep(1);
        dispatch_semaphore_signal(semaphoree);
    });
    //OSSpinLockLock
//    OSSpinLock spinlock = OS_SPINLOCK_INIT;
//    timeBefore = CFAbsoluteTimeGetCurrent();
//    for(i=0; i<count; i++){
//        OSSpinLockLock(&spinlock);
//        OSSpinLockUnlock(&spinlock);
//    }
//    timeCurrent = CFAbsoluteTimeGetCurrent();
//    printf("停用OSSpinLock used : %f\n", timeCurrent-timeBefore);
    
    /**
     * @synchronized used : 1.090570
     * NSLock used : 0.194595
     * NSCondition used : 0.188667
     * NSConditionLock used : 0.627998
     * NSRecursiveLock used : 0.423586
     * pthread_mutex used : 0.191954
     * dispatch_semaphore used : 0.139354
     * OSSpinLock used : 0.077738
     */
    
}
//同步锁
- (NSString *)someString {
    @synchronized(self) {
        return _someString;
    }
}
- (void)setSomeString:(NSString *)someString {
    @synchronized(self) {
        _someString = someString;
    }
}
//执行一次，之后用到，不在定义
#define KYS_GLOBAL_QUEUE_ONCE(block) \
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ \
    block();\
})
- (void)lock{
    NSConditionLock *conditionLock = [[NSConditionLock alloc] initWithCondition:0];
    
    KYS_GLOBAL_QUEUE_ONCE(^{
        for (int i=0;i<3;i++){
            [conditionLock lock];
            NSLog(@"线程 0:%d",i);
            sleep(1);
            [conditionLock unlockWithCondition:i];
        }
    });
    
    sleep(1);
    
    KYS_GLOBAL_QUEUE_ONCE(^{
        [conditionLock lock];
        NSLog(@"线程 1");
        [conditionLock unlock];
    });
    
    KYS_GLOBAL_QUEUE_ONCE(^{
        [conditionLock lockWhenCondition:2];
        NSLog(@"线程 2");
        [conditionLock unlockWithCondition:0];
    });
    
    KYS_GLOBAL_QUEUE_ONCE(^{
        [conditionLock lockWhenCondition:1];
        NSLog(@"线程 3");
        [conditionLock unlockWithCondition:2];
    });
    
    KYS_GLOBAL_QUEUE_ONCE(^{
        [conditionLock lockWhenCondition:0];
        NSLog(@"线程 4");
        [conditionLock unlockWithCondition:1];
    });
}
- (void)getMyBestMethod:(void (^)(NSString *))then{
    NSString* str = @"HelloWorld";
    if (then) {
        then(str);
    }
}
+ (void)getMyBestMethod:(void (^)(NSDictionary  *dict))then{
    NSDictionary* dictA = @{@"key":@"value"};
    if (then) {
        then(dictA);
    }
}
- (void)showIndex:(NSInteger)index
{
    void (^showEvent)(NSInteger) = ^(NSInteger aIndex)
    {
        NSLog(@"%ld", (long)aIndex);
    };
    showEvent(index);
}


- (void)backBlockNilMetnod{
	self.returnTextBlock(@"backBlockNilMetnod");
	[self dismissViewControllerAnimated:YES completion:nil];

}
- (void)returnText:(ReturnTextBlock)block {
	self.returnTextBlock = block;
}
- (void)other{
    
}
///倒计时
- (void)countDown
{
    __block int timeout=60; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                self.timeCount.enabled = YES;
//                [self.timeCount setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }else{
//            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                self.timeCount.enabled = NO;
//                [self.timeCount setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (void)dealloc{
    //    [_p fof_removeObserver:self forKeyPath:@"sex" context:nil];
    NSLog(@"释放了");
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
