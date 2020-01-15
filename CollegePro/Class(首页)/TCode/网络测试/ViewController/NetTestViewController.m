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
	UILabel *labelName;//显示名称
	int count1,count2,count3,count4,count5,coun6,count7,count8;//为创建Timer计时器
	NSTimer *timer1,*timer2,*timer3,*timer4,*timer5,*timer6,*timer7,*timer8;
	
	
	NSString *_someString;
}
@property (nonatomic,assign)dispatch_queue_t queue ;
@property (nonatomic,copy)NSString *someString;
@end

@implementation NetTestViewController
-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	timer8.fireDate = [NSDate distantFuture];
	timer7.fireDate = [NSDate distantFuture];
	[timer1 invalidate];
	[timer2 invalidate];
	[timer3 invalidate];
	[timer4 invalidate];
	[timer5 invalidate];
	[timer6 invalidate];
	[timer7 invalidate];
	[timer8 invalidate];
	timer1 = nil;
	timer2 = nil;
	timer3 = nil;
	timer4 = nil;
	timer5 = nil;
	timer6 = nil;
	timer7 = nil;
	timer8 = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self getdata];
//    [self timer];
//    _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    [self asyncGlobalQueue];//异步
//    [self asyncSerialQueue];//同步
    [self asyncGroup];
    dispatch
    [self asyncSemaphore];
    [self asyncBarrier];
}
static  BOOL y;
- (void)test{

    dispatch_queue_t queueMovies = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphoreMovies = dispatch_semaphore_create(5);//创建信号量
    
        dispatch_semaphore_wait(semaphoreMovies, DISPATCH_TIME_FOREVER);//等待信号量 有闲置的信号量就让新的任务进来，如果没有就按照顺序等待闲置的信号量 可以设置等待时间
        dispatch_async(queueMovies, ^{
            //模拟下载任务
            sleep(3);//假设下载一集需要10+i*2秒
            y = NO;
            if (y == YES) {
              return ;
            }
            else{
                [self testtest];
            }
            NSLog(@"A完成");
            dispatch_semaphore_signal(semaphoreMovies);//发送信号量 发送完成进度
        });
}
- (void)testtest{
    //创建一个调度组
    dispatch_group_t group = dispatch_group_create();
    
    //进入调度组
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //模拟请求耗时
        sleep(2);
        y = NO;
        if (y == YES) {
            return ;
        }
        else{
            [self test];
        }
        NSLog(@"B完成");
        //事件完成 离开调度组
        dispatch_group_leave(group);
    });
    
}

