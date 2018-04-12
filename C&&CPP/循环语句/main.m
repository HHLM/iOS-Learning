//
//  main.m
//  循环语句
//
//  Created by Mac on 2018/4/11.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        int sum = 0;
        for (int i = 1; i <= 100; i ++) {
            sum+=i;
        }
        printf("%d\n",sum);
        
        
        int sum1 = 0;
        int number = 100;
        
        printf("输入想要相加的最大数\n");
//       number =  scanf("%d",&number);
        
        sum1 = (number + 1) * number / 2;
        
        printf("sum1= %d\n",sum1);
     
    }
    return 0;
}
// goto 语句跳转
void setPositon(float x,float y) {
    printf("x = %0.2f,y = %0.2f",x,y);
    
    if (YES) {
        goto failed;
    }
failed:
    printf("你来了");
}


    
