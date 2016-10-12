//
//  AppDelegate.m
//  XXTransitionExample
//
//  Created by xunxu on 16/10/12.
//  Copyright © 2016年 xunxu. All rights reserved.
//

#import "AppDelegate.h"
#import "XXTransition.h"
#import "RootVC.h"
#import "SinkVC.h"
#import "PageVC.h"
#import "FragmentVC.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self transitionSetting];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    RootVC *vc = [[RootVC alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    return YES;
}

- (void)transitionSetting {
    //启动
    [XXTransition startGoodJob:GoodJobTypeAll transitionDuration:0.3];
    
    //更改全局NavTransiton效果
    [XXTransition setNavTransitonKey:XXTransitionAnimationNavPage];
    
    //自定义特殊ViewController的NavTransiton效果和返回手势
    [XXTransition registerPushViewController:[SinkVC class] forTransitonKey:XXTransitionAnimationNavSink];
    [XXTransition registerPushViewController:[PageVC class] forTransitonKey:XXTransitionAnimationNavPage];
    [XXTransition registerPopGestureType:XXPopGestureTypeFullScreen forViewController:[SinkVC class]];
    [XXTransition registerPopGestureType:XXPopGestureTypeForbidden forViewController:[PageVC class]];
    
    //添加自定义NavTransiton效果
    NSString *demoTransitionAnimationFragment = @"demoTransitionAnimationFragment";
    [XXTransition addPushAnimation:demoTransitionAnimationFragment animation:^(id<UIViewControllerContextTransitioning> transitionContext, NSTimeInterval duration) {
        
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *containerView = [transitionContext containerView];
        UIView *toVCTempView = [toVC.view snapshotViewAfterScreenUpdates:YES];
        [containerView addSubview:toVC.view];
        [containerView sendSubviewToBack:toVC.view];
        
        NSMutableArray *fragmentViews = [[NSMutableArray alloc] init];
        
        CGSize size = fromVC.view.frame.size;
        CGFloat fragmentWidth = 20.0f;
        
        NSInteger rowNum = size.width/fragmentWidth + 1;
        for (int i = 0; i < rowNum ; i++) {
            
            for (int j = 0; j < size.height/fragmentWidth + 1; j++) {
                
                CGRect rect = CGRectMake(i*fragmentWidth, j*fragmentWidth, fragmentWidth, fragmentWidth);
                UIView *fragmentView = [toVCTempView resizableSnapshotViewFromRect:rect  afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
                [containerView addSubview:fragmentView];
                [fragmentViews addObject:fragmentView];
                fragmentView.frame = rect;
                fragmentView.layer.transform = CATransform3DMakeTranslation( random()%50 *50, 0, 0);
                fragmentView.alpha = 0;
            }
            
        }
        
        
        [UIView animateWithDuration:duration animations:^{
            for (UIView *fragmentView in fragmentViews) {
                fragmentView.layer.transform = CATransform3DIdentity;
                fragmentView.alpha = 1;
                
            }
        } completion:^(BOOL finished) {
            for (UIView *fragmentView in fragmentViews) {
                [fragmentView removeFromSuperview];
            }
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }];
    
    [XXTransition addPopAnimation:demoTransitionAnimationFragment animation:^(id<UIViewControllerContextTransitioning> transitionContext, NSTimeInterval duration) {
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *containerView = [transitionContext containerView];
        UIView *fromTempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
        
        [containerView addSubview:toVC.view];
        
        NSMutableArray *fragmentViews = [[NSMutableArray alloc] init];
        
        CGSize size = fromVC.view.frame.size;
        CGFloat fragmentWidth = 20.0f;
        
        NSInteger rowNum = size.width/fragmentWidth + 1;
        for (int i = 0; i < rowNum ; i++) {
            
            for (int j = 0; j < size.height/fragmentWidth + 1; j++) {
                
                CGRect rect = CGRectMake(i*fragmentWidth, j*fragmentWidth, fragmentWidth, fragmentWidth);
                UIView *fragmentView = [fromTempView resizableSnapshotViewFromRect:rect  afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
                [containerView addSubview:fragmentView];
                [fragmentViews addObject:fragmentView];
                fragmentView.frame = rect;
            }
            
        }
        
        [UIView animateWithDuration:duration animations:^{
            for (UIView *fragmentView in fragmentViews) {
                
                CGRect rect = fragmentView.frame;
                
                rect.origin.x = rect.origin.x + random()%50 *50;
                fragmentView.frame = rect;
                fragmentView.alpha = 0.0;
            }
        } completion:^(BOOL finished) {
            for (UIView *fragmentView in fragmentViews) {
                [fragmentView removeFromSuperview];
            }
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    }];
    
    [XXTransition registerPopGestureType:XXPopGestureTypeScreenEdge forViewController:[FragmentVC class]];
    [XXTransition registerPushViewController:[FragmentVC class] forTransitonKey:demoTransitionAnimationFragment];
    
    //添加自定义ModalTransiton效果,使用需调用UIViewController+XXTransition方法 - xx_presentViewController: makeAnimatedTransitioning: completion:
    NSString *demoTransitionAnimationModalSink = @"DemoTransitionAnimationModalSink";
    __weak typeof(self) weakSelf = self;
    [XXTransition addPresentAnimation:demoTransitionAnimationModalSink animation:^(id<UIViewControllerContextTransitioning> transitionContext, NSTimeInterval duration) {
        UIView *containerView = [transitionContext containerView];
        UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
        UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        UIView *tempView = [fromView snapshotViewAfterScreenUpdates:NO];
        fromView.hidden = YES;
        
        [containerView addSubview:tempView];
        [containerView addSubview:toView];
        
        toView.frame = CGRectMake(0, CGRectGetHeight(containerView.frame), CGRectGetWidth(containerView.frame), 400);
        
        [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.5 animations:^{
                tempView.layer.transform = [weakSelf sinkTransformFirstPeriod];;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:.5 relativeDuration:.5 animations:^{
                tempView.layer.transform = [weakSelf sinkTransformSecondPeriod];
                toView.transform = CGAffineTransformMakeTranslation(0, -400);
            }];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }];
    
    [XXTransition addDismissAnimation:demoTransitionAnimationModalSink backGestureDirection:XXBackGesturePanDown animation:^(id<UIViewControllerContextTransitioning> transitionContext, NSTimeInterval duration) {
        UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
        UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        UIView *tempView = [transitionContext containerView].subviews[0];
        
        [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.5 animations:^{
                fromView.transform = CGAffineTransformIdentity;
                tempView.layer.transform = [weakSelf sinkTransformFirstPeriod];
            }];
            
            [UIView addKeyframeWithRelativeStartTime:.5 relativeDuration:.5 animations:^{
                tempView.layer.transform = CATransform3DIdentity;
            }];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            if (![transitionContext transitionWasCancelled]) {
                toView.hidden = NO;
                [tempView removeFromSuperview];
            }
        }];
    }];
}

- (CATransform3D)sinkTransformFirstPeriod{
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0/-900;
    t = CATransform3DTranslate(t, 0, 0, -100);
    t = CATransform3DRotate(t, 15.0 * M_PI/180.0, 1, 0, 0);
    return t;
    
}

- (CATransform3D)sinkTransformSecondPeriod{
    CATransform3D t = CATransform3DIdentity;
    t.m34 = [self sinkTransformFirstPeriod].m34;
    t = CATransform3DTranslate(t, 0, -40, 0);
    t = CATransform3DScale(t, 0.8, 0.8, 1);
    return t;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
