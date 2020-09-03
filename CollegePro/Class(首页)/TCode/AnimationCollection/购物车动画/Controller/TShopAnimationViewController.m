//
//  TShopAnimationViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/7/16.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "TShopAnimationViewController.h"
#import "backgroundView.h"
#import "ShowAnimationView.h"

#import "MaskView.h"

#import "AppDelegate.h"

#import "JHDownButton.h"



#define UIColorRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface TShopAnimationViewController ()<CAAnimationDelegate,UIScrollViewDelegate>
{
	UIImageView *mainImageView;
	int angle;
    NSMutableArray *arrlist;
    UILabel *label;
    NSTimer *timer;
}
@property (nonatomic ,strong)MaskView *maskView;
@property(nonatomic,strong) JHDownButton *button;

@property (nonatomic ,strong) UIButton *_btn;

@property (nonatomic, strong) UIView *contentView;
//日常检查任务
@property (nonatomic, strong) UILabel *dailyInspectionTasks;
//2019年9月1日-2020年9
@property (nonatomic, strong) UILabel *timeCutoff;
//发布人：
@property (nonatomic, strong) UILabel *publisher;
//200家
@property (nonatomic, strong) UILabel *numberStoresCount;
//门店数量
@property (nonatomic, strong) UILabel *numberStores;
//365次/家
@property (nonatomic, strong) UILabel *frequencyCount;
//次数
@property (nonatomic, strong) UILabel *frequency;
//1次/天
@property (nonatomic, strong) UILabel *frequencypCount;
//频次
@property (nonatomic, strong) UILabel *frequencyp;

//分割线
@property (nonatomic, strong) UILabel *line;
//7.3W次
@property (nonatomic, strong) UILabel *totalNumberPlansCount;
//计划总数
@property (nonatomic, strong) UILabel *totalNumberPlans;
//100次
@property (nonatomic, strong) UILabel *planCompletionCount;
//计划完成
@property (nonatomic, strong) UILabel *planCompletion;
//50次
@property (nonatomic, strong) UILabel *actualCompletionCount;
//实际完成
@property (nonatomic, strong) UILabel *actualCompletion;
//50%
@property (nonatomic, strong) UILabel *completionRateCount;
//完成率
@property (nonatomic, strong) UILabel *completionRate;
@property (nonatomic, strong) UILabel *oneLabel;//上 -左
@property (nonatomic, strong) UILabel *twoLabel;//上 -右
@property (nonatomic, strong) UILabel *threeLabel;//下
@end

@implementation TShopAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"UI布局学习";
	
	self.view.backgroundColor = [UIColor whiteColor];

//    [self createAnimation];
    [self creatAutoLayout];
//遍历
//    [self getSub:self.view andLevel:1];
//    [self testDataP];
//    [self alert];
    //    [test exampleB];
//    [self controil];//定制按钮
//    [self cres];
}
static UILabel *labelLay;
- (void)creatAutoLayout{
    UIView *customerView = [[UIView alloc]init];
    customerView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:customerView];
    UILabel *labelLay = [[UILabel alloc]init];
    labelLay.textColor = [UIColor blackColor];
    [customerView addSubview:labelLay];
    labelLay.layer.borderColor = [UIColor redColor].CGColor;
    labelLay.layer.borderWidth = 1.0;
    [customerView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.mas_equalTo(100);
        //        make.height.mas_equalTo(20);
        //        make.size.mas_equalTo(CGSizeMake(50, 100));
        //        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 0, 10, 0));
        //        make.left.mas_equalTo(self.view).mas_offset(UIEdgeInsetsMake(10, 0, 10, 0));
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(1);;
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(30);;
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-30);;
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            
        } else {
            // Fallback on earlier versions
        }
        
    }];
    [labelLay mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            //            make.top.equalTo(customerView.mas_top).offset(30);// 和父视图顶部间距30
            //            make.left.equalTo(customerView.mas_left).offset(30);// 和父视图左边间距30
            //            make.bottom.equalTo(customerView.mas_bottom).offset(-30);// 和父视图底部间距30
            //            make.right.equalTo(customerView.mas_right).offset(-30);// 和父视图右边间距30
            
            
            //        make.edges.equalTo(customerView).with.insets(UIEdgeInsetsMake(0, 30, 30, 30));//edges边缘的意思
            //            make.size.mas_equalTo(CGSizeMake(300, 300));
            //            make.center.equalTo(customerView);
            //            make.size.mas_equalTo(customerView).offset(-20);
            //            make.left.top.mas_equalTo(customerView).offset(20);
            //            make.right.bottom.mas_equalTo(customerView).offset(-20);
            
            make.centerY.mas_equalTo(customerView.mas_centerY);
            //            make.top.equalTo(customerView.mas_top).offset(-15);
            make.left.equalTo(customerView.mas_left).offset(10);
            make.right.equalTo(customerView.mas_right).offset(-10);
//            make.height.mas_equalTo(150);
            //            make.width.equalTo(customerView);
            
            
            
            //            make.size.equalTo(customerView).offset(-20);
            //            make.left.bottom.and.right.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 30, 30, 30));
            //            make.size.mas_equalTo(CGSizeMake(300, 300));
            //            make.center.equalTo(self.view);
            //            make.size.mas_equalTo(self.view).offset(-20);
            //            make.size.equalTo(self.view).offset(-20);
            //            make.centerX.equalTo(self.view.mas_centerX);
            //            make.centerY.equalTo(self.view.mas_centerY);
        }
    }];
    [labelLay layoutIfNeeded];
    NSLog(@"labelLay <%.2f>-<%.2f>\n\t-<%.2f>-<%.2f>",labelLay.frame.origin.x,labelLay.frame.origin.y,labelLay.frame.size.width,labelLay.frame.size.height);
    
    NSString *detailText = @"审核时间创建一个可变属性字符串";
    // 创建一个可变属性字符串
    NSMutableAttributedString *finalStr = [[NSMutableAttributedString alloc] init];
    NSAttributedString *nameTitle = [[NSAttributedString alloc] initWithString:[detailText substringToIndex:4] attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName: UIColorRGB(47, 56, 86)}];
    NSAttributedString *nameDetail = [[NSAttributedString alloc] initWithString:[detailText substringFromIndex:4] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16], NSForegroundColorAttributeName: UIColorRGB(94, 99, 123)}];
    // 拼接上两个字符串
    [finalStr appendAttributedString:nameTitle];
    [finalStr appendAttributedString:nameDetail];
    
    NSAttributedString *space = [[NSAttributedString alloc] initWithString:@"  " attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName: UIColorRGB(47, 56, 86)}];
    
    [finalStr insertAttributedString:space atIndex:4];
    labelLay.attributedText = finalStr;
    
    [customerView addSubview:self.oneLabel];
    [customerView addSubview:self.twoLabel];
    [customerView addSubview:self.threeLabel];
    
    self.oneLabel.text = @"抗压缩和抗拉伸性";
    self.twoLabel.text = @"遇见你，我变得很低很低，一直低到尘埃里去，但我的心是欢喜的。并且在那里开出一朵花来。";
    self.threeLabel.text = @"我行过许多地方的桥，看过许多次数的云，123，abc，喝过许多类的酒，却只爱过一个正当最好年龄的人";
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSLog(@"%@",[[self.threeLabel.text componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""]);
    //抗拉伸性 越高越不容易被拉伸
//    [self.oneLabel setContentHuggingPriority:UILayoutPriorityRequired
//                                     forAxis:UILayoutConstraintAxisHorizontal];
    //抗压缩性 越高越不容易被压缩
    [self.oneLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    ///建议一般是以上两个都设置
    [self.oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(customerView.mas_leading).mas_offset(15);
        make.top.mas_equalTo(0);
    }];
    
    [self.twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_oneLabel.mas_trailing).mas_offset(10);
        make.trailing.equalTo(@-15);
        make.top.equalTo(_oneLabel);
    }];
    
    [self.threeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_oneLabel);
        make.top.equalTo(_twoLabel.mas_bottom).mas_offset(15);
        make.trailing.equalTo(_twoLabel);
    }];
    
    self.twoLabel.numberOfLines = 1;
