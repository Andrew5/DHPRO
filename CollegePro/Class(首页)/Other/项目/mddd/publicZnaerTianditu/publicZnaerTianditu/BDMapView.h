//
//  BDMapView.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/3.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMapView.h"
#import "BaseView.h"

@interface BDMapView : BaseView

@property(nonatomic,retain)TMapView *tMapView;

@property(nonatomic,retain)UIButton *locationBtn;

@property(nonatomic,retain)UIButton *peopleBtn;
@property(nonatomic,retain) UIView *headsView;
@property(nonatomic,strong)id<BaseViewDelegate> baseViewDelegate;

-(void)setFriendListData:(NSArray *)datas;

@end
