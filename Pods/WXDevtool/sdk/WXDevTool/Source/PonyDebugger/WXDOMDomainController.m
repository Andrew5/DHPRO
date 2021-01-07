//
//  WXDOMDomainController.m
//  PonyDebugger
//
//  Created by Ryan Olson on 2012-09-19.
//
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.
//

#import "WXDOMDomainController.h"
#import "WXInspectorDomainController.h"
#import "WXRuntimeTypes.h"
#import "WXPageDomainController.h"
#import "WXPageDomainUtility.h"

#import <WeexSDK/WeexSDK.h>

#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

#pragma mark - Definitions

// Constants defined in the DOM Level 2 Core: http://www.w3.org/TR/DOM-Level-2-Core/core.html#ID-1950641247
static const int kWXDOMNodeTypeElement = 1;
static const int kWXDOMNodeTypeDocument = 9;

static NSString *const kWXDOMAttributeParsingRegex = @"[\"'](.*)[\"']";

#pragma mark - Private Interface

@interface WXDOMDomainController ()

// Use mirrored dictionaries to map between objets and node ids with fast lookup in both directions
@property (nonatomic, strong) NSMutableDictionary *objectsForNodeIds;
@property (nonatomic, strong) NSMutableDictionary *nodeIdsForObjects;
@property (nonatomic, assign) NSUInteger nodeIdCounter;

@property (nonatomic, strong) UIView *viewToHighlight;
@property (nonatomic, strong) UIView *highlightOverlay;

@property (nonatomic, assign) CGPoint lastPanPoint;
@property (nonatomic, assign) CGRect originalPinchFrame;
@property (nonatomic, assign) CGPoint originalPinchLocation;

@property (nonatomic, strong) UIView *inspectModeOverlay;

@property (nonatomic, strong) WXComponent *rootComponent;
@property (nonatomic, strong) NSMutableDictionary *instanceIdForRoot;
@property (nonatomic, strong) NSMutableDictionary *instancesDic;


@property (nonatomic, readwrite,strong) NSMutableDictionary *objectsForComponentRefs;
@property (nonatomic, readwrite,strong) NSMutableDictionary *componentForRefs;

@property (nonatomic, strong) NSMutableDictionary *kvoObserverRecode;
@end

#pragma mark - Implementation

@implementation WXDOMDomainController

@dynamic domain;
@synthesize rootDomNode;

#pragma mark - NSObject

- (id)init;
{
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowHidden:) name:UIWindowDidBecomeHiddenNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowShown:) name:UIWindowDidBecomeVisibleNotification object:nil];
        
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMovePanGesure:)];
        panGR.maximumNumberOfTouches = 1;
        UIPinchGestureRecognizer *pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleResizePinchGesture:)];
        
        self.highlightOverlay = [[UIView alloc] initWithFrame:CGRectZero];
        self.highlightOverlay.layer.borderWidth = 1.0;
        
        [self.highlightOverlay addGestureRecognizer:panGR];
        [self.highlightOverlay addGestureRecognizer:pinchGR];
        
        UITapGestureRecognizer *inspectTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleInspectTapGesture:)];
        UIPanGestureRecognizer *inspectPanGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleInspectPanGesture:)];
        inspectPanGR.maximumNumberOfTouches = 1;
        
        self.inspectModeOverlay = [[UIView alloc] initWithFrame:CGRectZero];
        self.inspectModeOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.inspectModeOverlay.backgroundColor = [UIColor clearColor];
        
        [self.inspectModeOverlay addGestureRecognizer:inspectTapGR];
        [self.inspectModeOverlay addGestureRecognizer:inspectPanGR];
    }
    return self;
}

- (void)dealloc;
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.objectsForComponentRefs = nil;
    self.nodeIdsForObjects = nil;
    self.kvoObserverRecode = nil;
    self.componentForRefs = nil;
    self.instanceIdForRoot = nil;
    self.instancesDic = nil;
}

#pragma mark - Class Methods

+ (WXDOMDomainController *)defaultInstance;
{
    static WXDOMDomainController *defaultInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultInstance = [[WXDOMDomainController alloc] init];
    });
    return defaultInstance;
}

+ (void)startMonitoringWeexComponentChanges
{
    static dispatch_once_t onceWeexToken;
    dispatch_once(&onceWeexToken, ^{
        Method original, swizzle;
        Class WXBridgeMgrClass = [WXBridgeManager class];
        
        original = class_getInstanceMethod(WXBridgeMgrClass, @selector(fireEvent:ref:type:params:domChanges:));
        swizzle = class_getInstanceMethod(WXBridgeMgrClass, sel_registerName("devtool_swizzled_fireEvent:ref:type:params:domChanges:"));
        method_exchangeImplementations(original, swizzle);
        
        original = class_getInstanceMethod(WXBridgeMgrClass, @selector(destroyInstance:));
        swizzle = class_getInstanceMethod(WXBridgeMgrClass, sel_registerName("devtool_swizzled_destroyInstance:"));
        method_exchangeImplementations(original, swizzle);
        
        Class WXComponentMgr = [WXComponentManager class];
        original = class_getInstanceMethod(WXComponentMgr, @selector(removeComponent:));
        swizzle = class_getInstanceMethod(WXComponentMgr, sel_registerName("devtool_swizzled_removeComponent:"));
        method_exchangeImplementations(original, swizzle);
        
        original = class_getInstanceMethod(WXComponentMgr, @selector(moveComponent:toSuper:atIndex:));
        swizzle = class_getInstanceMethod(WXComponentMgr, sel_registerName("devtool_swizzled_moveComponent:toSuper:atIndex:"));
        method_exchangeImplementations(original, swizzle);
        
        Class WXSDKInstanceClass = [WXSDKInstance class];
        original = class_getInstanceMethod(WXSDKInstanceClass, @selector(creatFinish));
        swizzle = class_getInstanceMethod(WXSDKInstanceClass, sel_registerName("devtool_swizzled_creatFinish"));
        method_exchangeImplementations(original, swizzle);
        
        Class viewClass = [UIView class];
        original = class_getInstanceMethod(viewClass, @selector(addSubview:));
        swizzle = class_getInstanceMethod(viewClass, sel_registerName("devtool_swizzled_addSubview:"));
        method_exchangeImplementations(original, swizzle);
        
        original = class_getInstanceMethod(viewClass, @selector(insertSubview:atIndex:));
        swizzle = class_getInstanceMethod(viewClass, sel_registerName("devtool_swizzled_insertSubview:atIndex:"));
        method_exchangeImplementations(original, swizzle);
        
        original = class_getInstanceMethod(viewClass, @selector(removeFromSuperview));
        swizzle = class_getInstanceMethod(viewClass, sel_registerName("devtool_swizzled_removeFromSuperview"));
        method_exchangeImplementations(original, swizzle);
        
        original = class_getInstanceMethod(viewClass, @selector(bringSubviewToFront:));
        swizzle = class_getInstanceMethod(viewClass, sel_registerName("devtool_swizzled_bringSubviewToFront:"));
        method_exchangeImplementations(original, swizzle);
        
        original = class_getInstanceMethod(viewClass, @selector(sendSubviewToBack:));
        swizzle = class_getInstanceMethod(viewClass, sel_registerName("devtool_swizzled_sendSubviewToBack:"));
        method_exchangeImplementations(original, swizzle);
        
        original = class_getInstanceMethod(viewClass, @selector(insertSubview:aboveSubview:));
        swizzle = class_getInstanceMethod(viewClass, sel_registerName("devtool_swizzled_insertSubview:aboveSubview:"));
        method_exchangeImplementations(original, swizzle);
        
        original = class_getInstanceMethod(viewClass, @selector(insertSubview:belowSubview:));
        swizzle = class_getInstanceMethod(viewClass, sel_registerName("devtool_swizzled_insertSubview:belowSubview:"));
        method_exchangeImplementations(original, swizzle);
        
        original = class_getInstanceMethod(viewClass, @selector(exchangeSubviewAtIndex:withSubviewAtIndex:));
        swizzle = class_getInstanceMethod(viewClass, sel_registerName("devtool_swizzled_exchangeSubviewAtIndex:withSubviewAtIndex:"));
        method_exchangeImplementations(original, swizzle);
        
    });
}


+ (Class)domainClass;
{
    return [WXDOMDomain class];
}

#pragma mark - Setter Overrides

- (void)setViewKeyPathsToDisplay:(NSArray *)viewKeyPathsToDisplay;
{
    if (![_viewKeyPathsToDisplay isEqualToArray:viewKeyPathsToDisplay]) {
        // Stop tracking all the views to remove KVO
        [self stopTrackingAllViews];
        
        // Now that the observers have been removed, it's safe to change the keyPaths array
        _viewKeyPathsToDisplay = viewKeyPathsToDisplay;
        
        // Refresh the DOM tree to see the new attributes
        [self.domain documentUpdated];
    }
}

