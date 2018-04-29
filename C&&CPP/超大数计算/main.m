//
//  main.m
//  超大数计算
//
//  Created by Mac on 2018/4/25.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"超大数计算!");
        
        NSString *number1 = @"9900009";
        NSString *number2 = @"12130";
        
        
       
        
        NSMutableArray *dataAll = [NSMutableArray array];
        
        
        
        for (NSInteger j = number2.length -1; j >= 0; j --) {
            
            unichar nStr = [number2 characterAtIndex:j];
            
           int b = [[NSString stringWithFormat:@"%c",nStr] intValue];
            
            NSMutableArray *datas = [NSMutableArray array];
            for (NSInteger i = (number1.length -1); i >= 0; i--) {
                char a = [number1 characterAtIndex:i];
                NSInteger num = [[NSString stringWithFormat:@"%c",a] integerValue];
                [datas addObject:@(num * b).description];
            }
            NSLog(@"%@",datas);
            
            for (int i = 0; i < datas.count-1; i++) {
                
                NSInteger temp = [datas[i] integerValue]/10;
                datas[i] = @([[datas objectAtIndex:i] integerValue] %10).description;
                datas[i+1] = @([datas[i+1] intValue] + temp).description;
            }
            
            NSLog(@"%@",datas);
//            datas = (NSMutableArray *)[[datas reverseObjectEnumerator] allObjects];
            
            
            
            [dataAll addObject:datas];
            
            
            NSString *bigNumber = [datas componentsJoinedByString:@""];
            
            NSLog(@"%@",datas);
            NSLog(@"%@",bigNumber);
        }
        
         NSLog(@"%@",dataAll);
        
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i< dataAll.count; i ++) {
            NSArray *datas = dataAll[i];
            for (int j = 0; j < datas.count; j ++) {
                if (array.count <= i+j) {
                    [array addObject:datas[j]];
                }else {
                    NSString *temp = @([array[i+j] integerValue] + [datas[j] integerValue] ).description;
                    array[i+j] = temp;
                }
            }
        }
        NSLog(@"------:%@",array);
        
        
        for (int i = 0; i < array.count-1; i++) {
            
            NSInteger temp = [array[i] integerValue]/10;
            array[i] = @([[array objectAtIndex:i] integerValue] %10).description;
            array[i+1] = @([array[i+1] intValue] + temp).description;
        }
        
        NSLog(@"%@",array);
        array = (NSMutableArray *)[[array reverseObjectEnumerator] allObjects];
        
    
        
        
        NSString *bigNumber = [array componentsJoinedByString:@""];
        
        NSLog(@"%@",array);
        NSLog(@"%@",bigNumber);
        
        
//        for (int i = 0; i < dataAll.count-1; i++) {
//
//            NSInteger temp = [dataAll[i] integerValue]/10;
//            dataAll[i] = @([[dataAll objectAtIndex:i] integerValue] %10).description;
//            dataAll[i+1] = @([dataAll[i+1] intValue] + temp).description;
//        }
//
//        NSLog(@"%@",dataAll);
//
//        dataAll = (NSMutableArray *)[[dataAll reverseObjectEnumerator] allObjects];
//
//
//        NSString *bigNumber = [dataAll componentsJoinedByString:@""];
//
//        NSLog(@"最后结果：%@",bigNumber);
        
        NSArray *a = @[@{@"key1":@"value1",@"key2":@"value2"},
                       @{@"keyA":@"valueA",@"keyB":@"valueB"}];
        
        
    }
    return 0;
}




