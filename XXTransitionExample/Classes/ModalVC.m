//
//  ModalVC.m
//  XXNavigation
//
//  Created by xunxu on 16/10/10.
//  Copyright © 2016年 许洵. All rights reserved.
//

#import "ModalVC.h"

@interface ModalVC ()

@end

@implementation ModalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    UIButton *dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 100, 44)];
    [dismissBtn setTitle:@"dismiss" forState:UIControlStateNormal];
    [dismissBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissAction {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)dealloc {

}
@end