//    self.twoLabel.lineBreakMode = NSLineBreakByCharWrapping; //以字符为显示单位显示，后面部分省略不显示。
//    self.twoLabel.lineBreakMode = NSLineBreakByClipping; //剪切与文本宽度相同的内容长度，后半部分被删除。
//    self.twoLabel.lineBreakMode = NSLineBreakByTruncatingHead; //前面部分文字以……方式省略，显示尾部文字内容。
//    self.twoLabel.lineBreakMode = NSLineBreakByTruncatingMiddle; //中间的内容以……方式省略，显示头尾的文字内容。
//    self.twoLabel.lineBreakMode = NSLineBreakByTruncatingTail; //结尾部分的内容以……方式省略，显示头的文字内容。
    self.twoLabel.lineBreakMode = NSLineBreakByWordWrapping; //以单词为显示单位显示，后面部分省略不显示。

    
    /*
     NSString *priceText = [NSString stringWithFormat:@"实付金额：¥%.2f",nearest];
     NSRange range2 = NSMakeRange(5, priceText.length - 3 - 5);
     NSRange range3 = NSMakeRange(priceText.length - 3, 3);
     NSMutableAttributedString *attPriceText = [[NSMutableAttributedString alloc] initWithString:priceText];
     [attPriceText addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBA(0xfb6c21, 1.0) range:range2];
     [attPriceText addAttribute:NSFontAttributeName value:kFont(18) range:range2];
     [attPriceText addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBA(0xfb6c21, 1.0) range:range3];
     */
    
    //    UIView *light = [UIView new];
    //    light.backgroundColor = [UIColor lightGrayColor];
    //    [customerView  addSubview:light];
    //    [light mas_makeConstraints:^(MASConstraintMaker *make) {
    //        // 顶部距离父视图centerY为10
    //        make.top.equalTo(labelLay.mas_centerY).mas_equalTo(-10);
    //        // 左右和高度与w相同
    //        make.right.and.height.equalTo(labelLay);
    //        make.left.equalTo(labelLay.mas_left).offset(10);
    //
    //    }];
    //    [light layoutIfNeeded];
    //    NSLog(@"light <%.2f>-<%.2f>\n\t-<%.2f>-<%.2f>",light.frame.origin.x,light.frame.origin.y,light.frame.size.width,light.frame.size.height);
    /*
     
     
     UIView *container = [UIView new];
     [customerView addSubview:container];
     [container mas_makeConstraints:^(MASConstraintMaker *make) {
     make.edges.equalTo(customerView);
     make.width.equalTo(customerView);
     }];
     
     int count = 20;
     UIView *lastView = nil;
     
     for (int i = 0; i <= count; i++) {
     UIView *subView = [UIView new];
     [container addSubview:subView];
     subView.backgroundColor = [UIColor colorWithHue:( arc4random() % 256 / 256.0 )saturation:( arc4random() % 128 / 256.0 ) + 0.5 brightness:( arc4random() % 128 / 256.0 ) + 0.5 alpha:1];
     [subView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.and.right.equalTo(container);
     make.height.mas_equalTo(@(20 * i));
     if (lastView) {
     // lastView存在时 以其底部为下一个view的顶部
     make.top.mas_equalTo(lastView.mas_bottom);
     } else {
     // lastView不存在时 以父视图的顶部为基准
     make.top.mas_equalTo(container.mas_top);
     }
     }];
     lastView = subView;
     }
     
     [container mas_makeConstraints:^(MASConstraintMaker *make) {
     make.bottom.equalTo(lastView.mas_bottom);
     }];
     
     
     
     UIButton *_stateButton;
     _stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
     //    _stateButton.frame = CGRectMake(30, 70, 100, 40);
     _stateButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
     _stateButton.backgroundColor = [UIColor yellowColor];
     
     //        _stateButton.titleLabel.adjustsFontSizeToFitWidth = YES;
     //    _stateButton.layer.cornerRadius = 12.0;
     _stateButton.layer.borderColor = [UIColor redColor].CGColor;
     _stateButton.layer.borderWidth = 1.0;
     [_stateButton setTitle:@"待复查" forState:UIControlStateNormal];
     [_stateButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
     [self.view addSubview:_stateButton];
     
     [_stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.mas_offset(15);
     make.top.mas_offset(100);
     make.height.mas_offset(20);
     
     }];
     //    [_stateButton layoutIfNeeded];ic_fast_order
     //切指定方向圆角(左上和左下)
     UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:_stateButton.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopLeft cornerRadii:CGSizeMake(10, 10)];
     CAShapeLayer * maskLayer = [[CAShapeLayer alloc]init];
     maskLayer.frame = _stateButton.bounds;
     maskLayer.path = maskPath.CGPath;
     _stateButton.layer.mask = maskLayer;
     _stateButton.clipsToBounds = YES;
     
     */
    //当底部为两个按钮时
    UIButton *buttonleft = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonleft setFrame:CGRectMake(0.0 ,0.0 ,DH_DeviceWidth ,44.0)];
    [buttonleft setTitle:@"重新整改" forState:(UIControlStateNormal)];
    buttonleft.backgroundColor = [UIColor blueColor];
    buttonleft.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size: 18];
    [self.view addSubview:buttonleft];
    
    UIButton *buttonright = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonright setFrame:CGRectMake(0.0 ,0.0 ,DH_DeviceWidth ,44.0)];
    [buttonright setTitle:@"通过" forState:(UIControlStateNormal)];
    buttonright.backgroundColor = [UIColor greenColor];
    buttonright.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Bold" size: 18];
    [self.view addSubview:buttonright];
    [buttonleft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(buttonright.mas_left);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            // Fallback on earlier versions
            make.bottom.equalTo(self.view.mas_bottom);
        }
        /**
         *  长宽相等 注意，这里不能用 make.height.equalTo(make.width);
         */
        //        make.height.equalTo(buttonleft.mas_width); /// 约束长度等于宽度
        make.width.equalTo(buttonright.mas_width);
        make.height.offset(44);
    }];
    [buttonright mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.height.equalTo(buttonleft.mas_height);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
            // Fallback on earlier versions
        }
    }];
    //增加闪动动画
    CAMediaTimingFunction *anticipateTiming = [CAMediaTimingFunction functionWithControlPoints:0.42 :-0.30 :1.00 :1.00];
    CAKeyframeAnimation *kfAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    kfAnimation.duration = 2.000;
    kfAnimation.values = @[@(1.000), @(0.400), @(1.000)];
    kfAnimation.keyTimes = @[@(0.000), @(0.500), @(1.000)];
    kfAnimation.timingFunctions = @[anticipateTiming, anticipateTiming];
    kfAnimation.repeatCount = HUGE_VALF;
    kfAnimation.beginTime = 0.23;
    kfAnimation.fillMode = kCAFillModeBoth;
    kfAnimation.removedOnCompletion = YES;
    [buttonleft.layer addAnimation:kfAnimation forKey:@"Untitled Animation_Opacity"];

    
    //    [self cres];
    /*
     //前面三个
     [string substringToIndex:3]
     //从第三个之后的四个
     [string substringWithRange:NSMakeRange(3,4)]
     //第七个之后的所有
     [string substringFromIndex:7]
     */
    
    //    [self clickBtn];
    //    [self setupUI2];
    //    [self initTopView];
    //横排的时候要相应设置控件数组的垂直约束，竖排的时候要相应设置控件数字的水平约束。
    //    [self test_masonry_vertical_fixItemWidth];
    //    [self test_masonry_vertical_fixSpace];
    //    [self test_masonry_horizontal_fixItemWidth];
    //    [self test_masonry_horizontal_fixSpace];
    //    宽度不够时
    //    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    //    宽度足够时
    //    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    //    backgroundView *vire = [backgroundView sureGuideView];
    //
    //    [self.view addSubview:vire];
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor redColor];
    UILabel *bottomAdView = [[UILabel alloc]init];
    bottomAdView.textColor = [UIColor blackColor];
    bottomAdView.text = @"大海专属";
    bottomAdView.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:bottomAdView];
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.view);
        make.top.equalTo(customerView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}
