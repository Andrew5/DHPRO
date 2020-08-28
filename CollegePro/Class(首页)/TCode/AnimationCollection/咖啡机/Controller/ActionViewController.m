//
//  ActionViewController.m
//  动画练习
//
//  Created by uniubi on 2017/3/16.
//  Copyright © 2017年 uniubi. All rights reserved.
//

#import "ActionViewController.h"
#import "gaunzi.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "DynamicStepProgressView.h"

@interface ActionViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *body;
@property (weak, nonatomic) IBOutlet UILabel *capacity;//容量
@property (weak, nonatomic) IBOutlet UILabel *money;//价格
@property(nonatomic,strong)gaunzi *guanzi;

@property(nonatomic,strong)DynamicStepProgressView *dynamicView;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self.view addSubview:self.dynamicView];
	
    _guanzi=[[gaunzi alloc]init];
    _guanzi.backgroundColor=[UIColor clearColor];
	_guanzi.frame=self.view.bounds;
    [self.view addSubview:_guanzi];
    
    //布局动画
    UIButton *singleMapView = [UIButton buttonWithType:(UIButtonTypeCustom)];
    singleMapView.frame=CGRectMake(46, 250, 50, 50);
//    singleMapView.image = [UIImage imageNamed:@"+c.png"];
    [singleMapView setImage:[UIImage imageNamed:@"+c.png"] forState:(UIControlStateNormal)];
    [singleMapView addTarget:self action:@selector(bt:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:singleMapView];
    
    singleMapView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    
    [UIView animateWithDuration:0.5   animations:^{
        singleMapView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }completion:^(BOOL finish){
        [UIView animateWithDuration:0.5      animations:^{
            singleMapView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                }];
        UIButton *singleMapView1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
        singleMapView1.frame =CGRectMake(127, 235, 38, 38);
        [singleMapView1 setImage:[UIImage imageNamed:@"+g.png"] forState:(UIControlStateNormal)];
        [singleMapView1 addTarget:self action:@selector(bt1:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:singleMapView1];
        
        singleMapView1.transform = CGAffineTransformMakeScale(0.0, 0.0);
        
        [UIView animateWithDuration:0.5   animations:^{
            singleMapView1.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }completion:^(BOOL finish){
            [UIView animateWithDuration:0.5      animations:^{
                singleMapView1.transform = CGAffineTransformMakeScale(0.9, 0.9);
            }];
            UIButton *singleMapView2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
            singleMapView2.frame =CGRectMake(207, 235, 40, 40);
            [singleMapView2 setImage:[UIImage imageNamed:@"+y.png"] forState:(UIControlStateNormal)];
            [singleMapView2 addTarget:self action:@selector(bt2:) forControlEvents:(UIControlEventTouchUpInside)];
            [self.view addSubview:singleMapView2];
            
            singleMapView2.transform = CGAffineTransformMakeScale(0.0, 0.0);
            
            [UIView animateWithDuration:0.5   animations:^{
                singleMapView2.transform = CGAffineTransformMakeScale(1.1, 1.1);
            }completion:^(BOOL finish){
                [UIView animateWithDuration:0.5      animations:^{
                    singleMapView2.transform = CGAffineTransformMakeScale(0.9, 0.9);
                }];
                
                UIButton *singleMapView3 = [UIButton buttonWithType:(UIButtonTypeCustom)];
                singleMapView3.frame =CGRectMake(282, 235, 40, 40);
                [singleMapView3 setImage:[UIImage imageNamed:@"+r.png"] forState:(UIControlStateNormal)];
                [singleMapView3 addTarget:self action:@selector(bt3:) forControlEvents:(UIControlEventTouchUpInside)];
                [self.view addSubview:singleMapView3];
                
                singleMapView3.transform = CGAffineTransformMakeScale(0.0, 0.0);
                
                [UIView animateWithDuration:0.5   animations:^{
                    singleMapView3.transform = CGAffineTransformMakeScale(1.1, 1.1);
                }completion:^(BOOL finish){
                    [UIView animateWithDuration:0.5      animations:^{
                        singleMapView3.transform = CGAffineTransformMakeScale(0.9, 0.9);
                    }];
                    
                    
                    
                }];
                
            }];
            
        }];
        
        
    }];
  
}
- (DynamicStepProgressView *)dynamicView
{
	if (!_dynamicView) {
		CGRect frame =CGRectMake(10,500,400, 25);
		_dynamicView = [[DynamicStepProgressView  alloc]initWithFrame:frame targetNumber:5];
		[_dynamicView setProgress:4];
		
	}
	return _dynamicView;
}
//点击+号按钮方法
-(void)bt:(UIButton*)bt
{
    CAKeyframeAnimation *matAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    matAnimation.path=_guanzi.apath.CGPath;
    matAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    matAnimation.rotationMode=kCAAnimationRotateAuto;
    matAnimation.duration=1.0;
    UIView *mateial=[[UIView alloc]init];
    mateial.backgroundColor=[UIColor colorWithRed:251/255.0 green:176/255.0 blue:59/255.0 alpha:1.0];
    mateial.frame=CGRectMake(0, 0, 15, 15);
    mateial.layer.masksToBounds=YES;
    mateial.layer.cornerRadius=7.5;
    [self.view addSubview:mateial];
    [self.view sendSubviewToBack:mateial];
    [mateial.layer addAnimation:matAnimation forKey:@"position"];
    
    [self getAnimation];
    //中间齿轮处理
    [self gearAnimation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //流水处理
        [self waterAnimation];
        
        
    });

}
-(void)bt1:(UIButton*)bt1
{
    CAKeyframeAnimation *matAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    matAnimation.path=_guanzi.apath1.CGPath;
    matAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    matAnimation.rotationMode=kCAAnimationRotateAuto;
    matAnimation.duration=0.5;
    UIView *mateial=[[UIView alloc]init];
    mateial.backgroundColor=[UIColor colorWithRed:251/255.0 green:176/255.0 blue:59/255.0 alpha:1.0];
    mateial.frame=CGRectMake(0, 0, 15, 15);
    mateial.layer.masksToBounds=YES;
    mateial.layer.cornerRadius=7.5;
    [self.view addSubview:mateial];
    [self.view sendSubviewToBack:mateial];

    [mateial.layer addAnimation:matAnimation forKey:@"position"];
    [self getAnimation];

}
-(void)bt2:(UIButton*)bt2
{
    CAKeyframeAnimation *matAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    matAnimation.path=_guanzi.apath2.CGPath;
    matAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    matAnimation.rotationMode=kCAAnimationRotateAuto;
    matAnimation.duration=0.5;
    UIView *mateial=[[UIView alloc]init];
    mateial.backgroundColor=[UIColor colorWithRed:251/255.0 green:176/255.0 blue:59/255.0 alpha:1.0];
    mateial.frame=CGRectMake(0, 0, 15, 15);
    mateial.layer.masksToBounds=YES;
    mateial.layer.cornerRadius=7.5;
    [self.view addSubview:mateial];
    [self.view sendSubviewToBack:mateial];

    [mateial.layer addAnimation:matAnimation forKey:@"position"];
    [self getAnimation];

}
-(void)bt3:(UIButton*)bt3
{
    CAKeyframeAnimation *matAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    matAnimation.path=_guanzi.apath3.CGPath;
    matAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    matAnimation.rotationMode=kCAAnimationRotateAuto;
    matAnimation.duration=1.0;
    UIView *mateial=[[UIView alloc]init];
    mateial.backgroundColor=[UIColor colorWithRed:251/255.0 green:176/255.0 blue:59/255.0 alpha:1.0];
    mateial.frame=CGRectMake(0, 0, 15, 15);
    mateial.layer.masksToBounds=YES;
    mateial.layer.cornerRadius=7.5;
    [self.view addSubview:mateial];
    [self.view sendSubviewToBack:mateial];

    [mateial.layer addAnimation:matAnimation forKey:@"position"];
    [self getAnimation];

}
//蓝色管子流动动画
-(void)getAnimation
{
    CAKeyframeAnimation *matAnimation1=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    matAnimation1.path=_guanzi.apath4.CGPath;
    matAnimation1.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    matAnimation1.rotationMode=kCAAnimationRotateAuto;
    matAnimation1.duration=1.0;
    UIView *mateial1=[[UIView alloc]init];
    mateial1.backgroundColor=[UIColor colorWithRed:168/255.0 green:216/255.0 blue:244/255.0 alpha:1.0];
    mateial1.frame=CGRectMake(0, 0, 12, 12);
    mateial1.layer.masksToBounds=YES;
    mateial1.layer.cornerRadius=6;
    [self.view addSubview:mateial1];
    [mateial1.layer addAnimation:matAnimation1 forKey:@"position"];

}
//齿轮处理
-(void)gearAnimation
{
    //布局动画
    UIImageView *singleMapView = [[UIImageView alloc]initWithFrame:CGRectMake(162, 320, 50, 50)];
        singleMapView.image = [UIImage imageNamed:@"窗口光效.png"];
    [self.view addSubview:singleMapView];
    
    singleMapView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    
    [UIView animateWithDuration:1   animations:^{
        singleMapView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }completion:^(BOOL finish){
        [UIView animateWithDuration:1      animations:^{
            singleMapView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        }];
    }];
}

