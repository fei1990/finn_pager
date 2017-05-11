//
//  TLBasePagerViewController.m
//  WFViewPagerDemo
//
//  Created by wangfei on 2017/4/24.
//  Copyright © 2017年 wangfei. All rights reserved.
//

#import "TLBasePagerViewController.h"

const CGFloat tabViewLeftGap = 5;

const CGFloat tabViewTopGap = 5;

const CGFloat tabLblGap = 5;

const CGFloat textHeight = 20;

@interface TLBasePagerViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate,TLPageViewDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (nonatomic, strong) UIScrollView *tabScrollView;

@property (nonatomic, strong) CALayer *lineLayer;

/**
 所有标题
 */
@property (nonatomic, strong) NSArray *tabTitlesArr;

/**
 内容控制器
 */
@property (nonatomic, strong) NSArray *contentVcsArr;

/**
 tabView array
 */
@property (nonatomic, strong) NSMutableArray *tabViewArr;

/**
 当前显示contentVc的索引
 */
@property (nonatomic, assign) NSInteger currentIndex;

/**
 下一个要显示的contentVc的索引
 */
@property (nonatomic, assign) NSInteger pendingIndex;

/**
 没被选中的tab item字体颜色
 */
@property (nonatomic, strong) UIColor *tabItemColorForNormal;

/**
 被选中的tab item字体颜色
 */
@property (nonatomic, strong) UIColor *tabItemColorForSelected;

/**
 标题的字体大小
 */
@property (nonatomic, assign) CGFloat itemTitleFontSize;

/**
 指示线颜色
 */
@property (nonatomic, strong) UIColor *lineColor;

@end

@implementation TLBasePagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.数据源及代理设置
    self.pageViewDataSource = self;
    self.pageViewDelegate = self;
    
    //2.获取默认配置
    [self getTitlesAndContentVCFromDataSource];
    
    //3.add subView
    [self.view addSubview:self.tabScrollView];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    //4.布局tab栏
    [self layoutTabElements];
    
    //5.重置frame 默认基类不做任何修改 子类重写此方法起作用
    [self resetFrameWithTab:self.tabScrollView pageView:self.pageViewController.view];
    
    //6.显示指定的控制器
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self showContentVc];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (UIScrollView *)tabScrollView {
    if (!_tabScrollView) {
        _tabScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        _tabScrollView.delegate = self;
        _tabScrollView.showsVerticalScrollIndicator = NO;
        _tabScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _tabScrollView;
}

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        UIScrollView *pageScroll = _pageViewController.view.subviews[0];
        pageScroll.delegate = self;
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        [_pageViewController.view setFrame:CGRectMake(0, CGRectGetMaxY(self.tabScrollView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.tabScrollView.frame))];
    }
    return _pageViewController;
}

- (NSMutableArray *)tabViewArr {
    if (!_tabViewArr) {
        _tabViewArr = [NSMutableArray array];
    }
    return _tabViewArr;
}

- (CALayer *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [CALayer layer];
        _lineLayer.borderWidth = 1;
        _lineLayer.borderColor = self.lineColor.CGColor;
        [_lineLayer setFrame:CGRectMake(0, CGRectGetHeight(self.tabScrollView.frame) - 10, 100, 1)];
    }
    return _lineLayer;
}

//2
- (void)getTitlesAndContentVCFromDataSource {
    if ([self.pageViewDataSource respondsToSelector:@selector(colorNormalForTabItems:)]) {
        self.tabItemColorForNormal = [self.pageViewDataSource colorNormalForTabItems:self];
    }
    if ([self.pageViewDataSource respondsToSelector:@selector(colorSelectedForTabItem:)]) {
        self.tabItemColorForSelected = [self.pageViewDataSource colorSelectedForTabItem:self];
    }
    if ([self.pageViewDataSource respondsToSelector:@selector(colorForLineView:)]) {
        self.lineColor = [self.pageViewDataSource colorForLineView:self];
    }
    if ([self.pageViewDataSource respondsToSelector:@selector(itemTitleFontSize:)]) {
        self.itemTitleFontSize = [self.pageViewDataSource itemTitleFontSize:self];
    }
    if ([self.pageViewDataSource respondsToSelector:@selector(tabTitlesInTabView:)]) {
        self.tabTitlesArr = [self.pageViewDataSource tabTitlesInTabView:self.tabScrollView];
    }
    if ([self.pageViewDataSource respondsToSelector:@selector(contentVcsInContainerVc:)]) {
        self.contentVcsArr = [self.pageViewDataSource contentVcsInContainerVc:self.pageViewController];
    }
    NSAssert2(self.tabTitlesArr.count == self.contentVcsArr.count, @"标题数量: %ld, 控制器数量: %ld, 必须保证数量相等", self.tabTitlesArr.count, self.contentVcsArr.count);
}

