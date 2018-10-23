//
//  SecondViewController.m
//  SJKVO
//
//  Created by 沈骏 on 2018/10/23.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import "SecondViewController.h"
#import "KVOView.h"

@interface SecondViewController ()

@property (strong, nonatomic) KVOView *kvoView;

@end

@implementation SecondViewController



/**
 观察者模式， 在不需要的时候都需释放
 
 通知中心：如果不释放， 什么也不会发生， 但是会有内存泄漏， 会有多次注册的可能
 KVO：如果不释放， 会奔溃 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.p = [[Person alloc] init];
//    Person *p2 = [[Person alloc] init];
//
//    [p2 addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
//
//    p2.name = @"ccc";
    
    self.kvoView = [KVOView KVOView];
    [self.view addSubview:self.kvoView];
    
}

- (IBAction)clickChangeNamePro:(UIButton *)sender {
//    self.p.name = @"bbb";
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    NSLog(@"...");
//}

@end