-(void)waterAnimation
{
    
    //布局动画
    UILabel *la1 =[[UILabel alloc]initWithFrame:CGRectMake(185, 450, 5, 50)];
    la1.backgroundColor=[UIColor brownColor];
    
    [self.view addSubview:la1];
    
    la1.frame = CGRectMake(185, 450, 5, 0);
    
    
    [UIView animateWithDuration:1.0   animations:^{
        la1.frame = CGRectMake(185, 450, 5, 50);
        
      
        
    }completion:^(BOOL finish){
        
        UILabel *la2 =[[UILabel alloc]initWithFrame:CGRectMake(165, 489, 42, 12)];
        la1.frame = CGRectMake(185, 450, 5, 50);

        la2.backgroundColor=[UIColor brownColor];
        [self.view addSubview:la2];
        la2.frame = CGRectMake(165, 501, 42, 0);
        [UIView animateWithDuration:1.0   animations:^{
            la2.frame = CGRectMake(165, 489, 42, 12);

        }completion:^(BOOL finish){
            
           
            [UIView animateWithDuration:0.5   animations:^{
                la1.transform = CGAffineTransformMakeTranslation(0, 20);
                la1.transform = CGAffineTransformScale(la1.transform, 1, 0.1);
            }completion:^(BOOL finish){
                
            
                
            }];
            
            
        }];
        
    }];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
