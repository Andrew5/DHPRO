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

NSString * const ABC              = @"extern_iPhone";
//--- const ---//
/** 局部常量 只能内部调用 **/
static const NSString *personA1 = @"a1";//用static修饰后，不能提供外界访问
static NSString *const personA2 = @"a2";//字符串常量

/** 全局常量 外部可访问 **/
NSString *const personB = @"bb";        //表示无论内容，指向都不能改了
NSString const *personC = @"cc";        //指针指向的内容不可修改
const NSString *personD = @"dd";        //相当于指针本身不可修改

//----extern-----//
/** 全局变量 外部可访问 **/
//注意：在定义全局变量的时候不能初始化，否则会报错！
extern NSString *personE;               //外部调用,动态传参


typedef struct{
    int id;
    float height;
    unsigned char flag;
}MyTestStruct;

@interface Animal : NSObject
-(void)action;
@end
@implementation Animal
- (void)action{
    NSLog(@"animal action");
}
@end
@interface Fish : Animal
-(void)action;
-(void)bubble;
@end
@implementation Fish
- (void)action{
    NSLog(@"Fish can swim");
}
-(void)bubble{
    NSLog(@"Fish can bubble");
}
@end
@interface Bird : Animal
-(void)action;
@end
@implementation Bird
- (void)action{
    NSLog(@"Bird can fly");
}
@end

@interface Dog : Animal
-(void)action;
@end
@implementation Dog
- (void)action{
    NSLog(@"Dog can call");
}
@end
@interface Rabbit : Animal
-(void)action;
@end
@implementation Rabbit
- (void)action{
    NSLog(@"Rabbit can jump");
}
@end

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

// 结构体类型名为 MyDate1
struct MyDate1{
    int year;
    int month;
    int day;
}; // 定义结构体类型变量
//结构体类型名为 MyDate2
typedef struct _MyDate{
    int year;
    int month;
    int day;
} MyDate2;

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
void doAction(Animal *obj){
    [obj action];
}
@implementation LabelMethodBlockSubVC
struct ListNode
{
   char  title[50];
   char  author[50];
   char  subject[100];
   int   book_id;
} book;
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

    ///TODO: NSValue
    MyTestStruct testStruct;
    testStruct.id = 1001;
    testStruct.height = 23.5f;
    testStruct.flag = 1;
    
    NSValue *nsValue= [NSValue valueWithBytes:&testStruct objCType:@encode(MyTestStruct)];
    
    MyTestStruct testStruct2;
    [nsValue getValue:&testStruct2];
    
    NSLog(@"id %i",testStruct2.id);
    NSLog(@"height %f",testStruct2.height);
    NSLog(@"flag %i",testStruct2.flag);
    
    ///TODO:多态 动物园
    Rabbit *rabbit = [[Rabbit alloc]init];
    Dog *dog = [[Dog alloc]init];
    Fish *fish = [[Fish alloc]init];
    Bird *bird = [[Bird alloc]init];

    Animal *zoom[4] = {rabbit,dog,fish,bird};
    for (int i = 0; i<4; i++) {
        doAction(zoom[i]);
    }
    ///多态局限性
    Animal *obj = [[Fish alloc]init];
    [obj action];
    [(Fish *)obj bubble];

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
    
    
    //分类实现timer循环引用
    //    self.timer = [NSTimer mxScheduledTimerWithTimeInterval:0.5 repeats:YES block:^(NSTimer *timer) {
    //        NSLog(@"执行了");
    //    }];
}
- (void)timerStart:(NSTimer *)ti{
    
}

- (void)cate{
    /*
     ///分类为什么不能直接添加属性
     分类并不会改变原有类的内存分布的情况，它是在运行期间决定的，此时内存的分布已经确定，若此时再添加实例会改变内存的分布情况，这对编译性语言是灾难，是不允许的。反观扩展(extension)，作用是为一个已知的类添加一些私有的信息，必须有这个类的源码，才能扩展，它是在编译器生效的，所以能直接为类添加属性或者实例变量。
    
     */
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
//        [self asyncSemaphore];
//        [self asyncBarrier];
//        [self pthreadLock];//线程锁‘
//        [self asyncGroup];
    });
}
//- (void)getIMPFromSelector:(SEL)aSelector {
//    NSLog(@"第一种 IMP class_getMethodImplementation(Class cls, SEL name)")
//    NSLog(@"实例方法")
//    IMP insttanceIMP1 = class_getMethodImplementation(objc_getClass("LabelMethodBlockSubVC"), aSelector);
//    NSLog(@"类方法")
//    IMP classIMP1 = class_getMethodImplementation(objc_getMetaClass("LabelMethodBlockSubVC"), aSelector);
//
//    NSLog(@"第二种 IMP method_getImplementation(Method m)")
//    NSLog(@"实例方法")
//    Method insttanceMethod = class_getInstanceMethod(objc_getClass("LabelMethodBlockSubVC"), aSelector);
//    IMP insttanceIMP2 = method_getImplementation(insttanceMethod);
//    NSLog(@"类方法")
//    Method classMethod1 = class_getClassMethod(objc_getClass("LabelMethodBlockSubVC"), aSelector);
//    IMP classIMP2 = method_getImplementation(classMethod1);
//    NSLog(@"类方法")
//    Method classMethod2 = class_getClassMethod(objc_getMetaClass("LabelMethodBlockSubVC"), aSelector);
//    IMP classIMP3 = method_getImplementation(classMethod2);
//
//    NSLog(@"insttanceIMP1:%p insttanceIMP2:%p classIMP1:%p classIMP2:%p classIMP3:%p", insttanceIMP1, insttanceIMP2, classIMP1, classIMP2, classIMP3);
//}

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
    /*
    NSGlobalBlock：类似函数，位于text段；
    NSStackBlock：位于栈内存，函数返回后Block将无效；
    NSMallocBlock：位于堆内存。
     */

    
}
///TODO:全局block
NSString *__globalString = nil;
- (void)testGlobalObj
{
    __globalString = @"1";
    void (^TestBlock)(void) = ^{
        NSLog(@"string is :%@", __globalString);
    };
    __globalString = nil;
    TestBlock();
}
///TODO:静态block
- (void)testStaticObj
{
    static NSString *__staticString = nil;
    __staticString = @"1";
    printf("static address: %p\n", &__staticString);    //static address: 0x6a8c
    void (^TestBlock)(void) = ^{
        printf("static address: %p\n", &__staticString); //static address: 0x6a8c
        NSLog(@"string is : %@", __staticString);
    };
    __staticString = nil;
    TestBlock();
}
///TODO:局部blcock
- (void)testLocalObj
{
    NSString *__localString = nil;
    __localString = @"1";
    printf("local address: %p\n", &__localString); //local address: 0xbfffd9c0
    void (^TestBlock)(void) = ^{
        printf("local address: %p\n", &__localString); //local address: 0x71723e4
        NSLog(@"string is : %@", __localString); //string is : 1
    };
    __localString = nil;
    TestBlock();
}
 
