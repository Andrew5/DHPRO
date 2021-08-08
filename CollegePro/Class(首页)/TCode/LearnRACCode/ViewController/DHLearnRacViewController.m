//
//  DHLearnRacViewController.m
//  CollegePro
//
//  Created by jabraknight on 2020/11/9.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHLearnRacViewController.h"
#import "ReactiveObjC.h"
//#import "NSObject+RACKVOWrapper.h"

#import "ReadView.h"
#import "FlageModel.h"
@interface DHLearnRacViewController ()
@property (nonatomic,strong)RACCommand *conmmand;
@property (nonatomic,strong)id subscriber;
@property (nonatomic,strong)ReadView *readView;

@end

@implementation DHLearnRacViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        //1、
        //            [self performSelector:@selector(drawlayer) withObject:nil afterDelay:5];
        //            [[NSRunLoop currentRunLoop] run];
        //2、    开启新的线程在后台执行SEl方法
        //            [self performSelector:@selector(drawlayer) withObject:nil];
        //3、
        //            [self performSelector:@selector(drawlayer) onThread:[NSThread currentThread] withObject:nil waitUntilDone:YES];
        //4、
        //            [self performSelectorOnMainThread:@selector(drawlayer) withObject:nil waitUntilDone:YES];
        //5、将更新UI事件放在主线程的NSDefaultRunLoopMode上执行，等用户不在滑动的时候再将UITrackingRunLoopMode切换到NSDefaultRunLoopMode时去更新UI，保证子线程数据返回更新UI时不打断用户滑动操作
        //            [self performSelectorOnMainThread:@selector(drawlayer) withObject:nil waitUntilDone:NO modes:@[NSDefaultRunLoopMode]];
        //6、
        //            [self performSelectorInBackground:@selector(drawlayer) withObject:nil];
        //7、
        //            [self performSelector:@selector(drawlayer) withObject:nil afterDelay:2 inModes:@[NSDefaultRunLoopMode]];
        //            [[NSRunLoop currentRunLoop] run];
        //8、
        //            [self performSelector:@selector(drawlayer) onThread:[NSThread currentThread] withObject:nil waitUntilDone:YES modes:@[NSDefaultRunLoopMode]];
    });
    
    //    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(drawlayer) object:nil];
    //    [NSThread detachNewThreadSelector:@selector(drawlayer) toTarget:self withObject:nil];
    //    [NSThread detachNewThreadWithBlock:^{
    //
    //            NSLog(@"block中的线程 ---- %@",[NSThread currentThread]);
    //    }];
    
    
    
    /*
     夜间模式通知
     NeedTransferToNight
     NeedTransferToDay
     */
    //    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self.view addSubview:btn];
    //    btn.frame = CGRectMake(10, 64, 45, 20);
    //    //        [btn.titleLabel setText:@"进入"];
    //    [btn setTitle:@"进入" forState:(UIControlStateNormal)];
    //    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    ////    [btn addTarget:self action:@selector(addPage) forControlEvents:(UIControlEventTouchUpInside)];
    //    [btn addTarget:self action:@selector(testRAC) forControlEvents:(UIControlEventTouchUpInside)];
    //    btn.layer.borderColor = [UIColor greenColor].CGColor;
    //    btn.layer.borderWidth = 1.0;
    // Do any additional setup after loading the view.
    [self testRAC];
}
- (void)testRAC{
    
    //    /* 创建信号 */
    //    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
    //
    //        /* 发送信号 */
    //        [subscriber sendNext:@"发送信号"];
    //
    //        return nil;
    //    }];
    //
    //    /* 订阅信号 */
    //    RACDisposable *disposable = [signal subscribeNext:^(id  _Nullable x) {
    //
    //        NSLog(@"信号内容：%@", x);
    //    }];
    //
    //    /* 取消订阅 */
    //    [disposable dispose];
    //
    
    
    //    /* 创建信号 */
    //    RACSubject *subject = [RACSubject subject];
    //
    //    /* 发送信号 */
    //    [subject sendNext:@"发送信号"];
    //
    //    /* 订阅信号（通常在别的视图控制器中订阅，与代理的用法类似） */
    //    [subject subscribeNext:^(id  _Nullable x) {
    //
    //        NSLog(@"信号内容：%@", x);
    //    }];
    //    /* 遍历字典 */
    //    NSDictionary *dictionary = @{@"key1":@"value1", @"key2":@"value2", @"key3":@"value3"};
    //    [dictionary.rac_sequence.signal subscribeNext:^(RACTuple * _Nullable x) {
    //        RACTupleUnpack(NSString *key, NSString *value) = x; // x 是一个元祖，这个宏能够将 key 和 value 拆开
    //        NSLog(@"字典内容：%@:%@", key, value);
    //    }];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:@"noti" object:nil];
    
    //    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
    //        NSLog(@"%@",x);
    //    }];
    
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(10, 84, 100, 100)];
    [self.view addSubview:firstView];
    
    firstView.layer.borderColor = [UIColor greenColor].CGColor;
    firstView.layer.borderWidth = 1.0;
    
    UIButton *btnFirstView = [UIButton buttonWithType:UIButtonTypeCustom];
    [firstView addSubview:btnFirstView];
    btnFirstView.frame = CGRectMake(10, 10, 45, 20);
    [btnFirstView setTitle:@"点击" forState:(UIControlStateNormal)];
    //    [btnFirstView addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [btnFirstView setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btnFirstView.layer.borderColor = [UIColor redColor].CGColor;
    btnFirstView.layer.borderWidth = 1.0;
    //    [[btnFirstView rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(RACTuple * _Nullable x) {
    //        //        NSLog(@"你竟然响应我了 厉害了");
    //        NSLog(@"RAC响应子视图上的按钮点击事件");
    //        NSLog(@"%@",x);
    //    }];
    //监听方法
    [[btnFirstView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"%@",x);
        //        [self RACCommand];
        //        [self RACTest];
        //        [self RACTestOne];
        //        [self RACSubject];
        //        [self RACReplaySubject];
        [self RACTuple];
    }];
    
    [[firstView rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(RACTuple * _Nullable x) {
        
        NSLog(@" view 中的按钮被点击了");
    }];
    
    _readView = [[ReadView alloc]init];
    _readView.frame = CGRectMake(110, 64, 100, 100);
    [self.view addSubview:_readView];
    _readView.layer.borderColor = [UIColor redColor].CGColor;
    _readView.layer.borderWidth = 1.0;
    //方法一
    [_readView.btnClickSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@被触发了",x);
    }];
    //方法二
    //调用私有方法
    //只要传值 就必须实现RACSubject
    [[_readView rac_signalForSelector:@selector(btnClick)] subscribeNext:^(id x) {
        NSLog(@"btnClick调用了");
    }];
    //代理KVO
