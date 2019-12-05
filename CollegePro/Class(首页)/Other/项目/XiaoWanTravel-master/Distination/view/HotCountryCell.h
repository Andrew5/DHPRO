//
//  HotCountryCell.h
//  XiaoWanTravel
//
//  Created by xiao on 16/7/23.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotCountryCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *countryName;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
