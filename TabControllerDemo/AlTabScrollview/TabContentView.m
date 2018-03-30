//
//  TabContentView.m
//  TestTabTitle
//
//  Created by 张小明 on 2018/3/29.
//  Copyright © 2018年 张小明. All rights reserved.
//

#import "TabContentView.h"

@implementation TabContentView
- (instancetype)initWithFrame:(CGRect)frame{
    
    self =[super initWithFrame:frame];
    if(self){
        [self initView];
    }
    return self;
}


-(void)initView{
    _pageController=[[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageController.delegate = self;
    _pageController.dataSource = self;
    _pageController.view.frame=self.bounds;
    [self addSubview:_pageController.view];
}

-(void)configParam:(NSMutableArray<UIViewController *> *)controllers Index:(NSInteger)index block:(TabSwitchBlcok)tabSwitch{
    
    _tabSwitch=tabSwitch;
    _controllers=controllers;
    _tabSwitch=tabSwitch;
    //默认展示的第一个页面
    [_pageController setViewControllers:[NSArray arrayWithObject:[self pageControllerAtIndex:index]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}

-(void)updateTab:(NSInteger)index{
    NSLog(@"updateTab---%lu",index);
    //默认展示的第一个页面
    [_pageController setViewControllers:[NSArray arrayWithObject:[self pageControllerAtIndex:index]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    
}




-(void)layoutSubviews{
    [super layoutSubviews];
    _pageController.view.frame=self.bounds;
}

//返回下一个页面
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index= [_controllers indexOfObject:viewController];
    if(index==(_controllers.count-1)){
        return nil;
    }
    index++;
    return [self pageControllerAtIndex:index];
}
//返回前一个页面
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    //判断当前这个页面是第几个页面
    NSInteger index=[_controllers indexOfObject:viewController];
    //如果是第一个页面
    if(index==0){
        return nil;
    }
    index--;
    return [self pageControllerAtIndex:index];
    
}

//根据tag值创建内容页面
-(UIViewController*)pageControllerAtIndex:(NSInteger)index{
    
    return [_controllers objectAtIndex:index];
    
}
//结束滑动的时候触发
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    NSLog(@"didFinishAnimating");
    NSInteger index=[_controllers indexOfObject:pageViewController.viewControllers[0]];
    _tabSwitch(index);
}
//开始滑动的时候触发
-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    NSLog(@"pageViewController");

}




@end
