//
//  LBTabBarTextController.h
//  Test
//
//  Created by Rillakkuma on 2017/12/8.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBTabBarTextController : UITabBarController<UITabBarControllerDelegate>
{
	UIImageView *postView;
	UIView *postBgView,*redView,*redView1 ,*findRedView;
	UIButton *centerBtn;
	NSTimer *_timer, *_locationTimer;
}
+(LBTabBarTextController *)sharedBaseTabBarViewController;

+(LBTabBarTextController *)destoryShared;

@property (nonatomic,strong)UIView * bgView;
@property (nonatomic,assign)NSInteger beforeIndex;
@property (nonatomic,assign)NSInteger presentIndex;

-(void)confirmSelectTabBar:(NSInteger)seder;

@end
