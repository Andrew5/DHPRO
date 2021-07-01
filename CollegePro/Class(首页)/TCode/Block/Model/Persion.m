
//
//  Persion.m
//  15
//
//  Created by jabraknight on 2018/11/28.
//  Copyright © 2018 大爷公司. All rights reserved.
//

#import "Persion.h"
@interface Persion()
//1 计算的结果
@property(nonatomic,assign) CGFloat resultCalculator;

//2 处理后的字符串
@property(nonatomic,strong) NSString *resultString;
@end
@implementation Persion

/*************************** 计算(加减乘除) *******************************/
+(CGFloat)makeCalculator:(void (^)(Persion *))block{
    if (block) {
        Persion *tool = [[Persion alloc] init];
        block(tool);
        return tool.resultCalculator;
    }
    return 0;
}
/*
1.“^”是一个用来表示第三级运算的数学符号
　在电脑上输入数学公式时，因为不便于输入乘方，该符号经常被用来表示次方。例如2的5次方通常被表示为2^5。而在某些计算器的按键上用这符号来表示次方。（关于乘方的运算，参见乘方）
　　＂^＂是一种位逻辑运算符
　　^
-----按位异或（Xor）是一种可逆运算符，只有在两个比较的位不同时其结果是1，否则结果为0。因此在计算时应先将数值转为二进制，进行位比较，然后把所得的结果转换为原来的进制数。

 */
/*
 void (^testBlock3)(void) = ^(){
 age = age+1-1;
 };
 blockSave x = ^{
 NSLog(@"(++age):%d", ++age);    // 变量前不加__block的情况下，会报错，变量的值只能获取，不能更改
 };
 
 subVC.myReturnTextBlock = ^(NSString *showText){
 NSLog(@"showText  %@",showText);
 //        instancetype用来在编译期确定实例的类型,而使用id的话,编译器不检查类型, 运行时检查类型
 //        instancetype和id一样,不做具体类型检查
 //        id可以作为方法的参数,但instancetype不可以
 //        instancetype只适用于初始化方法和便利构造器的返回值类型
 };
 */
- (void)useBlock{
    NSLog(@"计算结果1-->%f",[Persion makeCalculator:^(Persion *rj_tool) {
        rj_tool.plus(10).subtract(2).multiply(5).divide(8);
    }]);
    
    NSLog(@"计算结果2-->%f",[Persion makeCalculator:^(Persion *rj_tool) {
        rj_tool.plus(10);
        rj_tool.subtract(2);
        rj_tool.multiply(5);
        rj_tool.divide(5);
    }]);
    
    NSLog(@"计算结果:-->%@",[Persion makeAppendingString:^(Persion *rj_tool) {
        rj_tool.date(@"今天").who(@"我和她").note(@"嘿嘿嘿");
    }]);
}
-(RJCalculator)plus{
    return [^(CGFloat num){
        self.resultCalculator += num;
        return self;
    }copy];
}
-(RJCalculator)subtract{
    return [^(CGFloat num){
        self.resultCalculator -= num;
        
        return self;
    }copy];
}
-(RJCalculator)multiply{
    return [^(CGFloat num){
        self.resultCalculator *= num;
        
        return self;
    }copy];
}
-(RJCalculator)divide{
    return [^(CGFloat num){
        self.resultCalculator /= num;
        
        return self;
    }copy];
}
/*************************** 计算(加减乘除) *******************************/



/*************************** 拼接字符串 *******************************/
+(NSString *)makeAppendingString:(void (^)(Persion *))block{
    if (block) {
        Persion *tool = [[Persion alloc] init];
        tool.resultString = @"date,who一起去看电影,备注:note";
        block(tool);
        return tool.resultString;
    }
    return @"为什么你什么都不说?";
}
-(Persion *(^)(NSString *))date{
    return [^(NSString *str){
        self.resultString = [self.resultString stringByReplacingOccurrencesOfString:@"date" withString:str];
        
        return self;
    }copy];
}
-(Persion *(^)(NSString *))who{
    return [^(NSString *str){
        self.resultString = [self.resultString stringByReplacingOccurrencesOfString:@"who" withString:str];
        
        return self;
    }copy];
}
-(Persion *(^)(NSString *))note{
    return [^(NSString *str){
        self.resultString = [self.resultString stringByReplacingOccurrencesOfString:@"note" withString:str];
        
        return self;
    }copy];
}