- (void)testBlockObj
 
{
    __block NSString *_blockString = @"1";
 
    void (^TestBlock)(void) = ^{
 
        NSLog(@"string is : %@", _blockString);
    };
 
    _blockString = nil;
 
    TestBlock();
}
 
- (void)testWeakObj
{
    NSString *__localString = @"1";
 
    __weak NSString *weakString = __localString;
 
    printf("weak address: %p\n", &weakString);  //weak address: 0xbfffd9c4
 
    printf("weak str address: %p\n", weakString); //weak str address: 0x684c
 
    void (^TestBlock)(void) = ^{
 
        printf("weak address: %p\n", &weakString); //weak address: 0x7144324
 
        printf("weak str address: %p\n", weakString); //weak str address: 0x684c
 
        NSLog(@"string is : %@", weakString); //string is :1
    };
 
    __localString = nil;
 
    TestBlock();
 
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
- (void)testDataW{
        /*
         1、结构体只能封装属性，类却不仅可以封装属性也可以封装方法。如果一个封装的数据有属性也有行为，就只能用类了。

         2、结构体变量分配在栈，而OC对象分配在堆，栈的空间相对于堆来说是比较小的，但是存储在栈中的数据访问效率相对于堆而言是比较高

         3、堆的存储空间比较大，存储在堆中的数据访问效率相对于栈而言是比较低的

         4、如果定义一个结构体，这个结构体中有很多属性，那么这个时候结构体变量在栈中会占据很多空间，这样的话就会降低效率

         5、我们使用结构体的时候最好是属性比较少的结构体对象,如果属性较多的话就要使用类了。

         6、结构体赋值的话是直接赋值，对象的指针，赋值的是对象的地址。
         */
        struct MyDate1 d1= {2016, 1, 6};
        NSLog(@"d1: %d/%d/%d", d1.year, d1.month, d1.day);
        MyDate2 d2 = {2016, 5, 24};
        NSLog(@"d2: %d/%d/%d", d2.year, d2.month, d2.day);
        /*
        __block int a = 20;//注意block前面是两个下划线

            void (^myblock)() = ^{

            NSLog(@"a = %d",a);

            a =10; //外部变量有__block声明，所以在block里面可以修改block的值

            NSLog(@"a = %d",a);

            };

            myblock(a);
        ///3、
            int (^sumBlock)(int,int);

            void (^myBlock)();
            
        //    （4）block实现封装代码的3种写法：
        //
        //    第一种：

            ^(int a,int b){

                return a + b;

             };

        //     第二种：

             ^(){

                NSLog(@"a+b");

             };

        //     第三种：

            ^{
                NSLog(@"a+b");
            };
        
        
        //利用typedef定义block类型

        typedef int (^MyBlock)(int,int);

        // 这样就可以利用MyBlock这种类型来定义block变量

        //写法一：利用宏定义去写一个block

        void test(){

        MyBlock block;

        block=^(int a, int b){

             return a - b;

          };

        NSLog(@"%i",block(10,10));//调用block

        }

         //写法2：跟写法一一样，利用宏定义去定义一个block

        void test2(){

        MyBlock b3 = ^(int a,int b){

        return a - b;

        }

        NSLog(@"%i",b3(10,10));//调用block

         };

        //或者写法3：不用宏定义，直接用block的写法，原始用法

        void test3(){

        //定义了一个block，这个block返回值是int类型，接收两个int类型的参数

        int  (^sum) (int,int) = ^(int a,int b){

        return a+b;//该return返回的是block的返回值

        }

        NSLog(@"%i",sum(10,10));//调用block

        }
         */

//        NSLog(@"sizeof:  %zd--%zd", sizeof(staticString),sizeof(defineString));
//        NSLog(@"%lu--%lu",malloc_size((__bridge const void*)staticString),malloc_size((__bridge const void*)defineString));
//        self.staticString = @"结束";
//        NSLog(@"sizeof:%@-静态：%@-%@",self.staticString,staticString,defineString);
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


- (void)function1{
    
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
    self.travel(@"重庆").travel(@"北京").travel(@"上海");
    
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
        sn += avalue;
        bn += avalue;
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
- (void)returnContent:(ReturnCustomValicationBlock _Nonnull )block{
    BOOL result = YES;
    result = block(@"systemContent", @"customContent");

}
- (void)other{
    
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