/*
- (WXComponent *)_getParentComponentFormSubRef:(NSString *)subRef
{
    WXComponent *rootComponent = self.rootComponent ? :[self _getRootComponent];
    WXComponent *theRefComponent = [self getComponentWithRef:subRef fromParentComponent:rootComponent];
    if (theRefComponent) {
        return theRefComponent.supercomponent;
    }
    return nil;
}

- (WXComponent *)getComponentWithRef:(NSString *)ref fromParentComponent:(WXComponent *)parentComponent
{
    if (!parentComponent) {
        return nil;
    }
    if ([ref isEqualToString:parentComponent.ref]) {
        return parentComponent;
    }
    if (parentComponent.subcomponents.count > 0) {
        for (WXComponent *component in parentComponent.subcomponents) {
            if ([ref isEqualToString:component.ref]) {
                return component;
            }else {
                WXComponent *returnComponent = [self getComponentWithRef:ref fromParentComponent:component];
                if (returnComponent) {
                    return returnComponent;
                }
            }
        }
    }
    return nil;
}
*/
#pragma mark - WXDOMCommandDelegate

- (void)domain:(WXDOMDomain *)domain getDocumentWithCallback:(void (^)(WXDOMNode *root, id error))callback;
{
    if ([WXDebugger isVDom]) {
        __weak typeof(self) weakSelf = self;
        WXPerformBlockOnComponentThread(^{
            WXDOMNode *rootNode = [[WXDOMNode alloc] init];
            rootNode.nodeId = [NSNumber numberWithInt:1];
            rootNode.nodeType = @(kWXDOMNodeTypeDocument);
            rootNode.nodeName = @"#document";
            rootNode.children = @[ [weakSelf rootVirElementWithInstance:nil] ];
            self.rootDomNode = rootNode;
            callback(rootNode, nil);
        });
    } else {
        self.kvoObserverRecode = [[NSMutableDictionary alloc] init];
        [self stopTrackingAllViews];
        self.objectsForNodeIds = [[NSMutableDictionary alloc] init];
        self.nodeIdsForObjects = [[NSMutableDictionary alloc] init];
        self.nodeIdCounter = 3;
        callback([self rootNode], nil);
    }
}

- (void)domain:(WXDOMDomain *)domain highlightNodeWithNodeId:(NSNumber *)nodeId highlightConfig:(WXDOMHighlightConfig *)highlightConfig callback:(void (^)(id))callback;
{
    NSInteger transformNodeId = nodeId.integerValue;
    NSString *nodeKey = [NSString stringWithFormat:@"%ld",(long)transformNodeId];
    __block id objectForNodeId;
    if ([WXDebugger isVDom]) {
        __weak typeof(self) weakSelf = self;
        WXPerformBlockOnComponentThread(^{
            objectForNodeId = [weakSelf.objectsForComponentRefs objectForKey:nodeKey];
            WXPerformBlockOnMainThread(^{
                __strong typeof(self) strongSelf = weakSelf;
                if ([objectForNodeId isKindOfClass:[UIView class]]) {
                    [strongSelf configureHighlightOverlayWithConfig:highlightConfig];
                    [strongSelf revealHighlightOverlayForView:objectForNodeId allowInteractions:YES];
                }
                callback(nil);
            });
        });
    } else {
        objectForNodeId = [self.objectsForNodeIds objectForKey:nodeId];
        if ([objectForNodeId isKindOfClass:[UIView class]]) {
            [self configureHighlightOverlayWithConfig:highlightConfig];
            [self revealHighlightOverlayForView:objectForNodeId allowInteractions:YES];
        }
        
        callback(nil);
    }
}

- (void)domain:(WXDOMDomain *)domain hideHighlightWithCallback:(void (^)(id))callback;
{
    __weak typeof(self) weakSelf = self;
    WXPerformBlockOnComponentThread(^{
       WXPerformBlockOnMainThread(^{
           [weakSelf.highlightOverlay removeFromSuperview];
           weakSelf.viewToHighlight = nil;
           callback(nil);
       });
    });
}

- (void)domain:(WXDOMDomain *)domain removeNodeWithNodeId:(NSNumber *)nodeId callback:(void (^)(id))callback;
{
    UIView *view = [self.objectsForNodeIds objectForKey:nodeId];
    [view removeFromSuperview];
    
    callback(nil);
}

- (void)domain:(WXDOMDomain *)domain setAttributesAsTextWithNodeId:(NSNumber *)nodeId text:(NSString *)text name:(NSString *)name callback:(void (^)(id))callback;
{
    // The "class" attribute cannot be edited. Bail early
    if ([name isEqualToString:@"class"]) {
        callback(nil);
        return;
    }
    
    id nodeObject = [self.objectsForNodeIds objectForKey:nodeId];
    const char *typeEncoding = [self typeEncodingForKeyPath:name onObject:nodeObject];
    
    // Try to parse out the value
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kWXDOMAttributeParsingRegex options:0 error:NULL];
    NSTextCheckingResult *firstMatch = [regex firstMatchInString:text options:0 range:NSMakeRange(0, [text length])];
    if (firstMatch) {
        NSString *valueString = [text substringWithRange:[firstMatch rangeAtIndex:1]];
        
        // Note: this is by no means complete...
        // Allow BOOLs to be set with YES/NO
        if (typeEncoding && !strcmp(typeEncoding, @encode(BOOL)) && ([valueString isEqualToString:@"YES"] || [valueString isEqualToString:@"NO"])) {
            BOOL boolValue = [valueString isEqualToString:@"YES"];
            [nodeObject setValue:[NSNumber numberWithBool:boolValue] forKeyPath:name];
        } else if (typeEncoding && !strcmp(typeEncoding, @encode(CGPoint))) {
            CGPoint point = CGPointFromString(valueString);
            [nodeObject setValue:[NSValue valueWithCGPoint:point] forKeyPath:name];
        } else if (typeEncoding && !strcmp(typeEncoding, @encode(CGSize))) {
            CGSize size = CGSizeFromString(valueString);
            [nodeObject setValue:[NSValue valueWithCGSize:size] forKeyPath:name];
        } else if (typeEncoding && !strcmp(typeEncoding, @encode(CGRect))) {
            CGRect rect = CGRectFromString(valueString);
            [nodeObject setValue:[NSValue valueWithCGRect:rect] forKeyPath:name];
        } else if (typeEncoding && !strcmp(typeEncoding, @encode(id))) {
            // Only support editing for string objects (due to the trivial mapping between the string and its description)
            id currentValue = [nodeObject valueForKeyPath:name];
            if ([currentValue isKindOfClass:[NSString class]]) {
                [nodeObject setValue:valueString forKeyPath:name];
            }
        } else {
            NSNumber *number = @([valueString doubleValue]);
            [nodeObject setValue:number forKeyPath:name];
        }
    }
    
    callback(nil);
}

- (void)domain:(WXDOMDomain *)domain setInspectModeEnabledWithEnabled:(NSNumber *)enabled highlightConfig:(WXDOMHighlightConfig *)highlightConfig callback:(void (^)(id))callback;
{
    if ([enabled boolValue]) {
        [self configureHighlightOverlayWithConfig:highlightConfig];
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        self.inspectModeOverlay.frame = keyWindow.frame;
        [keyWindow addSubview:self.inspectModeOverlay];
    } else {
        [self.inspectModeOverlay removeFromSuperview];
    }
    
    callback(nil);
}

- (void)domain:(WXDOMDomain *)domain requestNodeWithObjectId:(NSString *)objectId callback:(void (^)(NSNumber *, id))callback;
{
    callback(@([objectId intValue]), nil);
}

- (void)domain:(WXDOMDomain *)domain getBoxModelNodeId:(NSString *)nodeId callback:(void (^)(WXDOMBoxModel *boxModel, id error))callback
{
    __block UIView *objectForNodeId;
    if ([WXDebugger isVDom]) {
        __weak typeof(self) weakSelf = self;
        WXPerformBlockOnComponentThread(^{
            NSString *nodeIdStr = [NSString stringWithFormat:@"%ld",(long)[nodeId integerValue]];
            objectForNodeId = [self.objectsForComponentRefs objectForKey:nodeIdStr];
            WXPerformBlockOnMainThread(^{
                [weakSelf _getBoxModelNode:objectForNodeId callback:^(WXDOMBoxModel *boxModel, id error) {
                    callback(boxModel,nil);
                }];
            });
        });
    } else {
        objectForNodeId = [self.objectsForNodeIds objectForKey:nodeId];
        [self _getBoxModelNode:objectForNodeId callback:^(WXDOMBoxModel *boxModel, id error) {
            callback(boxModel,nil);
        }];
    }
}

