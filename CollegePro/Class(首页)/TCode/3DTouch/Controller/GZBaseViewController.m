//
//  GZBaseViewController.m
//  3DTouch(GZ)
//
//  Created by xinshijie on 2017/4/10.
//  Copyright © 2017年 Mr.quan. All rights reserved.
//

#import "GZBaseViewController.h"
#import "HWSlider.h"

@interface GZBaseViewController ()

@property (strong, nonatomic)  UILabel *Label;
@property (strong, nonatomic)  UISlider *slider;
@property (strong, nonatomic)  NSLayoutConstraint *bottom;
@end

@implementation GZBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.navTitle;
    self.view.tag = 110 ;
    UILabel *Name = [[UILabel alloc] init];
    Name.text = [NSString stringWithFormat:@"GZDemo-%@",self.navTitle];
    Name.textColor = [UIColor blueColor];
    Name.textAlignment = NSTextAlignmentCenter ;
    Name.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.7 alpha:1];
    Name.frame = CGRectMake(50, 270, self.view.bounds.size.width - 100 , 30);
    [self.view addSubview:Name];
    
    
    _slider = [[UISlider alloc]initWithFrame:CGRectMake(50, 330, self.view.bounds.size.width - 100, 30)];
    _slider.backgroundColor = [UIColor orangeColor];
    _slider.minimumValue = 0;// 设置最小值
    _slider.maximumValue = 6.667;// 设置最大值
    _slider.value = [_Label.text integerValue] ;// 设置初始值
   // _slider.continuous = YES;// 设置可连续变化
//    _slider.minimumTrackTintColor = [UIColor greenColor]; //滑轮左边颜色，如果设置了左边的图片就不会显示
//    _slider.maximumTrackTintColor = [UIColor redColor]; //滑轮右边颜色，如果设置了右边的图片就不会显示
////    _slider.thumbTintColor = [UIColor orangeColor];//设置了滑轮的颜色，如果设置了滑轮的样式图片就不会显示
//    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
    [self.view addSubview:_slider];
    
    _Label = [[UILabel alloc]initWithFrame:CGRectMake(150, self.view.bounds.size.height - 40, self.view.bounds.size.width - 200, 35)];
    _Label.backgroundColor = [UIColor redColor];
    [self.view addSubview:_Label];
    
    //滑动条
    HWSlider *slider = [[HWSlider alloc] initWithFrame:CGRectMake(50, 100, 300, 75)];
    slider.layer.borderColor = [UIColor greenColor].CGColor;
    slider.layer.borderWidth = 1.0;
    [self.view addSubview:slider];
    // Do any additional setup after loading the view.
}
//// slider变动时改变label值
//- (void)sliderValueChanged:(id)sender {
//    self.slider.value = [_Label.text integerValue];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//3Dtouch会自动调用 预览页面 底部Action Items
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    //
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"删除" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        if ([self.delegate respondsToSelector:@selector(GZViewController:DidSelectedDeleteItem:)]) {
            [self.delegate GZViewController:self DidSelectedDeleteItem:self.navTitle];
        }
    }];
    //
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"返回" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        if ([self.delegate respondsToSelector:@selector(GZViewControllerDidSelectedBackItem:)]) {
            [self.delegate GZViewControllerDidSelectedBackItem:self];
        }
    }];
    
    NSArray *actions = @[action1,action2];
    
    return actions;
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSArray *arrayTouch = [touches allObjects];
    UITouch *touch = (UITouch *)[arrayTouch lastObject];
    if (touch.view.tag == 110) {
        NSLog(@"Began压力 ＝ %f",touch.force);
        _Label.text = [NSString stringWithFormat:@"压力%f",touch.force];
        _slider.value = [_Label.text integerValue] ;
        _bottom.constant = ((UITouch *)[arrayTouch lastObject]).force * 100;
    }
    
}

//按住移动or压力值改变时的回调
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSArray *arrayTouch = [touches allObjects];
    UITouch *touch = (UITouch *)[arrayTouch lastObject];
    //通过tag确定按压的是哪个view，注意：如果按压的是label，将label的userInteractionEnabled属性设置为YES
    _slider.value = touch.force ;
    
    NSLog(@"%ld",(long)_slider.value);
    if (touch.view.tag == 110) {
        NSLog(@"move压力 ＝ %f",touch.force);
        //红色背景的label显示压力值
        _Label.text = [NSString stringWithFormat:@"  压力%f",touch.force];
        _slider.value = touch.force ;
        //红色背景的label上移的高度＝压力值*100
        _bottom.constant = ((UITouch *)[arrayTouch lastObject]).force * 100;
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSArray *arrayTouch = [touches allObjects];
    UITouch *touch = (UITouch *)[arrayTouch lastObject];
    if (touch.view.tag == 110) {
        NSLog(@"End压力 ＝ %f",touch.force);
        _Label.text = [NSString stringWithFormat:@"   压力%f",touch.force];
        _slider.value = touch.force ;
        _bottom.constant = ((UITouch *)[arrayTouch lastObject]).force * 100;
    }
    
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSArray *arrayTouch = [touches allObjects];
    UITouch *touch = (UITouch *)[arrayTouch lastObject];
    if (touch.view.tag == 110) {
        NSLog(@"Cancel压力 ＝ %f",touch.force);
        NSLog(@"压力所在view的tag ＝ %li",touch.view.tag);
        _Label.text = [NSString stringWithFormat:@"压力%f",touch.force];
        _slider.value = touch.force ;
        _bottom.constant = ((UITouch *)[arrayTouch lastObject]).force * 100;
    }
    
}


@end
