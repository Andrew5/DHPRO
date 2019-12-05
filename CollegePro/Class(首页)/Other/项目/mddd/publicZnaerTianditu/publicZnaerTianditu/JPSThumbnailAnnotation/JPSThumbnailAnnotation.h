//
//  JPSThumbnailAnnotation.h
//  JPSThumbnailAnnotationView
//
//  Created by Jean-Pierre Simard on 4/21/13.
//  Copyright (c) 2013 JP Simard. All rights reserved.
//

@import Foundation;
#import "JPSThumnail.h"
#import "JPSThumbnailAnnotationView.h"
#import "TMapView.h"

@protocol JPSThumbnailAnnotationProtocol <NSObject>

- (TAnnotationView *)annotationViewInMap:(TMapView *)mapView;

@end

@interface JPSThumbnailAnnotation : NSObject <TAnnotation, JPSThumbnailAnnotationProtocol>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

+ (instancetype)annotationWithThumbnail:(JPSThumnail *)thumbnail;
- (id)initWithThumbnail:(JPSThumnail *)thumbnail;
- (void)updateThumbnail:(JPSThumnail *)thumbnail animated:(BOOL)animated;

@end
