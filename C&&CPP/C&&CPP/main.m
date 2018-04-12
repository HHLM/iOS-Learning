//
//  main.m
//  C&&CPP
//
//  Created by Mac on 2018/4/11.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        while (YES) {
         
            printf("我是刘小辉\n");
            int resurt = 0;
            printf("请输入你想要回去的年代\n");
            scanf("%d",&resurt);
            
            if (resurt == 2003) {
                printf("我多想回到过去，回到这一年\n");
                break;
            }else {
                printf("您输入的是：%d\n",resurt);
//                hh_dreamTime(resurt);
//                clicked();
            }
        }
    }
    return 0;
}
void clicked() {
    
}
//void hh_dreamTime(int year) {
//    printf("这些年代就像做梦一样过去了，以后要珍惜每一天");
//}

