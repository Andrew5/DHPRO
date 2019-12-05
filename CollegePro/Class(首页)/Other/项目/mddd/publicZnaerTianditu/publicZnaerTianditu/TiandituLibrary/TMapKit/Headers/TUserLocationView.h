//
//  TUserLocationView.h
//  TDT_MapKit
//
//  Created by xiangkui su on 12-9-24.
//  Copyright 2012 Tianditu Inc All rights reserved.
//

#import "TAnnotationView.h"
#import "TUserLocation.h"

@class TUserLocationViewInternal;

/// 用户位置视图信息
@interface TUserLocationView : TAnnotationView {
@private
    TUserLocationViewInternal *userinternal;
}
@end
