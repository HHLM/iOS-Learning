//
//  HHGCDViewController.m
//  HH-Thread
//
//  Created by Mac on 2018/4/14.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "HHGCDViewController.h"

@interface HHGCDViewController ()

@end

@implementation HHGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *array = @[@"1",@"2",@"3"];
    NSMutableArray *array1 = [@[@"1",@"2",@"3",@"4"] mutableCopy];
    [array1 removeObjectsInArray:array];
    NSLog(@"%@",array1);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self hh_gcd_group];
//    [self hh_gcd_single];
    [self hh_gcdSingle];
//    [self gcd_group_http];
//    [self gcd_group_bx];
//    [self gcd_group_notify];

//    [self gcd_main_yb];
//    [self gcd_sync];
//    [self gcd_async_block_sync];
//    [self gcd_queue];

    
}
#pragma mark -----------------------我是分割线 group----------------------

//MARK:notify 和 group 和起来用 当group执行完毕之后才执行notify
- (void)hh_gcd_group {
    //这样就可以顺序执行 当所有的请求都调用dispatch_group_level以后 ，就会进入dispathch_group_notify
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"线程1--%@",[NSThread currentThread]);
        dispatch_group_leave(group);
        
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"线程2--%@",[NSThread currentThread]);
        int i = 0;
        while (i < 100) {
            NSLog(@"------------|%d|",i);
            i++;
        }
        dispatch_group_leave(group);
    });
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"线程3--%@",[NSThread currentThread]);
        [NSThread sleepForTimeInterval:3.f];
        dispatch_group_leave(group);
    });
    /**
     notify的作用就是在group中的其他操作全部完成后，再操作自己的内容，
     所以线程4最后一个执行
     */
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0),^{
        NSLog(@"线程4--%@",[NSThread currentThread]);
    });
}
//MARK:循环创建多个数据请求 异步队列
- (void)gcd_group_http {
    dispatch_group_t group = dispatch_group_create();
    for (int i = 0; i < 10; i ++) {
        dispatch_group_enter(group);
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            
            NSLog(@"分组线程--%d----：%@",i,[NSThread currentThread]);
            sleep(1);
            dispatch_group_leave(group);
        });
//        if (9 == i) {
//            sleep(2);
//            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//                NSLog(@"当前线程------：%@",[NSThread currentThread]);
//            });
//        }
        
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"当前线程------：%@",[NSThread currentThread]);
    });
}
//MARK:线程组任务添加到串行队列中
- (void)gcd_group_cx {
    /** 创建一个串行队列*/
    dispatch_queue_t queue = dispatch_queue_create("queue_group_", NULL);
    /** 创建一个线程组*/
    dispatch_group_t group = dispatch_group_create();
    /** 异步线程组*/
    dispatch_group_async(group, queue, ^{
        NSLog(@"开始：task1");
        for (int i = 0; i < 10; i ++) {
            sleep(1);
            NSLog(@"当前线程：%@--%d",[NSThread currentThread],i);
        }
    });
    /** 异步线程组*/
    dispatch_group_async(group, queue, ^{
        NSLog(@"开始：task2");
        for (int i = 10; i < 20; i ++) {
            sleep(1);
            NSLog(@"当前线程：%@--%d",[NSThread currentThread],i);
        }
    });
    //监听线程组
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"开始：task3");
            for (int i = 20; i <= 30; i++) {
                sleep(1);
                NSLog(@"当前线程：%@--%d",[NSThread currentThread],i);
                if (30 == i) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"我回到主线程了~~~%@",[NSThread currentThread]);
                    });
                }
            }
            
        });
    });
    /**
     1：系统会开辟一条新的线程，用来执行同步任务；
     2：在dispatch_group_notify监听到回调之后，此时还在子线程中；需要编写回到主线程的语句
     3：不会造成主线程堵塞
     */
}
//MARK:线程组任务添加到并行队列中
- (void)gcd_group_bx {
    dispatch_queue_t queue = dispatch_queue_create("queue_group", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        NSLog(@"开始：task1");
        for (int i = 0; i < 10; i ++) {
            sleep(1);
            NSLog(@"当前线程：%@---%d",[NSThread currentThread],i);
        }
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"开始：task2");
        for (int i = 10; i < 20; i ++) {
            sleep(1);
            NSLog(@"当前线程：%@---%d",[NSThread currentThread],i);
        }
    });
    dispatch_group_notify(group, queue, ^{
        NSLog(@"开始：task3");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (int i = 20; i <= 30; i ++) {
                sleep(1);
                NSLog(@"当前线程：%@---%d",[NSThread currentThread],i);
                if (30 == i) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"我回到主线程了吗~~%@",[NSThread currentThread]);
                    });
                }
            }
        });
    });
    /**
     1：系统会为每个异步任务开辟一条子线程；
     2：每个任务在开辟的子线程中执行；
     3：在dispatch_group_notify监听到回调之后，此时还在某条子线程中；需要编写回到主线程的语句
     4：不会造成主线程堵塞；
     */
}
//MARK:多个异步线程执行完毕再执行某个任务
- (void)gcd_group_notify {
    dispatch_queue_t queue = dispatch_queue_create("queue_group_20150103", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        NSLog(@"当前线程--:gruop1");
        dispatch_group_enter(group);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (int i = 0; i < 10; i ++) {
                [NSThread sleepForTimeInterval:1.f];
                NSLog(@"正在下载。。。%d",i);
            }
            dispatch_group_leave(group);
        });
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"当前线程--:gruop2");
        dispatch_group_enter(group);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (int i = 10; i < 20; i ++) {
                [NSThread sleepForTimeInterval:1.f];
                NSLog(@"正在下载。。。%d",i);
            }
            dispatch_group_leave(group);
        });
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"当前线程--:gruop3");
        dispatch_group_enter(group);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (int i = 20; i < 30; i ++) {
                [NSThread sleepForTimeInterval:1.f];
                NSLog(@"正在下载。。。%d",i);
            }
            dispatch_group_leave(group);
        });
    });
    dispatch_group_notify(group, queue, ^{
        NSLog(@"当前线程--task:[%@]",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主线程了~~ %@",[NSThread currentThread]);
        });
    });
}
#pragma mark -----------------------我是分割线 queue----------------------

