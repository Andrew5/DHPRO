//
//  LocationUtil.m
//  publicZnaer
//
//  Created by Jeremy on 15/3/2.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "LocationUtil.h"
#import "AppDelegate.h"

@implementation LocationUtil
{
    TMapView *_locMapView;
     AppDelegate        *_appDelegate;
    
}

-(id)init{
    
    self = [super init];
    
    if (self) {
    
        _locMapView=[[TMapView alloc]init];
        _locMapView.delegate=self;
        [_locMapView StartGetPosition];
        [_locMapView ShowPosition];
        _locMapView.UserTrackMode=TUserTrackingModeFollow;
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    
    return self;
    
}

-(void)mapView:(TMapView *)mapView didUpdateUserLocation:(TUserLocation *)userLocation{

    _appDelegate.myLocation=userLocation;
}

@end