//    [_readView rac_observeKeyPath:@"frame" options:(NSKeyValueObservingOptionNew) observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
//        NSLog(@"代理KVO");
//    }];
    [[_readView rac_valuesForKeyPath:@"frame" observer:nil] subscribeNext:^(id  _Nullable x) {
        NSLog(@"ValueForKey %@",x);
    }];
    //通知
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
    }];
    
    //监听文本框
    UITextField *textFiled = [[UITextField alloc]init];
    [self.view addSubview:textFiled];
    textFiled.frame = CGRectMake(200, 64, 50, 30);
    textFiled.layer.borderColor = [UIColor greenColor].CGColor;
    textFiled.layer.borderWidth = 1.0;
    [textFiled.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"文本框 %@",x);
    }];
    //    [[readView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
    //        NSLog(@"红view 中的按钮被点击了");
    //    }];
    
    //    [[_readView rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(RACTuple * _Nullable x) {
    //
    //        NSLog(@"红view 中的按钮被点击了");
    //    }];
    
    //RAC
    //把控制器调用的系统方法转换成信号
    //rac_signalForSelector:监听某对象有没有调用方法
    //    [[self rac_signalForSelector:@selector(testRAC)] subscribeNext:^(RACTuple * _Nullable x) {
    //        NSLog(@"控制器调用了");
    //    }];
}


