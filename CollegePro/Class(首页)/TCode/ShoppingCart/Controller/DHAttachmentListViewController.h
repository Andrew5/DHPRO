//
//  DHAttachmentListVC.h
//  CollegePro
//
//  Created by jabraknight on 2020/9/17.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "BaseViewController.h"
#import "FilePickAllTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DHAttachmentListViewController : BaseViewController
@property(nonatomic,assign) PHDataType dataType;
@property(nonatomic,strong) NSString *TypeVC;
@end

NS_ASSUME_NONNULL_END
