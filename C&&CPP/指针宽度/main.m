//
//  main.m
//  指针宽度
//
//  Created by Mac on 2018/4/29.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"Hello, World!");
        
        int  *a = 100;
        //a指向的地址中的值是100
        
        int m = 100;
        
        int *q = &m;
        

        // 指针q指向m的地址 *q取m地址中的值
        
        printf("&q = %p ：q = %d\n",q,*q);
        
        *q = 20;
        
        printf("&q = %p ：q = %d\n",q,*q);
        
        printf("&m = %p ：m = %d\n",&m,m);
        
        printf("&a = %p ：a = %d\n",&a,a);
        
        int *p = (a+1);
        
        printf("&(a+1) = %p ： *(a+1) = %d\n",&p,(a+1));
        
        int **n = 100;
        
        printf("n+1 = %d\n",n+1);
        
        /**
        
         在64位中指针的宽度是：8个字节 可以做一些 + -的运算
         
         a 和 m 相比只是多了一个指针
         
        打印结果：
            &m = 0x7ffeefbff604 ：m = 100
            &a = 0x7ffeefbff608 ：a = 100
            &(a+1) = 0x7ffeefbff5f8 ： *(a+1) = 104
            n+1 = 108
         
            指针运算是根据指向的数据类型来的  去掉一个*看前面是什么类型 就根据什么类型计算
         因此 a+1的结果就是100 + 4 （int4个字节） = 104
         **n 去掉一个*还以一个* 因此 +1 时候 去类型值指针的长度 8 因此 n + 1 = 100 + 8 = 108
         
         */
        
        int  *b = 200;
        
        printf("&b = %p ： b的地址 = %d\n",&b,b);
        
        printf("a-b = %d\n",a-b);
        
    }
    return 0;
}
