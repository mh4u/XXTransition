//
//  XXTransition.m
//  XXNavigation
//
//  Created by xunxu on 16/10/8.
//  Copyright © 2016年 许洵. All rights reserved.
//

#import "XXTransition.h"
#import "XXTransitionManager.h"
#import "XXMacro.h"

NSString *const XXTransitionAnimationNavPage = @"XXTransitionAnimationNavPage";
NSString *const XXTransitionAnimationNavSink = @"XXTransitionAnimationNavSink";
NSString *const XXTransitionAnimationNavFragment = @"XXTransitionAnimationNavFragment";

NSString *const XXTransitionAnimationModalSink = @"XXTransitionAnimationModalSink";

@implementation XXTransition


+ (void)startGoodJob:(GoodJobType)goodJobType transitionDuration:(NSTimeInterval)duration {
    if (goodJobType & GoodJobTypeModalOnly) {
        [self loadModalTransitions];
    }
    if (goodJobType & GoodJobTypeNavOnly) {
        [XXTransitionManager sharedManager].animationKey = XXTransitionAnimationNavSink;
        [XXTransitionManager sharedManager].navTransitionEnable = YES;
        [self loadNavTransitions];
    }
    [XXTransitionManager sharedManager].transitionDuration = duration;
}

+ (void)setNavTransitonKey:(NSString *)transitonKey {
    [XXTransitionManager sharedManager].animationKey = transitonKey;
}


+ (void)setPopGestureType:(XXPopGestureType)popGestureType {
    if (popGestureType == XXPopGestureTypeAsGlobal) return;
    [XXTransitionManager sharedManager].popGestureType = popGestureType;
}

+ (void)registerPopGestureType:(XXPopGestureType)popGestureType forViewController:(Class)vcClass {
    [[XXTransitionManager sharedManager] registerPopGestureType:popGestureType forViewController:vcClass];
}


+ (void)loadModalTransitions {
    [self addPresentSinkAnimation];
    [self addDismissSinkAnimation];
    
}

+ (void)loadNavTransitions {
    [self addPushSinkAnimation];
    [self addPopSinkAnimation];
    
    [self addPushPageAnimation];
    [self addPopPageAnimation];
}


+ (void)addPushAnimation:(NSString *)transitionKey animation:(nonnull XXAnimationBlock)animationBlock {
    [[XXTransitionManager sharedManager] addPushAnimation:transitionKey animation:animationBlock];
}

+ (void)addPopAnimation:(NSString *)transitionKey animation:(nonnull XXAnimationBlock)animationBlock{
    [[XXTransitionManager sharedManager] addPopAnimation:transitionKey animation:animationBlock];
}

+ (void)addPresentAnimation:(NSString *)transitionKey animation:(nonnull XXAnimationBlock)animationBlock {
    [[XXTransitionManager sharedManager] addPresentAnimation:transitionKey animation:animationBlock];
}

+ (void)addDismissAnimation:(NSString *)transitionKey backGestureDirection:(XXBackGesture)backGestureDirection animation:(nonnull XXAnimationBlock)animationBlock {
     [[XXTransitionManager sharedManager] addDismissAnimation:transitionKey backGestureDirection:(XXBackGesture)backGestureDirection animation:animationBlock];
}

+ (void)registerPushViewController:(Class)vcClass forTransitonKey:(nonnull NSString *)transitonKey {
    [[XXTransitionManager sharedManager] registerClass:vcClass forTransitionKey:transitonKey];
}


