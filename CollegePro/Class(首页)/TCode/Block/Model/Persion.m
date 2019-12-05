
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
@end
