//
//  XXTransitionManager.h
//  XXNavigation
//
//  Created by 许洵 on 16/10/3.
//  Copyright © 2016年 许洵. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXGlobalConst.h"
@import UIKit;

NS_ASSUME_NONNULL_BEGIN


@interface XXTransitionManager : NSObject

@property (nonatomic, assign) NSTimeInterval transitionDuration;
@property (nonatomic, assign) BOOL navTransitionEnable;
@property (nonatomic, assign) XXPopGestureType popGestureType;
@property (nonatomic, copy) NSString *animationKey;

+ (instancetype)sharedManager;

//添加自定义转场动画
- (void)addPushAnimation:(NSString *)transitionKey animation:(XXAnimationBlock)animationBlock;

- (void)addPopAnimation:(NSString *)transitionKey animation:(XXAnimationBlock)animationBlock;

- (void)addPresentAnimation:(NSString *)transitionKey animation:(XXAnimationBlock)animationBlock;

- (void)addDismissAnimation:(NSString *)transitionKey backGestureDirection:(XXBackGesture)backGestureDirection animation:(XXAnimationBlock)animationBlock;

//注册使用特例转场效果的ViewController
- (void)registerClass:(Class)vcClass forTransitionKey:(NSString *)transitionKey;
//注册使用特例返回手势的ViewController，不受全局手势设置影响
- (void)registerPopGestureType:(XXPopGestureType)popGestureType forViewController:(Class)vcClass;

#pragma mark -
- (XXAnimationBlock)pushTransitionForViewController:(Class)vcClass;
- (XXAnimationBlock)popTransitionForViewController:(Class)vcClass;
- (XXPopGestureType)popGestureTypeForViewController:(Class)vcClass;

- (XXAnimationBlock)presentTransitionForAnimationKey:(NSString *)animationKey;
- (XXAnimationBlock)dismissTransitionForAnimationKey:(NSString *)animationKey;
- (XXBackGesture)dismissBackGestureDirectionForAnimationKey:(NSString *)animationKey;



@end

NS_ASSUME_NONNULL_END


