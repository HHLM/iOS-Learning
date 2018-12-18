//
//  HH2.m
//  HH-Thread
//
//  Created by Mac on 2018/12/13.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "HH2.h"
@implementation HH2

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(hh_log)) {
//        return [HH2 new];
    }
    return [super forwardingTargetForSelector:aSelector];
}
/** 方法名注册 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(hh_log)) {
        return [NSMethodSignature  signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    anInvocation.selector = @selector(run);
    //anInvocation.target = self
    [anInvocation invoke];
}
- (void)run {
    NSLog(@"H2再跑动");
}

@end