- (void)btnClick:(id)sender{
    NSLog(@"响应子视图上的按钮点击事件");
}
- (void)RACTest{
    //1、创建
    RACSignal *racSingal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        //调用：只要一个信号被订阅就会被调用
        //作用：发送数据
        //3、发送
        [subscriber sendNext:@"发现前方有问题"];
        return  nil;
    }];
    //2、订阅
    [racSingal subscribeNext:^(id  _Nullable x) {
        //调用：只要订阅者发送数据就可调用
        //作用：处理数据 真是到UI上
        NSLog(@"我%@",x);
    }];
}
//上述方法类似下面分解方法
- (void)RACTestOne{
    RACDisposable *(^didSubscribe)(id<RACSubscriber> subscribe) = ^RACDisposable *(id<RACSubscriber> subscriber){
        NSLog(@"信号被调用");
        //强引用
        //只要订阅者还在，就不会自动取消信号订阅
        self->_subscriber = subscriber;
        //3、发送
        [subscriber sendNext:@"发送"];
        return  [RACDisposable disposableWithBlock:^{
            //清空
            NSLog(@"清空");
        }];
    };
    //1、创建信号
    RACSignal *signal = [RACSignal createSignal:didSubscribe];
    //2、订阅
    [signal subscribeNext:^(id  _Nullable x) {
        //调用：只要订阅者发送数据就可调用
        //作用：处理数据 真是到UI上
        NSLog(@"我%@",x);
    }];
    //只要订阅者调用sendNext 就会执行nextBlock
    //只要信号被订阅 就会执行didSubscribe
    //前提是 RACDynamicSignal 不同类型的订阅处理订阅的的事件
    //    [_subscriber disposable];
}
//代替代理
- (void)RACSubject{
    RACSubject *subject = [RACSubject subject];
    //再发送数据
    [subject sendNext:@"1212"];
    //遍历所有的值 拿到刚刚创建的订阅者
    //仅仅是保存订阅者
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者接收到的消息：%@",x);
    }];
    [subject sendNext:@"3434"];
}
//先发信号 后订阅信号
- (void)RACReplaySubject{
    RACReplaySubject *subject = [RACReplaySubject subject];
    [subject sendNext:@"123"];
    //遍历所有的值 拿到当前订阅者去发送数据
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者接收到消息：%@",x);
    }];
    //保存值
    //遍历所有的订阅者 发送数据
    [subject sendNext:@"456"];
    
    //先发送信号 在订阅信号
}
- (void)RACTuple{
    /* 创建元组 */
    //        RACTuple *tuple = [RACTuple tupleWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
    /* 从别的数组中获取内容 */
    RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[@"1", @"2", @"3", @"4", @"5"]];
    /* 利用 RAC 宏快速封装 */
    //        RACTuple *tuple = RACTuplePack(@"1", @"2", @"3", @"4", @"5");
    NSLog(@"取元祖内容：%@", tuple[0]);
    NSLog(@"第一个元素：%@", [tuple first]);
    NSLog(@"最后一个元素：%@", [tuple last]);
    
    /* 遍历数组 */
    NSArray *array = @[@"1", @"2", @"3", @"4", @"5"];
    //RAC 集合
    RACSequence *sequence = array.rac_sequence;
    //把集合转成信号
    RACSignal *signal = sequence.signal;
    //订阅集合信号 内部自动遍历元素
    //1
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"输出值：%@",x);
    }];
    //上两行代码同下面
    //2
    [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"数组内容：%@", x); // x 可以是任何对象
    }];
    NSLog(@"----------------------------我是分割线-----------------------------");
    //字典
    NSDictionary *dict = @{@"account":@"123",@"age":@"456",@"name":@"789",@"sex":@"0",@"token":@"sdf23s2"};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        //        NSString *key = x[0];
        //        NSString *value = x[1];
        //        NSLog(@"输出的字典组合是 [%@:%@]",key,value);
        //等号右边为解析元组//有问题
        //        RACTupleUnpack(NSString *key,NSString *value) = x;
        //        NSLog(@"输出的字典组合是 [%@:%@]",key,value);
    }];
    
    //解析数据
    NSArray *dictArr = @[@{@"account":@"123",@"age":@"456",@"name":@"789",@"sex":@"0",@"token":@"sdf23s2"},@{@"account":@"1233",@"age":@"4566",@"name":@"7899",@"sex":@"010",@"token":@"sdf23s23"}];
    NSMutableArray *arr = [NSMutableArray array];
    [dictArr.rac_sequence.signal subscribeNext:^(NSDictionary *x) {
        FlageModel *flag = [FlageModel flageWithDict:x];
        [arr addObject:flag];
    }];
    //高级用法
    //把集合中的元素都映射成一个新的对象
    NSArray *arrarr = [[dictArr.rac_sequence map:^id(NSDictionary *value) {
        return [FlageModel flageWithDict:value];
    }] array];
    NSLog(@"数据源：%@",arrarr);
}
// RACCommand 的使用: 使用场景,监听按钮点击，网络请求
- (void)RACCommand{
    
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        NSLog(@"执行命令");
        // 创建空信号,必须返回信号
        //        return [RACSignal empty];
        
        // 2.创建信号,用来传递数据
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"请求数据"];
            
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            
            return nil;
        }];
        
    }];
    
    // 强引用命令，不要被销毁，否则接收不到数据
    self.conmmand = command;
    
    // 3.订阅RACCommand中的信号
    [command.executionSignals subscribeNext:^(id x) {
        
        NSLog(@"command.executionSignals %@",x);
        [x subscribeNext:^(NSString *x) {
            
            NSLog(@"x subscribeNext %@",x);
        }];
        
    }];
    
    // RAC高级用法
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    //    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
    //
    //        NSLog(@"command.executionSignals.switchToLatest   %@",x);
    //    }];
    
    // 4.监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[command.executing skip:1] subscribeNext:^(id x) {
        
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");
            
        }else{
            // 执行完成
            NSLog(@"执行完成");
        }
        
    }];
    // 5.执行命令
    [self.conmmand execute:@1];
    
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
