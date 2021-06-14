//
//  UIGestureRecognizer+Analysis.m
//  OneKeyAnalysis
//
//  Created by Rillakkuma on 2021/1/2.
//  Copyright © 2018年 Rillakkuma. All rights reserved.
//

#import "UIGestureRecognizer+Analysis.h"
#import "MethodSwizzingTool.h"
#import <objc/runtime.h>
#import "UIGestureRecognizer+gesture.h"
#import "DataContainer.h"
#import "CaptureTool.h"

@implementation UIGestureRecognizer (Analysis)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [MethodSwizzingTool swizzingForClass:[self class] originalSel:@selector(initWithTarget:action:) swizzingSel:@selector(vi_initWithTarget:action:)];
    });
}

- (instancetype)vi_initWithTarget:(nullable id)target action:(nullable SEL)action
{
    UIGestureRecognizer *selfGestureRecognizer = [self vi_initWithTarget:target action:action];
    
    if (!target && !action) {
        return selfGestureRecognizer;
    }
    
    if ([target isKindOfClass:[UIScrollView class]]) {
        return selfGestureRecognizer;
    }
    
    Class class = [target class];
    
    
    SEL sel = action;
    
    NSString * sel_name = [NSString stringWithFormat:@"%s/%@", class_getName([target class]),NSStringFromSelector(action)];
    SEL sel_ =  NSSelectorFromString(sel_name);
    
    BOOL isAddMethod = class_addMethod(class,
                                       sel_,
                                       method_getImplementation(class_getInstanceMethod([self class], @selector(responseUser_gesture:))),
                                       nil);
    
    self.methodName = NSStringFromSelector(action);
    if (isAddMethod) {
        Method selMethod = class_getInstanceMethod(class, sel);
        Method sel_Method = class_getInstanceMethod(class, sel_);
        method_exchangeImplementations(selMethod, sel_Method);
    }
    
    return selfGestureRecognizer;
}


-(void)responseUser_gesture:(UIGestureRecognizer *)gesture
{
    
    NSString * identifier = [NSString stringWithFormat:@"%s/%@", class_getName([self class]),gesture.methodName];
    
    SEL sel = NSSelectorFromString(identifier);
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL,id) = (void *)imp;
        func(self, sel,gesture);
    }
    
    
    NSDictionary * dic = [[[DataContainer dataInstance].data objectForKey:@"GESTURE"] objectForKey:identifier];
    if (dic) {
        
        NSString * eventid = dic[@"userDefined"][@"eventid"];
        NSString * targetname = dic[@"userDefined"][@"target"];
        NSString * pageid = dic[@"userDefined"][@"pageid"];
        NSString * pagename = dic[@"userDefined"][@"pagename"];
        NSDictionary * pagePara = dic[@"pagePara"];
        
        __block NSMutableDictionary * uploadDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [pagePara enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            id value = [CaptureTool captureVarforInstance:self withPara:obj];
            if (value && key) {
                [uploadDic setObject:value forKey:key];
            }
        }];
        
        NSLog(@"\n event id === %@,\n  target === %@, \n  pageid === %@,\n  pagename === %@,\n pagepara === %@ \n", eventid, targetname, pageid, pagename, uploadDic);
        
    }
}

@end
