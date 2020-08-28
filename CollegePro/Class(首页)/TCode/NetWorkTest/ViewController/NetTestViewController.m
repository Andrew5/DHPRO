//
//  NetTestViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/8/11.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "NetTestViewController.h"
#import "SFNetWorkManager.h"
#import "CommentsModel.h"
#import <objc/message.h>
#import "DataModel.h"


@interface NetTestViewController ()
{
	__block NSArray *_dataSource;
	
	int count1,count2,count3,count4,count5,coun6,count7,count8;//为创建Timer计时器
	NSTimer *timer1,*timer2,*timer3,*timer4,*timer5,*timer6,*timer7,*timer8;
	

}
@property (nonatomic,assign)dispatch_queue_t queue ;
@property (nonatomic,copy)NSString *someString;
@end

@implementation NetTestViewController
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    // Do any additional setup after loading the view.
}


- (void)getdata{
	NSString *URL = @"https://testapi.iuoooo.com/jrtc.api/Jinher.AMP.JRTC.RealTime.svc/GetChannelToken";
	NSArray *UserId = @[@"f2622c2b-80fb-4e66-9280-66d4eb6053e4"];
	NSString *PassWord = @"59254df4adb4f537906cb9c436641dd95d276a202960cab55aa546873c12e9c0";

    NSDictionary *param = NSDictionaryOfVariableBindings(UserId,PassWord);
    [SFNetWorkManager requestWithType:HttpRequestTypePost withUrlString:URL withParaments:param withSuccessBlock:^(NSDictionary *object) {
		
		self->_dataSource = [DataModel mj_objectArrayWithKeyValuesArray:object[@"data"]];
			
	} withFailureBlock:^(NSError *error) {
        NSLog(@"error %@",error.description);
	} progress:^(float progress) {
		
	}];
}

#pragma mark GCD- 依赖
- (void)relyOperation{
//    NSOperation
}


// 核心概念：
// 任务：Block  即将任务保存到一个Block中去。
// 队列： 把任务放到队列里面，队列先进先出的原则，把任务一个个取出（放到对应的线程）执行。
// 串行队列：顺序执行。即一个一个的执行。
// 并行队列：同时执行。同时执行很多个任务。
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}




- (void)other{
    NSLog(@"%s",__func__);
}

//消息动态解析
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(test)) {
        Method method = class_getInstanceMethod(self, @selector(other));
        class_addMethod(self, sel, method_getImplementation(method), method_getTypeEncoding(method));
//      class_addMethod([self class], name, (IMP)dynamicAdditionMethodIMP, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
//消息转发
//第一种1.0
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if (aSelector == @selector(test)) {
        //返回值为nil,相当于没有实现这个方法
        return [[DataModel alloc] init];
    }
    return [super forwardingTargetForSelector:aSelector];
}
//如果需要传参直接在参数列表后面添加就好了
void dynamicAdditionMethodIMP(id self, SEL _cmd) {
    NSLog(@"dynamicAdditionMethodIMP");
}
//第二种2.0
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    //返回方法签名
    return [NSMethodSignature signatureWithObjCTypes:"v16@:"];
}
//NSInvocation 里面包含了: 方法调用者,方法名,参数
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    //修改方法调用者
    anInvocation.target = (id)[[DataModel alloc] init];
    //调用方法
    [anInvocation invoke];
}

- (void)model
{
    DataModel *persion = ((DataModel *(*)(id, SEL))(void *)objc_msgSend)((id)((DataModel *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("DataModel"), sel_registerName("alloc")), sel_registerName("init"));
    //第一个参数是消息接受者(receive)persion, 第二个参数是方法签名sel_registerName("teset")
    ((void (*)(id, SEL))(void *)objc_msgSend)((id)persion, sel_registerName("teset"));
    
    //简化后
    [persion teset];
    objc_msgSend(persion, sel_registerName("teset"));
}
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//
//        [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//        [request setHTTPMethod:@"POST"];
//
//
//        // NSString * employeeIdStr = @"050f0146-0481-4ca2-ad10-9b70409d9df4";
//
//        // NSDictionary *json = @{@"EmployeeId": employeeIdStr,@"Key" :@"Signature",@"Value":@"卧室已经改过的的哦"};
//        NSDictionary *json = @{@"EmployeeId": employeeIdStr,@"Key" :self.keyStr,@"Value":self.editTextView.text};
//
//        NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
//
//        [request setHTTPBody:data];
//
//
//        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            NSLog(@"请求回来的内容-----%@",dict);
//            NSLog(@"==＝%@",[dict objectForKey:@"Message"]);
//            // [MBProgressHUD displayHudError:@"保存成功"];
//
//            NSString * errStr = @"上传中...";
//            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
//            hud.labelText = errStr;
//            hud.labelFont = [UIFont systemFontOfSize:14.0f];
//            hud.removeFromSuperViewOnHide = YES;
//            [hud setMode:MBProgressHUDModeCustomView];
//            [[UIApplication sharedApplication].keyWindow addSubview:hud];
//            [hud show:YES];
//            double fDelay = 4.0f;
//
//            if (errStr.length > 10)
//            {
//                fDelay = 4.0f;
//            }
//            [LoginAndRegister getEmployeeInfoForPC];
//            [hud performSelector:@selector(hide:) withObject:@"1" afterDelay:fDelay];
//
//            [self performSelector:@selector(back) withObject:nil afterDelay:4];
//            // [self.navigationController popViewControllerAnimated:YES];
//
//        }];
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
