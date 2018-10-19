//
//  UIViewController+Loggin.m
//  SJMethodSwizzling
//
//  Created by 沈骏 on 2018/10/19.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import "UIViewController+Loggin.h"
#import <objc/runtime.h>

// 每一个类都有一个Dispatch Table, 将方法名（SEL）和方法实现（IMP）对应
// Swizzle就是在程序x运行时 Dispatch Table做k改动， 让方法名字对应另一个IMP
@implementation UIViewController (Loggin)

// 当一个类被读到内存的时候， runtime 会给这个类及它的每一个类别都发送一个 +load: 消息。
+ (void)load
{
    swizzleMethod([self class], @selector(viewDidAppear:), @selector(swizzled_viewDidAppear:));
}

- (void)swizzled_viewDidAppear:(BOOL)animated {
    
    // 在 swizzled_viewDidAppear: 里调用 swizzled_viewDidAppear: 实际上调用的是原来的 viewDidAppear: 。
    [self swizzled_viewDidAppear:animated];
    
    NSLog(@"交换方法的执行内容");
}

void swizzleMethod(Class clazz, SEL originalSel, SEL swizzleSel) {
    
    Method originalMethod = class_getInstanceMethod(clazz, originalSel);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzleSel);
    
    // class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(clazz, originalSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    // the method doesn’t exist and we just added one
    if (didAddMethod) {
        class_replaceMethod(clazz, swizzleSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }

}

@end
