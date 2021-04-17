//
//  WXDOMDomainController.h
//  PonyDebugger
//
//  Created by Ryan Olson on 2012-09-19.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "WXPonyDebugger.h"
#import "WXDOMDomain.h"
#import "WXDOMTypes.h"
#import <UIKit/UIKit.h>

@interface WXDOMDomainController : WXDomainController <WXDOMCommandDelegate>

@property (nonatomic, strong) WXDOMDomain *domain;

@property (nonatomic, strong) WXDOMNode *rootDomNode;

+ (WXDOMDomainController *)defaultInstance;
//+ (void)startMonitoringUIViewChanges;
+ (void)startMonitoringWeexComponentChanges;

// The key paths will be reflected as attributes of the DOM node
// Note that support is currently limited to CGPoint, CGSize, CGRect, and numeric types (including BOOL).
// ex @[@"frame", @"bounds", @"alpha", @"hidden"]
@property (nonatomic, strong) NSArray *viewKeyPathsToDisplay;

// These should only be used by the swizzled UIView observing methods
- (void)removeView:(UIView *)view;
- (void)addView:(UIView *)view;
- (void)stopTrackingAllViews;

- (WXDOMNode *)rootNode;
- (WXDOMNode *)rootComponentNode;
- (void)removeWXComponentRef:(NSString *)ref withInstanceId:(NSString *)instanceId;
- (void)addWXComponentRef:(NSString *)ref withInstanceId:(NSString *)instanceId;
- (void)removeInstanceDicWithInstance:(NSString *)instanceId;

- (id)_getComponentFromRef:(NSString *)subRef;
- (NSDictionary *)getObjectsForComponentRefs;
- (NSArray *)attributesArrayForObject:(id)object;

@end
