//
//  TDodgeKeyboard+AccessObject.h
//  btc
//
//  Created by txj on 15/2/12.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "TDodgeKeyboard.h"

#import <objc/runtime.h>

@interface TDodgeKeyboard (AccessObject)

+(void) setObserverView : (UIView*) observerView;
+(UIView*) observerView;

+(void) setFristResponderView : (UIView*) firstResponderView;
+(UIView*) firstResponderView;

+(void) setOriginalViewFrame : (CGRect) originalViewFrame;
+(CGRect) originalViewFrame;

+(void) setKeyboardRect : (CGRect) keyboardRect;
+(CGRect) keyboardRect;

+(void) setKeyboardAnimationDutation : (double) keyboardAnimationDutation;
+(double) keyboardAnimationDutation;

+(void) setIsKeyboardShow : (BOOL) isKeyboardShow;
+(BOOL) isKeyboardShow;

@end