static BOOL btnSelected;
- (void)controil{
    //全局变量
    btnSelected = YES;
    self.button = [[JHDownButton alloc]initWithFrame:CGRectMake(0, 100, DH_DeviceWidth, 30) image:[UIImage imageNamed:@"ic_fast_order"] title:@"全部任务"];
    [self.button addTarget:self action:@selector(click) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.button];
    self.button.layer.borderColor = [UIColor redColor].CGColor;
    self.button.layer.borderWidth = 1.0;
}
- (void)click{
    if (btnSelected == YES) {
        btnSelected = NO;
        [self.button.imageView setImage:[UIImage imageNamed:@"tabbar1_selected"]];
    }else{
        btnSelected = YES;
        [self.button.imageView setImage:[UIImage imageNamed:@"ic_fast_order"]];

    }
}
- (void)createAnimation{
	//http://blog.csdn.net/iosevanhuang/article/details/14488239
	mainImageView = [[UIImageView alloc]init];
//	mainImageView.animationImages =[NSArray arrayWithObjects:[UIImage imageNamed:@"超级球"],[UIImage imageNamed:@"大师球"],[UIImage imageNamed:@"高级球"],nil];
	
	[mainImageView setImage:[UIImage imageNamed:@"超级球"]];
//	[mainImageView setAnimationDuration:1.5];
//	[mainImageView setAnimationRepeatCount:5];
	mainImageView.frame = CGRectMake(50, 100, 40, 40);
	[self.view addSubview: mainImageView];
	//
	CABasicAnimation* rotationAnimation;
	rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
	rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
	rotationAnimation.duration = 3;
	rotationAnimation.cumulative = YES;
	rotationAnimation.repeatCount = MAXFLOAT;
	
	[mainImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
	[self startAnimation];
//	CALayer *layer = [mainImageView layer];
//	layer.anchorPoint = CGPointMake(0.5, 0.0);
//	layer.position = CGPointMake(layer.position.x + layer.bounds.size.width * (layer.anchorPoint.x - 0.5), layer.position.y + layer.bounds.size.height * (layer.anchorPoint.y - 0.5));
//
//
//	CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
//	keyAnimaion.keyPath = @"transform.rotation";
//	keyAnimaion.values = @[@(-30 / 180.0 * M_PI),@(10 / 180.0 * M_PI),@(-30/ 180.0 * M_PI),@(0 / 180.0 * M_PI)];//度数转弧度
//	keyAnimaion.removedOnCompletion = NO;
//	keyAnimaion.fillMode = kCAFillModeForwards;
//	keyAnimaion.duration = 0.5;
//	keyAnimaion.repeatCount = 3;
//	[mainImageView.layer addAnimation:keyAnimaion forKey:nil];
	
	
	
//	//创建CAKeyframeAnimation
//		CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
//		animation.duration = 0.5;
//		animation.repeatCount = MAXFLOAT;
//		animation.removedOnCompletion = NO;
//		animation.fillMode = kCAFillModeForwards;
//		animation.delegate = self;
//	
////	存放图片的数组
//		NSMutableArray *array = [NSMutableArray array];
//		for(NSUInteger i = 1;i < 3 ;i++) {
//			if (i % 3 == 0){
//				UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"0%lu",(unsigned long)i]];
//				CGImageRef cgimg = img.CGImage;
//				[array addObject:(__bridge UIImage *)cgimg];
//			}
//		}
//		animation.values = array;
//		[mainImageView.layer addAnimation:animation forKey:nil];
//	CALayer *layer = [mainImageView layer];
//	layer.position = CGPointMake(100,100); //a 点
//	mainImageView.layer.position = CGPointMake(100,100);
//	// 路径
//	UIBezierPath *path = [UIBezierPath bezierPath];
//	[path moveToPoint:CGPointMake(100,100)];
//	[path addQuadCurveToPoint:CGPointMake(250,self.view.frame.size.height-80) controlPoint:CGPointMake(300, 200)];
	
//	// 指定position属性（移动）
//	CABasicAnimation *animation =
//	[CABasicAnimation animationWithKeyPath:@"position"];
//	animation.duration = 2.5; // 动画持续时间
//	animation.repeatCount = 1; // 不重复
//	animation.beginTime = CACurrentMediaTime() + 2; // 2秒后执行
//	animation.autoreverses = YES; // 结束后执行逆动画
//	// 动画先加速后减速
//	animation.timingFunction =
//	[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
//	// 设定动画起始帧和结束帧
//	animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(50, 100)]; // 起始点
//	animation.toValue = [NSValue valueWithCGPoint:CGPointMake(320, 480)]; // 终了点
//	[mainImageView.layer addAnimation:animation forKey:@"group"];

//
//
//	//关键帧动画
//	CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//	pathAnimation.path = path.CGPath;
//
//
//	CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//	rotateAnimation.removedOnCompletion = YES;
//	rotateAnimation.fromValue = [NSNumber numberWithFloat:0];
//	rotateAnimation.toValue = [NSNumber numberWithFloat:12];
//	rotateAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//	CAAnimationGroup *groups = [CAAnimationGroup animation];
//	groups.animations = @[pathAnimation,rotateAnimation];
//	groups.duration = 4;
//	groups.removedOnCompletion=NO;
//	groups.fillMode=kCAFillModeForwards;
//	[mainImageView.layer addAnimation:groups forKey:@"group"];
	
	/*
	// 关键帧
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//	CGMutablePathRef path = CGPathCreateMutable();
//	CGPathAddArcToPoint(path, nil, 60, 60, 100, 100, 50);
//	CGPathAddArcToPoint(path, nil, 100, 160, 200, 200, 50);
//
// animation.path = path;
	//动画时间
	//动画均匀进行kCAAnimationPaced
	animation.calculationMode = kCAAnimationCubicPaced;
	//设置value
	
	NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2-100, self.view.frame.size.height/2+5)];
	
	NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2-80, self.view.frame.size.height/2+10)];
	
	NSValue *value3=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2-60, self.view.frame.size.height/2+20)];
	
	NSValue *value4=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2-40, self.view.frame.size.height/2+40)];
	
	NSValue *value5=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2-20, self.view.frame.size.height/2+60)];
	
	NSValue *value6=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2-10, self.view.frame.size.height/2+80)];
	
	NSValue *value7=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2+100)];
	
	NSValue *value8=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2+10, self.view.frame.size.height/2+110)];
	
	NSValue *value9=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2+20, self.view.frame.size.height/2+120)];

	NSValue *value10=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2+30, self.view.frame.size.height/2+130)];

	NSValue *value11=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2+40, self.view.frame.size.height/2+140)];

	NSValue *value12=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2+50, self.view.frame.size.height/2+150)];

	NSValue *value13=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2+60, self.view.frame.size.height/2+80)];

	animation.values=@[value1,value2,value3,value4,value5,value6,value7,value8,value9,value10,value11,value12,value13];
	
	//重复次数 默认为1
	
	animation.repeatCount=MAXFLOAT;
	
	//设置是否原路返回默认为不
	
	animation.autoreverses = YES;
	
	//设置移动速度，越小越快
	
	animation.duration = 4.0f;
	
	animation.removedOnCompletion = YES;
	
	animation.fillMode = kCAFillModeForwards;
	
	animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	animation.delegate=self;
	
	//给这个view加上动画效果
	
	[mainImageView.layer addAnimation:animation forKey:nil];
	
	*/
	
//	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//	
//	//创建一个CGPathRef对象，就是动画的路线
//	
//	CGMutablePathRef path = CGPathCreateMutable();
//	
//	//自动沿着弧度移动
//	
//	CGPathAddEllipseInRect(path, NULL, CGRectMake(150, 200, 200, 100));
//	
//	//设置开始位置
//	
//	CGPathMoveToPoint(path,NULL,100,100);
//	
//	//沿着直线移动
//	
//	CGPathAddLineToPoint(path,NULL, 200, 100);
//	
//	CGPathAddLineToPoint(path,NULL, 200, 200);
//	
//	CGPathAddLineToPoint(path,NULL, 100, 200);
//	
//	CGPathAddLineToPoint(path,NULL, 100, 300);
//	
//	CGPathAddLineToPoint(path,NULL, 200, 400);
//	
//	//沿着曲线移动
//	
//	CGPathAddCurveToPoint(path,NULL,50.0,275.0,150.0,275.0,70.0,120.0);
//	
//	CGPathAddCurveToPoint(path,NULL,150.0,275.0,250.0,275.0,90.0,120.0);
//	
//	CGPathAddCurveToPoint(path,NULL,250.0,275.0,350.0,275.0,110.0,120.0);
//	
//	CGPathAddCurveToPoint(path,NULL,350.0,275.0,450.0,275.0,130.0,120.0);
//	
//	animation.path=path;
//	
//	CGPathRelease(path);
//	
//	animation.autoreverses = YES;
//	
//	animation.repeatCount=MAXFLOAT;
//	
//	animation.removedOnCompletion = NO;
//	
//	animation.fillMode = kCAFillModeForwards;
//	
//	animation.duration = 4.0f;
//	
//	animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//	
//	animation.delegate=self;
//	
//	[mainImageView.layer addAnimation:animation forKey:nil];
	
	
}
-(void)startAnimation

{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.01];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(endAnimation)];
    mainImageView.transform = CGAffineTransformMakeRotation(angle*(M_PI/180.0f));
	[UIView commitAnimations];
}

