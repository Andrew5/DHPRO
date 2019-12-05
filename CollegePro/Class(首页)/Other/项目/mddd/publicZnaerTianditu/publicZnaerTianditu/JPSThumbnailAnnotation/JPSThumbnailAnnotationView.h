//
//  JPSThumbnailAnnotationView.h
//  JPSThumbnailAnnotationView
//
//  Created by Jean-Pierre Simard on 4/21/13.
//  Copyright (c) 2013 JP Simard. All rights reserved.
//



@class JPSThumbnail;

#import "TMapView.h"

extern NSString * const kJPSThumbnailAnnotationViewReuseID;

typedef NS_ENUM(NSInteger, JPSThumbnailAnnotationViewAnimationDirection) {
    JPSThumbnailAnnotationViewAnimationDirectionGrow,
    JPSThumbnailAnnotationViewAnimationDirectionShrink,
};

typedef NS_ENUM(NSInteger, JPSThumbnailAnnotationViewState) {
    JPSThumbnailAnnotationViewStateCollapsed,
    JPSThumbnailAnnotationViewStateExpanded,
    JPSThumbnailAnnotationViewStateAnimating,
};

@protocol JPSThumbnailAnnotationViewProtocol <NSObject>

- (void)didSelectAnnotationViewInMap:(TMapView *)mapView;
- (void)didDeselectAnnotationViewInMap:(TMapView *)mapView;

@end

@interface JPSThumbnailAnnotationView :TAnnotationView <JPSThumbnailAnnotationViewProtocol>

- (id)initWithAnnotation:(id<TAnnotation>)annotation;

- (void)updateWithThumbnail:(JPSThumbnail *)thumbnail;

@end
