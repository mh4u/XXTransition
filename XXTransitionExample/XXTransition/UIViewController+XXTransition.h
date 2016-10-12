//
//  UIViewController+XXTransition.h
//  XXNavigation
//
//  Created by 许洵 on 16/10/4.
//  Copyright © 2016年 许洵. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXAnimatedTransitioning.h"
@class XXInteractiveTransition;

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (XXTransition) <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>


- (void)xx_presentViewController:(UIViewController *)viewControllerToPresent makeAnimatedTransitioning:(void (^)(XXAnimatedTransitioning *transitioning))block completion:(void (^ __nullable)(void))completion;

@end
NS_ASSUME_NONNULL_END
