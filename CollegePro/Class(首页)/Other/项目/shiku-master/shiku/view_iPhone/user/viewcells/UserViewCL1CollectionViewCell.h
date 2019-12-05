//
//  UserViewCL1CollectionViewCell.h
//  shiku
//
//  Created by txj on 15/4/7.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  cell模板，各属性请对照.xib文件
 */
@interface UserViewCL1CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *speratorline;
//图片
@property (weak, nonatomic) IBOutlet UIImageView *image1;

//SHUZI
@property (weak, nonatomic) IBOutlet UILabel *label1;//废弃
//WENZI
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end