/*************************** 拼接字符串 *******************************/
- (void)test
{
    __block int age = 20;
    int *ptr = &age;
    void (^textBlock)(void) = ^{
        NSLog(@"(++age):%d", ++age);
    };
    textBlock();
    
    // 对block进行retain、release、copy，retainCount都不会变化，都为1
    //    [textBlock retain];
    //    [textBlock copy];
    //    [textBlock release];
    
//    NSLog(@"Test: textBlock:%@, (*ptr):%d, %lu", textBlock, *ptr, (unsigned long)[textBlock retainCount]);
    NSLog(@"Test: textBlock:%@, (*ptr):%d", textBlock, *ptr);

    /**
     MRC下：(++age):21   (*ptr):21
     */
    
#pragma mark - 对栈中的block进行copy
    // 不引用外部变量
    /* 这里打印的是__NSGlobalBlock__类型，但是通过clang改写的底层代码指向的是栈区：impl.isa = &_NSConcreteStackBlock
     这里引用巧神的一段话：由于 clang 改写的具体实现方式和 LLVM 不太一样，并且这里没有开启 ARC。所以这里我们看到 isa 指向的还是__NSStackBlock__。但在 LLVM 的实现中，开启 ARC 时，block 应该是 __NSGlobalBlock__ 类型
     */
    void (^testBlock1)(void) = ^(){
        
    };
    void (^testBlock2)(void) = [testBlock1 copy];
    NSLog(@"Test: testBlock1: %@, testBlock2: %@", testBlock1, testBlock2);
//    [testBlock2 release];
    
    // 引用外部变量，block为__NSStackBlock__类型
    void (^testBlock3)(void) = ^(){
        age = age+1-1;
    };
    void (^testBlock4)(void) = [testBlock3 copy];
    NSLog(@"Test: testBlock3: %@, testBlock4: %@", testBlock3, testBlock4);
//    [testBlock4 release];
}

- (void (^)(float))add
{
    __weak typeof(self) wself = self;
    void (^result)(float) = ^(float value){
        wself.tmp += value;
    };
    return result;
}

NSString *lhString=@"hello-extern";
-(instancetype)initWithProperty:(NSDictionary *)property{
    if (self =[super init]) {
        NSLog(@"----%@",property);
    }
    return self;
}
+(void)numberInforDic:(void (^)(NSDictionary * _Nonnull))inforBlock
{
    NSLog(@"----%@",inforBlock);
}

