//
//  Person.h
//  SJRuntime
//
//  Created by 沈骏 on 2018/10/18.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (copy, nonatomic) NSString *name;

@property (assign, nonatomic) NSInteger age;

+ (void)impName1;

- (void)objcFunc1;

@end

NS_ASSUME_NONNULL_END
