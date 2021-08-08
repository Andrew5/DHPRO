//
//  DHLearnGCDViewController.m
//  CollegePro
//
//  Created by jabraknight on 2021/7/31.
//  Copyright © 2021 jabrknight. All rights reserved.
//

#import "DHLearnGCDViewController.h"
#include <pthread.h>

@interface DHLearnGCDViewController ()
{
    BOOL _gcdIsStope;
    NSString *_someString;
}
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation DHLearnGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //GCD停止正在执行的任务
    _gcdIsStope = NO;
    // Do any additional setup after loading the view.
}
- (void)cancelGCD{
    //GCD解除
    __weak typeof(self) ws = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), 0.1*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"timer执行了");
            //结束计时
            dispatch_source_cancel(ws.timer);
        });
    });
    //开启计时器
    dispatch_resume(_timer);
}
///TODO:多请求顺序执行 结束后统一操作
//例：如一个页面多个网络请求后刷新UI
- (void)testDataQ {
    //模拟并发后统一操作数据
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求1
        NSLog(@"RequestDataQ_1");
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        //模拟网络请求
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSLog(@"请求开始");
            sleep(2);
            NSLog(@"请求完成");
            //请求完成信号量+1，信号量为1，通过
            dispatch_semaphore_signal(sema);
        });
        NSLog(@"我是测试");
        //信号量为0，进行等待
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求2
        NSLog(@"RequestDataQ_2");
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求3
        NSLog(@"RequestDataQ_3");
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //界面刷新
        NSLog(@"任务均完成，刷新界面");
    });
}
//例：如第二个请求需要第一个请求的数据来操作
- (void)testDataR {
    // 1.任务一：获取用户信息
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"RequestDataR_1");
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSLog(@"请求1开始");
            sleep(3);
            NSLog(@"请求1完成");
            //请求完成信号量+1，信号量为1，通过
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }];
    // 2.任务二：请求相关数据
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"RequestDataR_2");
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSLog(@"请求2开始");
            sleep(2);
            NSLog(@"请求2完成");
            //请求完成信号量+1，信号量为1，通过
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }];
    // 3.设置依赖
    [operation2 addDependency:operation1];// 任务二依赖任务一
    // 4.创建队列并加入任务
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation2, operation1] waitUntilFinished:NO];
}
///NSOperation需要在NSOperationQueue中使用，通过queue可以实现先进先出的队列任务，可以添加或取消任务，NSOperation有2个重要的子类，分别是：NSInvocationOperation，NSBlockOperation，分别表示调用一个方法或调用一个block的任务。 NSOperation是比GCD更高层次的api，相同的线程操作如果能用NSOperation操作就尽量用，不能实现的线程操作才使用GCD.相比GCD，NSOperation还有个好处，就是任务可以被取消，而GCD不可以。
- (void)OperationFunction{
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    //设置队列最大同时进行的任务数量，1为串行队列
    [queue setMaxConcurrentOperationCount:1];
    //添加一个block任务
    [queue addOperationWithBlock:^{
        sleep(2);
        NSLog(@"block task 1");
    }];
    [queue addOperationWithBlock:^{
        sleep(2);
        NSLog(@"block task 2");
    }];
    //显示添加一个block任务
    NSBlockOperation *block1 = [NSBlockOperation blockOperationWithBlock:^{
        sleep(2);
        NSLog(@"block task 3");
    }];
    //设置任务优先级
    //说明：优先级高的任务，调用的几率会更大,但不表示一定先调用
    [block1 setQueuePriority:NSOperationQueuePriorityHigh];
    [queue addOperation:block1];
    NSBlockOperation *block2 = [NSBlockOperation blockOperationWithBlock:^{
        sleep(2);
        NSLog(@"block task 4，任务3依赖4");
    }];
    [queue addOperation:block2];
    //任务3依赖4
    [block1 addDependency:block2];
    //设置任务完成的回调
    [block2 setCompletionBlock:^{
        NSLog(@"block task 4 comlpete");
    }];
    //设置block1完成后才会继续往下走
    [block1 waitUntilFinished];
    NSLog(@"block task 3 is waitUntilFinished!");
    //初始化一个子任务
    NSInvocationOperation *oper1 = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(function1) object:nil];
    [queue addOperation:oper1];
    ///queue也有对应的方法，叫做waitUntilAllOperationsAreFinished
    [queue waitUntilAllOperationsAreFinished];
    NSLog(@"queue comlpeted");
    //    取消全部操作
    //    [queue cancelAllOperations];
    //    暂停操作/恢复操作/是否暂定状态
    //    [queue setSuspended:YES];[queue setSuspended:NO];[queue isSuspended];
    //操作优先级
    //      [queue waitUntilAllOperationsAreFinished];
}
- (void)function1{
}
- (void)operationA{
    //blockOperationWithBlock在不同的线程中并发执行的
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"task0---%@", [NSThread currentThread]);
    }];
    //为 NSBlockOperation 添加额外的操作
    [op addExecutionBlock:^{
        NSLog(@"task1----%@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        NSLog(@"task2----%@", [NSThread currentThread]);
    }];
    // 开始必须在添加其他操作之后
    [op start];
}
//enter leave
- (void)testDataSS {
    [self testAAA];
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    dispatch_group_enter(group);

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"Request__1");
        sleep(3);
        NSLog(@"Request1完成");
        dispatch_group_leave(group);
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"Request__2");
        sleep(1);
        NSLog(@"Request2完成");
        dispatch_group_leave(group);
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"Request__3");
        sleep(2);
        NSLog(@"Request3完成");
        dispatch_group_leave(group);
    });
    dispatch_group_notify(group,  dispatch_get_main_queue(), ^{
        NSLog(@"全部完成.%@",[NSThread currentThread]);
        CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
        NSLog(@"正常使用enter和leave耗时: %f ms", endTime * 1000.0);
    });
}
///TODO:dispatch_queue_t
- (void)testAAA{
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, globalQueue, ^{
        NSLog(@"请求11");
        sleep(3);
        NSLog(@"请求11完成");
    });
    dispatch_group_async(group, globalQueue, ^{
        NSLog(@"请求12");
        sleep(1);
        NSLog(@"请求12完成");
    });
    dispatch_group_async(group, globalQueue, ^{
        NSLog(@"请求13");
        sleep(2);
        NSLog(@"请求13完成");
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"请求完成");
        CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
        NSLog(@"不使用enter和leave耗时: %f ms", endTime * 1000.0);
    });
    
}

