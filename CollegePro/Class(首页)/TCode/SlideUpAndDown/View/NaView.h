//
//  NaView.h
//  UserDetail
//
//  Created by Rainy on 16/10/8.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NaViewDelegate <NSObject>
@optional
- (void)NaLeft;
- (void)NaRight;
@end
@interface NaView : UIView

@property(nonatomic,assign)id<NaViewDelegate>delegate;
@property(nonatomic,strong)UIImageView * headBackView;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)UIColor * color;
@property(nonatomic,strong)NSString * left_bt_Image;
@property(nonatomic,strong)NSString * right_bt_Image;

@end
