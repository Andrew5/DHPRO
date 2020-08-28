//
//  THomeCollectionViewCell.h
//  Test
//
//  Created by Rillakkuma on 2017/7/8.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THomeCollectionViewCell : UICollectionViewCell
//@property (nonatomic, strong)UIImageView *imageCover;
//@property (nonatomic, strong)UILabel *labelName;
//标题
@property (nonatomic, copy) NSString *title;
/**
 图片
 */
@property (nonatomic,copy)NSString *imageName;

@end
