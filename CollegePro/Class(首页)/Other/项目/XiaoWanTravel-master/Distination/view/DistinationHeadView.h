//
//  DistinationHeadView.h
//  XiaoWanTravel
//
//  Created by xiao on 16/7/23.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DistinationHeadViewDelegate <NSObject>

-(void)sendButton:(UIButton *)button;

@end
@interface DistinationHeadView : UICollectionReusableView
@property(nonatomic,strong)id<DistinationHeadViewDelegate>delegate;
@property(nonatomic,strong)UIButton *button;
@end
