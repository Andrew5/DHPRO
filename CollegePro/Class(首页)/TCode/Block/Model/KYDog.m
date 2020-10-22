//
//  KYDog.m
//  15
//
//  Created by jabraknight on 2019/4/9.
//  Copyright © 2019 大爷公司. All rights reserved.
//

#import "KYDog.h"
/** 字号 */
typedef NS_ENUM(NSInteger, HLFontSize) {
    HLFontSizeTitleSmalle = 0x00,
    HLFontSizeTitleMiddle = 0x11,
    HLFontSizeTitleBig = 0x22
};
@interface KYDog()
@property (copy, nonatomic) NSString *privateName;
@property (copy, nonatomic) NSString *privateSex;
@end
@implementation KYDog
/**
 什么是构造方法:初始化对象的方法。一般情况下,在 OC 当中创建1个对象分为两部分(new 做的事):alloc:分配内存空间，init :初始化对象。
 构造方法分为系统自带和自定义构造方法。
 （1）如果是系统自带的构造方法，需要重写父类中自带的构造方法 比如init
 （2）如果是自定义构造方法：属于对象方法那么以-号开头，返回值一般为id或者instancetype类型，方法名一般以init开头
 */
- (instancetype)initWithName:(NSString *)name andAge:(int)age{
    if (self = [super init]) {
        _name = name;
        _age = age;
        _name = [self  setDogName:@"大黄"];
        //6秒后 名叫小花的狗来接替大黄这条狗看家
        [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(changeName)userInfo:nil repeats:NO];
    }
    return self;
}
- (id)init{
    if (self = [super init]) {
        _name = [self  setDogName:@"大黄"];
        _age = 12;
        //6秒后 名叫小花的狗来接替大黄这条狗看家
        _printerData = [[NSMutableData alloc] init];
        
        [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(changeName)userInfo:nil repeats:NO];
    }
    return self;
}
- (void)appendTitle:(NSString *)title value:(NSString *)value valueOffset:(NSInteger)offset
{
    [self appendTitle:title value:value valueOffset:offset fontSize:HLFontSizeTitleSmalle];
    
}

- (void)appendTitle:(NSString *)title value:(NSString *)value valueOffset:(NSInteger)offset fontSize:(HLFontSize)fontSize
{
    
    // 3.设置标题内容
    [self setText:title];
    // 6.换行
    [self appendNewLine];
    
}
#pragma mark - -------------基本操作----------------
/**
 *  换行
 */
- (void)appendNewLine
{
    Byte nextRowBytes[] = {0x0A};
    [_printerData appendBytes:nextRowBytes length:sizeof(nextRowBytes)];
}
- (void)setText:(NSString *)text
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [text dataUsingEncoding:enc];
    [_printerData appendData:data];
}
//name拦截
//-(void)setName:(NSString *)name{
//    if ([_name isEqualToString:name]) {
//        return;
//    }
//    [self willChangeValueForKey:@"name"];
//    _name = name;
//    [self didChangeValueForKey:@"name"];
//
//}
- (void)changeName{
    [self willChangeValueForKey:@"name"];
    [self setValue:@23 forKey:@"age"];
    [self setValue:[self setDogName:@"小花来了"] forKey:@"name"];
    [self didChangeValueForKey:@"name"];
    
}
//-(void)loadNameValue:(NSString *)na{
//    NSLog(@"name指针地址:%p,name指针指向的对象内存地址:%p",&na,na);
//
//}
// 观测者实现协议方法
- (void)doSomething{
    NSLog(@"doSomething :%@", self);
}

- (void)getIvars
{
    unsigned int count = 0;
    // 拷贝出所胡的成员变量列表
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    for (int i = 0; i<count; i++) {
        // 取出成员变量
        Ivar ivar = ivars[i];
        // 打印成员变量的数据类型 成员变量名字
        NSLog(@"%s *%s", ivar_getTypeEncoding(ivar),ivar_getName(ivar));
        NSLog(@"---------------------------------------");
    }
    // 释放
    free(ivars);
}
-(NSString *)setDogName:(NSString *)name{
    return name;
}
//控制是否自动发送通知  大黄走了小花来了一定要告诉主人来 谁在看家
/*
 这里重写
 + (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
 没有什么卵用，只是方便查看调用顺序。因为auto这个方法只和setter相关，而现在是调用自定义方法并且内部直接访问成员变量。
 至于内部设置的那个name拦截，纯属为了娱乐😂
 */
+ (BOOL) automaticallyNotifiesObserversForKey:(NSString*)key{
    // 对于名为dongNameString的变更通知，使用自动通知
    if ([key  isEqualToString:@"name"]){
        return NO;
    }
    if ([key isEqualToString:@"age"]){
        return YES;
    }
    // 确保调用了父类的automaticallyNotfiesObserversForKey方法
    return [super automaticallyNotifiesObserversForKey:key];
}
@end

@implementation KYUser
@dynamic sex;
- (instancetype)init{
    if (self=[super init]) {
        _dog = [[KYDog alloc] init];
        _dog.age = 10;
        _arr = [NSMutableArray array];
    }
    return self;
}
+(NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key{
    NSMutableSet *keyPaths = [NSMutableSet set];
    if ([key isEqualToString:@"dog"]) {
        NSArray *array = @[@"_dog.age",@"_dog.city"];
        [keyPaths addObjectsFromArray:array];
    }
    return keyPaths;
}

-(void)setSex:(NSString *)sex{
    _sex = sex;
}
-(NSString *)getSex{
    return _sex;
}

@end