//4
- (void)layoutTabElements {
    
    CGFloat contentWidth = 0;
    
    CGFloat contentHeight = 0;
    
    for (NSInteger i = 0; i < self.tabTitlesArr.count; i++) {
        
        NSString *tabTitle = [self titleForTabAtIndex:i];
        
        CGSize textSize = [tabTitle textSizeWithHeight:textHeight fontSize:self.itemTitleFontSize];
        
        UIView *tabView = [self createTabViewWithIndex:i textSize:textSize tabTitle:tabTitle];
        
        [self.tabScrollView addSubview:tabView];
        
        contentWidth += CGRectGetWidth(tabView.frame);
        
        if (i == self.tabTitlesArr.count - 1) {
            contentWidth = contentWidth + tabViewTopGap * (self.tabTitlesArr.count + 1);
            contentHeight = CGRectGetHeight(tabView.frame);
        }
        
    }
    
    [self.tabScrollView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), contentHeight + 2 * tabViewTopGap)];
    
    [self.pageViewController.view setFrame:CGRectMake(0, CGRectGetMaxY(self.tabScrollView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.tabScrollView.frame))];
    
    [self.tabScrollView setContentSize:CGSizeMake(contentWidth, contentHeight + 2 * tabViewTopGap)];
    [self.tabScrollView.layer addSublayer:self.lineLayer];
}

- (UIView *)createTabViewWithIndex:(NSInteger)index textSize:(CGSize)textSize tabTitle:(NSString *)title {
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(tabLblGap, tabLblGap, textSize.width, textSize.height)];
    lbl.tag = index;
    lbl.font = [UIFont systemFontOfSize:self.itemTitleFontSize];
    lbl.textColor = self.tabItemColorForNormal;
    lbl.text = title;
    
    //获取前一个tabView
    UIView *preTabView = [self tabViewAtIndex:index - 1];
    
    UIView *tabView = [[UIView alloc]initWithFrame:CGRectMake((preTabView == nil ? tabViewLeftGap : CGRectGetMaxX(preTabView.frame) + tabViewLeftGap), tabViewTopGap, CGRectGetWidth(lbl.frame) + 2 * tabLblGap, CGRectGetHeight(lbl.frame) + 2 * tabLblGap)];
    tabView.tag = index;
    [tabView addSubview:lbl];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTabView:)];
    [tabView addGestureRecognizer:tap];
    
    //保存tabView
    [self.tabViewArr addObject:tabView];
    
    return tabView;
}

//5
- (void)resetFrameWithTab:(UIScrollView *)scrollView pageView:(UIView *)pageView {
    
}

- (void)scrollToNextContentVcWithIndex:(NSInteger)index {
    
    if (index < 0 || index >= self.tabTitlesArr.count) {
        return;
    }
    
    //获取tabView
    UIView *tabView = [self tabViewAtIndex:index];
    
    //获取tabLbl
    UILabel *tabLbl = [self tabLblOnView:tabView];
    
    //改变指定lbl的字体颜色
    tabLbl.textColor = self.tabItemColorForSelected;
    
    //重置line的frame
    [self.lineLayer setFrame:CGRectMake(CGRectGetMinX(tabView.frame) + tabLblGap, CGRectGetHeight(tabView.frame) + tabViewTopGap - 1, CGRectGetWidth(tabLbl.frame), 1)];
    
    CGFloat tabViewWidth = CGRectGetWidth(tabView.frame);
    
    CGFloat move_X = CGRectGetWidth(self.tabScrollView.frame) / 2 - tabViewWidth / 2;
    
    [self.tabScrollView scrollRectToVisible:CGRectMake(CGRectGetMinX(tabView.frame) - move_X, CGRectGetMinY(tabView.frame), CGRectGetWidth(self.tabScrollView.frame), CGRectGetHeight(tabView.frame)) animated:YES];
    
    //设置当前显示的contentVc的index
    self.currentIndex = index;
    
}

//6.
- (void)showContentVc {
    
    self.currentIndex = 0;
    
    if ([self.pageViewDataSource respondsToSelector:@selector(defaultSelectContentVc:)]) {
        self.currentIndex = [self.pageViewDataSource defaultSelectContentVc:self.pageViewController];
    }
    
    NSAssert(self.currentIndex < self.tabTitlesArr.count, @"标题数量: %ld, 当前默认选择要显示的索引: %ld, 越界了...", self.tabTitlesArr.count, self.currentIndex);
    
    self.pendingIndex = self.currentIndex + 1;
    
    UIViewController *contentVc = [self contentVcWithIndex:self.currentIndex];
    [self.pageViewController setViewControllers:@[contentVc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    
    [self scrollToNextContentVcWithIndex:self.currentIndex];
    
}

- (void)changePreLblStatesWithIndex:(NSInteger)index {
        if (index < 0 || index >= self.tabTitlesArr.count) {
        return;
    }
    
    //获取tabView
    UIView *tabView = [self tabViewAtIndex:index];
    
    //获取tabLbl
    UILabel *tabLbl = [self tabLblOnView:tabView];
    
    //改变指定lbl的字体颜色
    tabLbl.textColor = self.tabItemColorForNormal;
    
}

#pragma mark - 获取指定索引的标题
- (NSString *)titleForTabAtIndex:(NSInteger)index {
    NSAssert(index < self.tabTitlesArr.count, @"tabTitlesArr count: %ld, index: %ld...越界了!!!", self.tabTitlesArr.count, index);
    return self.tabTitlesArr[index];
}

- (UIView *)tabViewAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.tabViewArr.count) {
        return nil;
    }
    return self.tabViewArr[index];
}

