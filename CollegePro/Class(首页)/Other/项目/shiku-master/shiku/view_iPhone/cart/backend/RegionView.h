//
//  RegionView.h
//  shiku
//
//  Created by yanglele on 15/8/26.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RegionMode;
@protocol RefionViewDelegate <NSObject>

-(void)SelecateCell:(RegionMode *)mode Tag:(NSInteger)Tag;

@end
@interface RegionView : UIView

@property(nonatomic ,weak)id<RefionViewDelegate> m_delegate;

-(id)initWithFrame:(CGRect)frame Pid:(NSString *)pid Tag:(NSInteger)Tag;

-(id)initWithFrame:(CGRect)frame cartGoods_id:(NSNumber *)Goods_id;

-(void)cartGoods_id:(NSNumber *)Goods_id;

-(void)ReloadView:(NSString *)Pid Tag:(NSInteger)Tag;

@end
