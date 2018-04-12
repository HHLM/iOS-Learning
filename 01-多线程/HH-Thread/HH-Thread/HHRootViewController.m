//
//  HHRootViewController.m
//  HH-Thread
//
//  Created by Mac on 2018/4/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "HHRootViewController.h"
#import "HHThreadViewController.h"
@interface HHRootViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, weak) UIView *showView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation HHRootViewController

/**
 1、纯代码开发、加载试图结构
 2、功能和xib && storyboard功能一样
 3、如果重写这个方法，xib && storyboard都无效
 */
- (void)loadView {
    self.myTableView = [self creatTableView];
    self.view  = self.myTableView;
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    self.showView = view;
}
/**
 showView 使用weak不会报错的原因是：view添加到了self.view上
    这时候self.view的subviews是一个强指针指向它的，当他被移除的时候，这时候他的 weak指针所指就回被销毁。
    若是使用strong 就会在内存中一直存在，不被释放。
 
 要是myTableView 用weak修饰的话，除了
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = @[@"原子属性",@"NSThread",@"GCD"];
    [self.myTableView reloadData];
    
    
    
    /**
     RunLoop :
        -- 保证程序不退出
        -- 负责监听事件，监听iOS中所有的事件：
                        触摸，时钟，网络事件
        -- 如果没有事件发生，会让程序进入休眠状态
     */
    
    //默认是时钟模式
    //NSTimer *timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(upDate) userInfo:nil repeats:YES];
    /**
     NSDefaultRunLoopMode -- 时钟模式，网络事件。 默认模式
     NSRunLoopCommonModes -- 用户交互模式
     若时钟触发方法，执行了一个非常耗时的操作，UI界面就非常卡顿，或者定时器出错，要选择用户交互模式
     */
    NSTimer *timer =[NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(upDate) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}


int i = 0;
- (void)upDate
{
    i ++;
    NSLog(@"%d----%@",i,[NSThread currentThread]);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 20;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HHBaseViewController *vc = [[HHBaseViewController alloc] init];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        vc = [[HHThreadViewController alloc] init];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- UI
- (UITableView *)creatTableView
{
    UITableView *table = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    table.delegate = self;
    table.dataSource = self;
    [table setTableFooterView:[[UIView alloc] init]];
    return table;
}

@end
