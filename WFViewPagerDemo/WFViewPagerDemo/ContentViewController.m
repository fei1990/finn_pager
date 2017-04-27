//
//  ContentViewController.m
//  WFViewPagerDemo
//
//  Created by wangfei on 2017/4/25.
//  Copyright © 2017年 wangfei. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 30)];
    lbl.backgroundColor = [UIColor redColor];
    lbl.text = @"pager";
    [self.view addSubview:lbl];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
