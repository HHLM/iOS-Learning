//
//  HHRootViewController.m
//  HH-Thread
//
//  Created by Mac on 2018/4/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "HHRootViewController.h"
#import "HHThreadViewController.h"
#import "HHGCDViewController.h"
#import "HHAtomicViewController.h"
#import "HHRunLoopViewController.h"
#import "HHNSOperationViewController.h"
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
    _dataArray = @[@"Atomic",@"Thread",@"GCD",@"RunLoop",@"NSOperation"];
    [self.myTableView reloadData];

    testApp();
}



// MARK: OC的数组 通过C的方式改变长度
void testApp (){
    NSArray *array = @[@"0",@"1",@"2",@"3",@"4"];
    
    void *adds = (__bridge void*)array;
    
    NSLog(@"%p",adds);
    
    //⚠️ (NSUInteger*)adds + 1 这里面应该是存放着数组的长度 ？？？？ ⚠️
    *((NSUInteger*)adds + 1) = 2;
    
    NSLog(@"%p",adds + 1);
    
    
    NSLog(@"%@---%zd",array,array.count);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    NSString *className = [NSString stringWithFormat:@"HH%@ViewController",_dataArray[indexPath.row]];
    Class class = NSClassFromString(className);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    vc = [[class alloc] init];
    vc.title = _dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- UI
- (UITableView *)creatTableView
{
    UITableView *table = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor lightGrayColor];
    [table setTableFooterView:[[UIView alloc] init]];
    return table;
}

@end