-(void)getdata{
	NSString *URL = @"https://testapi.iuoooo.com/jrtc.api/Jinher.AMP.JRTC.RealTime.svc/GetChannelToken";
	NSArray *UserId = @[@"f2622c2b-80fb-4e66-9280-66d4eb6053e4"];
	NSString *PassWord = @"59254df4adb4f537906cb9c436641dd95d276a202960cab55aa546873c12e9c0";


	NSDictionary *param = NSDictionaryOfVariableBindings(UserId,PassWord);
    [SFNetWorkManager requestWithType:HttpRequestTypePost withUrlString:URL withParaments:param withSuccessBlock:^(NSDictionary *obself->ject) {
		
		_dataSource = [DataModel mj_objectArrayWithKeyValuesArray:object[@"data"]];
			
	} withFailureBlock:^(NSError *error) {
        NSLog(@"error %@",error.description);
	} progress:^(float progress) {
		
	}];
}
-(void)timer{
	count1 = 0;
	
	labelName = [[UILabel alloc]init];
	labelName.textAlignment = NSTextAlignmentCenter;
	labelName.textColor = [UIColor blackColor];
	labelName.font = DH_FontSize(14);
	labelName.frame = CGRectMake(0, 0, 15*10, 30);
	labelName.center = CGPointMake(self.view.centerX, 100);
	[self.view addSubview:labelName];
#pragma mark- NSTimer
	//@property NSTimeInterval tolerance;这是7.0之后新增的一个属性，因为NSTimer并不完全精准，通过这个值设置误差范围。
	/**
	 NSTimer会准时触发事件吗
	 
	 答案是否定的，而且有时候你会发现实际的触发时间跟你想象的差距还比较大。NSTimer不是一个实时系统，因此不管是一次性的还是周期性的timer的实际触发事件的时间可能都会跟我们预想的会有出入。差距的大小跟当前我们程序的执行情况有关系，比如可能程序是多线程的，而你的timer只是添加在某一个线程的runloop的某一种指定的runloopmode中，由于多线程通常都是分时执行的，而且每次执行的mode也可能随着实际情况发生变化。
	 假设你添加了一个timer指定2秒后触发某一个事件，但是签好那个时候当前线程在执行一个连续运算(例如大数据块的处理等)，这个时候timer就会延迟到该连续运算执行完以后才会执行。重复性的timer遇到这种情况，如果延迟超过了一个周期，则会和后面的触发进行合并，即在一个周期内只会触发一次。但是不管该timer的触发时间延迟的有多离谱，他后面的timer的触发时间总是倍数于第一次添加timer的间隙。
	 */
	/**
	 + (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;
	 
	 Interval:设置时间间隔,以秒为单位,一个>0的浮点类型的值，如果该值<0,系统会默认为0.1
	 
	 target:表示发送的对象，如self
	 
	 selector:方法选择器，在时间间隔内，选择调用一个实例方法
	 
	 userInfo:此参数可以为nil，当定时器失效时，由你指定的对象保留和释放该定时器。
	 
	 repeats:当YES时，定时器会不断循环直至失效或被释放，当NO时，定时器会循环发送一次就失效。
	 */
	
//	timer1 = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerRequest) userInfo:nil repeats:YES];
//	[[NSRunLoop currentRunLoop] addTimer:timer1 forMode:NSRunLoopCommonModes];
	/**
	 	使用block的方法就直接在block里面写延时后要执行的代码
	 + (NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block
	 */
//	timer2 = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//		NSLog(@"定时器开始。。。");
//		count2 ++;
//		labelName.text = [NSString stringWithFormat:@"计时器当前计数:%d",count2];
//	}];
//	[[NSRunLoop currentRunLoop] addTimer:timer2 forMode:NSRunLoopCommonModes];
	
	/**
	 	invocation:需要执行的方法
	 + (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo;
	 */
//	NSMethodSignature *sgn = [self methodSignatureForSelector:@selector(timerRequest)];
//	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature: sgn];
//	[invocation setTarget: self];
//	[invocation setSelector:@selector(timerRequest)];
//	timer3 = [NSTimer timerWithTimeInterval:1.0 invocation:invocation repeats:YES];
//	[[NSRunLoop currentRunLoop] addTimer:timer3 forMode:NSRunLoopCommonModes];
	
	/**
	 scheduledTimerWithTimeInterval 自动加入到RunLoop自动执行
	 + (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;
	 */
//	timer4 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRequest) userInfo:nil repeats:YES];

	/**
	 自动加入到RunLoop自动执行
	 + (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;
	 */
//	timer5 = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//		NSLog(@"定时器开始。。。");
//		count5 ++;
//		labelName.text = [NSString stringWithFormat:@"计时器当前计数:%d",count5];
//	}];
	/**
	 自动加入到RunLoop自动执行
	 + (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo;
	 */
//	NSMethodSignature *sgn = [self methodSignatureForSelector:@selector(timerRequest)];
//	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature: sgn];
//	[invocation setTarget: self];
//	[invocation setSelector:@selector(timerRequest)];
//	timer6 = [NSTimer scheduledTimerWithTimeInterval:1.0 invocation:invocation repeats:YES];
	
	/**
	 启动定时器
	 [NSDate distantPast];
	 停止定时器
	 [NSDate distantFuture];
	 - (instancetype)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)ti target:(id)t selector:(SEL)s userInfo:(nullable id)ui repeats:(BOOL)rep;
	 */
//	timer7 = [[NSTimer alloc]initWithFireDate:[NSDate distantPast] interval:1.0 target:self selector:@selector(timerRequest) userInfo:nil repeats:YES];
//	[[NSRunLoop mainRunLoop]addTimer:timer7 forMode:NSDefaultRunLoopMode];
	
	
	/**
	 - (instancetype)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block;
	 */
//	timer8 = [[NSTimer alloc]initWithFireDate:[NSDate distantPast] interval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//		NSLog(@"定时器开始。。。");
//		count8 ++;
//		labelName.text = [NSString stringWithFormat:@"计时器当前计数:%d",count8];
//	}];
//	[[NSRunLoop mainRunLoop]addTimer:timer8 forMode:NSDefaultRunLoopMode];
	//测试
//	NSTimer *timeTest = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRequest) userInfo:nil repeats:YES];
//	[self performSelector:@selector(simulateBusy:) withObject:@"ojbcet" afterDelay:3];

#pragma mark- 队列
    /*
    atomic 与 nonatomic
    
    问题：什么是原子性？ 说明并比较atomic和nonatomic。 atomic是百分之百安全的吗？
    
    原子性：并发编程中确保其操作具备整体性，系统其它部分无法观察到中间步骤，只能看到操作前后的结果。
    atomic：原子性的，编译器会通过锁定机制确保setter和getter的完整性。
    nonatomic：非原子性的，不保证setter和getter的完整性。
    区别：由于要保证操作完整，atomic速度比较慢，线程相对安全；nonatomic速度比较快，但是线程不安全。atomic也不是绝对的线程安全，当多个线程同时调用set和get时，就会导致获取的值不一样。由于锁定机制开销较大，一般iOS开发中会使用nonatomic，而macOS中使用atomic通常不会有性能瓶颈。
    拓展：要想线程绝对安全，就要使用 @synchronized同步锁。但是由于同步锁有等待操作，会降低代码效率。为了兼顾线程安全和提升效率，可采用GCD并发队列进行优化改进。get使用同步派发，set使用异步栅栏。
     */
	/*
	 
	 全局队列与并发队列的区别：
	 
	 1. 全局队列没有名称，并发队列有名称。
	 2. 全局队列能供所有的应用程序共享。
	 3. 在MRC开发中，全局队列不需要释放，但是并发队列需要释放。
	 二者调度任务的方式相同。
	 注意：并发队列有名称，可以方便系统运行出错时根据队列名称在日志中进行查找。
	 GCD默认已经提供了全局的并发队列，供整个应用使用，不需要手动创建。使用dispatch_get_global_queue函数获取全局的并发队列。
	 
		dispatch_queue_t dispatch_get_global_queue(dispatch_queue_priority_t  priority, unsigned long flags);
		 priority: 队列的优先级设为0即可  flags：此参数暂时无用，用0即可。举例如下：
		dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);  // 获得全局并发队列
		全局并发队列的优先级：
		#define DISPATCH_QUEUE_PRIORITY_HIGH 2 // 高
		#define DISPATCH_QUEUE_PRIORITY_DEFAULT 0 // 默认（中）
		#define DISPATCH_QUEUE_PRIORITY_LOW (-2) // 低
		#define DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN // 后台
		使用dispatch_queue_create函数创建串行队dispatch_queue_t
		dispatch_queue_create(const char *label, // 队列名称
		dispatch_queue_attr_t attr // 队列属性，如果是串行就传NULL
		);具体使用如下：
		dispatch_queue_t queue =dispatch_queue_create(“aaa”,NULL); // 创建串行队列
		dispatch_release(queue); // 非ARC需要释放手动创建的队列。
		主队列是GCD自带的一种特殊的串行队列。
		放到主队列中的任务，都会放到主线程中执行。
		使用dispatch_get_main_queue()获得主队列
		dispatch_queue_t queue = dispatch_get_main_queue();
	 
					   全局并行队列  	手动创建串行队列
		 同步(sync)  | 没有开启新线程 | 没有开启新线程  | 会死锁
			并行		   串行执行任务	 串行执行任务
		 异步(async) | 有开启新线程   | 有开启新线程	  | 没有开启新线程
			并行       并行执行任务	   | 串行执行任务	  | 串行执行任务
	 https://www.jianshu.com/p/44d84e275962
	 */
	/*
	 变量声明出来存放在栈上面
	 而block，默认存放在NSGlobalBlock 全局的block；我们常常把block和C中的函数做对比，此时也类似，NSGlobalBlock类似于函数，存放在代码段
	 
	 当block内部使用了外部的变量时，block的存放位置变成了NSMallockBlock（堆）
	 
	 __block 修饰以后，会类似于桥接，将被修饰的变量被block所持有，此时该变量也转存到堆空间，所以此时Block内部就可以对外部的变量进行修改
	 
	 （还有NSStatckBlock位于栈内存）
	 */
}
//同步锁
- (NSString *)someString {
	@synchronized(self) {
		return _someString;
	}
}
- (void)setSomeString:(NSString *)someString {
	@synchronized(self) {
		_someString = someString;
	}
}
////并发队列
//- (NSString *)someString {
//	__block NSString *localSomeString;
//	dispatch_sync(_queue, ^{
//		localSomeString = _someString;
//	});
//	return localSomeString;
//}
//- (void)setSomeString:(NSString *)someString {
//	dispatch_barrier_async(_queue, ^{
//		_someString = someString;
//	});
//}

