#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AlixLibService.h"
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "JSON.h"
#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"
#import "SBJSON.h"
#import "SBJsonBase.h"
#import "SBJsonParser.h"
#import "SBJsonWriter.h"
#import "DataSigner.h"
#import "DataVerifier.h"

FOUNDATION_EXPORT double AliPaySDKVersionNumber;
FOUNDATION_EXPORT const unsigned char AliPaySDKVersionString[];

