//
//  BaseTabBarController.h
//  tabBarText
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabBarController : UITabBarController<UITabBarControllerDelegate>
{
    UIImageView *postView;
    UIView *postBgView,*redView,*redView1 ,*findRedView;
    UIButton *centerBtn;
    NSTimer *_timer, *_locationTimer;
}
+(BaseTabBarController *)sharedBaseTabBarViewController;

+(BaseTabBarController *)destoryShared;

@property (nonatomic,strong)UIView * bgView;
@property (nonatomic,assign)NSInteger beforeIndex;
@property (nonatomic,assign)NSInteger presentIndex;

-(void)confirmSelectTabBar:(NSInteger)seder;
@end
