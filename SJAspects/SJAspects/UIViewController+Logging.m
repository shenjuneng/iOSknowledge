//
//  UIViewController+Logging.m
//  SJAspects
//
//  Created by 沈骏 on 2018/10/19.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import "UIViewController+Logging.h"
#import "Aspects.h"

@implementation UIViewController (Logging)

+ (void)load {
    [UIViewController aspect_hookSelector:@selector(viewDidAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated){
        
        NSString *className = NSStringFromClass([[aspectInfo instance] class]);
        NSLog(@"%@", className);
    } error:NULL];
}

@end