-(void)endAnimation{
	angle +=10;
    [self startAnimation];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    int contentOffsety = scrollView.contentOffset.y;
    NSLog(@"-移动数据-%d",contentOffsety);

//    CGFloat offsetY = scrollView.contentOffset.y;

}
// 递归获取子视图
- (void)getSub:(UIView *)view andLevel:(int)level {
    NSArray *subviews = [view subviews];
    
    // 如果没有子视图就直接返回
    if ([subviews count] == 0) return;
    
    for (UIView *subview in subviews) {
        
        // 根据层级决定前面空格个数，来缩进显示
        NSString *blank = @"";
        for (int i = 1; i < level; i++) {
            blank = [NSString stringWithFormat:@"  %@", blank];
        }
        
        // 打印子视图类名
        NSLog(@"打印子视图类名-%@%d: %@", blank, level, subview.class);
        
        // 递归获取此视图的子视图
        [self getSub:subview andLevel:(level+1)];
        
    }
}
static UIView *maskView;
- (void)alert{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setFrame:CGRectMake(0.0 ,64 ,DH_DeviceWidth ,50.0)];
//    [button setTitle:@"全部" forState:(UIControlStateNormal)];
//    [button setTitle:@"全部" forState:(UIControlStateSelected)];
//    [button setTitleColor:UIColorRGB(47, 56, 86) forState:(UIControlStateNormal)];
//    [button addTarget:self action:@selector(submit:) forControlEvents:(UIControlEventTouchUpInside)];
//    button.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:button];
//    ShowAnimationView *vire = [[ShowAnimationView alloc]init];
//    vire.backgroundColor = [UIColor blackColor];
//    vire.frame = CGRectMake(0, 100, DH_DeviceWidth, DH_DeviceHeight);
//    [vire showView];
//    [self.view addSubview:vire];
//    maskView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, DH_DeviceHeight)];
//    maskView.hidden = YES;
//    maskView.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
//    [[UIApplication sharedApplication].keyWindow addSubview:maskView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap:)];
//    maskView.userInteractionEnabled = YES;
//    [maskView addGestureRecognizer:tap];
//
//
//    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button1 setFrame:CGRectMake(0.0 ,button.y+button.height ,DH_DeviceWidth ,50.0)];
//    [button1 setTitle:@"进行" forState:(UIControlStateNormal)];
//    [button1 setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    //        [button addTarget:self action:@selector(submit) forControlEvents:(UIControlEventTouchUpInside)];
//    button1.tag = 123;
//    button1.backgroundColor = [UIColor colorWithRed:0.043 green:0.722 blue:0.729 alpha:1.000];
//    button1.hidden = YES;
//    [maskView addSubview:button1];
   
}
- (void)submit:(UIButton *)tap{
//    UIButton *btn = (UIButton *)[self.view viewWithTag:123];
//    if (tap.selected == YES) {
////        btn.hidden = YES;
//        maskView.hidden = YES;
//    }else{
////        btn.hidden = NO;
//        maskView.hidden = NO;
//    }
//    tap.selected =!tap.selected;
//
//    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-75, 100, 150, 150)];
//
//    btn1.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.5];
//
//    [btn1 setTitle:@"取消蒙层" forState:UIControlStateNormal];
//
//    //在蒙层上放的控件调用取消蒙层逻辑
//
//    [btn1 addTarget:self action:@selector(btn1:) forControlEvents: UIControlEventTouchUpInside];
//
//    [self.view addSubview:btn1];
//
//     //添加蒙层,以及蒙层上放的控件
//
//    _maskView = [MaskView makeViewWithMask:CGRectMake(0, 64+50, self.view.frame.size.width, self.view.frame.size.height) andView:btn1];
   
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

//-(void)doTap:(NSString *)str{
//
//     [maskView removeFromSuperview];
//}
-(void)btn1:(UIButton *)sender{

    //取消蒙层
    
    [_maskView block:^{
        
        NSLog(@"取消之后");
        
    }];
    
}
-(void)customUI{
    //定义显示图片的
    NSArray *imageNameList = @[@"scanscanBg.png",@"scanscanBg.png",@"scanscanBg.png",@"scanscanBg.png"];
    UIScrollView *scrollViewRoot = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 300, DH_DeviceWidth, self.view.frame.size.height-350)];
    scrollViewRoot.delegate = self;
    scrollViewRoot.backgroundColor = [UIColor redColor];
    [self.view addSubview:scrollViewRoot];
    
    // 添加图片
    for (NSInteger index = 0; index < imageNameList.count; index ++) {
        // UIScrollView上的每一张图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index * DH_DeviceWidth, 0, scrollViewRoot.frame.size.width, scrollViewRoot.frame.size.height)];
        //加载图片方式一:一直在占用内存，并未释放，且自动识别@2x，@3x等不同分辨率的图片，会提供一个缓存，具体是在加载的时候缓存到系统内存，使用的时候从缓存中进行加载，但是过多的话会导致内存泄露等内存警告问题，imageNamed后面跟的不是图片名称，是图片集合的名称，所以关于image@2x，image@3x等，只需要写上前面的image，他们属于一个image下的图片集合，内部会根据屏幕分辨率自动识别，并进行展示
        imageView.image = [UIImage imageNamed:imageNameList[index]];
        //加载图片方式二:数据形式加载，不会一直加载在内存里，也就是说没有做图片缓存处理，且自动识别@2x，@3x等不同分辨率的图片
        imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNameList[index] ofType:nil]];
        //NSString *filePaht1 = [[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:@"test.bundle/hotBagImage.png"];
        
        //加载图片方式三:数据形式加载，不会一直加载在内存里
        NSData *imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNameList[index] ofType:nil]];
        imageView.image = [UIImage imageWithData:imageData];
        /*
         Assets.xcassets 在使用大量图片时，不推荐这种方式，我们的一些小的icon或者图片可以放置进来，我们的启动图等在这里面管理还是比较方便；
         NSBundle或者ContentsOfFile方式虽然加载图片不占用内存资源，起到了性能优化，但是占的APP储存空间相对比较大，会增加包的体积。其中ContentsOfFile不同于NSBundle的是可以创建文件夹来管理图片，但是这样在多人开发中容易丢失图片文件。
         */
        [scrollViewRoot addSubview:imageView];
        //contentSize 为什么不从0开始，因为0*kScreenWidth等于0，就相当于没有大小，挤掉了第一张(备注：因为图片资源是从0开始的，在这里乘以0就相当于把第一张的大小变为0)
        scrollViewRoot.contentSize = CGSizeMake((index+1) * DH_DeviceWidth, 0);
        
        
    }
    //    void (^num)(int)=^(int x){
    //        NSLog(@"1、执行");
    //        dispatch_sync(dispatch_get_main_queue(), ^{//有可能引入死锁的问题
    //            NSLog(@"2、执行");
    //        });
    //        NSLog(@"3、执行");
    //    };
    //    num(1);
    
    UIView *orangeView = [[UIView alloc] init];
    
    orangeView.frame = CGRectMake(0, 0, 200,200);
    
    orangeView.backgroundColor = [UIColor orangeColor];
    
    orangeView.center = self.view.center;
    
    [self.view addSubview:orangeView];
    
    
    UIView *blueView = [[UIView alloc] init];
    
    blueView.frame = CGRectMake(0, 0, 150,150);
    
    blueView.backgroundColor = [UIColor blueColor];
    
    //    blueView.layer.anchorPoint = CGPointMake(0.0, 1.0);
    //
    //    blueView.center = self.view.center;
    
    [self.view addSubview:blueView];
    /**
     - (void)updateConstraintsIfNeeded  调用此方法，如果有标记为需要重新布局的约束，则立即进行重新布局，内部会调用updateConstraints方法
     - (void)updateConstraints          重写此方法，内部实现自定义布局过程
     - (BOOL)needsUpdateConstraints     当前是否需要重新布局，内部会判断当前有没有被标记的约束
     - (void)setNeedsUpdateConstraints  标记需要进行重新布局
     */
    //and,with,这两个方法内部实际上什么都没干，只是在内部将self直接返回，功能就是为了更加方便阅读，对代码执行没有实际作用
    
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self.view).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(300, 300));
        
    }];
    // 下面的方法和上面例子等价，区别在于使用insets()方法。
    [orangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(blueView.bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(300, 300));
        // 下、右不需要写负号，insets方法中已经为我们做了取反的操作了
        make.edges.equalTo(blueView).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    NSLog(@"orangeView center = %@",NSStringFromCGPoint(orangeView.center));
    
    NSLog(@"blueView center = %@",NSStringFromCGPoint(blueView.center));
    
    NSLog(@"orangeView bounds = %@",NSStringFromCGRect(orangeView.bounds));
    
    NSLog(@"blueView bounds = %@",NSStringFromCGRect(blueView.bounds));
}
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

// 搭建UI demo 长宽等比例
- (void) setupUI2
{
    WS(weakSelf);
    UIView * bgView = UIView.new;
    bgView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:bgView];
    CGFloat padding = 10.0f;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(padding, padding, padding, padding));
    }];
    
    UIView * redView = UIView.new;
    redView.backgroundColor = [UIColor redColor];
    [bgView addSubview:redView];
    
    UIView * yellowView = UIView.new;
    [bgView addSubview:yellowView];
    yellowView.backgroundColor = [UIColor yellowColor];
    
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(padding);
        make.right.equalTo(yellowView.mas_left).offset(-padding);
        make.centerY.equalTo(bgView);
        
        /**
         *  长宽相等 注意，这里不能用 make.height.equalTo(make.width);
         */
        make.height.equalTo(redView.mas_width); /// 约束长度等于宽度
        make.width.equalTo(yellowView.mas_width);
    }];
    
    [yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.right.equalTo(bgView).offset(-padding);
        make.height.equalTo(yellowView.mas_width);
    }];
    
}