/*
 *使用GCD 的多线程
 *优点：有很多串行并线队列多线程，block实现线程方法，高级，好用，方法多。
 *缺点：在很多不需要高级控制线程的场景可以不用使用GCD
 
 同步、非阻塞执行
 异步非阻塞执行
 一次性执行
 延迟执行
 线程队列串行执行
 线程队列控制（屏障，同步等待，线程暂停和恢复，线程信号量控制等）
 
 在主队列不允许开新的线程且在主线程中负责调度任务，不会再子线程中调度，再异步执行中会开启新线程，且会在新线程中执行，但不会马上就执行，异步主队列只会把新任务放在主队列，但不会马上执行，等线程有空了才执行
 
 atomic 与 nonatomic
 
 问题：什么是原子性？ 说明并比较atomic和nonatomic。 atomic是百分之百安全的吗？
 
 原子性：并发编程中确保其操作具备整体性，系统其它部分无法观察到中间步骤，只能看到操作前后的结果。
 atomic：原子性的，编译器会通过锁定机制确保setter和getter的完整性。
 nonatomic：非原子性的，不保证setter和getter的完整性。
 区别：由于要保证操作完整，atomic速度比较慢，线程相对安全；nonatomic速度比较快，但是线程不安全。atomic也不是绝对的线程安全，当多个线程同时调用set和get时，就会导致获取的值不一样。由于锁定机制开销较大，一般iOS开发中会使用nonatomic，而macOS中使用atomic通常不会有性能瓶颈。
 拓展：要想线程绝对安全，就要使用 @synchronized同步锁。但是由于同步锁有等待操作，会降低代码效率。为了兼顾线程安全和提升效率，可采用GCD并发队列进行优化改进。get使用同步派发，set使用异步栅栏。
 
 async -- 并发队列（最常用）
 会不会创建线程：会，一般同时开多条
 任务的执行方式：并发执行
 
 */