/*************************** 静态字符串 *******************************/
/*
一、引用inline标示符

引用inline标示符，能够使函数一作为一个标准的内联函数，函数的代码被放入符号表中，在使用时直接进行替换，（像宏一样展开）。

一般情况下引入内联函数是为了解决函数调用效率的问题，函数之间调用，是内存地址之间的调用，当函数调用完毕之后还会返回原来函数执行的地址，会有一定的时间开销，内联函数就是为了解决这一问题。
不用inline修饰的函数，汇编时会调用 call 指令，调用call指令就是就需要：

1)将下一条指令的所在地址入栈
2)并将子程序的起始地址送入PC（于是CPU的下一条指令就会转去执行子程序）.
GCC中的inline函数可以相当于在一个普通的全局函数加上inline属性。inline关键字仅仅是建议编译器在编译的时候做内联展开处理，而不是强制在gcc编译器中，编译器可以忽略这个建议的，某一些情况下编译器会自动忽略这个inline，将这个函数还原成普通函数。如果编译选项设置为负无穷，即使是inline函数也不会被内联展开，除非设置了强制内联展开的属性(attribute((always_inline)))，即NS_INLINE这个宏定义。

二、引用static标示符

通常情况下使用是用作声明静态变量。

1）修饰局部变量的时候，让局部变量只初始化一次，局部变量在程序中只有一份内存，但是并不会改变局部变量的作用域，仅仅是改变了局部变量的生命周期（只到程序结束，这个局部变量才会销毁）。
2）修饰全局变量的时候，全局变量的作用域仅限于当前文件。
当修饰函数的时候，对函数的连接方式产生影响，使得函数只在本文件内部有效，对其他文件是不可见的。这样的函数又叫作静态函数。使用静态函数的好处是，不需要担心在其他文件存在同名的函数从而产生干扰。

如果想要其他文件可以引用本地函数，则要在函数定义时使用关键字extern，表示该函数是外部函数，可供其他文件调用。另外在要引用别的文件中定义的外部函数的文件中，使用extern声明要用的外部函数即可。

另外也因为使用了static修饰，从而保证了不会不断地调用copy，保证了函数地址的一致性，减小了内存压力。

三、没有使用以上两个标识符修饰

简单浏览一下这个函数，我们可以发现这个函数是一个单例方法的构造，相对比较少见的用法，相对简洁，本仍然是一个简单的函数方法，可以被外界用CG_EXTERN调用。

用static修饰的函数，本限定在本源码文件中，不能被本源码文件以外的代码文件调用。而普通的函数，默认是extern的，也就是说，可以被其它代码文件调用该函数。
 总结

 一、为什么inline函数能取代宏？

 1）#define定义的函数要有特别的格式要求，并不是每个人都能熟练使用，而使用`inline`则就行平常写函数那样。
 2）和其他的宏定义一样，使用define宏定义的代码，编译器不会对其进行参数有效性检查，很容易出现无法察觉的错误，调试过程中会出现很多麻烦。
 3）不仅是输入类型，#define宏定义的代码，返回值不能被强制转换成可转换的适合的转换类 。
 4）#define是文本替换，需要在预编译时展开，内联函数是编译时候展开。
 二、inline函数优点相比于普通函数:

 1)inline函数避免了普通函数的,在汇编时必须调用call的缺点：取消了函数的参数压栈，减少了调用的开销,提高效率.所以执行速度确比一般函数的执行速度要快.
 2)集成了宏的优点,使用时直接用代码替换(像宏一样);
 三、inline内联函数的说明

 1）内联函数只是我们向编译器提供的申请，编译器不一定采取inline形式调用函数。
 2）内联函数不能承载大量的代码，如果内联函数的函数体过大，编译器会自动放弃内联。
 3）内联函数内不允许使用循环语句或开关语句。
 4）内联函数的定义须在调用之前。
 5）当使用内联函数时，如果在多处调用了此内联函数，则此函数就会有N次代码段的拷贝，所以多配合`static`标示符使用。
 使用内敛函数的目的

 为了解决函数调用效率的问题
 由于函数之间的调用，会从一个内存地址调到另一个内存地址，当函数调用完毕后还会返回原来函数执行的地址，会有一定的时间开销。
 内敛函数和普通函数的区别

 我们都知道函数不管是OC还是C/C++最终都需要编译成汇编指令，才能真正执行。普通函数在被调用的时候需要CPU执行CALL指令不同（需要完成程序计数器压栈->执行要执行的函数语句->出栈程序计数器），内联函数不需要这个调用过程，内联函数在编译的时候，会直接在需要执行内联函数的地方（普通函数执行CALL的汇编语句处）将内联函数的汇编片段copy一份并插入到此处，代替CALL指令（类似于宏定义），而不需要普通函数的CALL指令调用过程。因此内联函数的执行效率是比较高的，但是由于copy代码片段，需要内存消耗，所以内联函数是一种以空间换时间的方法。
 使用方法

 使用inline修饰的函数，在编译的时候，会把代码直接嵌入调用代码中。就相当于用#define 宏定义来定义一个add 函数那样！

 #define定义的格式要有要求，而使用inline则就行平常写函数那样，只要加上```inline``即可！

 使用#define宏定义的代码，编译器不会对其进行参数有效性检查，仅仅只是对符号表进行替换。

 #define宏定义的代码，其返回值不能被强制转换成可转换的适合的转换类型。

 static inline int add(int a, int b){
     return a + b;
 }
 在inline加上```static``修饰符，只是为了表明该函数只在该文件中可见！也就是说，在同一个工程中，就算在其他文件中也出现同名、同参数的函数也不会引起函数重复定义的错误！

 内联函数通常都是比较简单的代码片段，不能包含循环，递归（递归函数的内联扩展可能引起部分编译器的无穷编译）等的复杂流程，代码最好不要超过5行
 ————————————————
 
 */

@end
