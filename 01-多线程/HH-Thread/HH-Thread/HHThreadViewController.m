//
//  HHThreadViewController.m
//  HH-Thread
//
//  Created by Mac on 2018/4/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "HHThreadViewController.h"

@interface HHThreadViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak)   UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign,getter=isFinish) BOOL finish;
@end

@implementation HHThreadViewController

- (void)loadViews {
    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.scrollView];
    UIImageView *view = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
    [self.scrollView addSubview:view];
    
    self.imageView = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadViews];
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 2;
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(downLoadImage) object:nil];
    [thread start];
    [self creatThread];
    
}


// MARK: NSThread使用
- (void)creatThread {
    //用alloc init 适用于自定义的NSThread（子类）
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(hh_runThread) object:nil];
    thread.name = @"HHH";
    [thread start];
    
    /**
     ⚠️为什么此刻不执行这个方法？： hh_runThread执行的太快了
     hh_runOtherThread 是在 hh_runThread方法开辟的一个子线程 当hh_runThread方法一执行完就把线程给销毁了
     子线程的RunLoop是默认不工作的
     
     
     */
    [self performSelector:@selector(hh_runOtherThread) onThread:thread withObject:@"MMM" waitUntilDone:NO];
    
    
    
}
- (void)hh_runThread {
    NSLog(@"M-----:%@",[NSThread currentThread]);
    
    
    // OC中使用较多的退出循环的方式
    while (!self.finish) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
    
    //开启当前线程的runLoop
    //[[NSRunLoop currentRunLoop] run];
    
    /**
     若[[NSRunLoop currentRunLoop] run]开启
     下面这个不打印 说明开辟的线程在进行死循环
     */
    NSLog(@"干撒子！！！");
}
- (void)hh_runOtherThread {
    NSLog(@"N-----:%s%@",__FUNCTION__, [NSThread currentThread]);
    self.finish = YES;
}

- (void)downLoadImage
{
    NSLog(@"downLoadImage---:%@",[NSThread currentThread]);
    NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1523360919814&di=89778c1c01cd4140218cedbae48eaf4e&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fw%253D580%2Fsign%3D97c5163eb0de9c82a665f9875c8080d2%2F031593d4b31c8701a41640e1247f9e2f0608ffff.jpg"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    /**
     主线程执行setimage
     @param setImage: 执行的方法
     @return NO 不执行 YES 执行 ： 是否在当前线程线程执行完在继续执行当前线程
     */
    [self performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
}
- (void)setImage:(UIImage *)image
{
    //重写setter方法 要执行_image = image 要不然self.image是nil
    _image = image;
    NSLog(@"setImage---:%@",[NSThread currentThread]);
    _image = image;
    self.imageView.image = image;
    [self.imageView sizeToFit];
    self.scrollView.contentSize = image.size;
}
#pragma mark -- UIScrollview

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;
{
    return self.imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"%@",NSStringFromCGAffineTransform(self.imageView.transform));
}
@end
