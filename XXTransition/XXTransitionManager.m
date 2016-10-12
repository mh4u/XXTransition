//
//  XXTransitionManager.m
//  XXNavigation
//
//  Created by 许洵 on 16/10/3.
//  Copyright © 2016年 许洵. All rights reserved.
//

#import "XXTransitionManager.h"
#import "XXGlobalConst.h"
#import "XXMacro.h"

NS_INLINE NSString *formatTransitonKey(NSString *transitionKey, NSString *transitionType) {
    return [transitionKey stringByAppendingString:transitionType];
}

@interface XXTransitionManager ()

@property (nonatomic, strong) NSMutableDictionary *registedAnimationDic;
@property (nonatomic, strong) NSMutableDictionary *transitionDic;
@property (nonatomic, strong) NSMutableDictionary *dismissGestureDic;
@property (nonatomic, strong) NSMutableDictionary *registedPopGestureDic;


@end

@implementation XXTransitionManager

+ (id)sharedManager {
    static dispatch_once_t once;
    static XXTransitionManager *sharedManager = nil;
    dispatch_once(&once,^{
        sharedManager = [[self alloc] init];
        [sharedManager initData];
        
    });
    return sharedManager;
}

- (void)initData {
    _transitionDuration = 0.25;
    _transitionDic = [NSMutableDictionary dictionary];
}


- (void)addPushAnimation:(NSString *)transitionKey animation:(nonnull void (^)(id<UIViewControllerContextTransitioning> _Nonnull, NSTimeInterval))animationBlock {
    self.transitionDic[formatTransitonKey(transitionKey, TransitionTypePush)] = animationBlock;
}

- (void)addPopAnimation:(NSString *)transitionKey animation:(nonnull void (^)(id<UIViewControllerContextTransitioning> _Nonnull, NSTimeInterval))animationBlock {
    self.transitionDic[formatTransitonKey(transitionKey, TransitionTypePop)] = animationBlock;
}

- (void)addPresentAnimation:(NSString *)transitionKey animation:(void (^)(id<UIViewControllerContextTransitioning> _Nonnull, NSTimeInterval))animationBlock {
    self.transitionDic[formatTransitonKey(transitionKey, TransitionTypePresent)] = animationBlock;
}

- (void)addDismissAnimation:(NSString *)transitionKey backGestureDirection:(XXBackGesture)backGestureDirection animation:(nonnull XXAnimationBlock)animationBlock {
    self.transitionDic[formatTransitonKey(transitionKey, TransitionTypeDismiss)] = animationBlock;
    self.dismissGestureDic[transitionKey] = @(backGestureDirection);
}


- (void)registerClass:(Class)vcClass forTransitionKey:(nonnull NSString *)transitionKey {
    self.registedAnimationDic[NSStringFromClass(vcClass)] = transitionKey;
}

- (void)registerPopGestureType:(XXPopGestureType)popGestureType forViewController:(Class)vcClass {
    self.registedPopGestureDic[NSStringFromClass(vcClass)] = @(popGestureType);
}

- (XXAnimationBlock)pushTransitionForViewController:(Class)vcClass {
    NSString *animationKey = self.animationKey;;
    if ([self.registedAnimationDic.allKeys containsObject:NSStringFromClass(vcClass)]) {
        animationKey = self.registedAnimationDic[NSStringFromClass(vcClass)];
    }
    NSAssert(animationKey, @"XXTransition error: AnimationKey is nil");
    XXAnimationBlock block = self.transitionDic[formatTransitonKey(animationKey, TransitionTypePush)];
    NSAssert(block, @"XXTransition error: can't find a push transition");
    return block;
}

- (XXAnimationBlock)popTransitionForViewController:(Class)vcClass {
    NSString *animationKey = self.animationKey;;
    if ([self.registedAnimationDic.allKeys containsObject:NSStringFromClass(vcClass)]) {
        animationKey = self.registedAnimationDic[NSStringFromClass(vcClass)];
    }
    NSAssert(animationKey, @"XXTransition error: AnimationKey is nil");
    XXAnimationBlock block = self.transitionDic[formatTransitonKey(animationKey, TransitionTypePop)];
    NSAssert(block, @"XXTransition error: can't find a pop transition");
    return block;
}

- (XXPopGestureType)popGestureTypeForViewController:(Class)vcClass {
    return self.registedPopGestureDic[NSStringFromClass(vcClass)]?[self.registedPopGestureDic[NSStringFromClass(vcClass)] integerValue]:XXPopGestureTypeAsGlobal;
}



- (XXAnimationBlock)presentTransitionForAnimationKey:(NSString *)animationKey {
    XXAnimationBlock block = self.transitionDic[formatTransitonKey(animationKey, TransitionTypePresent)];
    NSAssert(block, @"XXTransition error: can't find a present transition");
    return block;
}

- (XXAnimationBlock)dismissTransitionForAnimationKey:(NSString *)animationKey {
    XXAnimationBlock block = self.transitionDic[formatTransitonKey(animationKey, TransitionTypeDismiss)];
    NSAssert(block, @"XXTransition error: can't find a dismiss transition");
    return block;
}

- (XXBackGesture)dismissBackGestureDirectionForAnimationKey:(NSString *)animationKey {
    return [self.dismissGestureDic[animationKey] integerValue];
}

#pragma mark - property
- (NSMutableDictionary *)registedAnimationDic {
    if (!_registedAnimationDic) {
        _registedAnimationDic = [NSMutableDictionary dictionary];
    }
    return _registedAnimationDic;
}

- (NSMutableDictionary *)dismissGestureDic {
    if (!_dismissGestureDic) {
        _dismissGestureDic = [NSMutableDictionary dictionary];
    }
    return _dismissGestureDic;
}

- (NSMutableDictionary *)registedPopGestureDic {
    if (!_registedPopGestureDic) {
        _registedPopGestureDic = [NSMutableDictionary dictionary];
    }
    return _registedPopGestureDic;
}


@end


