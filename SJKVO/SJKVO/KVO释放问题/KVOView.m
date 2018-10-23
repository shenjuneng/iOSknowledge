//
//  KVOView.m
//  SJKVO
//
//  Created by 沈骏 on 2018/10/23.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import "KVOView.h"

@implementation KVOView

- (instancetype)initView
{
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"KVOView" owner:nil options:nil];
    for (id object in objects) {
        if ([object isKindOfClass:[KVOView class]]) {
            self = object;
        }
    }
    
    if (self) {
        
    }
    
    return self;
}

+ (instancetype)KVOView
{
    return [[self alloc] initView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    
    NSLog(@"...%@", change);
}

- (void)removeFromSuperview {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [super removeFromSuperview];
}

@end
