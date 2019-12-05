//
//  ZQVariableMenuView.h
//  ZQVariableMenuDemo
//
//  Created by 肖兆强 on 2017/12/1.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQVariableMenuView : UIView

@property (nonatomic, strong) NSMutableArray *inUseTitles;

@property (nonatomic,strong) NSMutableArray *unUseTitles;

@property (nonatomic,assign) NSInteger fixedNum;

-(void)reloadData;


@end
