//
//  AddFirendViewController.h
//  publicZnaer
//
//  Created by Jeremy on 14/12/19.
//  Copyright (c) 2014年 southgis. All rights reserved.
//

#import "BaseViewController.h"
#import "AddFriendView.h"

#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]

@interface AddFirendViewController : BaseViewController<UITextFieldDelegate>


@property(nonatomic,retain)AddFriendView *addFirendView;

@property(nonatomic,strong)id<PassValueDelegate> valueDelegate;

@end
