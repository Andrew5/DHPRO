//
//  discountCell.h
//  XiaoWanTravel
//
//  Created by xiao on 16/7/25.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface discountCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *discount;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