- (UILabel *)tabLblOnView:(UIView *)tabView {
    
    UILabel *tabLbl = [tabView viewWithTag:tabView.tag];
    
    for (UIView *subView in tabView.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            tabLbl = (UILabel *)subView;
        }
    }
    
    return tabLbl;
}

#pragma mark - 点击tab进行内容控制器的切换
- (void)tapTabView:(UIGestureRecognizer *)tapGesture {
    
    UIView *tabView = tapGesture.view;
    
    UILabel *tabLbl = [self tabLblOnView:tabView];
    
    NSInteger tapViewTag = tabView.tag;
    
    //记录下即将要显示的contentVc的索引
    self.pendingIndex = tapViewTag;
    
    [self changePreLblStatesWithIndex:self.currentIndex];
    
    [self scrollToNextContentVcWithIndex:tapViewTag];
    
    UIViewController *contentVc = [self contentVcWithIndex:tapViewTag];
    
    __weak typeof(self) weakSelf = self;
    [self.pageViewController setViewControllers:@[contentVc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        
        if ([weakSelf.pageViewDelegate respondsToSelector:@selector(didSelectedTabItemLabel:withIndex:)]) {
            
            [weakSelf.pageViewDelegate didSelectedTabItemLabel:tabLbl withIndex:weakSelf.pendingIndex];
            
        }
        
    }];
    
}

/**
 根据索引取出容器中相应的控制器
 
 @param index 位置索引
 @return 返回内容控制器
 */
- (UIViewController *)contentVcWithIndex:(NSInteger)index {
    if (index >= 0 && index < self.contentVcsArr.count) {
        return self.contentVcsArr[index];
    }
    return nil;
}

/**
 取的容器中contentVC的索引
 
 @param contentVc contentVc
 @return 返回对应的索引
 */
- (NSInteger)indexOfContentVc:(UIViewController *)contentVc {
    if (contentVc == nil) {
        return NSNotFound;
    }
    return [self.contentVcsArr indexOfObject:contentVc];
}

#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSInteger index = [self.contentVcsArr indexOfObject:viewController];
    
    index = index - 1;
    
    return [self contentVcWithIndex:index];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSInteger index = [self.contentVcsArr indexOfObject:viewController];
    
    index = index + 1;
    
    return [self contentVcWithIndex:index];
    
}

#pragma mark -UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers NS_AVAILABLE_IOS(6_0) {
    
    UIViewController *contentVc = pendingViewControllers[0];
    self.pendingIndex = [self indexOfContentVc:contentVc];
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    
    
    if (completed) {
        
        [self changePreLblStatesWithIndex:self.currentIndex];
        
        [self scrollToNextContentVcWithIndex:self.pendingIndex];
        
        UIViewController *contentVc = [self contentVcWithIndex:self.pendingIndex];
        
        UIView *tabView = [self tabViewAtIndex:self.pendingIndex];
        
        UILabel *tabLbl = [self tabLblOnView:tabView];
        
        if ([self.pageViewDelegate respondsToSelector:@selector(didShowContentVc:withTabLbl:withIndex:)]) {
            [self.pageViewDelegate didShowContentVc:contentVc withTabLbl:tabLbl withIndex:self.pendingIndex];
        }
        
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tabScrollView) {
//        NSLog(@"%f", scrollView.contentOffset.x);
    }
}


#pragma mark - TLPageViewDataSource
- (NSArray *)tabTitlesInTabView:(UIScrollView *)tabScrollView {
    return @[@"头条333",@"头条",@"头条",@"头条",@"头条",@"头条",@"头条",@"天乐商城",@"头条",@"头条头条",@"头条",@"头条",@"头条",@"头条",@"头条",@"头条",@"头条",@"热点"];
}

- (NSInteger)defaultSelectContentVc:(UIPageViewController *)pageVc {
    return 10;
}

- (NSArray *)contentVcsInContainerVc:(UIPageViewController *)pagerVc {
    return @[[[UIViewController alloc]init]];
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

- (CGFloat)itemTitleFontSize:(UIViewController *)vc {
    return 15;
}

@end

///增加一个String扩展计算text的size
@implementation NSString (TLStringSizeCalculate)

- (CGSize)textSizeWithHeight:(CGFloat)height fontSize:(CGFloat)fontSize {
    
    NSDictionary *attributesDic = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    
    CGSize size = CGSizeMake(MAXFLOAT, height);
    
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesFontLeading attributes:attributesDic context:nil];
    
    return rect.size;
    
}

@end
