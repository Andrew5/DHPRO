//
//  CornerViewController.m
//  CollegePro
//
//  Created by jabraknight on 2019/7/4.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "CornerViewController.h"
#import "Masonry.h"
#import "CustomView.h"
#import "MasonryCustomView.h"

#import "UIView+RandomCorner.h"
@interface CornerViewController ()
@property (nonatomic, strong) UIView *masonryView;

@end

@implementation CornerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //直接设置frame使用固定布局的view，设置完frame后就可以设置圆角
    //如果是自定义视图，可以直接在initWithFrame方法中进行设置
    
    //能正常生产圆角
    UIView *view = [[UIView alloc] init];//
    view.frame = CGRectMake(50, 50, 200, 100);
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    [view setCorners:UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    
    //自定义视图，可以把画圆角的操作封装在视图内部的initWithFrame方法中
    CustomView *frameCustomView = [[CustomView alloc] init];
    frameCustomView.frame = CGRectMake(50, 170, 200, 100);
    frameCustomView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:frameCustomView];
    
    //使用masonry自动布局
    self.masonryView = [[UIView alloc] init];
    self.masonryView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.masonryView];
    
    [self.masonryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 100));
        make.top.mas_equalTo(self.view.mas_top).offset(300);
        make.centerX.mas_equalTo(self.view);
    }];
    
    //这里加了这句之后就看不到masonryView了
    //    [self.masonryView setCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
    
    MasonryCustomView *masonryCustomView = [[MasonryCustomView alloc] init];
    masonryCustomView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:masonryCustomView];
    [masonryCustomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(100);
        make.top.mas_equalTo(self.view.mas_top).offset(430);
        make.centerX.mas_equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
    ///空心圆
    /* The fill rule used when filling the path. Options are `non-zero' and
     * `even-odd'. Defaults to `non-zero'. */
//    @property(copy) NSString *fillRule; ```
         
//    属性用于指定使用哪一种算法去判断画布上的某区域是否属于该图形“内部” （内部区域将被填充）。对一个简单的无交叉的路径，哪块区域是“内部” 是很直观清除的。但是，对一个复杂的路径，比如自相交或者一个子路径包围另一个子路径，“内部”的理解就不那么明确了。
//
//    `kCAFillRuleNonZero`
//         字面意思是“非零”。按该规则，要判断一个点是否在图形内，从该点作任意方向的一条射线，然后检测射线与图形路径的交点情况。从0开始计数，路径从左向右穿过射线则计数加1，从右向左穿过射线则计数减1。得出计数结果后，如果结果是0，则认为点在图形外部，否则认为在内部。下图演示了kCAFillRuleNonZero规则:
//    ![3.png](http://upload-images.jianshu.io/upload_images/833634-f1b5b4a0052db40e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
//
//    `kCAFillRuleEvenOdd`
//         字面意思是“奇偶”。按该规则，要判断一个点是否在图形内，从该点作任意方向的一条射线，然后检测射线与图形路径的交点的数量。如果结果是奇数则认为点在内部，是偶数则认为点在外部。下图演示了kCAFillRuleEvenOdd 规则:
//    ![4.png](http://upload-images.jianshu.io/upload_images/833634-f522192d09f24ff0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
//
    UIView* aView = [[UIView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-100,10, 100, 100)];
    [self.view addSubview:aView];
    //用来标识layer的绘图是否正确
    aView.layer.borderWidth = 1.0;
    aView.layer.borderColor = [UIColor blackColor].CGColor;
    CAShapeLayer* cropLayer = [[CAShapeLayer alloc] init];
    [aView.layer addSublayer:cropLayer];
    // 创建一个绘制路径
    CGMutablePathRef path =CGPathCreateMutable();
    // 空心矩形的rect
    CGRect cropRect = CGRectMake(20, 30, 60, 40);
    // 绘制rect
    CGPathAddRect(path, nil, aView.bounds);
    CGPathAddRect(path, nil, cropRect);
    // 设置填充规则(重点)
    [cropLayer setFillRule:kCAFillRuleEvenOdd];
    // 关联绘制的path
    [cropLayer setPath:path];
    // 设置填充的颜色
    [cropLayer setFillColor:[[UIColor redColor] CGColor]];
    
    
    UIView* bView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 100, 100)];
    [self.view addSubview:bView];
    CAShapeLayer *pShapeLayer = [CAShapeLayer layer];
    pShapeLayer.fillColor = [UIColor blackColor].CGColor;[bView.layer addSublayer:pShapeLayer];
    UIBezierPath *pPath = [UIBezierPath bezierPathWithArcCenter:bView.center radius:100/2 startAngle:0.0 endAngle:M_PI*2 clockwise:YES];
    pShapeLayer.path = pPath.CGPath;

    UIBezierPath *pOtherPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, bView.centerX+50, bView.centerY+50)];
    pShapeLayer.path = pOtherPath.CGPath;

    [pOtherPath appendPath:pPath];
    pShapeLayer.path = pOtherPath.CGPath;
    //重点
    pShapeLayer.fillRule = kCAFillRuleEvenOdd;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //这里视图布局还没有完成，masonryView的frame还是（0，0，0，0），加了这句之后就看不到masonryView了
    //    [self.masonryView setCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //加在这里是OK的，而且这之后都是ok的
    [self.masonryView setCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //加在这里是OK的
    //    [self.masonryView setCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(20, 20)];
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
