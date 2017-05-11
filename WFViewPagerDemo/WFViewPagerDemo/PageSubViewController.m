//
//  PageSubViewController.m
//  WFViewPagerDemo
//
//  Created by wangfei on 2017/4/24.
//  Copyright © 2017年 wangfei. All rights reserved.
//

#import "PageSubViewController.h"
#import "ViewController.h"

@interface PageSubViewController ()

@end

@implementation PageSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)tabTitlesInTabView:(UIScrollView *)tabScrollView {
    return @[@"头条333",@"头条",@"头条",@"头条",@"头条",@"头条",@"头条",@"天乐商城",@"头条",@"头条头条",@"头条",@"头条",@"头条",@"头条",@"头条",@"头条",@"头条",@"热点"];
}

- (NSArray *)contentVcsInContainerVc:(UIPageViewController *)pagerVc {
    ContentViewController *vc1 = [[ContentViewController alloc]init];
    ViewController *vc2 = [[ViewController alloc]init];
    ContentViewController *vc3 = [[ContentViewController alloc]init];
    ContentViewController *vc4 = [[ContentViewController alloc]init];
    ContentViewController *vc5 = [[ContentViewController alloc]init];
    ContentViewController *vc6 = [[ContentViewController alloc]init];
    ContentViewController *vc7 = [[ContentViewController alloc]init];
    ContentViewController *vc8 = [[ContentViewController alloc]init];
    ContentViewController *vc9 = [[ContentViewController alloc]init];
    ContentViewController *vc10 = [[ContentViewController alloc]init];
    ContentViewController *vc11 = [[ContentViewController alloc]init];
    ContentViewController *vc12 = [[ContentViewController alloc]init];
    ContentViewController *vc13 = [[ContentViewController alloc]init];
    ContentViewController *vc14 = [[ContentViewController alloc]init];
    ContentViewController *vc15 = [[ContentViewController alloc]init];
    ContentViewController *vc16 = [[ContentViewController alloc]init];
    ContentViewController *vc17 = [[ContentViewController alloc]init];
    ViewController *vc18 = [[ViewController alloc]init];
    return @[vc1,vc2,vc3,vc4,vc5,vc6,vc7,vc8,vc9,vc10,vc11,vc12,vc13,vc14,vc15,vc16,vc17,vc18];
}

- (CGFloat)itemTitleFontSize:(UIViewController *)vc {
    return 16;
}

- (UIColor *)colorNormalForTabItems:(UIViewController *)vc {
    return [UIColor grayColor];
}

- (UIColor *)colorSelectedForTabItem:(UIViewController *)vc {
    return [UIColor blackColor];
}

- (UIColor *)colorForLineView:(UIViewController *)vc{
    return [UIColor redColor];
}

- (void)didSelectedTabItemLabel:(UILabel *)lbl withIndex:(NSInteger)index {
    
    NSLog(@"index: %ld", index);
    
}
- (void)didShowContentVc:(UIViewController *)contentVc withTabLbl:(UILabel *)lbl withIndex:(NSInteger)index {
    
    NSLog(@"index: %ld", index);
    
}

- (void)resetFrameWithTab:(UIScrollView *)scrollView pageView:(UIView *)pageView {
    
//    self.navigationItem.titleView = scrollView;
//    
//    [pageView setFrame:CGRectMake(0, 0, pageView.frame.size.width, self.view.frame.size.height)];
    
    
}

@end
