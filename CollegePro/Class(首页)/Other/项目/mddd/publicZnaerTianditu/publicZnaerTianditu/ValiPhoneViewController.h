//
//  ValiPhoneViewController.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/26.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "BaseViewController.h"
#import "ValiPhoneView.h"
@interface ValiPhoneViewController : BaseViewController

@property(nonatomic,strong)ValiPhoneView *valiPhoneView;

@property(nonatomic,strong)id<PassValueDelegate> passDelegate;

@end
