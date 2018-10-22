//
//  UIView+CLap_Extension.h
//  CLap
//
//  Created by 沈骏 on 16/8/4.
//  Copyright © 2016年 CLap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CLap_Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

+ (CGSize)getSizeWithStr:(NSString *)text
                 maxSize:(CGSize)maxSize
                    font:(CGFloat)font;

@end


