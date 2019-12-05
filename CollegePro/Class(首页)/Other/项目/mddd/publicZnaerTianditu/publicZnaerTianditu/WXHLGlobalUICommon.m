//
//  WXHLGlobalUICommon.m
//  WXMovie
//
//  Created by xiongbiao on 12-12-11.
//  Copyright (c) 2012年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "WXHLGlobalUICommon.h"

const CGFloat WXHLkDefaultRowHeight = 44;
              
const CGFloat WXHLkDefaultPortraitToolbarHeight   = 44;
const CGFloat WXHLkDefaultLandscapeToolbarHeight  = 33;

const CGFloat WXHLkDefaultPortraitKeyboardHeight      = 216;
const CGFloat WXHLkDefaultLandscapeKeyboardHeight     = 160;
const CGFloat WXHLkDefaultPadPortraitKeyboardHeight   = 264;
const CGFloat WXHLkDefaultPadLandscapeKeyboardHeight  = 352;

const CGFloat WXHLkGroupedTableCellInset = 9;
const CGFloat WXHLkGroupedPadTableCellInset = 42;

const CGFloat WXHLkDefaulWXHLransitionDuration      = 0.3;
const CGFloat WXHLkDefaultFasWXHLransitionDuration  = 0.2;
const CGFloat WXHLkDefaultFlipTransitionDuration  = 0.7;



///////////////////////////////////////////////////////////////////////////////////////////////////
float WXHLOSVersion()
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL WXHLOSVersionIsAtLeast(float version)
{
    static const CGFloat kEpsilon = 0.0000001;
#ifdef __IPHONE_6_0
    return 6.0 - version >= -kEpsilon;
#endif
#ifdef __IPHONE_5_1
    return 5.1 - version >= -kEpsilon;
#endif
#ifdef __IPHONE_5_0
    return 5.0 - version >= -kEpsilon;
#endif
#ifdef __IPHONE_4_2
    return 4.2 - version >= -kEpsilon;
#endif
#ifdef __IPHONE_4_1
    return 4.1 - version >= -kEpsilon;
#endif
#ifdef __IPHONE_4_0
    return 4.0 - version >= -kEpsilon;
#endif
#ifdef __IPHONE_3_2
    return 3.2 - version >= -kEpsilon;
#endif
#ifdef __IPHONE_3_1
    return 3.1 - version >= -kEpsilon;
#endif
#ifdef __IPHONE_3_0
    return 3.0 - version >= -kEpsilon;
#endif
#ifdef __IPHONE_2_2
    return 2.2 - version >= -kEpsilon;
#endif
#ifdef __IPHONE_2_1
    return 2.1 - version >= -kEpsilon;
#endif
#ifdef __IPHONE_2_0
    return 2.0 - version >= -kEpsilon;
#endif
    return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL WXHLIsKeyboardVisible() {
    // Operates on the assumption that the keyboard is visible if and only if there is a first
    // responder; i.e. a control responding to key events
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    return ![window isFirstResponder];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL WXHLIsPhoneSupported() {
    NSString* deviceType = [UIDevice currentDevice].model;
    return [deviceType isEqualToString:@"iPhone"];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL WXHLIsPad() {
#ifdef __IPHONE_3_2
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
#else
    return NO;
#endif
}


///////////////////////////////////////////////////////////////////////////////////////////////////
UIDeviceOrientation WXHLDeviceOrientation() {
    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationUnknown == orient) {
        return UIDeviceOrientationPortrait;
        
    } else {
        return orient;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL WXHLIsSupportedOrientation(UIInterfaceOrientation orientation) {
    if (WXHLIsPad()) {
        return YES;
        
    } else {
        switch (orientation) {
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                return YES;
            default:
                return NO;
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
CGAffineTransform WXHLRotateTransformForOrientation(UIInterfaceOrientation orientation) {
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI*1.5);
        
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2);
        
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
        
    } else {
        return CGAffineTransformIdentity;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

CGRect WXHLApplicationBounds()
{
    return [UIScreen mainScreen].bounds;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
CGRect WXHLApplicationFrame() {
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    return CGRectMake(0, 0, frame.size.width, frame.size.height);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
CGFloat WXHLToolbarHeightForOrientation(UIInterfaceOrientation orientation) {
    if (UIInterfaceOrientationIsPortrait(orientation) || WXHLIsPad()) {
        return WXHL_ROW_HEIGHT;
        
    } else {
        return WXHL_LANDSCAPE_TOOLBAR_HEIGHT;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
CGFloat WXHLKeyboardHeightForOrientation(UIInterfaceOrientation orientation) {
    if (WXHLIsPad()) {
        return UIInterfaceOrientationIsPortrait(orientation) ? WXHL_IPAD_KEYBOARD_HEIGHT
        : WXHL_IPAD_LANDSCAPE_KEYBOARD_HEIGHT;
        
    } else {
        return UIInterfaceOrientationIsPortrait(orientation) ? WXHL_KEYBOARD_HEIGHT
        : WXHL_LANDSCAPE_KEYBOARD_HEIGHT;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
CGFloat WXHLGroupedTableCellInset() {
    return WXHLIsPad() ? WXHLkGroupedPadTableCellInset : WXHLkGroupedTableCellInset;
}


