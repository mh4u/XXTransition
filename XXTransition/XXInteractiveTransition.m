//
//  XXInteractiveTransition.m
//  XXNavigation
//
//  Created by 许洵 on 16/10/3.
//  Copyright © 2016年 许洵. All rights reserved.
//

#import "XXInteractiveTransition.h"
#import "XXMacro.h"
#import "XXTransitionManager.h"
@interface XXInteractiveTransition ()

@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, assign) XXTransitionType transitionType;
@property (nonatomic, assign) XXBackGesture gestureDirection;
@property (nonatomic, copy) NSString *animationKey;

@end

@implementation XXInteractiveTransition

- (instancetype)initWithTansitionType:(XXTransitionType)transitionType animationKey:(NSString *)animationKey {
    if (self = [super init]) {
        self.transitionType = transitionType;
        self.animationKey = animationKey;
    }
    return self;
}

- (void)addFullScreenGestureToViewController:(UIViewController *)vc {
    UIPanGestureRecognizer *pan;
    if (self.transitionType == XXTransitionTypePop) {
        XXPopGestureType gestureType = [[XXTransitionManager sharedManager] popGestureTypeForViewController:vc.class];
        if (gestureType == XXPopGestureTypeAsGlobal)
            gestureType = [XXTransitionManager sharedManager].popGestureType;
        switch (gestureType) {
            case XXPopGestureTypeFullScreen:
                pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
                break;
            case XXPopGestureTypeScreenEdge:
                pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
                ((UIScreenEdgePanGestureRecognizer *)pan).edges = UIRectEdgeLeft;
                break;
            case XXPopGestureTypeForbidden:
                return;
            default:
                return;
        }
    } else if (self.transitionType == XXTransitionTypeDismiss) {
        if (self.gestureDirection == XXBackGestureNone) return;
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    }
    self.vc = vc;
    [vc.view addGestureRecognizer:pan];
}

-(void)panAction:(UIPanGestureRecognizer *)pan{
    
    CGFloat percent = 0.0;
    CGFloat totalWidth = pan.view.bounds.size.width;
    CGFloat totalHeight = pan.view.bounds.size.height;
    switch (self.gestureDirection) {
        case XXBackGesturePanLeft:{
            CGFloat x = [pan translationInView:pan.view].x;
            percent = -x/totalWidth;
        }
            break;
        case XXBackGesturePanRight:{
            CGFloat x = [pan translationInView:pan.view].x;
            percent = x/totalWidth;
        }
            break;
        case XXBackGesturePanDown:{
            CGFloat y = [pan translationInView:pan.view].y;
            percent = y/totalHeight;
        }
            break;
        case XXBackGesturePanUp:{
            CGFloat y = [pan translationInView:pan.view].y;
            percent = -y/totalHeight;
        }
            break;
        case XXBackGestureNone:
            return;
        default:
            return;
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            [self startGesture];
            break;
        case UIGestureRecognizerStateChanged:
            [self updateInteractiveTransition:percent];
            break;
        case UIGestureRecognizerStateEnded:
            _popByGesture = NO;
            if (percent > 0.5) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            break;
        default:
            break;
    }
}

- (void)startGesture {
    _popByGesture = YES;
    switch (self.transitionType) {
        case XXTransitionTypePop:
            [_vc.navigationController popViewControllerAnimated:YES];
            break;
        case XXTransitionTypeDismiss:
            [_vc dismissViewControllerAnimated:YES completion:NULL];
            break;
        default:
            break;
    }
}

- (XXBackGesture)gestureDirection {
    switch (self.transitionType) {
        case XXTransitionTypePop:
            return XXBackGesturePanRight;
        case XXTransitionTypeDismiss:
            return [[XXTransitionManager sharedManager] dismissBackGestureDirectionForAnimationKey:self.animationKey];
        default:
            return XXBackGestureNone;
    }
}

- (void)dealloc {
    XXLog(@"%@--销毁",self);
}

@end
