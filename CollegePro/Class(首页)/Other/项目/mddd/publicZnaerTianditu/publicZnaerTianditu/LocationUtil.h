//
//  LocationUtil.h
//  publicZnaer
//
//  Created by Jeremy on 15/3/2.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMapView.h"

@interface LocationUtil : NSObject<TMapViewDelegate>

@property(nonatomic,strong)TUserLocation *userLocation;

-(id)init;

@end
