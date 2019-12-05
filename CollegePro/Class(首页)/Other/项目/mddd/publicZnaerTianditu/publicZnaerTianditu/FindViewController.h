//
//  FindViewController.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/3.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "BaseViewController.h"
#import "FindView.h"
#import "TMapView.h"

@interface FindViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,BaseViewDelegate>

@property(nonatomic,strong)FindView *findView;

@property(nonatomic,strong)NSMutableArray *datas;

@property(nonatomic,strong)id<PassValueDelegate> valueDelegate;

@end