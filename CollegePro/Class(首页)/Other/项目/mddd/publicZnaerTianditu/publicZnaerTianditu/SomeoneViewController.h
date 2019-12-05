//
//  SomeoneViewController.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/3.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "BaseViewController.h"
#import "SomeoneView.h"

@interface SomeoneViewController : BaseViewController

@property(nonatomic,retain)SomeoneView *someoneView;
@property(nonatomic,strong)id<PassValueDelegate> valueDelegate;
@end
