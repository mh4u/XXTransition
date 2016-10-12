//
//  XXAnimatedTransitioning.m
//  XXNavigation
//
//  Created by 许洵 on 16/10/3.
//  Copyright © 2016年 许洵. All rights reserved.
//

#import "XXAnimatedTransitioning.h"
#import "XXTransitionManager.h"
#import "XXGlobalConst.h"
#import "XXMacro.h"
@interface XXAnimatedTransitioning ()

@property (nonatomic, assign) Class ownerClass;

@end

@implementation XXAnimatedTransitioning

- (instancetype)initWithTransitionType:(XXTransitionType)transitionType ownerViewControllerClass:(__unsafe_unretained Class)ownerClass {
    if (self = [super init]) {
        _transitionType = transitionType;
        _ownerClass = ownerClass;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.transitionType) {
        case XXTransitionTypePresent:
            [self presentAnimation:transitionContext];
            break;
        case XXTransitionTypeDismiss:
            [self dismissAnimation:transitionContext];
            break;
        case XXTransitionTypePush:
            [self pushAnimation:transitionContext];
            break;
        case XXTransitionTypePop:
            [self popAnimation:transitionContext];
            break;
        default:
            return;
    }
}

- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    void (^presentAnimationBlock)(id<UIViewControllerContextTransitioning>, NSTimeInterval) =  [[XXTransitionManager sharedManager] presentTransitionForAnimationKey:_animationKey];
    presentAnimationBlock(transitionContext, self.duration);
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    void (^dismissAnimationBlock)(id<UIViewControllerContextTransitioning>, NSTimeInterval) =  [[XXTransitionManager sharedManager] dismissTransitionForAnimationKey:_animationKey];
    dismissAnimationBlock(transitionContext, self.duration);
}


- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    void (^pushAnimationBlock)(id<UIViewControllerContextTransitioning>, NSTimeInterval) =  [[XXTransitionManager sharedManager] pushTransitionForViewController:_ownerClass];
    pushAnimationBlock(transitionContext, self.duration);
}


- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    void (^popAnimationBlock)(id<UIViewControllerContextTransitioning>, NSTimeInterval) =  [[XXTransitionManager sharedManager] popTransitionForViewController:_ownerClass];
    popAnimationBlock(transitionContext, self.duration);
}

#pragma mark - 
- (NSTimeInterval)duration {
    return _duration?_duration:[XXTransitionManager sharedManager].transitionDuration;
}

- (void)dealloc {
    XXLog(@"%@--销毁",self);
}

@end