/*
 在主队列不允许开新的线程且在主线程中负责调度任务，不会再子线程中调度，再异步执行中会开启新线程，且会在新线程中执行，但不会马上就执行，异步主队列只会把新任务放在主队列，但不会马上执行，等线程有空了才执行
 */
/**
 *  async -- 并发队列（最常用）
 *  会不会创建线程：会，一般同时开多条
 *  任务的执行方式：并发执行
 */
- (void)asyncGlobalQueue
{
	// 获得全局的并发队列
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	
	// 将 任务 添加 全局队列 中去 异步 执行
	dispatch_async(queue, ^{
		NSLog(@"-----下载图片1---%@", [NSThread currentThread]);
	});
	dispatch_async(queue, ^{
		NSLog(@"-----下载图片2---%@", [NSThread currentThread]);
	});
	dispatch_async(queue, ^{
		NSLog(@"-----下载图片3---%@", [NSThread currentThread]);
	});
	dispatch_async(queue, ^{
		NSLog(@"-----下载图片4---%@", [NSThread currentThread]);
	});
	dispatch_async(queue, ^{
		NSLog(@"-----下载图片5---%@", [NSThread currentThread]);
	});
/*通常我们会用for循环遍历，但是GCD给我们提供了快速迭代的方法dispatch_apply，使我们可以同时遍历。比如说遍历0~5这6个数字，for循环的做法是每次取出一个元素，逐个遍历。dispatch_apply可以同时遍历多个数字。
     */
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"GCD快速迭代 //%zd------%@",index, [NSThread currentThread]);
    });
 
}
/**
 *  async -- 串行队列（有时候用）
 *  会不会创建线程：会，一般只开1条线程
 *  任务的执行方式：串行执行（一个任务执行完毕后再执行下一个任务）
 */
