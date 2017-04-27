//
//  TLBasePagerViewController.h
//  WFViewPagerDemo
//
//  Created by wangfei on 2017/4/24.
//  Copyright © 2017年 wangfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TLPageViewDataSource <NSObject>

@required

/**
 获取所有标题栏的title

 @param tabScrollView scrollView
 @return 返回标题数组
 */
- (NSArray *)tabTitlesInTabView:(UIScrollView *)tabScrollView;

/**
 获取所有的内容控制器

 @param pagerVc container控制器
 @return 返回控制器数组
 */
- (NSArray *)contentVcsInContainerVc:(UIPageViewController *)pagerVc;

@optional

- (NSInteger)defaultSelectContentVc:(UIPageViewController *)pageVc;

/**
 没被选中的tab item的字体颜色
 
 @param vc TLBasePageViewController
 @return 返回color对象
 */
- (UIColor *)colorNormalForTabItems:(UIViewController *)vc;

/**
 被选中的tab item的字体颜色
 
 @param vc TLBasePageViewController
 @return 返回color对象
 */
- (UIColor *)colorSelectedForTabItem:(UIViewController *)vc;

/**
 指示线的背景色
 
 @param vc TLBasePageViewController
 @return 返回color对象
 */
- (UIColor *)colorForLineView:(UIViewController *)vc;

/**
 标题的字号

 @param vc TLBasePageViewController
 @return 返回字体大小
 */
- (CGFloat)itemTitleFontSize:(UIViewController *)vc;

@end

@protocol TLPageViewDelegate <NSObject>

@optional
/**
 点击了某个tab回调

 @param lbl 选中的tab label
 @param index 选中的index
 */
- (void)didSelectedTabItemLabel:(UILabel *)lbl withIndex:(NSInteger)index;

/**
 滚动到某个控制器时的回调

 @param contentVc 当前控制器
 @param lbl 控制器对应的tab label
 @param index 控制器对应的索引
 */
- (void)didShowContentVc:(UIViewController *)contentVc withTabLbl:(UILabel *)lbl withIndex:(NSInteger)index;

@end

@interface TLBasePagerViewController : UIViewController<TLPageViewDataSource>

@property (nonatomic, weak) id<TLPageViewDataSource>pageViewDataSource;

@property (nonatomic, weak) id<TLPageViewDelegate>pageViewDelegate;


/**
 由子类子重写
 scrollView建议修改横纵坐标及宽，高度由标题的字体大小计算得到，pageView建议修改横纵坐标及高度
 设置重写tabScrollView和pageView的frame是为了考虑将tabScrollView放到navigationItem的titleView上
 默认tabScrollView和pageView是加在self.view上

 @param scrollView tabScrollView
 @param pageView pageViewController的视图
 */
- (void)resetFrameWithTab:(UIScrollView *)scrollView pageView:(UIView *)pageView;

@end

@interface NSString (TLStringSizeCalculate)

- (CGSize)textSizeWithHeight:(CGFloat)height fontSize:(CGFloat)fontSize;

@end
