//
//  MeInfoViewController.h
//  publicZnaer
//
//  Created by Jeremy on 15/1/20.
//  Copyright (c) 2015年 southgis. All rights reserved.
//

#import "BaseViewController.h"
#import "MeInfoView.h"
#import "CaptureViewController.h"

@interface MeInfoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,PassValueDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PassImageDelegate>

@property(nonatomic,strong)MeInfoView *infoView;
@property(nonatomic,strong)id<PassValueDelegate> valueDelegate;
@end
