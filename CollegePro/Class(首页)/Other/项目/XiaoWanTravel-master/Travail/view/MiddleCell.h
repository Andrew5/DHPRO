//
//  MiddleCell.h
//  XiaoWanTravel
//
//  Created by xiao on 16/7/21.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiddleCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *MiddleImagev;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;

@end
