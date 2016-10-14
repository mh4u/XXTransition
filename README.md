# XXTransition
先上Demo 效果

![Demo展示](http://upload-images.jianshu.io/upload_images/680225-8e2349549a6f5dde.gif?imageMogr2/auto-orient/strip)

####XXTransition 是什么鬼？
经历过几个公司，领导换了一波波，产品换了一波波，App的转场动画也是换了一波波，于是各种 AnimatedTransitioning、 InteractiveTransition代码也写了一波波。如果项目中用到多种转场效果，那代码目录可能是像这样的。
![](http://upload-images.jianshu.io/upload_images/680225-d82c74519c330546.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

每个效果都分别有对应的实现了AnimatedTransitioning和InteractiveTransition逻辑的文件。

能不能简单点？方便的管理项目中用到的转场动画，方便的添加转场效果，同时也能满足各种转场效果的切换，手势交互的切换？ Yes，u can ! 这正是XXTransition能帮你做到的，请为它转身。

####XXTransition 为嘛来到这世上？
* 方便添加自定义转场效果，将重心放在动画效果的实现上
* 自由管理项目中多种转场动画，转场手势的切换，(妈妈再也不用担心恶心的需求啦)
* 对于原使用系统转场的工程，集成后无需修改任何原代码。
* 提供转场动画库。我会不断添加朴实无华和牛哔闪闪的转场动画在代码中，供你直接调用。这些效果，包括我自己亲手和不是亲手写的，如有雷同，别计较啦，都是分享啦，当然如果有大牛小牛给我投稿，我会很开心哒，也会在代码中注释出处哒。

####XXTransition 该怎么跑起来？

#####安装
 Github地址:https://github.com/mh4u/XXTransition/
将XXTransition目录文件拖到工程中即可

#####使用
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     
       //启动XXTransition自定义转场
      [XXTransition startGoodJob:GoodJobTypeAll transitionDuration:0.3];

      self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
      [self.window makeKeyAndVisible];
      RootVC *vc = [[RootVC alloc] init];
      self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
      return YES;
    }

这样一句话调用就可以开始工作啦！

#####Nav转场
* 初阶


     + (void)startGoodJob:(GoodJobType)goodJobType transitionDuration:(NSTimeInterval)duration;
该方法的第一个参数是枚举值

    typedef NS_OPTIONS(NSUInteger, GoodJobType) {
        GoodJobTypeNavOnly = 1 << 0,
        GoodJobTypeModalOnly = 1 << 1,
        GoodJobTypeAll = GoodJobTypeNavOnly | GoodJobTypeModalOnly
      };

可以设置只使用自定义Nav转场还是Modal转场，或者全部使用。XXTransition会在提供的转场效果中设定一个默认的Nav转场效果。如果你原先工程中使用的是系统的Nav转场效果，那恭喜你，现在不需要改其他代码就已经可以实现自定义转场了哦（使用Modal转场和Nav转场有所区别，往下看）。

如果你想换一个XXTransition提供的Nav转场，这样设置就可以啦。

    //启动XXTransition自定义转场
    [XXTransition startGoodJob:GoodJobTypeAll transitionDuration:0.3];
    //更改全局NavTransiton效果
    [XXTransition setNavTransitonKey:XXTransitionAnimationNavPage];

可是按照PM的要求，是一个全新的转场效果怎么办，得自己写啦。XXTransition可以让你专注于动画的实现，交互手势都不用care

     //添加自定义NavTransiton效果
     NSString *someNBTransitionAnimation = @“someNBTransitionAnimation";
     [XXTransition addPushAnimation:demoTransitionAnimationFragment animation:^(id<UIViewControllerContextTransitioning> transitionContext, NSTimeInterval duration) {
          //Push动画逻辑
      }];

      [XXTransition addPopAnimation:demoTransitionAnimationFragment animation:^(id<UIViewControllerContextTransitioning> transitionContext, NSTimeInterval duration) {
        //Pop动画逻辑
      }];

       //更改全局NavTransiton效果
      [XXTransition setNavTransitonKey:someNBTransitionAnimation];

* 进阶

一般情况下，一个App只会用一种转场效果，但有讲究有追求的话，可能需要多种转场效果配合不同交互手势在不同VC互相push,pop时进行切换，简单画个图你就明白了

![偶买噶](http://upload-images.jianshu.io/upload_images/680225-7af0139c875bc4d7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
你遇到过吗，遇到了麻烦给个赞或者星，表示同病相怜，没遇到也麻烦给个星或者赞，因为我遇到了，让我感受到你的温暖。碰到这种情况，不要蓝瘦，不用香菇，看看XXTransition怎么解决。
    
    //启动XXTransition自定义转场
    [XXTransition startGoodJob:GoodJobTypeAll transitionDuration:0.3];

    //更改全局NavTransiton效果
    [XXTransition setNavTransitonKey:XXTransitionAnimationNavPage];

    //注册特殊ViewController的NavTransiton效果和返回手势
    [XXTransition registerPushViewController:[SinkVC class] forTransitonKey:XXTransitionAnimationNavSink];
    [XXTransition registerPushViewController:[PageVC class] forTransitonKey:XXTransitionAnimationNavPage];
    [XXTransition registerPopGestureType:XXPopGestureTypeFullScreen forViewController:[SinkVC class]];
    [XXTransition registerPopGestureType:XXPopGestureTypeForbidden forViewController:[PageVC class]];

就这样，OK啦。SinkVC和PageVC分别使用响应的Nav转场效果和返回手势，而其他VC则使用全局转场效果

#####Modal转场
Modal切换ViewController的XXTransition使用方法和Nav有所不同，要在需要Present的使用调用UIViewController+XXTransition.h定义的方法

    - (void)xx_presentViewController:(UIViewController *)viewControllerToPresent makeAnimatedTransitioning:(void (^)(XXAnimatedTransitioning *transitioning))block completion:(void (^ __nullable)(void))completion
使用如下
    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
      if (indexPath.row == 0) {
          SinkVC *vc =[[SinkVC alloc] init];
          [self.navigationController pushViewController:vc animated:YES];
      } else {
          ModalVC *vc = [[ModalVC alloc] init];
          //XXTransition Modal转场
          [self xx_presentViewController:vc makeAnimatedTransitioning:^(XXAnimatedTransitioning * _Nonnull transitioning) {
              transitioning.duration = 0.5;
              transitioning.animationKey = XXTransitionAnimationModalSink;
          } completion:NULL];
      }
    }

如果你需要自己敲一个新的转场动画，类似于Nav转场中的自定义，专注动画实现，在下面两个方法中实现动画逻辑

    [XXTransition addPresentAnimation:demoTransitionAnimationModalSink animation:^(id<UIViewControllerContextTransitioning> transitionContext, NSTimeInterval duration) {
     //Present 转场逻辑
    }];  

    [XXTransition addDismissAnimation:demoTransitionAnimationModalSink backGestureDirection:XXBackGesturePanDown animation:^(id<UIViewControllerContextTransitioning> transitionContext, NSTimeInterval duration) {
     //Dismiss 转场逻辑
    }];

XXTransition 在dismiss的转场交互中，支持下面几中选择

    typedef NS_ENUM(NSInteger,XXBackGesture){
      XXBackGestureNone, //禁用手势
      XXBackGesturePanLeft,
      XXBackGesturePanRight,
      XXBackGesturePanUp,
      XXBackGesturePanDown,
    };

#####最后
如果你在使用XXTransition过程中发现任何问题，或是有任何建议，欢迎勾搭我。



 
