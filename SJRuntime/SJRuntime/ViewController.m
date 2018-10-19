//
//  ViewController.m
//  SJRuntime
//
//  Created by 沈骏 on 2018/10/18.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    Person *p = [[Person alloc] init];
    p.name = @"aaa";
    p.age = 23;
    
    unsigned int count;
    
    objc_property_t *propertyList = class_copyPropertyList(object_getClass(p), &count);
    for (unsigned int i = 0;i < count;i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSLog(@"property(屬性)-->%@", [NSString stringWithUTF8String:propertyName]);
    }
    
    // 对象方法列表
    Method *methodList = class_copyMethodList([p class], &count);
    for (unsigned int i = 0;i < count;i++) {
        Method method = methodList[i];
        NSLog(@"method(对象方法)-->%@", NSStringFromSelector(method_getName(method)));
    }

    Ivar *ivarList = class_copyIvarList([p class], &count);
    for (unsigned int i = 0; i < count; i++) {
        Ivar myIvar = ivarList[i];
        const char *ivarName = ivar_getName(myIvar);
        NSLog(@"Ivar(成员变量)---->%@", [NSString stringWithUTF8String:ivarName]);
    }
    
    //获取协议列表
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([p class], &count);
    for (unsigned int i = 0; i<count; i++) {
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
        NSLog(@"protocol---->%@", [NSString stringWithUTF8String:protocolName]);
    }
    
    [self testResolveInstanceMethod:p];
}


/**
 测试调用拦截
 */
- (void)testResolveInstanceMethod:(Person *)p {
    [p performSelector:@selector(objcFunc22) withObject:@"test"];
}

@end
