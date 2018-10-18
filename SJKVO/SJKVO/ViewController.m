//
//  ViewController.m
//  SJKVO
//
//  Created by 沈骏 on 2018/10/18.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NSObject+SJKVO.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Person *p = [[Person alloc] init];
    p.name = @"aaa";

    
    [p SJ_addObserver:self forKey:@"namef" withBlock:^(id  _Nonnull observedObject, NSString * _Nonnull observedKey, id  _Nonnull oldV, id  _Nonnull newV) {
        
    }];
}


@end
