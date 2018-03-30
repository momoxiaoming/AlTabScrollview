//
//  TabScrollview.h
//  TestTabTitle
//
//  Created by 张小明 on 2018/3/28.
//  Copyright © 2018年 张小明. All rights reserved.
//  

#import <UIKit/UIKit.h>
#define tagLineheight 2 //默认标记线高度
#define tagLineColor [UIColor redColor]  //默认标记颜色
#define defTag 0  //默认标记0号位
#define openAutoCorrection false  //默认开启选中标题自动居中功能
typedef void(^TabClickBlock)(NSInteger index);
typedef NS_ENUM(NSInteger, DirectionStyle) {
    horizontal = 0,
    vertical = 1
};
@interface TabScrollview : UIScrollView<UIScrollViewDelegate>


/**
 装载视图的数组
 */
@property (nonatomic,strong)NSArray<UIView*> *viewArr;


/**
 tab的宽度
 */
@property (nonatomic,assign)NSInteger tabWidth;

/**
 tab的高度
 */
@property (nonatomic,assign)NSInteger tabHeight;

/**
 tab下方标记线
 */
@property (nonatomic,strong)UIView *tagLine;
/**
 滚动的方向
 */
@property DirectionStyle direction;
/**
 记录位置下标
 */
@property (nonatomic,assign)NSInteger tagIndex;
/**
 tab下方标记线
 */
@property (nonatomic,strong)TabClickBlock clickBlock ;
/**
 更新标记线位置
 
 @param index tab位置下标
 */
-(void)updateTagLine:(NSInteger)index;
/**
 配置相关参数

 @param directionStyle 滚动方向
 @param viewArr tab的视图
 @param tabWidth tab的宽度
 @param tabHeight tab的高度
 @param index 默认的tab是第几个
  @param clickBlock 回调点击位置的block
 */
-(void)configParameter:(DirectionStyle)directionStyle viewArr:(NSArray<UIView*>*)viewArr tabWidth:(NSInteger)tabWidth tabHeight:(NSInteger)tabHeight index:(NSInteger)index block:(TabClickBlock) clickBlock;
@end
