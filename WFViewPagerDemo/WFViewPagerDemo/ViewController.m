//
//  ViewController.m
//  WFViewPagerDemo
//
//  Created by wangfei on 2017/4/24.
//  Copyright © 2017年 wangfei. All rights reserved.
//

#import "ViewController.h"
#import "PageSubViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.tag = 1;
    [btn setFrame:CGRectMake(10, 100, 100, 50)];
    [btn setTitle:@"text" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnAction:(UIButton *)btn {
    
    PageSubViewController *pageVc = [[PageSubViewController alloc]init];
    [self.navigationController pushViewController:pageVc animated:YES];
    
}


@end
