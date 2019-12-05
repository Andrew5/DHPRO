//
//  LabelNilMethodBlockViewController.m
//  Test
//
//  Created by Rillakkuma on 2016/11/29.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "LabelNilMethodBlockViewController.h"
#import "UIColor+expanded.h"
#import <objc/message.h>

@interface LabelNilMethodBlockViewController ()
@property (nonatomic,copy) void(^CallBack)(NSString *str);

//声明成员属性
@end

@implementation LabelNilMethodBlockViewController
//+ (LabelNilMethodBlockViewController *)shareManage;
//{
//    //设置静态变量
//    static LabelNilMethodBlockViewController *s=nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        if (s==nil) {
//            s = [[LabelNilMethodBlockViewController alloc] init];
//        }
//    });
//    return s;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Runtime";
	self.view.backgroundColor = [UIColor whiteColor];
//    self.nameP = @"筛选数字";
    NSLog(@"self.nameP %@",_nameP);
    // Do any additional setup after loading the view.
	UIButton *pushNillButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[pushNillButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	[pushNillButton setFrame:CGRectMake(10.0 ,80.0 ,120.0 ,20.0)];
	pushNillButton.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.00];       //背景颜
	[pushNillButton setTitle:@"回去" forState:(UIControlStateNormal)];
	[pushNillButton addTarget:self action:@selector(backBlockNilMetnod) forControlEvents:(UIControlEventTouchUpInside)];
	[self.view addSubview:pushNillButton];
//    (返回类型)(^块名称)(参数类型) = ^(参数列表) {代码实现};
    //    __weak typeof(self) _weakSelf = self;
    void(^DicBlock)(NSDictionary *dicdic) = ^(NSDictionary * inforDic){
        NSLog(@"dic %@",inforDic);
    };
    id library = [[NSClassFromString(@"Persion") alloc] init];

    ((void(*)(id,SEL,id))objc_msgSend)([library class], NSSelectorFromString(@"numberInforDic:"), DicBlock);
    //上面这代码等同于下面
    id item = ((id(*)(id,SEL,NSDictionary *))objc_msgSend)(library, NSSelectorFromString(@"initWithProperty:"),@{@"kay":@"value"});
    NSLog(@"item %@",item);
    //随机生成一个名字
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);
    NSString    *uuidString = ( NSString *)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    NSLog(@"后台uuidString:%@",uuidString);
	// Do any additional setup after loading the view.
}
- (void)setNameP:(NSString *)nameP{
    _nameP = nameP;
    NSLog(@"%@",nameP);
    
}
- (NSString *)nameP:(NSString *)a{
    _nameP = a;
//    _nameP = @"筛选数字";
    NSLog(@"nameP %@",_nameP);
    return _nameP;
}
-(void)setCommunicationMessage:(NSDictionary *)communicationMessage{
    _communicationMessage = communicationMessage;
    NSLog(@"self.%@",self.communicationMessage);
}

-(void)setReception:(receiveNoti)reception{
    _reception = reception;
    _reception(@"初始值开始");
}
- (void)setMyReturnTextBlock:(MyReturnTextBlock)myReturnTextBlock
{
    _myReturnTextBlock = myReturnTextBlock;
    _myReturnTextBlock(@"初始值返回");
}
- (void)backBlockNilMetnod{
	
	self.myReturnTextBlock(@"backBlockNilMetnod点击了返回");
    [self closeCurruntPage];

}
+(void)numberInfor:(void (^)(NSString *))inforBlock{
    if (inforBlock) {
        inforBlock(@"中文");
    }
}
+(BOOL)isWhiteSkinColor{
    //白色皮肤颜色
    UIColor * whiteColor = [UIColor colorWithString:@"fbfcf9"];
    if (whiteColor)
    {
        return YES;
    }
    return NO;
}
+ (BOOL)isWXAppInstalled{
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]] ) {
        NSLog(@"没有安装微信");
        return NO;
    }
    return YES;
}

- (NSString *)textFunction:(NSString *)str{
    NSLog(@"%@",str);
    return @"有返回值";
}
- (void)textValueFunction:(void(^)(NSString * infor))inforBlock{
    if (inforBlock) {
        inforBlock(@"无返回值的block");
    }
}
+ (void)loadDetailCallBack:(NSString *)name callBack:(void(^)(NSString* str))FinishCallBack{
//    if (FinishCallBack) {
//        FinishCallBack(@"中文");
//    }
    LabelNilMethodBlockViewController *bal = [LabelNilMethodBlockViewController new];
    [bal funcCallback:FinishCallBack];
    
}
- (void)funcCallback:(void(^)(NSString* str))FinishCallBack{
    
    self.CallBack = [FinishCallBack copy];
    if (FinishCallBack) {
        FinishCallBack(@"改变");
    }
}
// 防止多次调用
- (void)getShouldPrevent:(int)seconds{
    static BOOL shouldPrevent;
    if (shouldPrevent) return;
    shouldPrevent = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((seconds) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        shouldPrevent = NO;
    });
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