/**
 开不开线程:同步不开，异步开。
 开几条线程:串行队列开一条，并发开多条(异步)
 主队列:专门用来在主线程上调度任务的”队列”，主队列不能在其他线程中调度任务！
 如果主线程上当前正在有执行的任务，主队列暂时不会调度任务的执行！主队列同步任务，会造成死锁。原因是循环等待
 同步任务可以队列调度多个异步任务前，指定一个同步任务，让所有的异步任务，等待同步任务执行完成，这是依赖关系。
 全局队列：并发，能够调度多个线程，执行效率高，但是相对费电。 串行队列效率较低，省电省流量，或者是任务之间需要依赖也可以使用串行队列。
 也可以通过判断当前用户的网络环境来决定开的线程数。WIFI下6条，3G/4G下2～3条
 ---------------------
 作者：GabrielPanda
 来源：CSDN
 原文：https://blog.csdn.net/Nathan1987_/article/details/78511954
 版权声明：本文为博主原创文章，转载请附上博文链接！
 */
//*!!!:全局队列
- (void)gcd_queue {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    for (int i = 0; i < 10; i ++) {
        dispatch_async(queue, ^{
            NSLog(@"%@--%i",[NSThread currentThread],i);
        });
    }
    [NSThread sleepForTimeInterval:1.f];
    NSLog(@"全局队列");
}
//*!!!:异步任务block包裹同步任务
- (void)gcd_async_block_sync {
    dispatch_queue_t queue = dispatch_queue_create("queue_20150103_lxyy", DISPATCH_QUEUE_CONCURRENT);
    void(^task)(void) = ^{
        dispatch_sync(queue, ^{
            NSLog(@"第一个任务：%@",[NSThread currentThread]);
            sleep(2);
        });
        dispatch_async(queue, ^{
            NSLog(@"第二个任务：%@",[NSThread currentThread]);
            sleep(2);
        });
        dispatch_async(queue, ^{
            NSLog(@"第三个任务：%@",[NSThread currentThread]);
            sleep(2);
        });
    };
    
    dispatch_async(queue, task);
    [NSThread sleepForTimeInterval:1.f];
    NSLog(@"block异步任务包裹同步任务");
}
//MARK:同步任务
- (void)gcd_sync {
    dispatch_queue_t queue = dispatch_queue_create("queue_20150103_lxyy", DISPATCH_QUEUE_CONCURRENT);
    //必须先执行这个
    dispatch_sync(queue, ^{
        NSLog(@"第一个任务：%@",[NSThread currentThread]);
        sleep(2);
    });
    dispatch_async(queue, ^{
       NSLog(@"第二个任务：%@",[NSThread currentThread]);
        sleep(2);
    });
    dispatch_async(queue, ^{
        NSLog(@"第三个任务：%@",[NSThread currentThread]);
        sleep(2);
    });
    NSLog(@"同步任务");
    
}
//MARK:主队列，异步执行
- (void)gcd_main_yb {
    
    // 主队列 － 程序启动之后已经存在主线程，主队列同样存在
    dispatch_queue_t q = dispatch_get_main_queue();
    // 安排一个任务
    for (int i = 0; i<10; i++)
    {
        dispatch_async(q, ^{
            
            NSLog(@"%@ %d", [NSThread currentThread], i);
            
        });
    }
    NSLog(@"sleep");
    [NSThread sleepForTimeInterval:2.0];
    NSLog(@"主队列，异步执行");
}
//MARK:主队列
- (void)gcd_main_tb {
    NSLog(@"之前 - %@", [NSThread currentThread]);
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"sync - %@", [NSThread currentThread]);
    });
    
    NSLog(@"之后 - %@", [NSThread currentThread]);
}
//MARK:并行队列 异步执行
- (void)gcd_bx_yb {
    //创建并发队列 异步执行
    dispatch_queue_t testqueue = dispatch_queue_create("queue_20150103_lxyy", DISPATCH_QUEUE_CONCURRENT);
    // 执行任务
    for (int i = 0; i<10; i++) {
        dispatch_async(testqueue, ^{
            NSLog(@"%@ %d", [NSThread currentThread], i);
            sleep(1);
        });
    }
    NSLog(@"并发队列 同步执行");
}
//MARK:创建并发队列 同步执行
- (void)gcd_bx_tb {
    //创建并发队列 同步执行
    dispatch_queue_t testqueue = dispatch_queue_create("queue_20150103_lxyy", DISPATCH_QUEUE_CONCURRENT);
    // 执行任务
    for (int i = 0; i<10; i++) {
        dispatch_sync(testqueue, ^{
            NSLog(@"%@ %d", [NSThread currentThread], i);
            sleep(1);
        });
    }
    NSLog(@"并发队列 同步执行");
}
//MARK:创建串行队列 异步执行
- (void)gcd_cx_yb {
    dispatch_queue_t testqueue = dispatch_queue_create("queue_20150103_lyyy", NULL);
    // 执行任务
    for (int i = 0; i<10; i++)
    {
        sleep(1);
        dispatch_async(testqueue, ^{
            NSLog(@"%@ %d", [NSThread currentThread], i);
        });
    }
    NSLog(@"串行队列 异步执行");
}
//MARK:创建串行队列 同步执行
- (void)gcd_cx_tb {
    //创建串行队列 同步执行
    dispatch_queue_t testqueue = dispatch_queue_create("queue_20150103_lxyy", NULL);
    // 执行任务
    for (int i = 0; i<10; i++) {
        dispatch_sync(testqueue, ^{
            NSLog(@"%@ %d", [NSThread currentThread], i);
        });
    }
    NSLog(@"串行队列 同步执行");
}
/**
 同事执行三个线程，两个执行完毕之后才执行第三个
 semaphore_t 创建信号量的最大执行线程数 max
 waite 等待时间
 signal 发送信号  小max 执行当前线程 == max 等待  >max 执行下面的后面的
 */
