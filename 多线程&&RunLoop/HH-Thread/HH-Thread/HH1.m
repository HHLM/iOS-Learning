//
//  HH1.m
//  HH-Thread
//
//  Created by Mac on 2018/12/13.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "HH1.h"
#import <objc/runtime.h>

@implementation HH1
//- (void)hh_log; {
//    NSLog(@"log1");
//}
//void hh_log() {
//    
//}
+ (void)run {
    
}
/**
 消息转发类方法
 */
+ (BOOL)resolveClassMethod:(SEL)sel {
    
    if (sel == @selector(run)) {
        Method method = class_getClassMethod(self, @selector(run));
//        Method method = class_getInstanceMethod(objc_getClass(self),@selector(run));
        IMP imp = class_getMethodImplementation(self, @selector(run));
        const char *type = method_getTypeEncoding(method);
        class_addMethod(self, sel, imp, type);
    }
    return [super resolveClassMethod:sel];
}
/** 消息转发对象方法 */
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"%s",__func__);
    /** 会执行两次
     1、动态解析
     2、消息转发
     */
    
//    if (sel == @selector(hh_log)) {
//        return class_addMethod(self, sel, (IMP)hh_log, "v@:");
//    }
    
    Method method = class_getInstanceMethod(self, @selector(hh_log));
    IMP imp = class_getMethodImplementation(self, @selector(hh_log));
    const char *type = method_getTypeEncoding(method);
    return class_addMethod(self, sel, imp, type);
    
    return [super resolveInstanceMethod:sel];
    return YES;
}
+ (BOOL)instancesRespondToSelector:(SEL)aSelector {
    return [super instancesRespondToSelector:aSelector];
    return YES;
}
- (BOOL)respondsToSelector:(SEL)aSelector {
    NSLog(@"%s",__func__);
    return [super respondsToSelector:aSelector];
    return YES;
}
- (instancetype)init {
    self = [super init];
    if (self) {
//        NSArray * array1 = @[@1,@2,@3,@4,@5,@6,@7,@9];
//
//        int result = [self compare:array1 target:9];
//        //在这里打印结果看是否有相等的值
//        NSLog(@"%d",result);
        
        NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:@(6), @(1),@(2),@(5),@(9),@(4),@(3),@(7),nil];
//        [self quickSortArray:arr withLeftIndex:0 andRightIndex:arr.count - 1];
        [self maopaoArray:arr];
        NSLog(@"%@",arr);

    }return self;
}

/**
 冒泡排序
 @param array 排序数组
 */
- (void)maopaoArray:(NSMutableArray *)array {
    
    int i = (int)array.count - 1;
    NSInteger count = 0;
    while (i > 0) {
        int pos = 0;
        for (int j = 0; j < i; j ++) {
            if ([array[j] integerValue] < [array[j + 1] integerValue]) {
                NSInteger temp  = [array[j] integerValue];
                array[j] = array[j + 1];
                array[j+1] = @(temp);
                pos = j;
                count ++;
            }
        }
        i = pos;
    }
    NSLog(@"------|%ld",(long)count);

    return;
    
    for (int i = 0; i < array.count; i ++) {
        for (int j = 0; j < array.count - 1 - i; j ++) {
            if ([array[j] integerValue] < [array[j + 1] integerValue]) {
                NSInteger temp  = [array[j] integerValue];
                array[j] = array[j + 1];
                array[j+1] = @(temp);
                 count ++;
            }
        }
    }
    NSLog(@"------|%ld",(long)count);
}

/**
 快速排序
 @param array 需要排序的数组
 @param leftIndex 左边下标
 @param rightIndex 右边下标
 */
- (void)quickSortArray:(NSMutableArray *)array withLeftIndex:(NSInteger)leftIndex andRightIndex:(NSInteger)rightIndex {
    if (leftIndex >= rightIndex) return ; //如果数组长度为0或1时返回
    NSInteger i = leftIndex;
    NSInteger j = rightIndex;
    NSInteger key = [array[i] integerValue];
    while (i < j) {
        /** 大于基准数 就继续向前查找 */
        while (i < j && [array[j] integerValue] >= key) {
            j --;
        }
        /** 若比基准数字小放到i的位置*/
        array[i] = array[j];
        /** 若小于基准数 就继续向后后查找 */
        while (i < j && [array[i] integerValue] <= key) {
            i ++;
        }
        /** 如果比基准数大放到右边j的位置 */
        array[j] = array[i];
    }
    /** 将基准数放到正确的位置 */
    array[i] = @(key);
    /** 递归排序 基准数左边的数据 */
    [self quickSortArray:array withLeftIndex:leftIndex andRightIndex:i-1];
    /** 递归排序 基准数右边的数据 */
    [self quickSortArray:array withLeftIndex:i + 1 andRightIndex:rightIndex];
}


/** 1.速度快 2.比较次数少 3.性能好 缺点 1.必须是一个有序的数组（升序或者降序） 2.适用范围：适用不经常变动的数组 */
/**
 二分查找法
 @param array 需要查找的数组
 @param target 需要查找的数据
 @return 返回所在下标 -1 表示不存在
 */
- (int)compare:(NSArray *)array target:(int)target{
    if (!array.count) return -1;
    
    if (!array.count) return -1;
    unsigned int low = 0;
    unsigned int high = (int)array.count - 1;
    while (low <= high) {
        //会有一些朋友看到有些人是( low + high ) / 2这样写的,但是这样写有一点不好,就是low+high会出现整数溢出的情况,如果存在溢出,你再除以2也是没有用的,所以不能这么写
        int mid = low + ((high - low)/2);
        //第mid项的内容
        int num = [[array objectAtIndex:mid] intValue];
        if (target == num) {
            return low;
        }else if (num > target){
            high = mid - 1;//左边进行查找
        }else{
            low = mid +1;//右边进行查找
        }
    }
    return -1;//返回-1是没找到
}
@end
