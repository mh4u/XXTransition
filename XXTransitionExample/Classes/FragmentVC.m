//
//  FragmentVC.m
//  XXNavigation
//
//  Created by xunxu on 16/10/10.
//  Copyright © 2016年 许洵. All rights reserved.
//

#import "FragmentVC.h"
#import "PageVC.h"
@interface FragmentVC ()

@end

@implementation FragmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.title = @"fragment效果，边缘手势";
    
    UIButton *pushBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 100, 44)];
    [pushBtn setTitle:@"push" forState:UIControlStateNormal];
    [pushBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [pushBtn addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushAction {
    PageVC *ctrler = [[PageVC alloc] init];
    [self.navigationController pushViewController:ctrler animated:YES];
}
@end
