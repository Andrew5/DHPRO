//
//  MyfarmViewController.h
//  shiku
//
//  Created by Rilakkuma on 15/9/7.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "TBaseUIViewController.h"
#import "UserBackend.h"
#import "HomeGetdata.h"
#import "MyfarmTableViewCell.h"
#import "HomeViewControllernew.h"

@interface MyfarmViewController : TBaseUIViewController<UITableViewDataSource,UITableViewDelegate,MyfarmTableViewCellDelegate>
@property (nonatomic,weak)IBOutlet UITableView *myTableView;

@property (strong, nonatomic) UserBackend *backend;
@property(nonatomic ,strong)NSMutableArray * m_DataArr;
@property(nonatomic, strong) GOODS *goods;
@property(nonatomic, strong) NSNumber *goods_id;
@property(nonatomic, copy) NSString *usertoken;


@end
