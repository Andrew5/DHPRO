//
//  ZQVariableMenuCell.h
//  ZQVariableMenuDemo
//
//  Created by 肖兆强 on 2017/12/1.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQVariableMenuCell : UICollectionViewCell

//标题
@property (nonatomic, copy) NSString *title;


/**
 图片
 */
@property (nonatomic,copy)NSString *imageName;


//是否正在移动状态
@property (nonatomic, assign) BOOL isMoving;

//是否不可移动
@property (nonatomic, assign) BOOL isFixed;


@end