- (void)domain:(WXDOMDomain *)domain getNodeForLocationX:(NSNumber *)locationX locationY:(NSNumber *)locationY callback:(void (^)(NSNumber *nodeId, id error))callback
{
    UIView *selectView;
    UIView *rootView;
    NSNumber *nodeId = nil;
    CGPoint point = CGPointMake(locationX.floatValue, locationY.floatValue);
    rootView = [WXPageDomainUtility getCurrentKeyController].view;
    selectView = [self p_point:point withRootView:rootView];
    if ([WXDebugger isVDom]) {
        if (selectView.wx_ref) {
            nodeId = [self _getRealNodeIdWithComponentRef:selectView.wx_ref];
        }
        callback(nodeId, nil);
    } else {
        nodeId = [self.nodeIdsForObjects objectForKey:[NSValue valueWithNonretainedObject:selectView]];
        callback(nodeId, nil);
    }
}


- (UIView *)p_point:(CGPoint)point withRootView:(UIView *)rootView;
{
    if (!rootView || (!CGRectEqualToRect(rootView.frame, CGRectZero) && !CGRectContainsPoint([self changeRectFromView:rootView], point))) {
        return nil;
    }
    if (rootView.subviews.count > 0) {
        UIView *tempView;
        for (UIView *subView in [rootView.subviews reverseObjectEnumerator]) {
            if (CGRectEqualToRect(subView.frame, CGRectZero) || CGRectContainsPoint([self changeRectFromView:subView], point)) {
                UIView *returnView = [self p_point:point withRootView:subView];
                if (!returnView) {
                    tempView = subView;
                }else {
                    return returnView;
                }
            }
        }
        return tempView;
    }
    return nil;
}

- (CGRect)changeRectFromView:(UIView *)view
{
    UIView *toView = [WXPageDomainUtility getCurrentKeyController].view;
    if ([view isEqual:toView]) {
        return view.frame;
    }
    return [view.superview convertRect:view.frame toView:toView];
}

#pragma mark - Gesture Moving and Resizing

- (void)handleMovePanGesure:(UIPanGestureRecognizer *)panGR;
{
    switch (panGR.state) {
        case UIGestureRecognizerStateBegan:
            self.lastPanPoint = [panGR locationInView:self.viewToHighlight.superview];
            break;
            
        default: {
            // Convert to superview coordinates for a consistent basis
            CGPoint newPanPoint = [panGR locationInView:self.viewToHighlight.superview];
            CGFloat deltaX = newPanPoint.x - self.lastPanPoint.x;
            CGFloat deltaY = newPanPoint.y - self.lastPanPoint.y;
            
            CGRect frame = self.viewToHighlight.frame;
            frame.origin.x += deltaX;
            frame.origin.y += deltaY;
            self.viewToHighlight.frame = frame;
            
            self.lastPanPoint = newPanPoint;
            break;
        }
    }
}

- (void)handleResizePinchGesture:(UIPinchGestureRecognizer *)pinchGR;
{
    switch (pinchGR.state) {
        case UIGestureRecognizerStateBegan:
            self.originalPinchFrame = self.viewToHighlight.frame;
            self.originalPinchLocation = [pinchGR locationInView:self.viewToHighlight.superview];
            break;
        
        case UIGestureRecognizerStateChanged: {
            // Scale the frame by the pinch amount
            CGFloat scale = [pinchGR scale];
            CGRect newFrame = self.originalPinchFrame;
            CGFloat scaleByFactor = (scale - 1.0) / 1.0;
            scaleByFactor /= 3.0;
            
            newFrame.size.width *= 1.0 + scaleByFactor;
            newFrame.size.height *= 1.0 + scaleByFactor;
            
            // Translate the center by the difference between the current centroid and the original centroid
            CGPoint location = [pinchGR locationInView:self.viewToHighlight.superview];
            CGPoint center = CGPointMake(floor(CGRectGetMidX(self.originalPinchFrame)), floor(CGRectGetMidY(self.originalPinchFrame)));
            center.x += location.x - self.originalPinchLocation.x;
            center.y += location.y - self.originalPinchLocation.y;
            
            newFrame.origin.x = center.x - newFrame.size.width / 2.0;
            newFrame.origin.y = center.y - newFrame.size.height / 2.0;
            self.viewToHighlight.frame = newFrame;
            break;
        }
        
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            self.viewToHighlight.frame = CGRectIntegral(self.viewToHighlight.frame);
            break;
            
        default:
            break;
    }
}

#pragma mark - Inspect Mode

- (void)handleInspectTapGesture:(UITapGestureRecognizer *)tapGR;
{
    switch (tapGR.state) {
        case UIGestureRecognizerStateRecognized:
            [self inspectViewAtPoint:[tapGR locationInView:nil]];
            break;
            
        default:
            break;
    }
    
}

- (void)handleInspectPanGesture:(UIPanGestureRecognizer *)panGR;
{
    switch (panGR.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            // As the user drags, highlight the view that we would inspect
            CGPoint panPoint = [panGR locationInView:nil];
            UIView *chosenView = [self chooseViewAtPoint:panPoint givenStartingView:[[UIApplication sharedApplication] keyWindow]];
            [self revealHighlightOverlayForView:chosenView allowInteractions:NO];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
            // When the user finishes dragging, send the inspect command
            [self inspectViewAtPoint:[panGR locationInView:nil]];
            break;
            
        default:
            break;
    }
}

- (void)inspectViewAtPoint:(CGPoint)point;
{
    WXInspectorDomain *inspectorDomain = [[WXInspectorDomainController defaultInstance] domain];
    WXRuntimeRemoteObject *remoteObject = [[WXRuntimeRemoteObject alloc] init];
    
    UIView *chosenView = [self chooseViewAtPoint:point givenStartingView:[[UIApplication sharedApplication] keyWindow]];
    NSNumber *chosenNodeId = [self.nodeIdsForObjects objectForKey:[NSValue valueWithNonretainedObject:chosenView]];
    
    remoteObject.type = @"object";
    remoteObject.subtype = @"node";
    remoteObject.objectId = [chosenNodeId stringValue];
    
    [inspectorDomain inspectWithObject:remoteObject hints:nil];
    [self.inspectModeOverlay removeFromSuperview];
}

- (UIView *)chooseViewAtPoint:(CGPoint)point givenStartingView:(UIView *)startingView;
{
    // Look into the subviews (topmost first) to see if there's a view there that we should select
    for (UIView *subview in [startingView.subviews reverseObjectEnumerator]) {
        CGRect subviewFrameInWindowCoordinates = [startingView convertRect:subview.frame toView:nil];
        if (![self shouldIgnoreView:subview] && !subview.hidden && subview.alpha > 0.0 && CGRectContainsPoint(subviewFrameInWindowCoordinates, point)) {
            // We've found a promising looking subview. Recurse to check it out
            return [self chooseViewAtPoint:point givenStartingView:subview];
        }
    }
    
    // We didn't find anything in the subviews, so just return the starting view
    return startingView;
}

#pragma mark - Highlight Overlay

- (void)configureHighlightOverlayWithConfig:(WXDOMHighlightConfig *)highlightConfig;
{
    WXDOMRGBA *contentColor = [highlightConfig valueForKey:@"contentColor"];
    NSNumber *r = [contentColor valueForKey:@"r"];
    NSNumber *g = [contentColor valueForKey:@"g"];
    NSNumber *b = [contentColor valueForKey:@"b"];
    NSNumber *a = [contentColor valueForKey:@"a"];
    
    self.highlightOverlay.backgroundColor = [UIColor colorWithRed:[r floatValue] / 255.0 green:[g floatValue] / 255.0 blue:[b floatValue] / 255.0 alpha:[a floatValue]];
    
    WXDOMRGBA *borderColor = [highlightConfig valueForKey:@"borderColor"];
    r = [borderColor valueForKey:@"r"];
    g = [borderColor valueForKey:@"g"];
    b = [borderColor valueForKey:@"b"];
    a = [borderColor valueForKey:@"a"];
    
    self.highlightOverlay.layer.borderColor = [[UIColor colorWithRed:[r floatValue] / 255.0 green:[g floatValue] / 255.0 blue:[b floatValue] / 255.0 alpha:[a floatValue]] CGColor];
}

