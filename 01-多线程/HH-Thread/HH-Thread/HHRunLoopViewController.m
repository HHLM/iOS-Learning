//
//  HHRunLoopViewController.m
//  HH-Thread
//
//  Created by Mac on 2018/4/15.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "HHRunLoopViewController.h"

@interface HHRunLoopViewController ()

@end

@implementation HHRunLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     RunLoop :
     -- 保证程序不退出
     -- 负责监听事件，监听iOS中所有的事件：
     触摸，时钟，网络事件
     -- 如果没有事件发生，会让程序进入休眠状态
     */
    
    //默认是时钟模式
    NSTimer *timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(upDate) userInfo:nil repeats:YES];
    //修改runloop的方式
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    /**
     NSDefaultRunLoopMode -- 时钟模式，网络事件。 默认模式
     NSRunLoopCommonModes -- 用户交互模式
     若时钟触发方法，执行了一个非常耗时的操作，UI界面就非常卡顿，或者定时器出错，要选择用户交互模式
     */
    //    NSTimer *timer =[NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(upDate) userInfo:nil repeats:YES];
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)observer
{
    
}

int i = 0;
- (void)upDate
{
    i ++;
    NSLog(@"%d----%@",i,[NSThread currentThread]);
}


@end
