//
//  XXTransition.h
//  XXNavigation
//
//  Created by xunxu on 16/10/8.
//  Copyright © 2016年 许洵. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XXGlobalConst.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, GoodJobType) {
    GoodJobTypeNavOnly = 1 << 0,
    GoodJobTypeModalOnly = 1 << 1,
    GoodJobTypeAll = GoodJobTypeNavOnly | GoodJobTypeModalOnly
};

@interface XXTransition : NSObject

/*
 启动自定义转场
 */
+ (void)startGoodJob:(GoodJobType)goodJobType transitionDuration:(NSTimeInterval)duration;

//设置全局Push&Pop Transiton
+ (void)setNavTransitonKey:(NSString *)transitonKey;

//设置全局返回手势，默认全屏滑动
+ (void)setPopGestureType:(XXPopGestureType)popGestureType;

//注册使用特例返回手势的ViewController，不受全局手势设置影响
+ (void)registerPopGestureType:(XXPopGestureType)popGestureType forViewController:(Class)vcClass;

//用户添加自定义转场动画
+ (void)addPushAnimation:(NSString *)transitionKey animation:(XXAnimationBlock)animationBlock;

+ (void)addPopAnimation:(NSString *)transitionKey animation:(XXAnimationBlock)animationBlock;

+ (void)addPresentAnimation:(NSString *)transitionKey animation:(XXAnimationBlock)animationBlock;

+ (void)addDismissAnimation:(NSString *)transitionKey backGestureDirection:(XXBackGesture)backGestureDirection animation:(XXAnimationBlock)animationBlock;

//注册使用特例转场效果的ViewController
+ (void)registerPushViewController:(Class)vcClass forTransitonKey:(NSString *)transitonKey;

@end


//TransitionKey
UIKIT_EXTERN NSString *const XXTransitionAnimationNavPage;
UIKIT_EXTERN NSString *const XXTransitionAnimationNavSink;

UIKIT_EXTERN NSString *const XXTransitionAnimationModalSink;

NS_ASSUME_NONNULL_END

