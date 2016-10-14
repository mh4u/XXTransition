//
//  RootVC.m
//  XXNavigation
//
//  Created by 许洵 on 16/10/2.
//  Copyright © 2016年 许洵. All rights reserved.
//

#import "RootVC.h"
#import "SinkVC.h"
#import "UIViewController+XXTransition.h"
#import "XXTransition.h"
#import "ModalVC.h"

static NSString *RootVCCellId = @"RootVCCellId";
@interface RootVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadViews];
    [self loadData];
}

- (void)loadViews {
    self.title = @"Root VC";
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:RootVCCellId];
    [self.view addSubview:_tableView];
    
}

- (void)loadData {
    _data = @[@"多种转场手势组合走起--致敬蛋疼的需求", @"自定义present效果"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RootVCCellId forIndexPath:indexPath];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = _data[indexPath.row];
    return cell;
}


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
            transitioning.animationKey = @"DemoTransitionAnimationModalSink";
        } completion:NULL];
    }
}




@end