-(NSString *)inputValue:(NSString *)str{
    
    NSMutableString *string=[[NSMutableString alloc] init];
    
    for(int i=0;i<str.length;i++){
        
        [string appendString:[str substringWithRange:NSMakeRange(str.length-i-1, 1)]];
        
    }
    
    return string;
    
}
- (void)testDataO{
    UIImage *image = [UIImage imageNamed:@"_MG_5586.JPG"];//8M
    
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName]];
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(93,93)];// 图片进行尺寸压缩
    
    [UIImageJPEGRepresentation(smallImage,0.3) writeToFile:imageFilePath atomically:YES];// 图片进行质量压缩
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    NSData *ImageData =UIImagePNGRepresentation(selfPhoto);
    NSLog(@"ImageData %lu",(unsigned long)ImageData.length);
}
static  UILabel *label;
- (void)testDataP
{
    NSInteger num = 3;
    label = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 200.0, self.view.frame.size.width-60.0, 16*3+8*2)];
    label.font = [UIFont systemFontOfSize:16.0];
    label.layer.borderColor = [UIColor redColor].CGColor;
    label.layer.borderWidth = 1.0;
    label.numberOfLines = num;
    [label setTag:189];
    [self.view addSubview:label];
    
    NSString *text = @"明月几时有？把酒问青天。不知天上宫阙，今夕是何年。我欲乘风归去，又恐琼楼玉宇，高处不胜寒。起舞弄清影，何似在人间？转朱阁，低绮户，照无眠。不应有恨，何事长向别时圆？人有悲欢离合，月有阴晴圆缺，此事古难全。但愿人长久，千里共婵娟。";
    //    NSString *text = @"明月几时有";
    label.text = text;
    NSDictionary *dictName = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName:[UIColor blackColor]};
    NSDictionary *dictMore = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName:[UIColor blueColor]};
    NSMutableAttributedString *attStr = [DHTool addWithName:label more:@"全文" nameDict:dictName moreDict:dictMore numberOfLines:num];
    label.attributedText = attStr;
    NSLog(@"%f--%@",[DHTool autoSizeOfHeghtWithText:label.text font:[UIFont systemFontOfSize:16.0] width:self.view.frame.size.width-60.0].height,label.text);
    
    label.frame = CGRectMake(30.0, 200.0, self.view.frame.size.width-60.0, 20*num);
    
    //    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    btn.frame = label.frame;
    //    [btn setTitle:@"test" forState:UIControlStateNormal];
    //    [btn addTarget:self action:@selector(showAll:) forControlEvents:UIControlEventTouchUpInside];
    //    [label addSubview:btn];
    
    //富文本
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 300.0, self.view.frame.size.width-60.0, 16*3+8*2)];
    label1.font = [UIFont systemFontOfSize:16.0];
    label1.layer.borderColor = [UIColor redColor].CGColor;
    label1.layer.borderWidth = 1.0;
    label1.numberOfLines = 1;
    label1.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:label1];
    
    NSString * string = [NSString stringWithFormat:@"您的号码是%@号",@"43"];
//    label1.attributedText = [self paramWithStr:string Range:NSMakeRange(5, 1)];
    //整改项数量 显示配置

    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    label1.attributedText = [self paramWithStr:string Range:NSMakeRange(5, [[string componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""].length)];
    
}
/*
 //发布信息textflied
 -(SFTextView *)textF
 {
 if (!_textF) {
 _textF = [[SFTextView alloc] init];
 _textF.font = FONT_SIZE(13);
 _textF.textColor = KColorC;
 _textF.backgroundColor = [UIColor whiteColor];
 //        _textF.backgroundColor = [UIColor clearColor];
 //        _textF.delegate = self;
 //设置placeholder属性
 [_textF setPlaceHolderAttr:@"  写下你的观点/见解" textColor:KColorD font:FONT_SIZE(13)];
 //设置字数限制属性
 [_textF setCharCountAttr:150 right:SNRealValue(11) bottom:SNRealValue(9) textColor:KColorC font:KFontSizeG];
 _textF.layer.cornerRadius = SNRealValue(5);
 }
 return _textF;
 }
 */
- (NSMutableAttributedString *)paramWithStr:(NSString *)name Range:(NSRange)ran{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:name];
    
    /*
     常见的属性及说明
     NSFontAttributeName  字体
     NSParagraphStyleAttributeName  段落格式
     NSForegroundColorAttributeName  字体颜色
     NSBackgroundColorAttributeName   背景颜色
     NSStrikethroughStyleAttributeName 删除线格式
     NSUnderlineStyleAttributeName      下划线格式
     NSStrokeColorAttributeName        删除线颜色
     NSStrokeWidthAttributeName 删除线宽度
     NSShadowAttributeName  阴影
     
     属性及说明
     
     
     
     key
     说明
     
     
     NSFontAttributeName
     字体，value是UIFont对象
     
     
     NSParagraphStyleAttributeName
     绘图的风格（居中，换行模式，间距等诸多风格），value是NSParagraphStyle对象
     
     
     NSForegroundColorAttributeName
     文字颜色，value是UIFont对象
     
     
     NSLigatureAttributeName
     字符连体，value是NSNumber
     
     
     NSKernAttributeName
     字符间隔
     
     
     NSStrikethroughStyleAttributeName
     删除线，value是NSNumber
     
     
     NSUnderlineStyleAttributeName
     下划线，value是NSNumber
     
     
     NSStrokeColorAttributeName
     描绘边颜色，value是UIColor
     
     
     NSStrokeWidthAttributeName
     描边宽度，value是NSNumber
     
     
     NSShadowAttributeName
     阴影，value是NSShadow对象
     
     
     NSTextEffectAttributeName
     文字效果，value是NSString
     
     
     NSAttachmentAttributeName
     附属，value是NSTextAttachment 对象
     
     
     NSLinkAttributeName
     链接，value是NSURL or NSString
     
     
     NSBaselineOffsetAttributeName
     基础偏移量，value是NSNumber对象
     
     
     NSStrikethroughColorAttributeName
     删除线颜色，value是UIColor
     
     
     NSObliquenessAttributeName
     字体倾斜
     
     
     NSExpansionAttributeName
     字体扁平化
     
     
     NSVerticalGlyphFormAttributeName
     垂直或者水平，value是 NSNumber，0表示水平，1垂直
     
     富文本段落排版格式属性说明
     
     属性说明
     
     lineSpacing
     字体的行间距
     
     firstLineHeadIndent
     首行缩进
     
     alignment
     （两端对齐的）文本对齐方式：（左，中，右，两端对齐，自然）
     
     lineBreakMode
     结尾部分的内容以……方式省略 ( "...wxyz" ,"abcd..." ,"ab...yz")
     
     headIndent
     整体缩进(首行除外)
     
     minimumLineHeight
     最低行高
     
     maximumLineHeight
     最大行高
     
     paragraphSpacing
     段与段之间的间距
     
     paragraphSpacingBefore
     段首行空白空间
     
     baseWritingDirection
     书写方向（一共三种）
     
     hyphenationFactor
     连字属性 在iOS，唯一支持的值分别为0和1
     */
    
    //方法一：set方法单向设置和集合设置
    //方法1、
    //    [attributeString setAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName, nil] range:ran];
    //方法2、
    //    [attributeString setAttributes:[NSMutableDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:22], NSFontAttributeName,[UIColor redColor],NSForegroundColorAttributeName, nil] range:ran];
    //方法3、
    //    NSDictionary *attributedDict = @{
    //                                     NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:22],
    //                                     NSForegroundColorAttributeName:[UIColor redColor]
    //                                     };
    //,NSUnderlineStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleDouble | NSUnderlineStyleThick)
    //    [attributeString setAttributes:attributedDict];
    //方法二：add方法设置key-value
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:ran];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:22] range:ran];
    return  attributeString;
}
- (void)showAll:(UIButton *)btn{
    
}
- (CGFloat)heightTextWithText:(UILabel *)text
{
    //    //1.1最大允许绘制的文本范围
    CGSize size = CGSizeMake((text.frame.size.width), MAXFLOAT);
    //    //1.2配置计算时的行截取方法,和contentLabel对应
    //    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    //    [style setLineSpacing:0];
    //    //    //1.3配置计算时的字体的大小
    //    //    //1.4配置属性字典
    //    NSDictionary *dic = @{NSFontAttributeName:text.font, NSParagraphStyleAttributeName:style};
    //    //    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:string attributes:dic];
    //    //    lb.attributedText = attributeStr;
    //    //2.计算
    //    //如果想保留多个枚举值,则枚举值中间加按位或|即可,并不是所有的枚举类型都可以按位或,只有枚举值的赋值中有左移运算符时才可以
    //    CGFloat heightText = [text.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    //
    // 计算高度
    //    CGSize size = [text boundingRectWithSize:CGSizeMake(SNRealValue(ScreenWidth - 38 - 26), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFont_Regular(15)} context:nil].size;
    //    CGFloat heightText = size.height;
    size = [text.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:text.font,NSFontAttributeName, nil]];
    
    return size.height;
}


