//
//  FriendInfoViewController.h
//  publicZnaer
//
//  Created by Jeremy on 15/1/6.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendInfoView.h"

@interface FriendInfoViewController : BaseViewController<PassValueDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)FriendInfoView *infoView;
@property(nonatomic,strong)id<PassValueDelegate> valueDelegate;
@end
