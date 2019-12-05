//
//  DPPhotoListViewController.h
//  DPPictureSelector
//
//  Created by boombox on 15/9/1.
//  Copyright (c) 2015年 lidaipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPPhotoGroupViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface DPPhotoListCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) BOOL isChoose;/**< 是否已选择 */

@end

@interface DPPhotoListViewController : UIViewController

@property (strong, nonatomic) ALAssetsGroup *group;/**< 相薄 */
@property (strong, nonatomic) DPPhotoGroupViewController *groupVC;

@end
