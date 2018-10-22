//
//  ViewController.m
//  SJRunLoop
//
//  Created by 沈骏 on 2018/10/22.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import "ViewController.h"

/*
 线程和RunLoop的关系：
 
 1. 线程和 RunLoop 之间是一一对应的，
 2. 其对应关系是保存在一个全局的 Dictionary 里
 3. 线程刚创建时并没有 RunLoop，如果你不主动获取，那它一直都不会有
 4. RunLoop 的创建是发生在第一次获取时，RunLoop 的销毁是发生在线程结束时
 5. 只能在一个线程的内部获取其 RunLoop（主线程除外）。
 
 */

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CFRunLoopRef ref = CFRunLoopGetMain();
}


@end
