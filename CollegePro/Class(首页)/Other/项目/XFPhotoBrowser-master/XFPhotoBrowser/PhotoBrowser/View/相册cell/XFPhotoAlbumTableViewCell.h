//
//  XFPhotoAlbumTableViewCell.h
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/5.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFAssetsLibraryModel;

@interface XFPhotoAlbumTableViewCell : UITableViewCell

- (void)setupModel:(XFAssetsLibraryModel *)model;

@end
