//
//  NearbViewController.h
//  shiku
//
//  Created by Rilakkuma on 15/8/20.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "TBaseUIViewController.h"
#import "MapAnnotationMode.h"
@interface NearbViewController : TBaseUIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)MapAnnotationMode *model;
@property (strong, nonatomic)NSArray *locationDataArray;
@property (strong, nonatomic)NSString *subtitle;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;

@property (nonatomic)CGFloat lat;
@property (nonatomic)CGFloat longati;;

@end
@interface NeardataObject : NSObject
@property NSString *mid;
@property NSString *rates;
@property NSString *sales;
@property NSString *areas;
@property NSString *catenmae;
@property NSString *distance;
@property NSString *title;
@property NSString *goodsImage;

@end