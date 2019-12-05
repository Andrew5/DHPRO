//
//  RegisterViewController.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/26.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "BaseViewController.h"
#import "RegisterView.h"
@interface RegisterViewController : BaseViewController<PassValueDelegate>

@property(nonatomic,retain)RegisterView *registerView;

@end
