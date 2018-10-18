//
//  NSObject+SJKVO.h
//  SJKVO
//
//  Created by 沈骏 on 2018/10/18.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SJKVO)

- (void)SJ_addObserver:(NSObject *)observer
                forKey:(NSString *)key
             withBlock:(void(^)(id observedObject, NSString *observedKey, id oldV, id newV))block;

- (void)SJ_removeObserver:(NSObject *)observer
                   forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
