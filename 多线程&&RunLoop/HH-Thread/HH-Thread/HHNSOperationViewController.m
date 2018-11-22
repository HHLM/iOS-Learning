//
//  HHNSOperationViewController.m
//  HH-Thread
//
//  Created by Mac on 2018/11/22.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "HHNSOperationViewController.h"

#define TICK   NSDate *startTime = [NSDate date]

#define TOCK   NSLog(@"Time: %f", -[[NSDate date] timeIntervalSinceNow])

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
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"任务一");
    }];
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSDate *startTime = [NSDate date];
        sleep(1);
        NSLog(@"任务二");
        NSDate *startTime1 = [NSDate date];
        NSLog(@"%f",startTime1.timeIntervalSince1970 - startTime.timeIntervalSince1970);
    }];
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSDate *startTime = [NSDate date];
        sleep(1);
        NSLog(@"任务三");
        NSDate *startTime1 = [NSDate date];
        NSLog(@"%f",startTime1.timeIntervalSince1970 - startTime.timeIntervalSince1970);
    }];
    
    // 3.设置依赖
    [operation1 addDependency:operation2];// 任务一依赖任务二
    [operation1 addDependency:operation3];// 任务一依赖任务三
    
    // 4.创建队列并加入任务
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation2, operation1,operation3] waitUntilFinished:NO];
    NSLog(@"--------------------------");
}
@end
