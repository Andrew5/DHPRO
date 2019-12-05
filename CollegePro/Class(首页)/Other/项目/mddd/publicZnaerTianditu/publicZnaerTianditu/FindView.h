//
//  FindView.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/3.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

typedef enum {
    distance500 = 500,
    distance1000 = 1000,
    distance1500 = 1500
}DistanceParam;

typedef enum {
    girl = 0,
    man = 1,
    all = 2
}SexParam;


@interface FindView : BaseView

@property(nonatomic,strong)UIView      *topView;
@property(nonatomic,strong)UIButton    *screenBtn;
@property(nonatomic,strong)UIButton     *distanceBtn;
@property(nonatomic,strong)UIButton     *sexBtn;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *mBaseView;
@property(nonatomic,strong)UIView *contentView;

@property(nonatomic       )DistanceParam distanceParam;
@property(nonatomic       )SexParam        sexParam;
@property(nonatomic,strong)id<BaseViewDelegate> baseViewDelegate;

@end
