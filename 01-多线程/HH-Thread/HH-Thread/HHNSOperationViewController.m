//
//  HHNSOperationViewController.m
//  HH-Thread
//
//  Created by Mac on 2018/11/22.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "HHNSOperationViewController.h"

@interface HHNSOperationViewController ()

@end

@implementation HHNSOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self test];
}
- (void)test {
    // 1.任务一：获取用户信息
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务一");
        
    }];
    
    // 2.任务二：请求相关数据
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        sleep(1);
        NSLog(@"任务二");
    }];
    
    // 2.任务二：请求相关数据
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        sleep(2);
        NSLog(@"任务三");
    }];
    
    // 3.设置依赖
    [operation1 addDependency:operation2];// 任务二依赖任务一
    [operation1 addDependency:operation3];// 任务三依赖任务一
    
    // 4.创建队列并加入任务
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation2, operation1,operation3] waitUntilFinished:NO];
    NSLog(@"--------------------------");
}
@end