-(void)GCDFunction{

    NSLog(@"GCDFunction start");

    //获取一个队列
    dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    //dispatch_async：异步方式执行方法（最常用）
    //    dispatch_async(defaultQueue, ^{
    //        [self function1];
    //    });

    //dispatch_sync：同步方式使用场景，比较少用，一般与异步方式进行调用
    //    dispatch_async(defaultQueue, ^{
    //       NSMutableArray *array = [self GCD_sync_Function];
    //       dispatch_async(dispatch_get_main_queue(), ^{
    //           //利用获取的arry在主线程中更新UI
    //
    //       });
    //    });

    //dispatch_once：一次性执行，常常用户单例模式.这种单例模式更安全
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    //        // code to be executed once
    //        NSLog(@"dispatch_once");
    //    });

    //dispatch_after 延迟异步执行
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC);
    //    dispatch_after(popTime, defaultQueue, ^{
    //        NSLog(@"dispatch_after");
    //    });

    //dispatch_group_async 组线程可以实现线程之间的串联和并联操作
    //    dispatch_group_t group = dispatch_group_create();
    //    NSDate *now = [NSDate date];
    //    //做第一件事 2秒
    //    dispatch_group_async(group, defaultQueue, ^{
    //        [NSThread sleepForTimeInterval:2];
    //         NSLog(@"work 1 done");
    //    });
    //    //做第二件事 5秒
    //    dispatch_group_async(group, defaultQueue, ^{
    //        [NSThread sleepForTimeInterval:5];
    //        NSLog(@"work 2 done");
    //    });
    //
    //    //两件事都完成后会进入方法进行通知
    //    dispatch_group_notify(group, defaultQueue, ^{
    //        NSLog(@"dispatch_group_notify");
    //        NSLog(@"%f",[[NSDate date]timeIntervalSinceDate:now]);//总共用时5秒，因为2个线程同时进行
    //    });

    //dispatch_barrier_async :作用是在并行队列中，等待前面的队列执行完成后在继续往下执行
    //    dispatch_queue_t concurrentQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    //    dispatch_async(concurrentQueue, ^{
    //        [NSThread sleepForTimeInterval:2];
    //        NSLog(@"work 1 done");
    //    });
    //    dispatch_async(concurrentQueue, ^{
    //        [NSThread sleepForTimeInterval:2];
    //        NSLog(@"work 2 done");
    //    });
    //    //等待前面的线程完成后执行
    //    dispatch_barrier_async(concurrentQueue, ^{
    //         NSLog(@"dispatch_barrier_async");
    //    });
    //
    //    dispatch_async(concurrentQueue, ^{
    //        [NSThread sleepForTimeInterval:3];
    //        NSLog(@"work 3 done");
    //    });

    //dispatch_semaphore 信号量的使用，串行异步操作
    //    dispatch_semaphore_create　　　创建一个semaphore
    //　　 dispatch_semaphore_signal　　　发送一个信号
    //　　 dispatch_semaphore_wait　　　　等待信号

    /*应用场景1：马路有2股道，3辆车通过 ，每辆车通过需要2秒
     *条件分解:
        马路有2股道 <=>  dispatch_semaphore_create(2) //创建两个信号
        三楼车通过 <=> dispatch_async(defaultQueue, ^{ } 执行三次
        车通过需要2秒 <=>  [NSThread sleepForTimeInterval:2];//线程暂停两秒
     */

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);

        dispatch_async(defaultQueue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            [NSThread sleepForTimeInterval:2];
            NSLog(@"carA pass the road");
            dispatch_semaphore_signal(semaphore);
        });
        dispatch_async(defaultQueue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            [NSThread sleepForTimeInterval:2];
            NSLog(@"carB pass the road");
            dispatch_semaphore_signal(semaphore);
        });
        dispatch_async(defaultQueue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            [NSThread sleepForTimeInterval:2];
            NSLog(@"carC pass the road");
            dispatch_semaphore_signal(semaphore);
        });

    //应用场景2 ：原子性保护，保证同时只有一个线程进入操作
    //    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    //    for(int i=0 ;i< 10000 ;i++){
    //        dispatch_async(defaultQueue, ^{
    //            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    //            NSLog(@"i:%d",i);
    //            dispatch_semaphore_signal(semaphore);
    //        });
    //    }

    NSLog(@"GCDFunction end");
}
/**
    只执行一次  (多用于单例模式)

    dispatch_once(dispatch_once_t *predicate, dispatch_block_t block);

    dispatch_once_t *predicate：一个全局的变量      dispatch_block_t block：block函数块

    多次执行

    dispatch_apply(size_t iterations, dispatch_queue_t queue,void (^block)(size_t));

    size_t iterations：执行次数      dispatch_queue_t queue：队列      void (^block)(size_t)：block函数块
 
    //定义block
    typedef void (^BLOCK)(void);
 
    //将执行代码封装到block中
    BLOCK myBlock = ^(){
         static int count = 0;
         NSLog(@"count=%d",count++);
    };
    //只会执行一次，GCD once
    static dispatch_once_t predicate;
    dispatch_once(&predicate, myBlock);
    dispatch_once(&predicate, myBlock);
 
    //GCD多次执行任务
    dispatch_apply(5, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), myBlock);
    //运行结果如下：执行了5次,有5个输出
 
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
//串行队列+同步执行//同步执行。不开启新的线程
- (void) asyncSerialQueueSync {
    NSLog(@"test start");
    
    dispatch_queue_t serialQueue = dispatch_queue_create("com.ks.serialQueue", NULL);
    
    dispatch_sync(serialQueue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"block1 %@", [NSThread currentThread]);
        }
    });
    
    dispatch_sync(serialQueue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"block2 %@", [NSThread currentThread]);
        }
    });
    
    dispatch_sync(serialQueue, ^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"block3 %@", [NSThread currentThread]);
        }
    });
    
    NSLog(@"test over");
}
static  BOOL y;
- (void)semaphore{

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
//            [self test];
        }
        NSLog(@"B完成");
        //事件完成 离开调度组
        dispatch_group_leave(group);
    });
    
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
}
#pragma mark GCD 演练
/*
 串行队列：顺序，因为是串行队列,一个一个执行。
 同步执行：在当前线程执行，不会开辟新线程。
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
 结果：只会开辟一个线程，而且所有任务都在这个新的线程里面执行，当所有任务添加到队列之后再执行
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
 并发队列：可以同时执行多个任务；因为并发队列，异步执行时体现其并发性，任务之间交替着同时执行。
 异步执行：肯定会开新线程，在新线程执行。
 结果：会开很多个线程，同时执行；当所有任务添加到队列之后再执行。
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
 同步执行：不会开辟新线程，是在当前线程执行；因为是同步执行，没有体现出并发性，任务还是一个接一个执行；任务一加入队列就立马执行
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
     设置一个停止的标记，当我们需要停止已经执行的任务时，可以根据标记直接return
     
     全局队列与并发队列的区别：
     https://www.jianshu.com/p/44d84e275962
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
     
                       全局并行队列      手动创建串行队列
         同步(sync)  | 没有开启新线程 | 没有开启新线程  | 会死锁
            并行           串行执行任务     串行执行任务
         异步(async) | 有开启新线程   | 有开启新线程      | 没有开启新线程
            并行       并行执行任务       | 串行执行任务      | 串行执行任务
     */
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 异步执行任务
    for (int i=0 ; i<10 ; i++) {
        dispatch_async(queue, ^{
            if (self->_gcdIsStope) {
                return ;
            }
            sleep(1);
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
///TODO:设置 MaxConcurrentOperationCount（最大并发操作数）
/// NSOperationQueue
- (void)setMaxConcurrentOperationCount {

    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    // 2.设置最大并发操作数
    queue.maxConcurrentOperationCount = 1; // 串行队列
// queue.maxConcurrentOperationCount = 2; // 并发队列
// queue.maxConcurrentOperationCount = 8; // 并发队列

    // 3.添加操作
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
}
/**
 * 使用 addOperation: 将操作加入到操作队列中
 * 使用 NSOperation 子类创建操作，并使用 addOperation: 将操作加入到操作队列后能够开启新线程，进行并发执行
 */
- (void)operationQueue{
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 2.创建操作
    // 使用 NSInvocationOperation 创建操作1
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(other) object:nil];
    
    // 使用 NSInvocationOperation 创建操作2
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(other) object:nil];
    
    // 使用 NSBlockOperation 创建操作3
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op3 addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    // 3.使用 addOperation: 添加所有操作到队列中
    [queue addOperation:op1]; // [op1 start]
    [queue addOperation:op2]; // [op2 start]
    [queue addOperation:op3]; // [op3 start]
}

////并发队列
//- (NSString *)someString {
//    __block NSString *localSomeString;
//    dispatch_sync(_queue, ^{
//        localSomeString = _someString;
//    });
//    return localSomeString;
//}
//- (void)setSomeString:(NSString *)someString {
//    dispatch_barrier_async(_queue, ^{
//        _someString = someString;
//    });
//}

///TODO:线程间通信  可以看到：通过线程间的通信，先在其他线程中执行操作，等操作执行完了之后再回到主线程执行主线程的相应操作。

- (void)communication {
    
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    // 2.添加操作
    [queue addOperationWithBlock:^{
        // 异步进行耗时操作
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
        
        // 回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 进行一些 UI 刷新等操作
            for (int i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
                NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
            }
        }];
    }];
}
//定义block类型
typedef void(^KYSBlock)(void);
///TODO:线程锁
- (void)pthreadLock{
    CFTimeInterval timeBefore;
    CFTimeInterval timeCurrent;
    NSUInteger i;
    NSUInteger count = 1000*10000;//执行一千万次
    //@synchronized
    id obj = [[NSObject alloc]init];;
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++){
        @synchronized(obj){
        }
    }
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("@synchronized used : %f\n", timeCurrent-timeBefore);
    //NSLock
    NSLock *lock = [[NSLock alloc]init];
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++){
        [lock lock];
        [lock unlock];
    }
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("NSLock used : %f\n", timeCurrent-timeBefore);
    //NSCondition
    NSCondition *condition = [[NSCondition alloc]init];
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++){
        [condition lock];
        [condition unlock];
    }
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("NSCondition used : %f\n", timeCurrent-timeBefore);
    //NSConditionLock
    NSConditionLock *conditionLock = [[NSConditionLock alloc]init];
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++){
        [conditionLock lock];
        [conditionLock unlock];
    }
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("NSConditionLock used : %f\n", timeCurrent-timeBefore);
    //NSRecursiveLock
    NSRecursiveLock *recursiveLock = [[NSRecursiveLock alloc]init];
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++){
        [recursiveLock lock];
        [recursiveLock unlock];
    }
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("NSRecursiveLock1 used : %f\n", timeCurrent-timeBefore);
    
