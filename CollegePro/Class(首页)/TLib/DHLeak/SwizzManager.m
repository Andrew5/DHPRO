//
//  SwizzManager.m
//  CollegePro
//
//  Created by Rillakkuma on 2018/11/29.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "SwizzManager.h"

@implementation SwizzManager

+ (void)swizzMethodForClass:(Class)clazz originSel:(SEL)originSel newSel:(SEL)newSel{
    
    swizzleMethod(clazz, originSel, newSel);
   
}

+ (void)swizzMethodForClass:(Class)clazz newSelImpClass:(Class)impClass impSel:(SEL)impSel originSel:(SEL)originSel newSel:(SEL)newSel{
    IMP newImp = method_getImplementation(class_getInstanceMethod(impClass, impSel));
    BOOL result = class_addMethod(clazz, newSel, newImp, nil);
    result = result && [self containsSel:originSel inClass:clazz];
    if (result) {
        swizzleMethod(clazz, originSel, newSel);
    }
}
//类是否包含方法
+ (BOOL)containsSel:(SEL)sel inClass:(Class)class{
    
    unsigned int count;
    Method *methodList = class_copyMethodList(class,&count);
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSString *tempMethodString = [NSString stringWithUTF8String:sel_getName(method_getName(method))];
        if ([tempMethodString isEqualToString:NSStringFromSelector(sel)]) {
            return YES;
        }
    }
    
    return NO;
}
//交换方法
void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)
{
    // the method might not exist in the class, but in its superclass
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    // the method doesn’t exist and we just added one
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}


@end