- (void)revealHighlightOverlayForView:(UIView *)view allowInteractions:(BOOL)interactionEnabled;
{
    // Add a highlight overlay directly to the window if this is a window, otherwise to the view's window
    self.viewToHighlight = view;
    
    UIWindow *window = self.viewToHighlight.window;
    CGRect highlightFrame = CGRectZero;
    
    if (!window && [self.viewToHighlight isKindOfClass:[UIWindow class]]) {
        window = (UIWindow *)self.viewToHighlight;
        highlightFrame = window.bounds;
    } else {
        highlightFrame = [window convertRect:self.viewToHighlight.frame fromView:self.viewToHighlight.superview];
    }
    
    self.highlightOverlay.frame = highlightFrame;
    self.highlightOverlay.userInteractionEnabled = interactionEnabled;
    
    // Make sure the highlight goes behind the inspect overlay if it's on screen
    if (self.inspectModeOverlay.superview == window) {
        [window insertSubview:self.highlightOverlay belowSubview:self.inspectModeOverlay];
    } else {
        [window addSubview:self.highlightOverlay];
    }
}

#pragma mark - View Hierarchy Changes

- (void)windowHidden:(NSNotification *)windowNotification;
{
    [self removeView:windowNotification.object];
}

- (void)windowShown:(NSNotification *)windowNotification;
{
    [self addView:windowNotification.object];
}

- (void)removeView:(UIView *)view
{
    // Bail early if we're ignoring this view or if the document hasn't been requested yet
    if ([self shouldIgnoreView:view] || !self.objectsForNodeIds) {
        return;
    }
    
    NSNumber *nodeId = [self.nodeIdsForObjects objectForKey:[NSValue valueWithNonretainedObject:view]];

    // Only proceed if this is a node we know about
    if ([self.objectsForNodeIds objectForKey:nodeId]) {
        
        NSNumber *parentNodeId = nil;
        
        if (view.superview) {
            parentNodeId = [self.nodeIdsForObjects objectForKey:[NSValue valueWithNonretainedObject:view.superview]];
        } else if ([view isKindOfClass:[UIWindow class]]) {
            // Windows are always children of the root element node
            parentNodeId = @(1);
        } else {
            // Windows are always children of the root element node
            parentNodeId = @(1);
        }
        [self.domain childNodeRemovedWithParentNodeId:parentNodeId nodeId:nodeId];
        [self stopTrackingView:view];
    }
}

- (void)addView:(UIView *)view;
{
    // Bail early if we're ignoring this view or if the document hasn't been requested yet
    if ([self shouldIgnoreView:view] || !self.objectsForNodeIds) {
        return;
    }

    // Only proceed if we know about this view's superview (corresponding to the parent node)
    NSNumber *parentNodeId = nil;
    if (view.superview) {
        parentNodeId = [self.nodeIdsForObjects objectForKey:[NSValue valueWithNonretainedObject:view.superview]];
    }
    
    if ([self.objectsForNodeIds objectForKey:parentNodeId]) {
        
        WXDOMNode *node = [self nodeForView:view];

        // Find the sibling view to insert the node in the right place
        // We're actually looking for the next view in the subviews array. Index 0 holds the back-most view.
        // We essentialy dispay the subviews array backwards.
        NSNumber *previousNodeId = nil;
        NSUInteger indexOfView = [view.superview.subviews indexOfObject:view];
        
        // If this is the last subview in the array, it has no previous node.
        if (indexOfView + 1 < [view.superview.subviews count] - 1) {
            indexOfView = indexOfView > 0 ? indexOfView - 1 : 0;
            UIView *aheadSibling = [view.superview.subviews objectAtIndex:indexOfView + 1];
            previousNodeId = [self.nodeIdsForObjects objectForKey:[NSValue valueWithNonretainedObject:aheadSibling]];
        }
        
        [self.domain childNodeInsertedWithParentNodeId:parentNodeId previousNodeId:previousNodeId node:node];
    } else if ([view isKindOfClass:[UIWindow class]]) {
        
        WXDOMNode *node = [self nodeForView:view];
        
        // Look at the other windows to find where to place this window
        NSNumber *previousNodeId = nil;
        NSArray *windows = [[UIApplication sharedApplication] windows];
        NSUInteger indexOfWindow = [windows indexOfObject:view];
        
        if (indexOfWindow > 0 && indexOfWindow < windows.count) {
            UIWindow *previousWindow = [windows objectAtIndex:indexOfWindow - 1];
            previousNodeId = [self.nodeIdsForObjects objectForKey:[NSValue valueWithNonretainedObject:previousWindow]];
        }
        
        // Note that windows are always children of the root element node (id 1)
        [self.domain childNodeInsertedWithParentNodeId:@(1) previousNodeId:previousNodeId node:node];
    }
}

- (void)startTrackingView:(UIView *)view withNodeId:(NSNumber *)nodeId;
{
    NSAssert(view != self.highlightOverlay, @"The highlight overlay should not be tracked. We update its frame in the KVO observe method, so tracking it will lead to infinite recursion");
    
    if (nodeId) {
        [self.nodeIdsForObjects setObject:nodeId forKey:[NSValue valueWithNonretainedObject:view]];
        [self.objectsForNodeIds setObject:view forKey:nodeId];
        
        // Use KVO to keep the displayed properties fresh
//        for (NSString *keyPath in self.viewKeyPathsToDisplay) {
//            [view addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
//        }
        
        NSNumber *record = [self.kvoObserverRecode objectForKey:[NSValue valueWithNonretainedObject:view]];
        if (record) {
            [self.kvoObserverRecode setObject:[NSNumber numberWithInteger:record.integerValue + 1] forKey:[NSValue valueWithNonretainedObject:view]];
        }else {
            [self.kvoObserverRecode setObject:[NSNumber numberWithInteger:1] forKey:[NSValue valueWithNonretainedObject:view]];
        }
    }
}

- (void)stopTrackingComponent:(WXComponent *)component withInstanceId:(NSString *)instanceId
{
    if (!component.ref && !self.instancesDic[instanceId]) {
        return;
    }
    
    for (WXComponent *subComponent in component.subcomponents) {
        [self stopTrackingComponent:subComponent withInstanceId:instanceId];
    }
    
    [self.objectsForComponentRefs removeObjectForKey:component.ref];
}

- (void)stopTrackingView:(UIView *)view;
{
    NSValue *viewKey = [NSValue valueWithNonretainedObject:view];
    NSNumber *nodeId = [self.nodeIdsForObjects objectForKey:viewKey];
    
    // Bail early if we weren't tracking this view
    if (!nodeId) {
        return;
    }
    
    
    // Recurse to get any nested views
    for (UIView *subview in view.subviews) {
        [self stopTrackingView:subview];
    }
    
    // Remove the highlight if necessary
    if (view == self.viewToHighlight) {
        [self.highlightOverlay removeFromSuperview];
        self.viewToHighlight = nil;
    }
    
    NSInteger kvoCount = [[self.kvoObserverRecode objectForKey:[NSValue valueWithNonretainedObject:view]] integerValue];
    if (kvoCount <= 0) {
        return;
    }else {
        for (NSInteger i = 0; i < kvoCount; i++) {
            // Unregister from KVO
//            for (NSString *keyPath in self.viewKeyPathsToDisplay) {
//                [view removeObserver:self forKeyPath:keyPath];
//            }
        }
        [self.kvoObserverRecode removeObjectForKey:[NSValue valueWithNonretainedObject:view]];
    }
    
    // Important that this comes last, so we don't get KVO observations for objects we don't konw about
    [self.nodeIdsForObjects removeObjectForKey:viewKey];
    [self.objectsForNodeIds removeObjectForKey:nodeId];
}

- (void)stopTrackingAllViews;
{
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        [self stopTrackingView:window];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    // Make sure this is a node we know about and a key path we're observing
    NSNumber *nodeId = [self.nodeIdsForObjects objectForKey:[NSValue valueWithNonretainedObject:object]];
    
    if ([self.objectsForNodeIds objectForKey:nodeId] && [self.viewKeyPathsToDisplay containsObject:keyPath]) {
        // Update the attributes on the DOM node
        NSString *newValue = [self stringForValue:[change objectForKey:NSKeyValueChangeNewKey] atKeyPath:keyPath onObject:object];
        [self.domain attributeModifiedWithNodeId:nodeId name:keyPath value:newValue];
    }
    
    // If this is the view we're highlighting, update appropriately
    if (object == self.viewToHighlight && [keyPath isEqualToString:@"frame"]) {
        CGRect updatedFrame = [[change objectForKey:NSKeyValueChangeNewKey] CGRectValue];
        self.highlightOverlay.frame = [self.viewToHighlight.superview convertRect:updatedFrame toView:nil];
    }
    
    // Note that we do not call [super observeValueForKeyPath:...] because super doesn't implement the method
}

