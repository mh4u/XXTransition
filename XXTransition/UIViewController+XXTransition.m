//
//  UIViewController+XXTransition.m
//  XXNavigation
//
//  Created by 许洵 on 16/10/4.
//  Copyright © 2016年 许洵. All rights reserved.
//

#import "UIViewController+XXTransition.h"
#import "XXAnimatedTransitioning.h"
#import "XXInteractiveTransition.h"
#import "XXGlobalConst.h"
#import "XXMacro.h"
#import <objc/runtime.h>
#import "XXTransitionManager.h"


@implementation UIViewController (XXTransition)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method sysMethod = class_getInstanceMethod(self.class, @selector(viewDidAppear:));
        Method xxMethod = class_getInstanceMethod(self.class, @selector(xx_viewDidAppear:));
        method_exchangeImplementations(sysMethod, xxMethod);
    });
}

- (void)xx_viewDidAppear:(BOOL)animated {
    if ([XXTransitionManager sharedManager].navTransitionEnable && self.navigationController && self.navigationController.delegate != self) {
        self.navigationController.delegate = self;
    }
    [self xx_viewDidAppear:animated];
}

#pragma mark - AssociatedObject
- (void)setXx_interactive:(XXInteractiveTransition *)xx_interactive {
    objc_setAssociatedObject(self, @selector(xx_interactive), xx_interactive, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XXInteractiveTransition *)xx_interactive {
    return objc_getAssociatedObject(self, @selector(xx_interactive));
}

- (void)setXx_transitioning:(XXAnimatedTransitioning *)xx_transitioning {
    objc_setAssociatedObject(self, @selector(xx_transitioning), xx_transitioning, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XXAnimatedTransitioning *)xx_transitioning {
    return objc_getAssociatedObject(self, @selector(xx_transitioning));
}


#pragma mark - 
- (void)xx_presentViewController:(UIViewController *)viewControllerToPresent makeAnimatedTransitioning:(void (^)(XXAnimatedTransitioning * _Nonnull))block completion:(void (^)(void))completion {
    viewControllerToPresent.transitioningDelegate = viewControllerToPresent;
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
    XXAnimatedTransitioning *transitioning = [[XXAnimatedTransitioning alloc] init];
    block(transitioning);
    transitioning.transitionType = XXTransitionTypePresent;
    viewControllerToPresent.xx_transitioning = transitioning;
    [self presentViewController:viewControllerToPresent animated:YES completion:completion];
}

#pragma mark - Present Dismiss
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    presented.xx_interactive = [[XXInteractiveTransition alloc] initWithTansitionType:XXTransitionTypeDismiss animationKey:presented.xx_transitioning.animationKey];
    [presented.xx_interactive addFullScreenGestureToViewController:presented];
    return presented.xx_transitioning;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    XXAnimatedTransitioning *transitioning = self.xx_transitioning;
    transitioning.transitionType = XXTransitionTypeDismiss;
    return transitioning;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    return self.xx_interactive.popByGesture?self.xx_interactive:nil;
}

#pragma mark - Push Pop
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    XXAnimatedTransitioning *transition = [[XXAnimatedTransitioning alloc] initWithTransitionType:operation == UINavigationControllerOperationPush?XXTransitionTypePush:XXTransitionTypePop ownerViewControllerClass:[self class]];
    if (transition && operation == UINavigationControllerOperationPush) {
        self.xx_interactive = [[XXInteractiveTransition alloc] initWithTansitionType:XXTransitionTypePop animationKey:nil];
        [self.xx_interactive addFullScreenGestureToViewController:self];
    }
    return transition;
}


- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if (((XXAnimatedTransitioning *)animationController).transitionType == XXTransitionTypePop) {
        return self.xx_interactive.popByGesture?self.xx_interactive:nil;
    } else {
        return nil;
    }
}




@end