// 改变图片尺寸
-(UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y =0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x =0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context =UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0,0, asize.width, asize.height));//clear background
        [image drawInRect:rect];//压缩图片h指定尺寸
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }
    return newimage;
}
////这样循环次数多，效率低，耗时长。
//- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength WithoutImage:(UIImage *)image{
//    CGFloat compression = 1;
//    NSData *data = UIImageJPEGRepresentation(image, compression);
//    while (data.length > maxLength && compression > 0) {
//        compression -= 0.02;
//        data = UIImageJPEGRepresentation(image, compression); // When compression less than a value, this code dose not work
//    }
//    return data;
//}
////二分法来优化
/*
 当图片大小小于 maxLength，大于 maxLength * 0.9 时，不再继续压缩。最多压缩 6 次，1/(2^6) = 0.015625 < 0.02，也能达到每次循环 compression减小 0.02 的效果。这样的压缩次数比循环减小 compression少，耗时短。需要注意的是，当图片质量低于一定程度时，继续压缩没有效果。也就是说，compression继续减小，data 也不再继续减小。
 */
- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength WithoutImage:(UIImage *)image{
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
    /*
     //方法结合计算
     // Compress by quality
     CGFloat compression = 1;
     NSData *data = UIImageJPEGRepresentation(self, compression);
     //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
     if (data.length < maxLength) return data;
     
     CGFloat max = 1;
     CGFloat min = 0;
     for (int i = 0; i < 6; ++i) {
     compression = (max + min) / 2;
     data = UIImageJPEGRepresentation(self, compression);
     //NSLog(@"Compression = %.1f", compression);
     //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
     if (data.length < maxLength * 0.9) {
     min = compression;
     } else if (data.length > maxLength) {
     max = compression;
     } else {
     break;
     }
     }
     //NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
     if (data.length < maxLength) return data;
     UIImage *resultImage = [UIImage imageWithData:data];
     // Compress by size
     NSUInteger lastDataLength = 0;
     while (data.length > maxLength && data.length != lastDataLength) {
     lastDataLength = data.length;
     CGFloat ratio = (CGFloat)maxLength / data.length;
     //NSLog(@"Ratio = %.1f", ratio);
     CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
     (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
     UIGraphicsBeginImageContext(size);
     [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
     resultImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     data = UIImageJPEGRepresentation(resultImage, compression);
     //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
     }
     //NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
     return data;
     */
}

// 搭建UI 多个视图的布局
- (void) setupUI3
{
    WS(weakSelf);
    CGFloat padding = 10.0f;
    UIView * superView = UIView.new;
    [self.view addSubview:superView];
    superView.backgroundColor = [UIColor redColor];
    [superView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(padding+64.0f, padding, padding, padding));
    }];
    
    
    NSInteger count = 3;
    UIView * tempView = nil;
    CGFloat height = 50.0f; // 高度固定等于50
    for (NSInteger i = 0; i<count; i++) {
        
        UIView * subView = UIView.new;
        [superView addSubview:subView];
        subView.backgroundColor = [UIColor brownColor];
        if (i == 0) {
            [subView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(superView).offset(padding);
                make.height.equalTo(@(height));
                make.centerY.equalTo(superView);
            }];
            
        } else if (i == count -1) {
            [subView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempView.mas_right).offset(padding);
                make.right.equalTo(superView.mas_right).offset(-padding);
                make.height.equalTo(tempView);
                make.width.equalTo(tempView);
                make.centerY.equalTo(tempView);
            }];
            
        } else {
            [subView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempView.mas_right).offset(padding);
                make.centerY.equalTo(tempView);
                make.height.equalTo(tempView);
                make.width.equalTo(tempView);
                
            }];
            
        }
        
        tempView = subView;
        //[subView layoutIfNeeded];
    }
    
}
// 搭建UI 高度和宽度相等
- (void) setupUI4
{
    WS(weakSelf);
    CGFloat padding = 10.0f;
    UIView * superView = UIView.new;
    [self.view addSubview:superView];
    superView.backgroundColor = [UIColor redColor];
    [superView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).with.insets(UIEdgeInsetsMake(padding+64.0f, padding, padding, padding));
    }];
    
    
    NSInteger count = 3;
    UIView * tempView = nil;
    // CGFloat height = 50.0f;
    for (NSInteger i = 0; i<count; i++) {
        
        UIView * subView = UIView.new;
        [superView addSubview:subView];
        subView.backgroundColor = [UIColor brownColor];
        if (i == 0) {
            [subView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(superView).offset(padding);
                //make.height.equalTo(@(height));
                make.centerY.equalTo(superView);
                make.height.equalTo(subView.mas_width);
            }];
            
        } else if (i == count -1) {
            [subView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempView.mas_right).offset(padding);
                make.right.equalTo(superView.mas_right).offset(-padding);
                make.height.equalTo(tempView);
                make.width.equalTo(tempView);
                make.centerY.equalTo(tempView);
            }];
            
        } else {
            [subView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempView.mas_right).offset(padding);
                make.centerY.equalTo(tempView);
                //make.height.equalTo(tempView);
                make.width.equalTo(tempView);
                make.height.equalTo(subView.mas_width);
                
            }];
            
        }
        tempView = subView;
    }
}
//顶部view的初始化
- (void)initTopView{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, DH_DeviceWidth, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.alpha = .8;
    
    NSArray *titleArr = @[@"人气",@"价格",@"桌数",@"优惠"];
    for (int i = 0; i < titleArr.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"ic_fast_order"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"tabbar01_selected"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.showsTouchWhenHighlighted = YES;
        btn.frame = CGRectMake(10 + i * ((DH_DeviceWidth - 50)/4 + 10) , 10, (DH_DeviceWidth - 50)/4, 25);
        //设置tag值
        btn.tag = i + 100;
        [btn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:btn];
    }
    
    [self.view addSubview:topView];
}
//人气、价格、作品数、优惠
- (void)choose:(UIButton *)sender{
    for (int i = 0; i < 4; i++) {
        UIButton *btn = (UIButton *)[[sender superview]viewWithTag:100 + i];
        [btn setSelected:NO];
        if (!btn.selected) {
            [btn setImage:[UIImage imageNamed:@"ic_fast_order"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"tabbar01_selected"] forState:UIControlStateNormal];
        }
    }
    UIButton *button = (UIButton *)sender;
    [button setSelected:YES];
    [button setImage:[UIImage imageNamed:@"tabbar03_selected"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:170.0/255 green:107.0/255 blue:208.0/255 alpha:1] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"tabbar02_selected"] forState:UIControlStateNormal];
}
static NSArray *_titleArr;
-(void)initUIButtonView{
    
    _titleArr = @[@"人气",@"价格",@"桌数",@"优惠"];
    
    for (int i = 0; i < _titleArr.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10 + i * ((DH_DeviceWidth - 50)/4 + 10) , 20, (DH_DeviceWidth - 50)/4, 25);
        [btn setTitle:_titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.showsTouchWhenHighlighted = YES;
        //设置tag值
        btn.tag = i + 100;
        btn.selected = NO;
        [btn addTarget:self action:@selector(chooses:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"ic_fast_order"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"tabbar01_selected"] forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor colorWithRed:170.0/255 green:107.0/255 blue:208.0/255 alpha:1] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"tabbar03_selected"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"tabbar03_selected"] forState:UIControlStateSelected];
        [self.view addSubview:btn];
    }
    
}
//人气、价格、作品数、优惠
- (void)chooses:(UIButton *)sender{
    //方法一
//    for (int i = 0; i < _titleArr.count; i++) {
//        UIButton *btn = (UIButton *)[[sender superview]viewWithTag:100 + i];
//        [btn setSelected:NO];
//    }
//    UIButton *button = (UIButton *)sender;
//    [button setSelected:YES];
    //方法二
    for (int i = 0; i < _titleArr.count; i++) {
        UIButton *btn = (UIButton *)[[sender superview]viewWithTag:100 + i];
        //选中当前按钮时
        if (sender.tag == btn.tag) {
            
            sender.selected = !sender.selected;
        }else{
            
            [btn setSelected:NO];
        }
    }
    
    
}

static NSMutableArray *_masonryViewArray;
- (NSMutableArray *)masonryViewArray {
    
    if (!_masonryViewArray) {
        
        _masonryViewArray = [NSMutableArray array];
        for (int i = 0; i < 4; i ++) {
            
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor redColor];
            [self.view addSubview:view];
            [_masonryViewArray addObject:view];
        }
    }
    
    return _masonryViewArray;
}