- (void)asyncSerialQueue
{
	// 1.创建一个串行队列
	dispatch_queue_t queue = dispatch_queue_create("cn.heima.queue", NULL);
	
	// 2.将任务添加到串行队列中 异步 执行
	dispatch_async(queue, ^{
		NSLog(@"-----下载图片10---%@", [NSThread currentThread]);
	});
	dispatch_async(queue, ^{
		NSLog(@"-----下载图片20---%@", [NSThread currentThread]);
	});
	dispatch_async(queue, ^{
		NSLog(@"-----下载图片30---%@", [NSThread currentThread]);
	});
	dispatch_async(queue, ^{
		NSLog(@"-----下载图片40---%@", [NSThread currentThread]);
	});
	dispatch_async(queue, ^{
		NSLog(@"-----下载图片50---%@", [NSThread currentThread]);
	});
    
}
#pragma mark GCD- 依赖
- (void)relyOperation{
//    NSOperation
}
/**
 调度组异步执行
 */
- (void)asyncGroup{
    
    //创建一个调度组
    dispatch_group_t group = dispatch_group_create();
    
    //进入调度组
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //模拟请求耗时
        sleep(2);
        NSLog(@"A");
        //事件完成 离开调度组
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(2);
        NSLog(@"B");
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(2);
        NSLog(@"C");
        dispatch_group_leave(group);
    });
    /*
     参数1:调度组
     参数2:队列
     参数3:任务
     */
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        sleep(1);
        NSLog(@"下载第1首歌曲");
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        sleep(1);
        NSLog(@"下载第2首歌曲");
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        sleep(1);
        NSLog(@"下载第3首歌曲");
    });
    //所有任务从调度组里面拿出来 调用通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"歌曲下载完成");
    });
    dispatch_group_enter(group);

}

