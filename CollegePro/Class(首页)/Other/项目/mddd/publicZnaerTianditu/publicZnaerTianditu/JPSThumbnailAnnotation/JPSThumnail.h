//
//  JPSThumnail.h
//  publicZnaerTianditu
//
//  Created by 吴小星 on 15-3-16.
//  Copyright (c) 2015年 吴小星. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMapView.h"

typedef void (^ActionBlock)();

@interface JPSThumnail : NSObject

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) ActionBlock disclosureBlock;
@property (nonatomic, strong)NSDictionary *info;

@end