//水平方向排列、固定控件间隔、控件长度不定
- (void)test_masonry_horizontal_fixSpace {
    
    // 实现masonry水平固定间隔方法
    [self.masonryViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:30 leadSpacing:10 tailSpacing:10];
    
    // 设置array的垂直方向的约束
    [self.masonryViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@150);
        make.height.equalTo(@80);
    }];
}

//水平方向排列、固定控件长度、控件间隔不定
- (void)test_masonry_horizontal_fixItemWidth {
    
    // 实现masonry水平固定控件宽度方法
    [self.masonryViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:80 leadSpacing:10 tailSpacing:10];
    
    // 设置array的垂直方向的约束
    [self.masonryViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@150);
        make.height.equalTo(@80);
    }];
}

//垂直方向排列、固定控件间隔、控件高度不定
- (void)test_masonry_vertical_fixSpace {
    
    // 实现masonry垂直固定控件高度方法
    [self.masonryViewArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:30 leadSpacing:10 tailSpacing:10];
    
    // 设置array的水平方向的约束
    [self.masonryViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@150);
        make.width.equalTo(@80);
    }];
}
//垂直方向排列、固定控件高度、控件间隔不定
- (void)test_masonry_vertical_fixItemWidth {
    
    // 实现masonry垂直方向固定控件高度方法
    [self.masonryViewArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:80 leadSpacing:10 tailSpacing:10];
    
    // 设置array的水平方向的约束
    [self.masonryViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@150);
        make.width.equalTo(@80);
    }];
}

- (void)clickBtn{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0.0 ,100.0 ,DH_DeviceWidth ,50.0)];
    [button setTitle:@"全部⬇️" forState:(UIControlStateNormal)];
    [button setTitle:@"全部⬆️" forState:(UIControlStateSelected)];
    [button setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(submit:) forControlEvents:(UIControlEventTouchUpInside)];
    button.backgroundColor = [UIColor colorWithRed:0.043 green:0.722 blue:0.729 alpha:1.000];
    [self.view addSubview:button];
    
    //
    
    //
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(0.0 ,150.0 ,DH_DeviceWidth ,50.0)];
    [button1 setTitle:@"提交" forState:(UIControlStateNormal)];
    [button1 setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    [button addTarget:self action:@selector(submit) forControlEvents:(UIControlEventTouchUpInside)];
    button1.backgroundColor = [UIColor colorWithRed:0.043 green:0.722 blue:0.729 alpha:1.000];
    [self.view addSubview:button1];
    button1.tag = 121;
    button1.hidden=YES;
}
//- (void)submit:(UIButton *)sender{
//    UIButton *btn = (UIButton*)[self.view viewWithTag:121];
//    if (sender.selected==YES) {
//        [UIView animateWithDuration:1 animations:^{
//            btn.hidden = YES;
//        }];
//
//    }else{
//        [UIView animateWithDuration:1 animations:^{
//            btn.hidden = NO;
//        }];
//    }
//    sender.selected = !sender.selected;
//}
#pragma mark - 将某个时间戳转化成 时间
- (NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
    
}
#pragma mark - 将某个时间转化成 时间戳

- (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    return timeSp;
}
- (void)cres{
    self.contentView = [[UIView alloc]init];
    self.contentView.layer.borderColor = [UIColor redColor].CGColor;
    self.contentView.layer.borderWidth = 1.0;
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.dailyInspectionTasks];
    [self.contentView addSubview:self.timeCutoff];
    [self.contentView addSubview:self.publisher];
    [self.contentView addSubview:self.numberStoresCount];
    [self.contentView addSubview:self.numberStores];
    [self.contentView addSubview:self.frequencyCount];
    [self.contentView addSubview:self.frequency];
    [self.contentView addSubview:self.frequencypCount];
    [self.contentView addSubview:self.frequencyp];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.totalNumberPlansCount];
    [self.contentView addSubview:self.totalNumberPlans];
    [self.contentView addSubview:self.planCompletionCount];
    [self.contentView addSubview:self.planCompletion];
    [self.contentView addSubview:self.actualCompletionCount];
    [self.contentView addSubview:self.actualCompletion];
    [self.contentView addSubview:self.completionRateCount];
    [self.contentView addSubview:self.completionRate];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-150);
        make.left.offset(5);
        make.right.offset(-5);
        make.height.offset(190);
    }];
    
    [self.dailyInspectionTasks setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.dailyInspectionTasks mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(8);
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.height.mas_offset(16);
    }];
    
    [self.timeCutoff setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.timeCutoff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dailyInspectionTasks.mas_left);
        make.top.equalTo(self.dailyInspectionTasks.mas_bottom).offset(8);
        make.height.mas_offset(12);
    }];
    
    [self.publisher setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.publisher mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-8);
        make.top.equalTo(self.contentView.mas_top).offset(14);
        make.height.mas_offset(12);
    }];
    //次数
    [self.frequencyCount setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.frequency mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeCutoff.mas_bottom).offset(50);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.height.mas_offset(12);
        make.width.mas_offset(40);
    }];
    [self.frequencyCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.frequency.mas_top).offset(-22);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.height.mas_offset(14);
    }];
    
    //门店数量
    [self.numberStoresCount setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.numberStores mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.frequency.mas_top);
        make.left.equalTo(self.frequency.mas_left).offset(-85-60);
        make.height.mas_offset(14);
        make.width.mas_offset(70);
    }];
    [self.numberStoresCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberStores.mas_top).offset(-22);
        make.centerX.equalTo(self.numberStores.mas_centerX);
        make.height.mas_offset(14);
    }];
    //频次
    [self.frequencypCount setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.frequencyp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.frequency.mas_top);
//        make.left.equalTo(self.frequency.mas_right).offset(105);
        make.right.equalTo(self.contentView.mas_right).offset(-29);
        make.height.mas_offset(14);
        make.width.mas_offset(40);
    }];
    [self.frequencypCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.frequencyp.mas_top).offset(-22);
        make.centerX.equalTo(self.frequencyp.mas_centerX);
        make.height.mas_offset(14);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.frequencyp.mas_bottom).offset(20);
        make.left.equalTo(self.contentView.mas_left).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(-8);
        make.height.mas_offset(1);
    }];
    //1
    [self.totalNumberPlansCount setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.totalNumberPlans mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(38);
        make.right.equalTo(self.planCompletion.mas_left);
        make.width.equalTo(self.planCompletion.mas_width);
        make.left.equalTo(self.line.mas_left).offset(12);
        make.height.mas_offset(12);
    }];
    [self.totalNumberPlansCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalNumberPlans.mas_top).offset(-22);
        make.centerX.equalTo(self.totalNumberPlans.mas_centerX);
        make.height.mas_offset(14);
    }];
    //2
    [self.planCompletionCount setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.planCompletion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalNumberPlans.mas_top);
        make.right.equalTo(self.actualCompletion.mas_left);
        make.width.equalTo(self.actualCompletion.mas_width);
        make.left.equalTo(self.totalNumberPlans.mas_right);
        make.height.equalTo(self.totalNumberPlans.mas_height);
    }];
    [self.planCompletionCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.planCompletion.mas_top).offset(-22);
        make.centerX.equalTo(self.planCompletion.mas_centerX);
        make.height.mas_offset(14);
    }];
    //3
    [self.actualCompletionCount setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.actualCompletion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalNumberPlans.mas_top);
        make.left.equalTo(self.planCompletion.mas_right);
        make.right.equalTo(self.completionRate.mas_left);
        make.height.equalTo(self.planCompletion.mas_height);
        make.width.equalTo(self.completionRate.mas_width);
    }];
    [self.actualCompletionCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.actualCompletion.mas_top).offset(-22);
        make.centerX.equalTo(self.actualCompletion.mas_centerX);
        make.height.mas_offset(14);
    }];
    //4
    [self.completionRateCount setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.completionRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalNumberPlans.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.height.equalTo(self.actualCompletion.mas_height);
    }];
    [self.completionRateCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.planCompletion.mas_top).offset(-22);
        make.centerX.equalTo(self.completionRate.mas_centerX);
        make.height.mas_offset(14);
    }];
    
    [self.completionRateCount layoutIfNeeded];
    self.completionRateCount.layer.borderColor = [UIColor redColor].CGColor;
    self.completionRateCount.layer.borderWidth = 1.0;
    
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.completionRateCount.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(5.5, 5.5)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.completionRateCount.bounds;
    maskLayer.path = maskPath.CGPath;
    self.completionRateCount.layer.mask = maskLayer;
    //    self.correctionlistCount.clipsToBounds = YES;
    //    self.correctionlistCount.translatesAutoresizingMaskIntoConstraints = NO;
    
}
- (UILabel *)dailyInspectionTasks
{
    if (!_dailyInspectionTasks) {
        _dailyInspectionTasks = [[UILabel alloc]init];
        _dailyInspectionTasks.font = [UIFont fontWithName:@"Medium" size:16];
//        _dailyInspectionTasks.textColor = UIColorRGB(47, 56, 86);
        _dailyInspectionTasks.textAlignment = NSTextAlignmentLeft;
        _dailyInspectionTasks.text = @"日常检查任务";
    }
    return _dailyInspectionTasks;
}
- (UILabel *)timeCutoff
{
    if (!_timeCutoff) {
        _timeCutoff = [[UILabel alloc]init];
        _timeCutoff.font = [UIFont fontWithName:@"Regular" size:12];
//        _timeCutoff.textColor = UIColorRGB(153, 160, 182);
        _timeCutoff.textAlignment = NSTextAlignmentLeft;
        _timeCutoff.text = @"2019年9月1日-2020年9月3日";
    }
    return _timeCutoff;
}
- (UILabel *)publisher
{
    if (!_publisher) {
        _publisher = [[UILabel alloc]init];
        _publisher.font = [UIFont fontWithName:@"Regular" size:12];
//        _publisher.textColor = UIColorRGB(153, 160, 182);
        _publisher.textAlignment = NSTextAlignmentLeft;
        _publisher.text = @"发布人：马云";
        
    }
    return _publisher;
}