// 核心概念：
// 任务：Block  即将任务保存到一个Block中去。
// 队列： 把任务放到队列里面，队列先进先出的原则，把任务一个个取出（放到对应的线程）执行。
// 串行队列：顺序执行。即一个一个的执行。
// 并行队列：同时执行。同时执行很多个任务。
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self gcdTest3];
}

#pragma mark GCD 演练
/*
 串行队列：顺序，一个一个执行。
 同步：在当前线程执行，不会开辟新线程。
 dispatch：调度，GCD里面的函数都是以dispatch开头的。
 */
-(void)gcdTest1
{
	// 1. 创建一个串行队列
	// 参数：1.队列标签(纯c语言)   2.队列的属性
	dispatch_queue_t  queue =  dispatch_queue_create("itcast", DISPATCH_QUEUE_SERIAL);
	
	// 2. 同步执行任务
	// 一般只要使用“同步” 执行，串行队列对添加的任务，会立马执行。
	dispatch_sync(queue, ^{
		NSLog(@"%@", [NSThread currentThread]);
	});
	NSLog(@"完成！");
}

/**
 串行队列：任务必须要一个一个先后执行。
 异步执行：肯定会开新线程，在新线程执行。
 结果：只会开辟一个线程，而且所有任务都在这个新的线程里面执行。
 */
-(void)gcdTest2
{
	// 1. 串行队列
	dispatch_queue_t queue = dispatch_queue_create("itcast", DISPATCH_QUEUE_SERIAL);
	// 按住command进入， #define DISPATCH_QUEUE_SERIAL NULL
	//  DISPATCH_QUEUE_SERIAL 等于直接写NULL， 且开发的时候都使用NULL
	// 2. 异步执行
	for (int i=0 ; i<10 ; i++) {
		dispatch_async(queue, ^{
			NSLog(@"%@  %d", [NSThread currentThread], i);
		});
	}
}

/**
 并发队列：可以同时执行多个任务，
 异步执行：肯定会开新线程，在新线程执行。
 结果：会开很多个线程，同时执行。
 */
-(void)gcdTest3
{
	// 1. 并发队列
	dispatch_queue_t queue = dispatch_queue_create("cz", DISPATCH_QUEUE_CONCURRENT);
	
	// 异步执行任务
	for (int i=0 ; i<5 ; i++) {
		dispatch_async(queue, ^{
            NSLog(@"A开始 %@",[NSThread currentThread]);
            //模拟请求耗时
            sleep(1);
            NSLog(@"-%d-完成:%@",i, [NSThread currentThread]);
		});
	}
}

/**
 并发队列：可以同时执行多个任务
 同步执行：不会开辟新线程，是在当前线程执行。
 结果：不开新线程，顺序执行。
 */
-(void)gcdTest4
{
	// 并发队列
	dispatch_queue_t queue = dispatch_queue_create("itcast", DISPATCH_QUEUE_CONCURRENT);
	for (int i=0 ; i< 10; i++) {
		dispatch_sync(queue, ^{
			NSLog(@"%@  %d", [NSThread currentThread], i);
		});
	}
	
}


