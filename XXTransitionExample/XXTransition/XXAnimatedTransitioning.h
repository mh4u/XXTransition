//
//  XXAnimatedTransitioning.h
//  XXNavigation
//
//  Created by 许洵 on 16/10/3.
//  Copyright © 2016年 许洵. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXGlobalConst.h"
@import UIKit;

@interface XXAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) XXTransitionType transitionType;

/*------外部自定义设置-------*/
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, copy) NSString *animationKey;
/*------------------------*/

- (instancetype)initWithTransitionType:(XXTransitionType)transitionType ownerViewControllerClass:(Class)ownerClass;

@end
