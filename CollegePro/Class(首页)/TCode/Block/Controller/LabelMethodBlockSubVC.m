//
//  LabelMethodBlockSubVC.m
//  Test
//
//  Created by Rillakkuma on 2016/11/29.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "LabelMethodBlockSubVC.h"

#import "Persion.h"
#import "KYDog.h"
#import "SFTextView.h"
#include <stdlib.h>
#include <stdio.h>
#import <malloc/malloc.h>
#import <objc/message.h>
#import <CommonCrypto/CommonCrypto.h>

#import "WeakProxy.h"
#import "TempTarget.h"
#import "CancelableObject.h"
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

@interface LabelMethodBlockSubVC ()
{
    //成员变量
    int numC;
    BOOL chooseState;
}
// 属性声明的block都是全局的__NSGlobalBlock__
@property (nonatomic, copy) void (^copyBlock)(void);
@property (nonatomic, weak) void (^weakBlock)(void);

//测试字符串⬇️⬇️⬇️
@property(nonatomic,copy)NSString*str1;
@property(nonatomic,strong)NSString*str2;
@property(nonatomic,strong) NSString *rtcMessageID;
//测试字符串⬆️⬆️⬆️

@property(nonatomic, strong)SFTextView *textF;

@property (nonatomic, strong)KYUser *user;

@property(nonatomic,strong)Persion* p;

//解除timer循环引用
//@property (nonatomic, weak) NSTimer *timer;
//GCD解除timer循环引用
@property (nonatomic, strong) dispatch_source_t timer;

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
    self.navigationItem.title = @"Block知识";

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
    //函数式编程、链式编程优缺点
    //Block的底层实现原理
    [self baseBlock];
    //NSTimer循环引用解决方案
    [self getquoteof];
    
    void (^ MtTestBlock)(int,int)=^(int a,int b){
        int v= a+b;
        NSLog(@"%d",v);
    };
    MtTestBlock(10,20);

}
///TODO:NSTimer
- (void)getquoteof{
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
//    [self testDataN];//KVO进阶
//    [self testDataO];
//    [self testDataT];//访问私有变量
//    [self testDataQ];
    [self testDataR];
//    [self testDataSS];
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
    
    self.weakBlock = ^{
        
    };
    NSLog(@"2：%@", self.weakBlock);
    
#pragma mark - copyBlock （使用函数内变量） __NSMallocBlock__
    
    self.copyBlock = ^{
        age = age+1-1;
    };
    NSLog(@"3：%@", self.copyBlock);
    
#pragma mark - weakBlock（使用函数内变量） __NSStackBlock__
    
    self.weakBlock = ^{
        age = age+1-1;
    };
    NSLog(@"4：%@", self.weakBlock);
    
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
    // Do any additional setup after loading the view.
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
    self.user.userId = @"35325";
    // MRC下
    Persion *test = [[Persion alloc] init];
    [test test];
    [self getPrivateVarWithClass:self.user.dog];

    // 1、添加KVO监听
    //NSKeyValueObservingOptionInitial 观察最初的值 在注册观察服务时会调用一次
    //NSKeyValueObservingOptionPrior 分别在被观察值的前后触发一次 一次修改两次触发
    [self.user addObserver:self forKeyPath:@"dog.name" options:NSKeyValueObservingOptionNew context:nil];
    
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
    
    KYDog *person = [KYDog new];
    NSLog(@"%zd", class_getInstanceSize([KYDog class])); // 输出为56
        NSLog(@"%zd", malloc_size((__bridge const void *)(person))); // 输出为 64
    //    NSLog(@"%zd",malloc(person));
        NSLog(@"%ld",sizeof(person));
    //malloc() 函数和calloc ()函数的主要区别是前者不能初始化所分配的内存空间，而后者能
    NSLog(@"%zd", class_getInstanceSize([KYDog class])); // 输出为8
    NSLog(@"%zd", malloc_size((__bridge const void *)(person))); // 输出为 16
    NSLog(@"%lu",sizeof(person)); // 输出为8
    [person loadNameValue:@"name"];

    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([KYDog class], &count);
    //对私有变量的更改
    Ivar namevar = ivars[4];
    object_setIvar(person, namevar, @"456");
    NSString *privateName = object_getIvar(person, namevar);
    NSLog(@"privateName : %@",privateName);
    NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(namevar)];
    ivarName = [ivarName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    ivarName = [ivarName stringByReplacingOccurrencesOfString:@"@" withString:@""];
    if ([ivarName containsString:@"privateName"]) {
        object_setIvar(person, namevar, @"我的名字");
        NSString *privateName = object_getIvar(person, namevar);
        NSLog(@"privateName %@",privateName);
    }
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
    
    //else   若当前类无法捕捉到这个KVO，那很有可能是在他的superClass，或者super-superClass...中
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
}
// 3、触发修改属性值
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.user.userId = @"123456789";
    //    self.user.dog.name = @"肖";
    self.user.dog.age = 15;
    [self.user.dog setValue:@"20.0" forKey:@"name"];
    
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
//多请求结束后统一操作
//例：如一个页面多个网络请求后刷新UI
- (void)testDataQ {
    //模拟并发后统一操作数据
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求1
        NSLog(@"Request_1");
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
        NSLog(@"Request_2");
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求3
        NSLog(@"Request_3");
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //界面刷新
        NSLog(@"任务均完成，刷新界面");
    });
}
//多请求顺序执行
//例：如第二个请求需要第一个请求的数据来操作
- (void)testDataR {
    // 1.任务一：获取用户信息
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"Request_1");
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
        NSLog(@"Request_2");
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
//enter leave
- (void)testDataSS {
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"Request_1");
        sleep(3);
        NSLog(@"Request1完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"Request_2");
        sleep(1);
        NSLog(@"Request2完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"Request_3");
        sleep(2);
        NSLog(@"Request3完成");
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group,  dispatch_get_main_queue(), ^{
        
        NSLog(@"全部完成.%@",[NSThread currentThread]);
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
- (void)getMyBestMethod:(void (^)(NSString *))then{
    
    NSString* str = @"HelloWorld";
    if (then) {
        then(str);
    }
    
}
-(void)showIndex:(NSInteger)index
{
    void (^showEvent)(NSInteger) = ^(NSInteger aIndex)
    {
        NSLog(@"%ld", aIndex);
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
