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
//    [self hh_gcdGroup];
//    [self hh_gcdSingle1];
//    [self hh_gcdGroup];
    [self groupHttp];
}

/**
 同事执行三个线程，两个执行完毕之后才执行第三个
 semaphore_t 创建信号量的最大执行线程数 max
 waite 等待时间
 signal 发送信号  小max 执行当前线程 == max 等待  >max 执行下面的后面的
 */
- (void)hh_gcdSingle1 {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 2; i++) {
        dispatch_async(quene, ^{
            for (int i = 0; i < 100; i++) {
                NSLog(@"i = %d", i);
            }
            dispatch_semaphore_signal(semaphore);
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }

//    dispatch_async(quene, ^{
//        for (int i = 100; i < 110; i++) {
//            NSLog(@"i = %d", i);
//        }
//        dispatch_semaphore_signal(semaphore);
//    });
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
/**
 创建信号量 开辟最大线程
 */
- (void)hh_gcdSingle {
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semap = dispatch_semaphore_create(5);
    for (int i = 0; i < 100; i ++) {
        dispatch_semaphore_wait(semap, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
            sleep(2);
            NSLog(@"-------");
            dispatch_semaphore_signal(semap);
        });
        dispatch_semaphore_wait(semap, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_signal(semap);
        
    }
}
/**
 notify 和 group 和起来用 当group执行完毕之后才执行notify
 */
- (void)hh_gcdGroup {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"线程1--%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"线程2--%@",[NSThread currentThread]);
        int i = 0;
        while (i < 100) {
            NSLog(@"------------|%d|",i);
            i++;
        }
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"线程3--%@",[NSThread currentThread]);
    });
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0),^{
      NSLog(@"线程4--%@",[NSThread currentThread]);
    });
    
    /**
     notify的作用就是在group中的其他操作全部完成后，再操作自己的内容，
     所以线程4最后一个执行
     */
    
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        NSLog(@"回到主线程主线程");
//    });
}

/** 循环创建多个数据请求 异步队列*/
- (void)groupHttp {
    dispatch_group_t group = dispatch_group_create();
    for (int i = 0; i < 10; i ++) {
        dispatch_group_enter(group);
        dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
    
            NSLog(@"分组线程--%d----：%@",i,[NSThread currentThread]);
            dispatch_group_leave(group);
        });
        if (9 == i) {
            sleep(2);
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                NSLog(@"当前线程------：%@",[NSThread currentThread]);
            });
        }
        
    }
}
/** GCD 信号量*/
- (void)gcd_single_http {
    
}
@end
