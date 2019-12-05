//
//  UDTableViewCell.h
//  Test
//
//  Created by Rillakkuma on 16/7/27.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CustomSelectBlock)(BOOL selected, NSInteger row);

@interface UDTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, strong) UIButton *btnSelect;

@property (nonatomic, getter=isCustomSelected) BOOL customSelected;

@property (nonatomic, copy) CustomSelectBlock customSelectedBlock;

@end
