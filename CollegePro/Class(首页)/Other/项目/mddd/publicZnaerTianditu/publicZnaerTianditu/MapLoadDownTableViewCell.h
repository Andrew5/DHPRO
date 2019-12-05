//
//  MapLoadDownTableViewCell.h
//  Znaer
//
//  Created by Jeremy on 14-6-25.
//  Copyright (c) 2014年 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDProgressView.h"
#import "TMapView.h"
#import "TDownLoadingCity.h"


@interface MapLoadDownTableViewCell : UITableViewCell

@property (nonatomic,retain) UILabel *cityName;
@property (nonatomic,retain) ZDProgressView *progressView;
@property (nonatomic,retain) NSIndexPath *indexPath;
@property (nonatomic,retain) TDownLoadingCity *updateInfo;//进度条初始进度

- (void)changeProgressValue:(TDownLoadingCity *)element;

@end