/**
 解析如下：
 串行队列：即要求按顺序挨个执行队列内的任务，即一次只执行一个。
 并行队列：即要求同时执行队列内的任务。即一次要执行一个或多个队列内的任务。
 同步执行：即只在当前线程执行队列内的任务，不会另外开辟新的线程。
 异步执行：即开辟一个或多个新的线程来执行队列内的任务，让新的线程来执行。
 
 串行队列同步执行：即由当前线程按顺序执行队列内的任务，不会开辟新的线程。
 串行队列异步执行：即另外开辟一个新的线程（仅仅一个），并由这个新的线程来顺序执行队列内的任务，因为异步就是另外开辟线程，又因为串行队列一次只要求执行一个，所以只开辟一个新的线程来顺序执行即可。
 并行队列同步执行：即由当前线程同时执行队列内的任务。由于当前单线程是无法实现同时执行多个任务即无法一次执行多个任务，所以只会由当前线程顺序执行队列内的任务。
 并行队列异步执行：另外开辟多个线程来同时执行队列内的任务。因为队列内的任务要求同时执行多个，又可以开辟新的线程。所以会开辟多个新的线程来同时执行队列内的任务。但执行任务的顺序不确定，且开辟新线程的个数不确定。
 需要注意的是：同步只在当前线程执行。异步只在别的线程执行。
 */

/*****************************************************************************************/
#pragma mark - 主队列
/**
 主队列：专门负责在主线程上调度任务，不会在子线程调度任务，在主队列不允许开新线程。
 主队列特点：不允许开新线程。
 异步执行：会开新线程，在新线程执行。
 异步特点：异步任务不需要马上执行，只是把任务放到主队列，等线程有空再去执行，也就是等gcdTest5执行完毕，主线程就有空了。
 结果：不开线程，只能在主线程上，顺序执行。
 */
-(void) gcdTest5
{
	// 1. 获得主队列—> 程序启动以后至少有一个主线程—> 一开始就会创建主队列。
	dispatch_queue_t queue = dispatch_get_main_queue();
	
	NSLog(@"开始------------------------");
	// 2. 异步执行任务
	for(int i=0; i<10; i++){
		NSLog(@"调度前");
		// 异步：把任务放到主队列里，但是不需要马上执行。
		dispatch_async(queue, ^{  // 也就是说，把{}内的任务先放到队列里面，等主线程别的任务完成之后才执行。
			NSLog(@"%@  %d", [NSThread currentThread], i);
		});
		NSLog(@"睡会");
		[NSThread sleepForTimeInterval:1.0];
	}
	NSLog(@"完成------------------------");
	/**
	 之所以将放到主队列内的任务最后执行，是因为当前队列所在的gcdTest5方法正由主线程进行执行，只有将先调度的gcdTest5执行完毕，才会执行加在队列内的任务。注意在执行方法过程中只是先把任务加到队列中。
	 */
}

/**
 主队列：专门负责在主线程上调度任务，不会在子线程调度任务，在主队列不允许开新线程。
 同步执行：要马上执行。
 结果：死锁。
 */
-(void)gcdTest6
{
	
	// 1. 获得主队列—> 程序启动以后至少有一个主线程—> 一开始就会创建主队列。
	dispatch_queue_t queue = dispatch_get_main_queue();
	
	NSLog(@"开始------------------------");
	// 2. 同步执行任务
	for(int i=0; i<10; i++){
		NSLog(@"调度前");
		// 同步：把任务放到主队列里，但是需要马上执行。
		dispatch_sync(queue, ^{
			NSLog(@"%@  %d", [NSThread currentThread], i);
		});
		NSLog(@"睡会");
		[NSThread sleepForTimeInterval:1.0];
	}
	NSLog(@"完成------------------------");
	/**
	 同步任务需要马上执行，但是主线程上面正在执行gcdTest6。所以需要等gcdTest6执行完毕，但是gcdTest6也在等主队列内的任务执行完毕。相互等待造成主线程阻塞。产生死锁。
	 */
}

/******************************************************************************************/

#pragma mark GCD- 同步任务的所用
-(void)gcdTest7
{
	// 并发队列
	dispatch_queue_t queue = dispatch_queue_create("cz", DISPATCH_QUEUE_CONCURRENT);
	/**
	 例子：有一个小说下载网站
	 - 必须登录，才能下载小说
	 
	 有三个任务：
	 1. 下载任务
	 2. 下载小说A
	 3. 下载小说B
	 */
	// 添加任务
	// 同步任务：需要马上执行，不会开辟新线程。
	dispatch_sync(queue, ^{
		NSLog(@"用户登录 %@", [NSThread currentThread]);
	});
	dispatch_async(queue, ^{
		NSLog(@"下载小说A%@", [NSThread currentThread]);
	});
	dispatch_async(queue, ^{
		NSLog(@"下载小说B %@", [NSThread currentThread]);
	});
}

