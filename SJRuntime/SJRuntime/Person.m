//
//  Person.m
//  SJRuntime
//
//  Created by 沈骏 on 2018/10/18.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import "Car.h"

/*
 方案一：
 + (BOOL)resolveInstanceMethod:(SEL)sel
 + (BOOL)resolveClassMethod:(SEL)sel
 
 方案二：
 // 返回你需要转发消息的对象
 - (id)forwardingTargetForSelector:(SEL)aSelector
 
 方案三：
 - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
 - (void)forwardInvocation:(NSInvocation *)anInvocation;
 */

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

//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    NSString *selName = NSStringFromSelector(sel);
//    NSLog(@"%@", selName);
//    class_addMethod([self class], sel, (IMP) dynamicMethodIMP, "v@:");
//    return NO;
//}

// iOS 4.3 加入很多新的 runtime 方法，主要都是以 imp 为前缀的方法，比如 用 block 快速创建一个 imp
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    IMP fooIMP = imp_implementationWithBlock(^(id _self) {
        NSLog(@"Doing foo");
    });
    
    class_addMethod([self class], sel, (IMP)fooIMP, "v@:");
    return NO;
}



/**
 返回你需要转发消息的对象
 */
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    return [[Car alloc] init];
//}

//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//
//    NSString *sel = NSStringFromSelector(aSelector);
//    // 判断转发的SEL
//    if ([sel isEqualToString:@"run"]) {
//        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
//    }
//
//    return [super methodSignatureForSelector:aSelector];
//}
//
//- (void)forwardInvocation:(NSInvocation *)anInvocation {
//    SEL selector = [anInvocation selector];
//
//    Car *car = [[Car alloc] init];
//    if ([car respondsToSelector:selector]) {
//        [anInvocation invokeWithTarget:car];
//    }
//}

@end
