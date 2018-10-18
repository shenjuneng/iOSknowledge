//
//  NSObject+SJKVO.m
//  SJKVO
//
//  Created by 沈骏 on 2018/10/18.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import "NSObject+SJKVO.h"
#import <objc/runtime.h>
#import <objc/message.h>

NSString *const kSJKVOClassPrefix = @"SJKVOClassPrefix_";

@implementation NSObject (SJKVO)

#pragma mark - public

- (void)SJ_addObserver:(NSObject *)observer
                forKey:(NSString *)key
             withBlock:(void(^)(id observedObject, NSString *observedKey, id oldV, id newV))block {
    
    // 1. 抛出异常 如果 本类或父类 没有实现 setter的实现方法
    SEL setterSelector = NSSelectorFromString(setterForGetter(key));
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    if (!setterMethod) {
        // throw invalid argument exception
        NSLog(@"throw invalid argument exception");
    } else {
        NSLog(@"setter方法存在");
    }
    
    Class clazz = object_getClass(self);
    NSString *clazzName = NSStringFromClass(clazz);
    
    if (![clazzName hasPrefix:kSJKVOClassPrefix]) {
        clazz = [self makeKvoClassWithOriginalClassName:clazzName];
        NSLog(@"%@", clazz);
    }
}

- (void)SJ_removeObserver:(NSObject *)observer
                   forKey:(NSString *)key {
    
}

#pragma mark - kit
/**
 获得相应的setter的名字（SEL）
 */
static NSString *setterForGetter(NSString *getter) {
    if (getter.length <= 0) {
        return nil;
    }
    NSString *capitalizedString = [getter capitalizedString];
    NSString *setter = [NSString stringWithFormat:@"set%@:", capitalizedString];
    
    return setter;
}

static Class kvo_class(id self, SEL _cmd) {
    Class superClazz = class_getSuperclass(object_getClass(self));
    NSLog(@"%@", superClazz);
    return superClazz;
}


/**
 根据原类名 生成新类
 */
- (Class)makeKvoClassWithOriginalClassName:(NSString *)originalClazzName {
    // 给新类名 加上前缀
    NSString *kvoClazzName = [kSJKVOClassPrefix stringByAppendingString:originalClazzName];
    Class clazz = NSClassFromString(kvoClazzName);
    NSLog(@"%@",clazz);
    if (clazz) {
        return clazz;
    }
    
    // 这个新类不存在， 创建它
    Class originalClazz = object_getClass(self);
    Class kvoClazz = objc_allocateClassPair(originalClazz, kvoClazzName.UTF8String, 0);
    
    // grab class method's signature so we can borrow it
    Method clazzMethod = class_getInstanceMethod(originalClazz, @selector(class));
    const char *types = method_getTypeEncoding(clazzMethod);
    class_addMethod(kvoClazz, @selector(class), (IMP)kvo_class, types);
    
    objc_registerClassPair(kvoClazz);
    
    return kvoClazz;
}

@end
