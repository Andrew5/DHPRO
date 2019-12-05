//
//  LastCell.h
//  XiaoWanTravel
//
//  Created by xiao on 16/7/21.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LastCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *authour;

@property (weak, nonatomic) IBOutlet UILabel *readLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconV;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@end