- (void)hh_gcd_single {
    /** 创建一个限号量*/
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    /** 开辟一个线程*/
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 4; i++) {
        //NSLog(@"1--%@",[NSThread currentThread]);
        dispatch_async(quene, ^{
            NSLog(@"tasl--%d",i);
            for (int j = 0; j < 100; j++) {
//                NSLog(@"i = %d", j);
            }
            [NSThread sleepForTimeInterval:1];
           // NSLog(@"2--%@",[NSThread currentThread]);
            /** 信号通知，让信号量 +1*/
            dispatch_semaphore_signal(semaphore);
        });
       // NSLog(@"3--%@",[NSThread currentThread]);
        /** 等待，直到信号量大于0时候，可以操作，同时将信号量-1*/
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    NSLog(@"4--%@",[NSThread currentThread]);
    NSLog(@"😑");
    return;
    
    dispatch_semaphore_t sema1 = dispatch_semaphore_create(0);
    dispatch_semaphore_t sema2 = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < 2; i ++) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (int i = 0; i < 100; i++) {
                    NSLog(@"i = %d", i);
                }
                //            sleep(1);
                dispatch_semaphore_signal(sema1);
            });
        }
        dispatch_semaphore_wait(sema1, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_signal(sema2);
    });
    dispatch_semaphore_wait(sema2, DISPATCH_TIME_FOREVER);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
         NSLog(@"+++++++++");
    });
    
    
}
/** 创建信号量 开辟最大线程 */
- (void)hh_gcdSingle {
    /**
        dispatch_semaphore_wait(semap, DISPATCH_TIME_FOREVER);
        放在前面 少执行一次
        放在后面 多执行一次
     */
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semap = dispatch_semaphore_create(5);
    for (int i = 0; i < 100; i ++) {
        dispatch_semaphore_wait(semap, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            NSLog(@"-------%d",i);
            [NSThread sleepForTimeInterval:2];
            dispatch_semaphore_signal(semap);
        });
        
//        dispatch_semaphore_wait(semap, DISPATCH_TIME_FOREVER);
//        NSLog(@"-----分割线 --\n");
//        dispatch_semaphore_signal(semap);
        
    }
}
//FIXME: GCD信号量
/** GCD 信号量*/
- (void)gcd_single_http {
    
}
@end
