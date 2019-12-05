//
//  BDMapViewController.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/3.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "BaseViewController.h"
#import "TMapView.h"
#import "BDMapView.h"
#import "Constants.h"

@interface BDMapViewController : BaseViewController<TMapViewDelegate, BaseViewDelegate,PassValueDelegate>

@property(nonatomic,retain)BDMapView *mapView;

@property(nonatomic,strong)id<PassValueDelegate> valueDelegate;

@property(nonatomic,strong)NSMutableArray *arrayRecentFriend;//最近联系人列表
//@property(nonatomic,strong)id<PassValueDelegate> valueDelegate;



@end
