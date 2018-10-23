//
//  KVOView.h
//  SJKVO
//
//  Created by 沈骏 on 2018/10/23.
//  Copyright © 2018年 沈骏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KVOView : UIView

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

+ (instancetype)KVOView;

@end

NS_ASSUME_NONNULL_END