/***************************************************************************************/
#pragma mark- GCD全局队列
/**
 全局队列与并发队列的区别：
 1. 全局队列没有名称，并发队列有名称。
 2. 全局队列，是供所有的应用程序共享。
 3. 在MRC开发中，全局队列不需要释放，但并发队列需要释放。
 对比：调度任务的方式相同。
 */
-(void)gcdTest8
{
	// 获得全局队列
	/**  一般不修改优先级
	 第一个参数，一般写0 （可以适配IOS7或IOS8）
	 第二个参数，保留参数，0
	 IOS7
	 DISPATCH_QUEUE_PRIORITY_HIGH 2   高优先级
	 DISPATCH_QUEUE_PRIORITY_DEFAULT 0  默认优先级
	 DISPATCH_QUEUE_PRIORITY_LOW (-2)   低优先级
	 DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN 后台优先级（最低）
	 
	 IOS8   左边与IOS7对照
	 DISPATCH_QUEUE_PRIORITY_HIGH:         QOS_CLASS_USER_INITIATED
	 DISPATCH_QUEUE_PRIORITY_DEFAULT:      QOS_CLASS_DEFAULT
	 DISPATCH_QUEUE_PRIORITY_LOW:          QOS_CLASS_UTILITY
	 DISPATCH_QUEUE_PRIORITY_BACKGROUND:   QOS_CLASS_BACKGROUND
	 
	 为了对IOS7或8都使用，所以写0即可
	 */
	dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
	// 异步执行任务
	for (int i=0 ; i<10 ; i++) {
		dispatch_async(queue, ^{
			NSLog(@"%@  %d", [NSThread currentThread], i);
		});
	}
}
#pragma mark- GCD信号量
- (void)asyncSemaphore{
    
    NSArray*moviesArray = [NSArray arrayWithObjects:
                           @"第1集", @"第2集",@"第3集",@"第4集",@"第5集",
                           @"第6集",@"第7集",@"第8集",@"第9集",@"第10集",
                           @"第11集", @"第12集",@"第13集",@"第14集",@"第15集",
                           @"第16集",@"第17集",@"第18集",@"第19集",@"第20集",
                           nil];
    
    dispatch_queue_t queueMovies = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphoreMovies = dispatch_semaphore_create(5);//创建信号量
    
    for (int i = 0 ; i<moviesArray.count; i++) {
        dispatch_semaphore_wait(semaphoreMovies, DISPATCH_TIME_FOREVER);//等待信号量 有闲置的信号量就让新的任务进来，如果没有就按照顺序等待闲置的信号量 可以设置等待时间
        dispatch_async(queueMovies, ^{
            //模拟下载任务
            NSLog(@"%@开始下载",moviesArray[i]);
            sleep(10+i*2);//假设下载一集需要10+i*2秒
            NSLog(@"%@下载完成",moviesArray[i]);
            dispatch_semaphore_signal(semaphoreMovies);//发送信号量 发送完成进度
        });
    }
    dispatch_queue_t queueshili = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphoreshili = dispatch_semaphore_create(5);
    
    for (int i = 0 ; i<20; i++) {
        dispatch_semaphore_wait(semaphoreshili, DISPATCH_TIME_FOREVER);
        dispatch_async(queueshili, ^{
            NSLog(@"任务%d开始",i);
            sleep(i);
            NSLog(@"任务%d结束",i);
            dispatch_semaphore_signal(semaphoreshili);
        });
    }
}
#pragma mark- asyncBarrier栅栏函数
/**
 栅栏函数
 <一>什么是dispatch_barrier_async函数
 毫无疑问,dispatch_barrier_async函数的作用与barrier的意思相同,在进程管理中起到一个栅栏的作用,它等待所有位于barrier函数之前的操作执行完毕后执行,并且在barrier函数执行之后,barrier函数之后的操作才会得到执行,该函数需要同dispatch_queue_create函数生成的concurrent Dispatch Queue队列一起使用
 
 <二>dispatch_barrier_async函数的作用
 
 1.实现高效率的数据库访问和文件访问
 
 2.避免数据竞争
 */