- (UILabel *)numberStoresCount
{
    if (!_numberStoresCount) {
        _numberStoresCount = [[UILabel alloc]init];
        _numberStoresCount.font = [UIFont fontWithName:@"Regular" size:12];
//        _numberStoresCount.textColor = UIColorRGB(47, 56, 86);
        _numberStoresCount.textAlignment = NSTextAlignmentCenter;
        _numberStoresCount.text = @"200家";
    }
    return _numberStoresCount;
}

- (UILabel *)numberStores
{
    if (!_numberStores) {
        _numberStores = [[UILabel alloc]init];
        _numberStores.font = [UIFont fontWithName:@"Regular" size:12];
//        _numberStores.textColor = UIColorRGB(44, 215, 115);
        _numberStores.textAlignment = NSTextAlignmentLeft;
        _numberStores.text = @"门店数量";
    }
    return _numberStores;
}

- (UILabel *)frequencyCount
{
    if (!_frequencyCount) {
        _frequencyCount = [[UILabel alloc]init];
        _frequencyCount.font = [UIFont fontWithName:@"Medium" size:16];
//        _frequencyCount.textColor = UIColorRGB(47, 56, 86);
        _frequencyCount.textAlignment = NSTextAlignmentCenter;
        _frequencyCount.text = @"1次/天";
        
    }
    return _frequencyCount;
}

- (UILabel *)frequency
{
    if (!_frequency) {
        _frequency = [[UILabel alloc]init];
        _frequency.font = [UIFont fontWithName:@"Regular" size:14];
//        _frequency.textColor = UIColorRGB(255, 159, 35);
        _frequency.textAlignment = NSTextAlignmentLeft;
        _frequency.text = @"次数";
    }
    return _frequency;
}

- (UILabel *)frequencypCount
{
    if (!_frequencypCount) {
        _frequencypCount = [[UILabel alloc]init];
        _frequencypCount.font = [UIFont fontWithName:@"Regular" size:14];
//        _frequencypCount.textColor = UIColorRGB(255, 159, 35);
        _frequencypCount.textAlignment = NSTextAlignmentCenter;
        _frequencypCount.text = @"365次/家";
        
    }
    return _frequencypCount;
}

- (UILabel *)frequencyp
{
    if (!_frequencyp) {
        _frequencyp = [[UILabel alloc]init];
        _frequencyp.font = [UIFont fontWithName:@"Regular" size:14];
//        _frequencyp.textColor = UIColorRGB(66, 139, 254);
        _frequencyp.textAlignment = NSTextAlignmentLeft;
        _frequencyp.text = @"频次";
        
    }
    return _frequencyp;
}
- (UILabel *)line
{
    if (!_line) {
        _line = [[UILabel alloc]init];
        _line.backgroundColor = UIColorRGB(238, 238, 238);
    }
    return _line;
}
- (UILabel *)totalNumberPlansCount
{
    if (!_totalNumberPlansCount) {
        _totalNumberPlansCount = [[UILabel alloc]init];
        _totalNumberPlansCount.font = [UIFont fontWithName:@"Regular" size:14];
        _totalNumberPlansCount.textColor = UIColorRGB(153, 160, 182);
        _totalNumberPlansCount.textAlignment = NSTextAlignmentCenter;
        _totalNumberPlansCount.text = @"1.9W次";
        
    }
    return _totalNumberPlansCount;
}

- (UILabel *)totalNumberPlans
{
    if (!_totalNumberPlans) {
        _totalNumberPlans = [[UILabel alloc]init];
        _totalNumberPlans.font = [UIFont fontWithName:@"Regular" size:12];
        _totalNumberPlans.textColor = UIColorRGB(153, 160, 182);
        _totalNumberPlans.textAlignment = NSTextAlignmentCenter;
        _totalNumberPlans.text = @"计划总量";
        
    }
    return _totalNumberPlans;
}

- (UILabel *)planCompletionCount
{
    if (!_planCompletionCount) {
        _planCompletionCount = [[UILabel alloc]init];
        _planCompletionCount.font = [UIFont fontWithName:@"Regular" size:14];
        _planCompletionCount.textColor = UIColorRGB(153, 160, 182);
        _planCompletionCount.textAlignment = NSTextAlignmentCenter;
        _planCompletionCount.text = @"150次";
        
    }
    return _planCompletionCount;
}

- (UILabel *)planCompletion
{
    if (!_planCompletion) {
        _planCompletion = [[UILabel alloc]init];
        _planCompletion.font = [UIFont fontWithName:@"Regular" size:12];
        _planCompletion.textColor = UIColorRGB(153, 160, 182);
        _planCompletion.textAlignment = NSTextAlignmentCenter;
        _planCompletion.text = @"计划完成";
        
    }
    return _planCompletion;
}

- (UILabel *)actualCompletionCount
{
    if (!_actualCompletionCount) {
        _actualCompletionCount = [[UILabel alloc]init];
        _actualCompletionCount.font = [UIFont fontWithName:@"Regular" size:14];
        _actualCompletionCount.textColor = UIColorRGB(153, 160, 182);
        _actualCompletionCount.textAlignment = NSTextAlignmentCenter;
        _actualCompletionCount.text = @"50次";
        
    }
    return _actualCompletionCount;
}

- (UILabel *)actualCompletion
{
    if (!_actualCompletion) {
        _actualCompletion = [[UILabel alloc]init];
        _actualCompletion.font = [UIFont fontWithName:@"Regular" size:12];
        _actualCompletion.textColor = UIColorRGB(153, 160, 182);
        _actualCompletion.textAlignment = NSTextAlignmentCenter;
        _actualCompletion.text = @"实际完成";
    }
    return _actualCompletion;
}

- (UILabel *)completionRateCount{
    if (!_completionRateCount) {
        _completionRateCount = [[UILabel alloc]init];
        _completionRateCount.font = [UIFont fontWithName:@"Regular" size:14];
        _completionRateCount.textColor = UIColorRGB(153, 160, 182);
        _completionRateCount.textAlignment = NSTextAlignmentCenter;
        _completionRateCount.text = @"第%ld次整改单";
        
    }
    return _completionRateCount;
}

- (UILabel *)completionRate{
    if (!_completionRate) {
        _completionRate = [[UILabel alloc]init];
        _completionRate.font = [UIFont fontWithName:@"Regular" size:14];
        _completionRate.textColor = UIColorRGB(153, 160, 182);
        _completionRate.textAlignment = NSTextAlignmentCenter;
        _completionRate.text = @"完成率";
    }
    return _completionRate;
}
- (UILabel *)oneLabel
{
    if (!_oneLabel) {
        _oneLabel = [[UILabel alloc] init];
        _oneLabel.textColor = [UIColor redColor];
        _oneLabel.font = [UIFont systemFontOfSize:15];
    }
    return _oneLabel;
}

- (UILabel *)twoLabel
{
    if (!_twoLabel) {
        _twoLabel = [[UILabel alloc] init];
        _twoLabel.textColor = [UIColor orangeColor];
        _twoLabel.font = [UIFont systemFontOfSize:15];
        _twoLabel.numberOfLines = 0;//换行
    }
    return _twoLabel;
}

- (UILabel *)threeLabel
{
    if (!_threeLabel) {
        _threeLabel = [[UILabel alloc] init];
        _threeLabel.textColor = [UIColor magentaColor];
        _threeLabel.font = [UIFont systemFontOfSize:15];
        _threeLabel.numberOfLines = 0;//换行
    }
    return _threeLabel;
}
//- (void)startAnimation
//
//{
//
//	CGAffineTransform endAngle = CGAffineTransformMakeRotation(mainImageView * (M_PI / 180.0f));
//
//	[UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//
//		mainImageView.transform = endAngle;
//
//	} completion:^(BOOL finished) {
//
//		angle += 10; [self startAnimation];
//
//	}];
//
//}
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
