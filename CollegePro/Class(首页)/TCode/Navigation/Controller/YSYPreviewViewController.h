//
//  YSYPreviewViewController.h
//  Test
//
//  Created by Rillakkuma on 2016/10/9.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostTableViewController.h"
static UIImage *currentImage;
@interface YSYPreviewViewController : UIViewController<UIActionSheetDelegate>
+(void) setPreviewImage:(UIImage *)image;
- (IBAction)deleteSelectedImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;
@end