#pragma mark - Push&Pop
+ (void)addPushSinkAnimation {
    [self addPushAnimation:XXTransitionAnimationNavSink animation:^(id<UIViewControllerContextTransitioning>  _Nonnull transitionContext, NSTimeInterval duration) {
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *containerView = [transitionContext containerView];
        UIView *fromView = fromVC.view;
        UIView *toView = toVC.view;
//        [containerView addSubview:fromView];  containerView会自动添加addSubview:fromView
        [containerView addSubview:toView];
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        toView.layer.transform = CATransform3DMakeTranslation(screenWidth,0,0);
        [UIView animateWithDuration:duration animations:^{
            
            fromView.layer.transform = CATransform3DMakeScale(0.95,0.95,1);
            toView.layer.transform = CATransform3DIdentity;
            
        } completion:^(BOOL finished){
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    }];
}

+ (void)addPopSinkAnimation {
    [self addPopAnimation:XXTransitionAnimationNavSink animation:^(id<UIViewControllerContextTransitioning>  _Nonnull transitionContext, NSTimeInterval duration) {
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *containerView = [transitionContext containerView];
    
        UIView *fromView = fromVC.view;
        UIView *toView = toVC.view;
        
        [containerView insertSubview:toView atIndex:0];
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        toView.layer.transform = CATransform3DMakeScale(0.95,0.95,1);
        fromView.layer.transform = CATransform3DIdentity;
        [UIView animateWithDuration:duration animations:^{
            toView.layer.transform = CATransform3DIdentity;
            fromView.layer.transform = CATransform3DMakeTranslation(screenWidth,0,0);
        } completion:^(BOOL finished){
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }];
    
}

+ (void)addPushPageAnimation {
    [self addPushAnimation:XXTransitionAnimationNavPage animation:^(id<UIViewControllerContextTransitioning>  _Nonnull transitionContext, NSTimeInterval duration) {
        UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
        UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        UIView *containerView = [transitionContext containerView];
        
        [containerView addSubview:toView];
//        CGPoint point = CGPointMake(0, 0.5);
//        fromView.frame = CGRectOffset(fromView.frame, (point.x - fromView.layer.anchorPoint.x) * fromView.frame.size.width, (point.y - fromView.layer.anchorPoint.y) * fromView.frame.size.height);
//        fromView.layer.anchorPoint = point;
//        CATransform3D transfrom3d = CATransform3DIdentity;
//        transfrom3d.m34 = -0.002;
//        containerView.layer.sublayerTransform = transfrom3d;
        
        [UIView animateWithDuration:duration animations:^{
            fromView.layer.transform = CATransform3DMakeRotation(-M_PI_2, 1, 1, 0);
            
        } completion:^(BOOL finished) {
           [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    }];
}


+ (void)addPopPageAnimation {
    [self addPopAnimation:XXTransitionAnimationNavPage animation:^(id<UIViewControllerContextTransitioning>  _Nonnull transitionContext, NSTimeInterval duration) {
        UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
        UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:toView];
        
        [UIView animateWithDuration:duration animations:^{
            toView.layer.transform = CATransform3DIdentity;
            toView.alpha = 0.2;
            
        } completion:^(BOOL finished) {
             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    }];
}


#pragma mark - Present&Dismiss
+ (void)addPresentSinkAnimation {
    [self addPresentAnimation:XXTransitionAnimationModalSink animation:^(id<UIViewControllerContextTransitioning>  _Nonnull transitionContext, NSTimeInterval duration) {
        UIView *containerView = [transitionContext containerView];
        UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
        UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        UIView *tempView = [fromView snapshotViewAfterScreenUpdates:NO];
        fromView.hidden = YES;
        UIView *maskView = [[UIView alloc] initWithFrame:tempView.bounds];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0;
        [tempView addSubview:maskView];
        
        [containerView addSubview:tempView];
        [containerView addSubview:toView];
        
        toView.frame = CGRectMake(0, CGRectGetHeight(containerView.frame), CGRectGetWidth(containerView.frame), 400);
        
        [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.5 animations:^{
                tempView.layer.transform = [self sinkTransformFirstPeriod];
                maskView.alpha = 0.2;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:.5 relativeDuration:.5 animations:^{
                tempView.layer.transform = [self sinkTransformSecondPeriod];
                maskView.alpha = 0.4;
                toView.transform = CGAffineTransformMakeTranslation(0, -400);
            }];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//            if ([transitionContext transitionWasCancelled]) {
//                fromView.hidden = NO;
//                [tempView removeFromSuperview];
//                [toView removeFromSuperview];
//            }
        }];
    }];
}

+ (void)addDismissSinkAnimation {
    [self addDismissAnimation:XXTransitionAnimationModalSink backGestureDirection:XXBackGesturePanDown animation:^(id<UIViewControllerContextTransitioning>  _Nonnull transitionContext, NSTimeInterval duration) {

        UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
        UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        UIView *tempView = [transitionContext containerView].subviews[0];
        UIView *maskView = tempView.subviews.lastObject;
        
        [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.5 animations:^{
                fromView.transform = CGAffineTransformIdentity;
                tempView.layer.transform = [self sinkTransformFirstPeriod];
                maskView.alpha = 0.2;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:.5 relativeDuration:.5 animations:^{
                tempView.layer.transform = CATransform3DIdentity;
                maskView.alpha = 0;
            }];
        } completion:^(BOOL finished) {
            if (![transitionContext transitionWasCancelled]) {
                [tempView removeFromSuperview];
                toView.hidden = NO;
            } //失败会自动还原
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }];
}


+ (CATransform3D)sinkTransformFirstPeriod{
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0/-900;
    t = CATransform3DTranslate(t, 0, 0, -100);
    t = CATransform3DRotate(t, 15.0 * M_PI/180.0, 1, 0, 0);
    return t;
    
}

+ (CATransform3D)sinkTransformSecondPeriod{
    CATransform3D t = CATransform3DIdentity;
    t.m34 = [self sinkTransformFirstPeriod].m34;
    t = CATransform3DTranslate(t, 0, -40, 0);
    t = CATransform3DScale(t, 0.8, 0.8, 1);
    return t;
}

@end