- (BOOL)shouldIgnoreView:(UIView *)view;
{
    return view == nil || view == self.highlightOverlay || view == self.inspectModeOverlay;
}

- (NSNumber *)getAndIncrementNodeIdCount;
{
    return @(self.nodeIdCounter++);
}

#pragma mark - Node Generation
- (WXDOMNode *)rootVirElementWithInstance:(NSString *)instance
{
    [self initObjectsForComponentRefs];
    NSString *instanceStr = instance ? :[self _weexInstanceId];
    NSString *instanceFormatStr = [NSString stringWithFormat:@"instance:%@",instanceStr];
    NSNumber *instanceId = [NSNumber numberWithInteger:INT32_MAX - [instanceStr integerValue]] ? : [NSNumber numberWithInteger:0];
    
    //add a instance element
    WXDOMNode *instanceNode = [[WXDOMNode alloc] init];
    instanceNode.nodeId = instanceId;
    instanceNode.nodeType = @(kWXDOMNodeTypeElement);
    instanceNode.nodeName = instanceFormatStr;
    instanceNode.children = @[ [self rootComponentNodeWithInstance:instance] ];
    
    self.instanceIdForRoot = nil;
    self.instanceIdForRoot = [[NSMutableDictionary alloc] init];
    [self.instanceIdForRoot setObject:instanceStr forKey:@"instanceNode"];
    [self.instanceIdForRoot setObject:instanceId forKey:instanceStr];
    //update rootDomNode
    self.rootDomNode = instanceNode;
    
    return instanceNode;
}

- (WXDOMNode *)rootComponentNodeWithInstance:(NSString *)instance
{
    self.rootComponent = [self _getRootComponentWithInstance:instance];
    WXDOMNode *rootVirElement = [[WXDOMNode alloc] init];
    rootVirElement.nodeId = [NSNumber numberWithInt:2];
    rootVirElement.nodeType = @(kWXDOMNodeTypeElement);
    rootVirElement.nodeName = self.rootComponent.type;
    rootVirElement.children = [self virtualNodes];
    return rootVirElement;
    
}

- (NSArray *)virtualNodes
{
    NSMutableArray *domNodes = [NSMutableArray array];
    if (!self.componentForRefs) {
        self.componentForRefs = [[NSMutableDictionary alloc] init];
    }
    NSArray *subcomponentAry = [NSArray arrayWithArray:self.rootComponent.subcomponents];
    for (id component in subcomponentAry) {
        WXComponent *transComponent = (WXComponent *)component;
        [self.componentForRefs setObject:transComponent forKey:transComponent.ref];
        WXDOMNode *elementNode = [self nodeForComponent:transComponent];
        [domNodes addObject:elementNode];
    }
    return domNodes;
}

- (WXDOMNode *)nodeForComponent:(WXComponent *)component
{
    // Build the child nodes by recursing on this component's subcomponents
    NSMutableArray *childComponents = [[NSMutableArray alloc] initWithCapacity:component.subcomponents.count];
    for (WXComponent *subComponent in component.subcomponents) {
        [self.componentForRefs setObject:subComponent forKey:subComponent.ref];
        WXDOMNode *childComponent = [self nodeForComponent:subComponent];
        if (childComponent) {
            [childComponents addObject:childComponent];
        }
    }
    WXDOMNode *virtualNode = [self elementVirNodeForComponent:component withChildComponet:childComponents];
    
    return virtualNode;
}

-(WXDOMNode *)elementVirNodeForComponent:(WXComponent *)component withChildComponet:(NSArray *)children
{
    WXDOMNode *elementNode = [[WXDOMNode alloc] init];
    elementNode.nodeType = @(kWXDOMNodeTypeElement);
    elementNode.nodeName = component.type;
    elementNode.children = children;
    elementNode.childNodeCount = @([children count]);
    elementNode.nodeId = [NSNumber numberWithFloat:[component.ref integerValue] + 2];
    NSString *ref = [NSString stringWithFormat:@"%ld",(long)([component.ref integerValue] + 2)];
    elementNode.attributes = [self attributesArrayForObject:[self.objectsForComponentRefs objectForKey:ref]];
    return elementNode;
}
#pragma mark - WeexSDKMethod
- (NSString *)_weexInstanceId
{
    NSArray *instanceIds = [[WXSDKManager bridgeMgr] getInstanceIdStack];
    if (instanceIds.count > 0) {
        return [instanceIds firstObject];
    }
    return @"";
}

- (WXComponent *)_getRootComponentWithInstance:(NSString *)instance
{
    NSString *instanceId = instance ? :[self _weexInstanceId];
    WXSDKInstance *currentInstance = [WXSDKManager instanceForID:instanceId];
    [currentInstance.rootView setWx_ref:@"_rootParent"];
    return currentInstance.rootView.wx_component;
}

- (id)_getComponentFromRef:(NSString *)subRef
{
    NSString *instanceId = [self _weexInstanceId];
    WXSDKInstance *currentInstance = [WXSDKManager instanceForID:instanceId];
    WXComponent *currentComponent = [currentInstance componentForRef:subRef];
    return currentComponent;
}

- (NSNumber *)_getRealNodeIdWithComponentRef:(NSString *)ref
{
    NSNumber *nodeId = nil;
    if ([ref isEqualToString:@"_root"]) {
        nodeId = @(2);
    } else {
        nodeId = [NSNumber numberWithInteger:[ref integerValue] + 2];
    }
    return nodeId;
}


- (void)initObjectsForComponentRefs
{
    self.objectsForComponentRefs = [[NSMutableDictionary alloc] init];
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIView *parentView in windows) {
        [self childrenForParent:parentView];
    }
}

- (UIView *)childrenForParent:(UIView *)parentView
{
    if ([self shouldIgnoreView:parentView]) {
        return nil;
    }
    
    // Build the child nodes by recursing on this view's subviews
    for (UIView *subview in [parentView.subviews reverseObjectEnumerator]) {
        [self childrenForParent:subview];
    }
    if ([parentView isKindOfClass:[UIView class]]) {
        NSValue *value = nil;
        @try {
            value = [parentView valueForKeyPath:@"wx_ref"];
            if (value) {
                NSString *key = [self stringForValue:value atKeyPath:@"wx_ref" onObject:parentView];
                if ([key isEqualToString:@"_root"]) {
                    [self.objectsForComponentRefs setObject:parentView forKey:@"2"];
                }else {
                    NSString *newKey = [NSString stringWithFormat:@"%ld",(long)([key integerValue] + 2)];
                   [self.objectsForComponentRefs setObject:parentView forKey:newKey];
                }
            }
        } @catch (NSException *exception) {
            
        }
    }
    return parentView;
}



- (WXDOMNode *)rootComponentNode
{
    return self.rootDomNode;
}

- (NSDictionary *)getObjectsForComponentRefs
{
    return self.objectsForComponentRefs;
}

- (WXDOMNode *)rootNode;
{
    WXDOMNode *rootNode = [[WXDOMNode alloc] init];
    rootNode.nodeId = [NSNumber numberWithInt:1];//[self getAndIncrementNodeIdCount];
    rootNode.nodeType = @(kWXDOMNodeTypeDocument);
    rootNode.nodeName = @"#document";
    rootNode.children = @[ [self rootElement] ];
    self.rootDomNode = rootNode;
    return rootNode;
}

- (WXDOMNode *)rootElement;
{
    WXDOMNode *rootElement = [[WXDOMNode alloc] init];
    rootElement.nodeId = [NSNumber numberWithInt:2];//[self getAndIncrementNodeIdCount];
    rootElement.nodeType = @(kWXDOMNodeTypeElement);
    rootElement.nodeName = @"iosml";
    rootElement.children = [self windowNodes];
    
    return rootElement;
}

- (NSArray *)windowNodes;
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    NSMutableArray *windowNodes = [NSMutableArray arrayWithCapacity:[windows count]];
    
    for (id window in windows) {
        WXDOMNode *windowNode = [self nodeForView:window];
        if (windowNode) {
            [windowNodes addObject:windowNode];
        }
    }
    
    return windowNodes;
}

- (WXDOMNode *)nodeForView:(UIView *)view;
{
    // Don't generate nodes for views we want to ignore
    if ([self shouldIgnoreView:view]) {
        return nil;
    }
    
    // Build the child nodes by recursing on this view's subviews
    NSMutableArray *childNodes = [[NSMutableArray alloc] initWithCapacity:[view.subviews count]];
    for (UIView *subview in [view.subviews reverseObjectEnumerator]) {
        WXDOMNode *childNode = [self nodeForView:subview];
        if (childNode) {
            [childNodes addObject:childNode];
        }
    }
    
    WXDOMNode *viewNode = [self elementNodeForObject:view withChildNodes:childNodes];
    [self startTrackingView:view withNodeId:viewNode.nodeId];
    
    return viewNode;
}

