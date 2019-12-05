//
//  DPPhotoGroupViewController.h
//  DPPictureSelector
//
//  Created by boombox on 15/9/1.
//  Copyright (c) 2015年 lidaipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DPPhotoGroupViewControllerDelegate <NSObject>

@optional
/**
 *  选择完图片回调
 */
- (void)didSelectPhotos:(NSMutableArray *)photos;

@end

@interface DPPhotoGroupCell : UITableViewCell

@end

@interface DPPhotoGroupViewController : UIViewController

@property (assign, nonatomic) NSInteger maxSelectionCount;/**< 最多选择图片张数 */
@property (assign, nonatomic) id<DPPhotoGroupViewControllerDelegate> delegate;

@end
