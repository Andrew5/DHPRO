//
//  ShowViewController.m
//  PackageDemo
//
//  Created by 思 彭 on 2017/4/12.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "ShowViewController.h"
#import "TagPickerView.h"

@interface ShowViewController ()

@property (nonatomic, weak) UILabel *label;

@end

@implementation ShowViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 80, self.view.frame.size.width - 80, 60)];
    label.text = @"点击弹出选择哟!!!";
    label.backgroundColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    label.userInteractionEnabled = YES;
    self.label = label;
    // 触发弹出
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [label addGestureRecognizer:tap];


    UILabel *labell = [[UILabel alloc]initWithFrame:CGRectMake(50, 150, 275, 50)];
    labell.text = @"不会是我吧推技术";
    labell.textAlignment = NSTextAlignmentCenter;
    labell.font = [UIFont systemFontOfSize:30];
    labell.textColor = [UIColor redColor];
    labell.backgroundColor = [UIColor clearColor];
    [self.view addSubview:labell];
    labell.text = [self inputValue:labell.text];

    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 0, 0.5);
    transform = CGAffineTransformMakeRotation(M_PI*1);
    labell.transform = transform;

    CABasicAnimation* rotationAnimation;
    //    //绕哪个轴，那么就改成什么：这里是绕y轴 ---> transform.rotation.y
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    //    //旋转角度
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
    labell.transform = CGAffineTransformMakeRotation(-M_PI);
    [labell.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}
-(NSString *)inputValue:(NSString *)str{
    
    NSMutableString *string=[[NSMutableString alloc] init];
    
    for(int i=0;i<str.length;i++){
        
        [string appendString:[str substringWithRange:NSMakeRange(str.length-i-1, 1)]];
        
    }
    
    return string;
    
}
#pragma mark - Private Method

- (void)tapClick: (UITapGestureRecognizer *)tap {
    
    TagPickerView *tagsView = [TagPickerView shareInstance];
    tagsView.tagsArray = @[@"aaa", @"bbb", @"ccc", @"思思童鞋", @"ddd", @"11111111111",@"哈哈哈哈哈哈", @"开心,😊每天都是好心情!!!",@"上班啦",@"今天吃麦当劳"];
    [self.view addSubview:tagsView];  // 注意要将放到self.view上
    tagsView.selectedTagBlock = ^(NSArray *tagsArray) {
		NSLog(@"当前选择的标签个数: %lu 标签是: ",(unsigned long)tagsArray.count);
        NSMutableArray *arr = [tagsArray mutableCopy]; // 不可变数组才可以拼接
        for (NSString *tagStr in tagsArray) {
            NSLog(@"--%@--",tagStr);
            self.label.text = [arr componentsJoinedByString:@"--"];
        }
    };
}

@end