- (WXDOMNode *)elementNodeForObject:(id)object withChildNodes:(NSArray *)children;
{
    WXDOMNode *elementNode = [[WXDOMNode alloc] init];
    elementNode.nodeType = @(kWXDOMNodeTypeElement);
    
    if ([object isKindOfClass:[UIWindow class]]) {
        elementNode.nodeName = @"window";
    } else if ([object isKindOfClass:[UIView class]]) {
        elementNode.nodeName = @"view";
    } else {
        elementNode.nodeName = @"object";
    }
    
    elementNode.children = children;
    elementNode.childNodeCount = @([elementNode.children count]);
    
    NSNumber *nodeId = [self.nodeIdsForObjects objectForKey:[NSValue valueWithNonretainedObject:object]];
    if (nodeId) {
        elementNode.nodeId = nodeId;
    }else {
        elementNode.nodeId = [self getAndIncrementNodeIdCount];
    }
    elementNode.attributes = [self attributesArrayForObject:object];
    
    return elementNode;
}

- (void)removeWXComponentRef:(NSString *)ref withInstanceId:(NSString *)instanceId
{
    
    if (!self.objectsForComponentRefs) {
        return;
    }
    WXComponent *corrComponent = [self _getComponentFromRef:ref];
    NSNumber *parentNodeId = nil;
    NSNumber *corrNodeId = [self _getRealNodeIdWithComponentRef:corrComponent.ref];
    
    if (corrComponent.supercomponent) {
        parentNodeId = [self _getRealNodeIdWithComponentRef:corrComponent.supercomponent.ref];
    } else if ([corrComponent.ref isEqualToString:@"_root"]) {
        // Document are always children of the root element node
        parentNodeId = @(1);
        corrNodeId = [self.instanceIdForRoot objectForKey:instanceId];
        if (corrNodeId) {
            [self.objectsForComponentRefs removeAllObjects];
            [self.instanceIdForRoot removeAllObjects];
        } else {
            return;
        }
    }
    [self.domain childNodeRemovedWithParentNodeId:parentNodeId nodeId:corrNodeId];
}

- (void)moveWXComponentRef:(NSString *)ref toSuper:(NSString *)superRef atIndex:(NSInteger)index
{
    if (!self.objectsForComponentRefs) {
        return;
    }
    WXComponent *corrComponent = [self _getComponentFromRef:ref];
    WXComponent *parentComponent = [self _getComponentFromRef:superRef];
    NSNumber *parentNodeId = [self _getRealNodeIdWithComponentRef:parentComponent.ref];
    WXComponent *previousComponent = nil;
    NSNumber *previousNodeId = nil;
    if (!corrComponent || !parentComponent) {
        return;
    }
    if ([self.objectsForComponentRefs objectForKey:[NSString stringWithFormat:@"%ld",(long)parentNodeId.integerValue]]) {
        WXDOMNode *node = [self nodeForComponent:corrComponent];
        if (index < [parentComponent.subcomponents count] - 1) {
            NSInteger previousIndex = index - 1;
            if (previousIndex < 0) {
                previousNodeId = @(-1);
            }else {
                previousComponent = [parentComponent.subcomponents objectAtIndex:previousIndex];
                previousNodeId = [self _getRealNodeIdWithComponentRef:previousComponent.ref];
            }
        }
        [self.domain childNodeInsertedWithParentNodeId:parentNodeId previousNodeId:previousNodeId node:node];
    }
}

- (void)addWXComponentRef:(NSString *)ref withInstanceId:(NSString *)instanceId
{
    if (!self.objectsForComponentRefs) {
        return;
    }
    WXComponent *corrComponent = [self _getComponentFromRef:ref];
    if (!corrComponent) {
        return;
    }
    WXComponent *parentComponent = corrComponent.supercomponent;
    WXComponent *previousComponent = nil;
    NSNumber *parentNodeId = [self _getRealNodeIdWithComponentRef:parentComponent.ref];
    NSNumber *previousNodeId = nil;
    if (parentComponent && [self.objectsForComponentRefs objectForKey:[NSString stringWithFormat:@"%ld",(long)parentNodeId.integerValue]]) {
        WXDOMNode *node = [self nodeForComponent:corrComponent];
        NSUInteger indexOfComponent = [parentComponent.subcomponents indexOfObject:corrComponent];
        if (indexOfComponent < [parentComponent.subcomponents count]) {
            NSInteger index = indexOfComponent - 1;
            if (index < 0) {
                previousNodeId = @(-1);
            }else {
                previousComponent = [parentComponent.subcomponents objectAtIndex:index];
                if (!previousComponent) {
                    return;
                }
                previousNodeId = [self _getRealNodeIdWithComponentRef:previousComponent.ref];
            }
        }
        [self.domain childNodeInsertedWithParentNodeId:parentNodeId previousNodeId:previousNodeId node:node];
    } else if ([corrComponent.ref isEqualToString:@"_root"]) {
        NSString *showInstance = [self.instanceIdForRoot objectForKey:@"instanceNode"];
        if (showInstance && ![showInstance isEqualToString:instanceId]) {
            [self removeWXComponentRef:@"_root" withInstanceId:showInstance];
        }
        if ([self.instanceIdForRoot objectForKey:instanceId]) {
            return;
        }
        WXDOMNode *node = [self rootVirElementWithInstance:instanceId];
        [self.domain childNodeInsertedWithParentNodeId:@(1) previousNodeId:previousNodeId node:node];
    }
}

- (void)removeInstanceDicWithInstance:(NSString *)instanceId
{
    if (self.instancesDic[instanceId]) {
        [self.instancesDic removeObjectForKey:instanceId];
    }
}

- (void)addVDomTreeWithView:(UIView *)view
{
    NSString *ref = view.wx_ref;
    if (ref) {
        NSMutableDictionary *viewRefs = self.objectsForComponentRefs;
        NSNumber *nodeId = [self _getRealNodeIdWithComponentRef:ref];
        NSString *nodeIdKey = [NSString stringWithFormat:@"%ld",(long)[nodeId integerValue]];
        if (![viewRefs objectForKey:nodeIdKey]) {
            NSArray *attributes = [self attributesArrayForObject:view];
            for (int i = 0; i < attributes.count; i++) {
                if (i % 2 == 0) {
                    NSString *newValue = attributes[i + 1];
                    [self.domain attributeModifiedWithNodeId:nodeId name:attributes[i] value:newValue];
                }
            }
        }
        [viewRefs setObject:view forKey:[NSString stringWithFormat:@"%ld",(long)[nodeId integerValue]]];
        
        if (self.componentForRefs.count <= 0 && !self.rootComponent) {
            return;
        }else if(![self.componentForRefs objectForKey:ref]){
            WXComponent *component = [self _getComponentFromRef:ref];
            if (component) {
                [self.componentForRefs setObject:component forKey:ref];
                [self addWXComponentRef:ref withInstanceId:nil];
            }
        }
    }
}

- (void)removeVDomTreeWithView:(UIView *)view
{
    NSString *ref = view.wx_ref;
    if (ref) {
        NSNumber *nodeId = [self _getRealNodeIdWithComponentRef:ref];
        NSMutableDictionary *viewRefs =  self.objectsForComponentRefs;
        ref = [NSString stringWithFormat:@"%ld",(long)[nodeId integerValue]];
        if ([viewRefs objectForKey:ref] && [viewRefs objectForKey:ref] == view) {
            [viewRefs removeObjectForKey:ref];
            NSArray *attributes = @[@"class", @"frame", @"hidden", @"alpha", @"opaque"];
            for (NSString *key in attributes) {
                [self.domain attributeRemovedWithNodeId:nodeId name:key];
            }
            [self.objectsForComponentRefs removeObjectForKey:ref];
        }
//        if (self.componentForRefs.count > 0) {
//            if ([self.componentForRefs objectForKey:ref]) {
//                [self removeWXComponentRef:ref withInstanceId:nil];
//            }
//        }
    }
}

- (void)removeVDomTreeWithRef:(NSString *)ref
{
    if (ref) {
        NSNumber *nodeId = [self _getRealNodeIdWithComponentRef:ref];
        NSMutableDictionary *viewRefs =  self.objectsForComponentRefs;
        ref = [NSString stringWithFormat:@"%ld",(long)[nodeId integerValue]];
        if ([viewRefs objectForKey:ref]) {
            [viewRefs removeObjectForKey:ref];
            NSArray *attributes = @[@"class", @"frame", @"hidden", @"alpha", @"opaque"];
            for (NSString *key in attributes) {
                [self.domain attributeRemovedWithNodeId:nodeId name:key];
            }
            [self.objectsForComponentRefs removeObjectForKey:ref];
        }
        //        if (self.componentForRefs.count > 0) {
        //            if ([self.componentForRefs objectForKey:ref]) {
        //                [self removeWXComponentRef:ref withInstanceId:nil];
        //            }
        //        }
    }
}