- (void)asyncBarrier{
    //同dispatch_queue_create函数生成的concurrent Dispatch Queue队列一起使用
    dispatch_queue_t queuezhalan = dispatch_queue_create("zhalanqueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queuezhalan, ^{
        NSLog(@"栅栏函数----1-----%@", [NSThread currentThread]);
    });
    
    dispatch_async(queuezhalan, ^{
        NSLog(@"栅栏函数----2-----%@", [NSThread currentThread]);
    });
    
    dispatch_async(queuezhalan, ^{
        NSLog(@"栅栏函数----3-----%@", [NSThread currentThread]);
    });
    
    dispatch_async(queuezhalan, ^{
        NSLog(@"栅栏函数----4-----%@", [NSThread currentThread]);
    });
    
    dispatch_barrier_async(queuezhalan, ^{
        NSLog(@"栅栏函数----barrier-----%@", [NSThread currentThread]);
    });
    
    dispatch_async(queuezhalan, ^{
        NSLog(@"栅栏函数----5-----%@", [NSThread currentThread]);
    });
    dispatch_async(queuezhalan, ^{
        NSLog(@"栅栏函数----6-----%@", [NSThread currentThread]);
    });
}

// 模拟当前线程正好繁忙的情况
- (void)simulateBusy:(NSString *)str{
	NSLog(@"str %@",str);

	NSLog(@"定时器开始创建");
	NSTimer *timer1 = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerRequest) userInfo:nil repeats:YES];
	//没有把定时器添加到RunLoop中
	/**
	 我们前面自己动手添加runloop的时候，可以看到有一个参数runloopMode，这个参数是干嘛的呢？
	 前面提到了要想timer生效，我们就得把它添加到指定runloop的指定mode中去，通常是主线程的defalut mode。但有时我们这样做了，却仍然发现timer还是没有触发事件。这是为什么呢？
	 这是因为timer添加的时候，我们需要指定一个mode，因为同一线程的runloop在运行的时候，任意时刻只能处于一种mode。所以只能当程序处于这种mode的时候，timer才能得到触发事件的机会。
	 举个不恰当的例子，我们说兄弟几个分别代表runloop的mode，timer代表他们自己的才水桶，然后一群人去排队打水，只有一个水龙头，那么同一时刻，肯定只能有一个人处于接水的状态。也就是说你虽然给了老二一个桶，但是还没轮到它，那么你就得等，只有轮到他的时候你的水桶才能碰上用场。
	 */
	
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//		//创建定时器
	//	[[NSRunLoop currentRunLoop] addTimer:timer3 forMode:NSRunLoopCommonModes];

//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];
//
//	});
//	dispatch_async(dispatch_get_main_queue(), ^{
//		//创建定时器
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];
//	});
	timer1 = timer1;
	NSLog(@"定时器创建完成");
	
	
//	NSLog(@"start simulate busy!");
//	NSUInteger caculateCount = 0x0FFFFFFF;
//	CGFloat uselessValue = 0;
//	for (NSUInteger i = 0; i < caculateCount; ++i) {
//		uselessValue = i / 0.3333;
//	}
//	NSLog(@"finish simulate busy!");
}
- (void)timerRequest{
	count1 ++;
	labelName.text = [NSString stringWithFormat:@"计时器当前计数:%d",count1];
	NSLog(@"定时器开始。。。");
}
#pragma mark- BlockOperation
- (void)gcdTest{
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"task0---%@", [NSThread currentThread]);
    }];
    
    [op addExecutionBlock:^{
        NSLog(@"task1----%@", [NSThread currentThread]);
    }];
    
    [op addExecutionBlock:^{
        NSLog(@"task2----%@", [NSThread currentThread]);
    }];
    
    // 开始必须在添加其他操作之后
    [op start];
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
    anInvocation.target = [[DataModel alloc] init];
    //调用方法
    [anInvocation invoke];
}
// add by yangyanhui base64加密
- (NSString *)base64Encode:(NSData *)data
{
    static char base64EncodingTable[64] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
    };
    int length = [data length];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = (const unsigned char *)[data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
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
