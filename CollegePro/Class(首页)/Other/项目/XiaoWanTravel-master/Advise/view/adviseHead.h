//
//  adviseHead.h
//  XiaoWanTravel
//
//  Created by xiao on 16/7/30.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol adviseHeadDelegate <NSObject>

-(void)downloandSleeve:(UIButton* )btn;

@end
@interface adviseHead : UIView


@property(nonatomic,strong) UIImageView* imageHeader;
@property(nonatomic,strong)UILabel *labelhead;
@property(nonatomic,strong) UIButton* downlondBtn;
@property(nonatomic,strong) UIProgressView* progress;
@property(nonatomic,assign) id<adviseHeadDelegate> delegate;

@end
