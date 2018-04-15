//
//  main.m
//  Array
//
//  Created by Mac on 2018/4/11.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        int number[4] = {10,11,12,13};
        
        
        for (int i = 0; i < sizeof(number)/sizeof(int); i ++) {
            int a = number[i];
            printf("%d:---:%p\n",a,&a);
        }
        
        int *p = (int *)&number;
        

        int b = number[0];
        
        printf("%d--%p\n",b,&b);
        
        
        printf("%d\n",*p);
        
        int *  q = (int *)(&number + 1);
        
        printf("%p\n",q);
        
        printf("%p---%p\n",number,&number);
        printf("%p---%p\n",number+1,&number+1);
        
    }
    return 0;
}
