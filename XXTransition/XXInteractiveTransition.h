//
//  XXInteractiveTransition.h
//  XXNavigation
//
//  Created by 许洵 on 16/10/3.
//  Copyright © 2016年 许洵. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXGlobalConst.h"
@import UIKit;
@interface XXInteractiveTransition : UIPercentDrivenInteractiveTransition



@property (nonatomic, assign) BOOL popByGesture; //是否通过手势返回

- (instancetype)initWithTansitionType:(XXTransitionType)transitionType animationKey:(NSString *)animationKey;

- (void)addFullScreenGestureToViewController:(UIViewController *)vc;

@end
