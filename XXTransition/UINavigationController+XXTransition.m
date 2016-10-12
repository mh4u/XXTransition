//
//  UINavigationController+XXTransition.m
//  XXNavigation
//
//  Created by 许洵 on 16/10/4.
//  Copyright © 2016年 许洵. All rights reserved.
//

#import "UINavigationController+XXTransition.h"
#import "XXTransitionManager.h"
#import <objc/runtime.h>
#import "XXMacro.h"
@implementation UINavigationController (XXTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method sysPush = class_getInstanceMethod(self.class, @selector(pushViewController:animated:));
        Method xxPush = class_getInstanceMethod(self.class, @selector(xx_pushViewController:animated:));
        method_exchangeImplementations(sysPush, xxPush);
    });
}

- (void)xx_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([XXTransitionManager sharedManager].navTransitionEnable) {
        self.delegate = (id<UINavigationControllerDelegate>)viewController;
    }
    [self xx_pushViewController:viewController animated:animated];
}




@end
