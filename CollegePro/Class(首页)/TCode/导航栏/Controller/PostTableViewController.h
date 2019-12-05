//
//  PostTableViewController.h
//  Test
//
//  Created by Rillakkuma on 2016/10/9.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSYPreviewViewController.h"
@interface PostTableViewController : UITableViewController<UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *photosCollectionView;
@property (weak, nonatomic) IBOutlet UISwitch *WeiboSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *RenrenSwitch;
- (IBAction)DoubanSwitched:(id)sender;
- (IBAction)RenrenSwitched:(id)sender;
- (IBAction)WeiboSwitched:(id)sender;

+(void) deleteSelectedImage:(NSInteger) index;
+(void) deleteSelectedImageWithImage:(UIImage*)image;
@end
