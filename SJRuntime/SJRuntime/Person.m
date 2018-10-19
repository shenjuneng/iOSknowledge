//
//  Person.m
//  SJRuntime
//
//  Created by 沈骏 on 2018/10/18.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>


@implementation Person

+ (void)impName1 {
    NSLog(@"kkk1");
}

+ (void)impName2 {
    NSLog(@"kkk2");
}

- (void)objcFunc1 {
    NSLog(@"objcFunc1");
}

- (void)objcFunc2 {
    NSLog(@"objcFunc2");
}

void dynamicMethodIMP(id self, SEL _cmd) {
    NSLog(@"找不到方法");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selName = NSStringFromSelector(sel);
    NSLog(@"%@", selName);
    class_addMethod([self class], sel, (IMP) dynamicMethodIMP, "v@:");
    return YES;
}


@end
