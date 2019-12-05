//
//  myCell.h
//  Test
//
//  Created by Rillakkuma on 16/7/12.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myCell : UITableViewCell{
    UILabel * myLable;
    UIImageView * myImageView;
    UILabel * title;
}
@property (strong,nonatomic) UILabel * myLabel;
@property (strong,nonatomic) UIImageView * myImageView;
@property (strong,nonatomic) UILabel * title;
//@property (strong,nonatomic) UIButton * addImageButton;

@end
