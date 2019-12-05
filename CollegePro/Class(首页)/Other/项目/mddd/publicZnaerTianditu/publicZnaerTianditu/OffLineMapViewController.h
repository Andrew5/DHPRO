//
//  OffLineMapViewController.h
//  publicZnaer
//
//  Created by Jeremy on 15/1/29.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "BaseViewController.h"
#import "TMapView.h"
#import "TOffLineManger.h"
#import "OffLineMapView.h"

@interface OffLineMapViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,TOffLineMangerDelegate>

@property(nonatomic,strong)OffLineMapView *offLineMapView;

@property(nonatomic, retain) TOffLineManger *offLineManger;
@property(nonatomic, retain) TOffLineMapSearch *offLineMapSearch;

@property(nonatomic,strong)NSMutableArray *arraylocalDownLoadMapInfo;//本地下载的离线地图

@property (assign)BOOL isOpen;
@property (nonatomic,retain)NSIndexPath *selectIndex;

@end
