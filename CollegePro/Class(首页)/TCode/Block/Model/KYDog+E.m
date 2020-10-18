//
//  KYDog+E.m
//  CollegePro
//
//  Created by jabraknight on 2020/4/21.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "KYDog+E.h"


@implementation KYDog (E)
-(void)loadNameValue:(NSString *)na{
    NSLog(@"name指针地址:%p,name指针指向的对象内存地址:%p",&na,na);
    NSLog(@"此方法为补救方法");
}
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    if([NSStringFromSelector(sel) isEqualToString:@"loadNameValue:"]){
        SEL selA = @selector(loadNameValue:);
        Method methodA = class_getInstanceMethod(self.class, @selector(loadNameValue:));
        class_addMethod(self.class, selA, class_getMethodImplementation(self.class, @selector(loadNameValue:)), method_getTypeEncoding(methodA));
//        class_addMethod(self.class,NSSelectorFromString(@"buchongmethod:"), (IMP)buchongmethod,"@:");//给对象添加一个方法
        return [super resolveInstanceMethod:sel];//重新发送
    }
    return NO;
}
- (id)forwardingTargetForSelector:(SEL)aSelector{
    if([NSStringFromSelector(aSelector) isEqualToString:@"loadNameValue:"]){
        KYDog *people = [[KYDog alloc]init];
        NSLog(@"新生成一个People对象%@，让他来帮我们完成eat的动作",people);
        return people;//返回新的对象，让新的对象去执行新对象中的eat方法
    }
    return nil;
}
-(NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector
{
    if([NSStringFromSelector(aSelector) isEqualToString:@"loadNameValue:"]){
        //是我们要处理的方法
        //第一步生成方法信号，告诉系统我们找到了这个方法的处理方式了
        NSMethodSignature *methodSignature = [super methodSignatureForSelector:aSelector];
        if(!methodSignature) {
            methodSignature = [NSMethodSignature signatureWithObjCTypes:"v@:*"];//https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
        }
        return methodSignature;
    }
    NSLog(@"没有这个方法的处理方式");
    return nil;//返回nil的时候，系统就会抛出unrecognized selector sent to的错误。
}
- (void)forwardInvocation:(NSInvocation *)anInvocation{
    
}

@end