- (BOOL)diffWithRootComponent
{
    WXComponent *newRootComponent = [self _getRootComponentWithInstance:nil];
    if (self.rootComponent.subcomponents.count != newRootComponent.subcomponents.count) {
        return YES;
    }
    return NO;
}

#pragma mark - Attribute Generation
- (NSDictionary *)attributesDicForObject:(id)object
{
    // No attributes for a nil object
    if (!object) {
        return nil;
    }
    
    NSString *className = [[object class] description];
    
    // Thanks to http://petersteinberger.com/blog/2012/pimping-recursivedescription/
    SEL viewDelSEL = NSSelectorFromString([NSString stringWithFormat:@"%@wDelegate", @"_vie"]);
    if ([object respondsToSelector:viewDelSEL]) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        UIViewController *vc = [object performSelector:viewDelSEL];
#pragma clang diagnostic pop
        
        if (vc) {
            className = [className stringByAppendingFormat:@" (%@)", [vc class]];
        }
    }
    NSMutableDictionary *attributesDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"class", className, nil];
    
    if ([object isKindOfClass:[UIView class]]) {
        // Get strings for all the key paths in viewKeyPathsToDisplay
        for (NSString *keyPath in self.viewKeyPathsToDisplay) {
            
            NSValue *value = nil;
            
            @try {
                value = [object valueForKeyPath:keyPath];
            } @catch (NSException *exception) {
                // Continue if valueForKeyPath fails (ie KVC non-compliance)
                continue;
            }
            
            NSString *stringValue = [self stringForValue:value atKeyPath:keyPath onObject:object];
            if (stringValue) {
                [attributesDic setObject:stringValue forKey:keyPath];
            }
        }
    }
    
    return attributesDic;
}


- (NSArray *)attributesArrayForObject:(id)object;
{
    // No attributes for a nil object
    if (!object) {
        return nil;
    }
    
    NSString *className = [[object class] description];
    
    // Thanks to http://petersteinberger.com/blog/2012/pimping-recursivedescription/
    SEL viewDelSEL = NSSelectorFromString([NSString stringWithFormat:@"%@wDelegate", @"_vie"]);
    if ([object respondsToSelector:viewDelSEL]) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        UIViewController *vc = [object performSelector:viewDelSEL];
#pragma clang diagnostic pop
        
        if (vc) {
            className = [className stringByAppendingFormat:@" (%@)", [vc class]];
        }
    }
    
    NSMutableArray *attributes = [NSMutableArray arrayWithArray:@[ @"class", className ]];
    
    if ([object isKindOfClass:[UIView class]]) {
        // Get strings for all the key paths in viewKeyPathsToDisplay
        for (NSString *keyPath in self.viewKeyPathsToDisplay) {
            
            NSValue *value = nil;
            
            @try {
                value = [object valueForKeyPath:keyPath];
            } @catch (NSException *exception) {
                // Continue if valueForKeyPath fails (ie KVC non-compliance)
                continue;
            }
            
            NSString *stringValue = [self stringForValue:value atKeyPath:keyPath onObject:object];
            if (stringValue) {
                [attributes addObjectsFromArray:@[ keyPath, stringValue ]];
            }
        }
    }
    
    return attributes;
}

- (NSString *)stringForValue:(id)value atKeyPath:(NSString *)keyPath onObject:(id)object;
{
    NSString *stringValue = nil;
    const char *typeEncoding = [self typeEncodingForKeyPath:keyPath onObject:object];
    
    if (typeEncoding) {
        // Special structs
        if (!strcmp(typeEncoding,@encode(BOOL))) {
            stringValue = [(id)value boolValue] ? @"YES" : @"NO";
        } else if (!strcmp(typeEncoding,@encode(CGPoint))) {
            stringValue = NSStringFromCGPoint([value CGPointValue]);
        } else if (!strcmp(typeEncoding,@encode(CGSize))) {
            stringValue = NSStringFromCGSize([value CGSizeValue]);
        } else if (!strcmp(typeEncoding,@encode(CGRect))) {
            stringValue = NSStringFromCGRect([value CGRectValue]);
        }
    }
    
    // Boxed numeric primitives
    if (!stringValue && [value isKindOfClass:[NSNumber class]]) {
        stringValue = [(NSNumber *)value stringValue];
        
    // Object types
    } else if (!stringValue && typeEncoding && !strcmp(typeEncoding, @encode(id))) {
        stringValue = [value description];
    }
    
    return stringValue;
}

- (const char *)typeEncodingForKeyPath:(NSString *)keyPath onObject:(id)object;
{
    const char *encoding = NULL;
    NSString *lastKeyPathComponent = nil;
    id targetObject = nil;
    
    // Separate the key path components
    NSArray *keyPathComponents = [keyPath componentsSeparatedByString:@"."];
    
    if ([keyPathComponents count] > 1) {
        // Drill down to find the targetObject.key piece that we're interested in.
        NSMutableArray *mutableComponents = [keyPathComponents mutableCopy];
        lastKeyPathComponent = [mutableComponents lastObject];
        [mutableComponents removeLastObject];
        
        NSString *targetKeyPath = [mutableComponents componentsJoinedByString:@"."];
        @try {
            targetObject = [object valueForKeyPath:targetKeyPath];
        } @catch (NSException *exception) {
            // Silently fail for KVC non-compliance
        }
    } else {
        // This is the simple case with no dots. Use the full key and original target object
        lastKeyPathComponent = keyPath;
        targetObject = object;
    }
    
    // Look for a matching set* method to infer the type
    NSString *selectorString = [NSString stringWithFormat:@"set%@:", [lastKeyPathComponent stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[lastKeyPathComponent substringToIndex:1] uppercaseString]]];
    NSMethodSignature *methodSignature = [targetObject methodSignatureForSelector:NSSelectorFromString(selectorString)];
    if (methodSignature) {
        // We don't care about arg0 (self) or arg1 (_cmd)
        encoding = [methodSignature getArgumentTypeAtIndex:2];
    }
    
    // If we didn't find a setter, look for the getter
    // We could be more exhasutive here with KVC conventions, but these two will cover the majority of cases
    if (!encoding) {
        NSMethodSignature *getterSignature = [targetObject methodSignatureForSelector:NSSelectorFromString(lastKeyPathComponent)];
        encoding = [getterSignature methodReturnType];
    }
    
    return encoding;
}


#pragma mark - private method
- (void)_getBoxModelNode:(UIView *)objectForNodeId callback:(void (^)(WXDOMBoxModel *boxModel, id error))callback
{
    CGFloat scale = [WXPageDomainController defaultInstance].domain.screenScaleFactor;
    UIView *view = [WXPageDomainUtility getCurrentKeyController].view;
    CGRect changeRect = [objectForNodeId.superview convertRect:objectForNodeId.frame toView:view];
    NSNumber *width = [NSNumber numberWithInteger:objectForNodeId.frame.size.width / scale];
    NSNumber *height = [NSNumber numberWithInteger:objectForNodeId.frame.size.height / scale];
    CGFloat left = changeRect.origin.x;
    CGFloat top = changeRect.origin.y;
    CGFloat right = left + objectForNodeId.frame.size.width;
    CGFloat bottom = top + objectForNodeId.frame.size.height;
    
    CGFloat paddingLeft = 0;
    CGFloat paddingRight = 0;
    CGFloat paddingTop = 0;
    CGFloat paddingBottom = 0;
    
    //    UIEdgeInsets marginView = [objectForNodeId layoutMargins];
    CGFloat marginLeft = 0;//marginView.left * scale;
    CGFloat marginRight = 0;//marginView.right * scale;
    CGFloat marginTop = 0;//marginView.top * scale;
    CGFloat marginBottom = 0;//marginView.bottom * scale;
    
    CGFloat borderLeftWidth = 0;
    CGFloat borderRightWidth = 0;
    CGFloat borderTopWidth = 0;
    CGFloat borderBottomWidth = 0;
    
    NSArray *content = @[@(left + borderLeftWidth + paddingLeft),
                         @(top + borderTopWidth + paddingTop),
                         @(right - borderRightWidth - paddingRight),
                         @(top + borderTopWidth + paddingTop),
                         @(right - borderRightWidth - paddingRight),
                         @(bottom - borderBottomWidth - paddingBottom),
                         @(left + borderLeftWidth + paddingLeft),
                         @(bottom - borderBottomWidth - paddingBottom)];
    NSArray *padding = @[@(left + borderLeftWidth),
                         @(top + borderTopWidth),
                         @(right - borderRightWidth),
                         @(top + borderTopWidth),
                         @(right - borderRightWidth),
                         @(bottom - borderBottomWidth),
                         @(left + borderLeftWidth),
                         @(bottom - borderBottomWidth)];
    NSArray *border = @[@(left),
                        @(top),
                        @(right),
                        @(top),
                        @(right),
                        @(bottom),
                        @(left),
                        @(bottom)];
    NSArray *margin = @[@(left - marginLeft),
                        @(top - marginTop),
                        @(right + marginRight),
                        @(top - marginTop),
                        @(right + marginRight),
                        @(bottom + marginBottom),
                        @(left - marginLeft),
                        @(bottom + marginBottom)];
    
    WXDOMBoxModel *model = [[WXDOMBoxModel alloc] init];
    model.width = width;
    model.height = height;
    model.content = content;
    model.padding = padding;
    model.margin = margin;
    model.border = border;
    callback(model, nil);
}


