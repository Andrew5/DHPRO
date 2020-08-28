//
//  ExpandCell.h
//  点击按钮出现下拉列表
//
//  Created by 杜甲 on 14-3-26.
//  Copyright (c) 2014年 杜甲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpandCell : UITableViewCell
@property (strong , nonatomic) UILabel* m_TileL;
-(void)setCellContentData:(NSString*)name;

@end
