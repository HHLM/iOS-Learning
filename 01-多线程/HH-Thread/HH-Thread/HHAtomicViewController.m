//
//  HHAtomicViewController.m
//  HH-Thread
//
//  Created by Mac on 2018/4/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "HHAtomicViewController.h"

@interface HHAtomicViewController ()
/**
 nonatomic  ： 非原子属性
 atomic  ： 原子属性，保证这个属性的安全性（线程安全），就是针对多线程设计的！ 消耗大 为setter方法加锁
 
 原子属性的目的：被多个线程写入同一个对象的时候，保证同一时间只有一个线程能够执行.
 单写多读的一种多线程技术，同样有可能出现“脏数据”，重新读一下
 */

/** 全局的锁对象 */
@property (nonatomic, strong) NSObject *lockObj;
/** 原子属性 */
@property (atomic, strong) NSObject *myAtomic;
@end

@implementation HHAtomicViewController

@synthesize myAtomic = _myAtomic;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSData *data;
    /** 原子属性 == YES  先把文件保存到一个临时的文件中，等全部写入之后，再改名*/
    [data writeToFile:@"" atomically:YES];
}
/** OC中定义属性 通常会生成 _成员变量 如果同时重写了 getter && setter  _成员变量 就不自动生成！ */


/**
 实际中，原子属性内部有一个锁 ，自旋锁
 
 自旋锁  和  互斥锁

 共同点：
    1、都能保证线程安全
 不同点：
    互斥锁：如果线程被锁在外面，就会进入休眠状态，等待锁打开，打开之后然后被唤醒
    自旋锁：如果线程被锁在外面，就会用死循环的方式，一直等待锁被打开！
 
 无论什么锁，都很消耗性能，效率不高；
 */

/** 线程安全
 
 *在多个线程进行读写操作时候，仍然保证数据正确！
 
 *UI 线程，共同约定：所有的UI更新，都放在主线程上执行！ UIKit 框架都是线程不安全的 （因为安全效率下降 ）
 
 */
- (void)setMyAtomic:(NSObject *)myAtomic {
    /** 加一把互斥锁 */
    @synchronized(self) {
        _myAtomic = myAtomic;
    }
}
- (NSObject *)myAtomic
{
    return _myAtomic;
}


@end