@end

@implementation WXBridgeManager (hackery)

- (void)devtool_swizzled_fireEvent:(NSString *)instanceId ref:(NSString *)ref type:(NSString *)type params:(NSDictionary *)params domChanges:(NSDictionary *)domChanges
{
    [self devtool_swizzled_fireEvent:instanceId ref:ref type:type params:params domChanges:domChanges];
    WXPerformBlockOnComponentThread(^{
        WXSDKInstance *currentInstance = [WXSDKManager instanceForID:instanceId];
        if ([ref isEqualToString:@"_root"]) {
            switch (currentInstance.state) {
                case WeexInstanceAppear:{
                    [[WXDOMDomainController defaultInstance] addWXComponentRef:ref withInstanceId:instanceId];
                }
                    break;
                case WeexInstanceDisappear: {
                    [[WXDOMDomainController defaultInstance].componentForRefs removeAllObjects];
                    [[WXDOMDomainController defaultInstance] removeWXComponentRef:ref withInstanceId:instanceId];
                }
                    break;
                default:
                    break;
            }
        } 
    });
}

- (void)devtool_swizzled_destroyInstance:(NSString *)instance
{
    [self devtool_swizzled_destroyInstance:instance];
    WXPerformBlockOnComponentThread(^{
        [[WXDOMDomainController defaultInstance] removeWXComponentRef:@"_root" withInstanceId:instance];
        [[WXDOMDomainController defaultInstance] removeInstanceDicWithInstance:instance];
    });
}

@end

@implementation WXSDKInstance (hackery)

- (void)devtool_swizzled_creatFinish
{
    [self devtool_swizzled_creatFinish];
    WXPerformBlockOnComponentThread(^{
        [[WXDOMDomainController defaultInstance] removeWXComponentRef:@"_root" withInstanceId:self.instanceId];
        [[WXDOMDomainController defaultInstance] addWXComponentRef:@"_root" withInstanceId:self.instanceId];
    });
}

@end

@implementation WXComponentManager (Hackery)

- (void)devtool_swizzled_removeComponent:(NSString *)ref
{
    [self devtool_swizzled_removeComponent:ref];
    WXPerformBlockOnComponentThread(^{
       [[WXDOMDomainController defaultInstance] removeWXComponentRef:ref withInstanceId:nil];
    });
}

- (void)devtool_swizzled_moveComponent:(NSString *)ref toSuper:(NSString *)superRef atIndex:(NSInteger)index
{
    [self devtool_swizzled_moveComponent:ref toSuper:superRef atIndex:index];
    WXPerformBlockOnComponentThread(^{
        [[WXDOMDomainController defaultInstance] removeWXComponentRef:ref withInstanceId:nil];
        [[WXDOMDomainController defaultInstance] moveWXComponentRef:ref toSuper:superRef atIndex:index];
    });
}

@end

@implementation UIView (Hackery)

// There is a different set of view add/remove observation methods that could've been swizzled instead of the ones below.
// Choosing the set below seems safer becuase the UIView implementations of the other methods are documented to be no-ops.
// Custom UIView subclasses may override and not make calls to super for those methods, which would cause us to miss changes in the view hierarchy.

- (void)devtool_swizzled_addSubview:(UIView *)view
{
    if (![WXDebugger isVDom]) {
        [[WXDOMDomainController defaultInstance] removeView:view];
        [self devtool_swizzled_addSubview:view];
        [[WXDOMDomainController defaultInstance] addView:view];
    } else {
        [self devtool_swizzled_addSubview:view];
        WXPerformBlockOnComponentThread(^{
           [[WXDOMDomainController defaultInstance] addVDomTreeWithView:view];
        });
    }
}

- (void)devtool_swizzled_insertSubview:(UIView *)view atIndex:(NSInteger)index;
{
    if (![WXDebugger isVDom]) {
        [[WXDOMDomainController  defaultInstance] removeView:view];
        [self devtool_swizzled_insertSubview:view atIndex:index];
        [[WXDOMDomainController defaultInstance] addView:view];
    } else {
        [self devtool_swizzled_insertSubview:view atIndex:index];
        WXPerformBlockOnComponentThread(^{
            [[WXDOMDomainController defaultInstance] addVDomTreeWithView:view];
        });
    }
}

- (void)devtool_swizzled_removeFromSuperview
{
    if (![WXDebugger isVDom]) {
        [[WXDOMDomainController defaultInstance] removeView:self];
        [self devtool_swizzled_removeFromSuperview];
    } else {
        NSString *refString = [self.wx_ref copy];
        [self devtool_swizzled_removeFromSuperview];
        WXPerformBlockOnComponentThread(^{
           [[WXDOMDomainController defaultInstance] removeVDomTreeWithRef:refString];
        });
    }
}


- (void)devtool_swizzled_bringSubviewToFront:(UIView *)view;
{
    if (![WXDebugger isVDom]) {
        [[WXDOMDomainController  defaultInstance] removeView:view];
        [self devtool_swizzled_bringSubviewToFront:view];
        [[WXDOMDomainController defaultInstance] addView:view];
    }else {
        [self devtool_swizzled_bringSubviewToFront:view];
    }
}

- (void)devtool_swizzled_sendSubviewToBack:(UIView *)view;
{
    if (![WXDebugger isVDom]) {
        [[WXDOMDomainController  defaultInstance] removeView:view];
        [self devtool_swizzled_sendSubviewToBack:view];
        [[WXDOMDomainController defaultInstance] addView:view];
    }else {
        [self devtool_swizzled_sendSubviewToBack:view];
    }
}

- (void)devtool_swizzled_insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview;
{
    if (![WXDebugger isVDom]) {
        [[WXDOMDomainController  defaultInstance] removeView:view];
        [self devtool_swizzled_insertSubview:view aboveSubview:siblingSubview];
        [[WXDOMDomainController defaultInstance] addView:view];
    }else {
        [self devtool_swizzled_insertSubview:view aboveSubview:siblingSubview];
    }
}

- (void)devtool_swizzled_insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview;
{
    if (![WXDebugger isVDom]) {
        [[WXDOMDomainController  defaultInstance] removeView:view];
        [self devtool_swizzled_insertSubview:view belowSubview:siblingSubview];
        [[WXDOMDomainController defaultInstance] addView:view];
    }else {
        [self devtool_swizzled_insertSubview:view belowSubview:siblingSubview];
    }
}

- (void)devtool_swizzled_exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2;
{
    if (![WXDebugger isVDom]) {
        // Guard against calls with out-of-bounds indices.
        // exchangeSubviewAtIndex:withSubviewAtIndex: doesn't crash in this case, so neither should we.
        if (index1 >= 0 && index1 < [[self subviews] count]) {
            [[WXDOMDomainController defaultInstance] removeView:[[self subviews] objectAtIndex:index1]];
        }
        if (index2 >= 0 && index2 < [[self subviews] count]) {
            [[WXDOMDomainController defaultInstance] removeView:[[self subviews] objectAtIndex:index2]];
        }
        
        [self devtool_swizzled_exchangeSubviewAtIndex:index1 withSubviewAtIndex:index2];
        
        if (index1 >= 0 && index1 < [[self subviews] count]) {
            [[WXDOMDomainController defaultInstance] addView:[[self subviews] objectAtIndex:index1]];
        }
        if (index2 >= 0 && index2 < [[self subviews] count]) {
            [[WXDOMDomainController defaultInstance] addView:[[self subviews] objectAtIndex:index2]];
        }
    }else {
        [self devtool_swizzled_exchangeSubviewAtIndex:index1 withSubviewAtIndex:index2];
    }
}

@end
