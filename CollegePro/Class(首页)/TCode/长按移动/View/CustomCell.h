//
//  CustomCell.h
//  UIcollectionV
//
//  Created by BOBO on 16/11/10.
//  Copyright © 2016年 BOBO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UICollectionViewCell


@property (nonatomic,strong)  UIImageView *iconView;
@property(strong,nonatomic)UILabel * titlesLab;
@property(strong,nonatomic)UIImageView * delimgv;

-(instancetype)initWithFrame:(CGRect)frame;


@end
