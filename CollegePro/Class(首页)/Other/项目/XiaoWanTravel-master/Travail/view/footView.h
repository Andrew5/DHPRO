//
//  footView.h
//  XiaoWanTravel
//
//  Created by xiao on 16/7/22.
//  Copyright © 2016年 xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol footViewDelegate <NSObject>//代理方法,五步

-(void)sendButton:(UIButton *)button;

@end
@interface footView : UICollectionReusableView
@property(nonatomic,assign)id<footViewDelegate>delegate;
@property(nonatomic,strong) UIButton *button;
@end