//    timeBefore = CFAbsoluteTimeGetCurrent();
//    KYS_GLOBAL_QUEUE(^{
//        static void (^RecursiveBlock)(int);
//        RecursiveBlock = ^(int value) {
//            [recursiveLock lock];
//            if (value > 0) {
//                NSLog(@"加锁层数 %d", value);
//                sleep(1);
//                RecursiveBlock(--value);
//            }
//            [recursiveLock unlock];
//        };
//        RecursiveBlock(3);
//    });
//    timeCurrent = CFAbsoluteTimeGetCurrent();
//    printf("NSRecursiveLock2 used : %f\n", timeCurrent-timeBefore);

    //pthread_mutex
    pthread_mutex_t mutex =PTHREAD_MUTEX_INITIALIZER;
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++){
        pthread_mutex_lock(&mutex);
        pthread_mutex_unlock(&mutex);
    }
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("pthread_mutex used : %f\n", timeCurrent-timeBefore);
    //dispatch_semaphore
    dispatch_semaphore_t semaphore =dispatch_semaphore_create(1);
    timeBefore = CFAbsoluteTimeGetCurrent();
    for(i=0; i<count; i++){
        dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);
        dispatch_semaphore_signal(semaphore);
    }
    timeCurrent = CFAbsoluteTimeGetCurrent();
    printf("dispatch_semaphore used : %f\n", timeCurrent-timeBefore);
    //参数可以理解为信号的总量，传入的值必须大于或等于0，否则，返回NULL
    //dispatch_semaphore_signal +1
    //dispatch_semaphore_wait等待信号，当<=0时会进入等待状态，否则，-1
