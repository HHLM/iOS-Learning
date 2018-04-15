//
//  main.m
//  C#
//
//  Created by Mac on 2018/4/11.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!\n");
        int a = 10;
        int *p = &a;
        *p = 20;
        printf("a的值变成了：%d\n",a);
        
        //const右边的不能修改
        const int *q = NULL;
        //*q 不能修改 但是q是可以改的
        
        printf("q的值：%p\n",q);

        q = &a;
        
        printf("q改变后的值：%p\n",q);
        
        int * const m = NULL;
        
        //printf("m的值：%d\n",*m);
        //m = &a;
        
//        *m = a;
        
        printf("m的值：%p\n",m);
        
        //因此常量定义要用下面的格式
        
        NSString *const HHConstName = @"HHLM";
        
        NSLog(@"%@",HHConstName);
        
    }
    return 0;
}
