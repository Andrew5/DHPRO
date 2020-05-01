//
//  UIButton+Delay.m
//  Test001
//
//  Created by StriEver on 16/4/18.
//  Copyright © 2016年 StriEver. All rights reserved.
//

#import "UIButton+Delay.h"
#import <objc/runtime.h>
#define defaultInteral  @"1"
@implementation UIButton (Delay)
- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    if (!self.isNeedDelay) {
        [super sendAction:action to:target forEvent:event];
        return;
    }
    self.delayInterval = [defaultInteral integerValue] ; //倒计时时间
    if (self.timer) {
       dispatch_source_cancel(self.timer);
        self.timer = nil;
    
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    if (!self.timer) {
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    }
    dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
    if(self.delayInterval==0){ //倒计时结束，关闭
        dispatch_source_cancel(self.timer);
        self.timer = nil;
        [super sendAction:action to:target forEvent:event];
        self.delayInterval = [defaultInteral integerValue];
    }else{
        [super sendAction:@selector(handleAction:) to:self forEvent:event];
        self.delayInterval--;
    }
});
      dispatch_resume(self.timer);

}
- (void)handleAction:(id)sender {
	
}
- (NSInteger)delayInterval{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setDelayInterval:(NSInteger)delayInterval{
    objc_setAssociatedObject(self, @selector(delayInterval), @(delayInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
/**
 objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
 
 id object                     :表示关联者，是一个对象，变量名理所当然也是object
 
 const void *key               :获取被关联者的索引key
 
 id value                      :被关联者，这里是一个block
 
 objc_AssociationPolicy policy : 关联时采用的协议，有assign，retain，copy等协议，一般使用OBJC_ASSOCIATION_RETAIN_NONATOMIC
 
 Core Foundation对象简称CF
 ARC环境下编译器不会自动管理CF对象的内存，所以当我们创建了一个CF对象以后就需要我们使用CFRelease将其手动释放
 
 __bridge_transfer:常用在讲CF对象转换成OC对象时，将CF对象的所有权交给OC对象，此时ARC就能自动管理该内存；（作用同CFBridgingRelease()）
 
 __bridge_retained:（与__bridge_transfer相反）常用在将OC对象转换成CF对象时，将OC对象的所有权交给CF对象来管理；(作用同CFBridgingRetain())
 
 CFStringRef cfString= CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)text,NULL,CFSTR("!*’();:@&=+$,/?%#[]"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
 NSString *ocString = (__bridge_transfer CFStringRef)cfString;
 
 */
- (dispatch_source_t)timer{
//#ifdef DEBUG
	return objc_getAssociatedObject(self, _cmd);
//#else
//	return (__bridge dispatch_source_t)(objc_getAssociatedObject(self, _cmd));//ARC环境下 __bridge 涉及对象所有权的转换
//#endif
}
- (void)setTimer:(dispatch_source_t)timer{
//#ifdef DEBUG
	objc_setAssociatedObject(self, @selector(timer),timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//#else
//	objc_setAssociatedObject(self, @selector(timer),CFBridgingRelease(timer), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//#endif
}
- (void)setIsNeedDelay:(BOOL)isNeedDelay{
    // 注意BOOL类型 需要用OBJC_ASSOCIATION_RETAIN_NONATOMIC 不要用错，否则set方法会赋值出错
    objc_setAssociatedObject(self, @selector(isNeedDelay), @(isNeedDelay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isNeedDelay{
    //_cmd == @select(isIgnore); 和set方法里一致
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
@end