//    __block dispatch_semaphore_t semaphoree = dispatch_semaphore_create(1);
//    KYS_GLOBAL_QUEUE(^{
//        dispatch_semaphore_wait(semaphoree, DISPATCH_TIME_FOREVER);
//        NSLog(@"这里简单写一下用法，可自行实现生产者、消费者");
//        sleep(1);
//        dispatch_semaphore_signal(semaphoree);
//    });
    //OSSpinLockLock
//    OSSpinLock spinlock = OS_SPINLOCK_INIT;
//    timeBefore = CFAbsoluteTimeGetCurrent();
//    for(i=0; i<count; i++){
//        OSSpinLockLock(&spinlock);
//        OSSpinLockUnlock(&spinlock);
//    }
//    timeCurrent = CFAbsoluteTimeGetCurrent();
//    printf("停用OSSpinLock used : %f\n", timeCurrent-timeBefore);
    
    /**
     * @synchronized used : 1.090570
     * NSLock used : 0.194595
     * NSCondition used : 0.188667
     * NSConditionLock used : 0.627998
     * NSRecursiveLock used : 0.423586
     * pthread_mutex used : 0.191954
     * dispatch_semaphore used : 0.139354
     * OSSpinLock used : 0.077738
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
//执行一次，之后用到，不在定义
#define KYS_GLOBAL_QUEUE_ONCE(block) \
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ \
    block();\
})
- (void)lock{
    NSConditionLock *conditionLock = [[NSConditionLock alloc] initWithCondition:0];
    
    KYS_GLOBAL_QUEUE_ONCE(^{
        for (int i=0;i<3;i++){
            [conditionLock lock];
            NSLog(@"线程 0:%d",i);
            sleep(1);
            [conditionLock unlockWithCondition:i];
        }
    });
    
    sleep(1);
    
    KYS_GLOBAL_QUEUE_ONCE(^{
        [conditionLock lock];
        NSLog(@"线程 1");
        [conditionLock unlock];
    });
    
    KYS_GLOBAL_QUEUE_ONCE(^{
        [conditionLock lockWhenCondition:2];
        NSLog(@"线程 2");
        [conditionLock unlockWithCondition:0];
    });
    
    KYS_GLOBAL_QUEUE_ONCE(^{
        [conditionLock lockWhenCondition:1];
        NSLog(@"线程 3");
        [conditionLock unlockWithCondition:2];
    });
    
    KYS_GLOBAL_QUEUE_ONCE(^{
        [conditionLock lockWhenCondition:0];
        NSLog(@"线程 4");
        [conditionLock unlockWithCondition:1];
    });
}
///倒计时
- (void)countDown
{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                self.timeCount.enabled = YES;
//                [self.timeCount setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }else{
//            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
                    dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                self.timeCount.enabled = NO;
//                [self.timeCount setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
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
