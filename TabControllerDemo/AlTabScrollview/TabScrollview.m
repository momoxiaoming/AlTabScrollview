//
//  TabScrollview.m
//  TestTabTitle
//
//  Created by 张小明 on 2018/3/28.
//  Copyright © 2018年 张小明. All rights reserved.
//

#import "TabScrollview.h"


@implementation TabScrollview
//可以在xib storyBoard  以及代码中都可以实现

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)configParameter:(DirectionStyle)directionStyle viewArr:(NSArray<UIView*>*)viewArr tabWidth:(NSInteger)tabWidth tabHeight:(NSInteger)tabHeight index:(NSInteger)index block:(TabClickBlock) clickBlock{
    _viewArr=viewArr;
    _tabHeight=tabHeight;
    _tabWidth=tabWidth;
    _direction=directionStyle;
    
    //
    _clickBlock=clickBlock;
    
    _tagIndex=index;
    if(_direction==horizontal){
        
        [self updateTag:index];
        [_viewArr enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame=CGRectMake(idx*_tabWidth, 0, _tabWidth, _tabHeight);
            [self addSubview:obj];
            [self setListener:obj index:idx];
        }];
        
        //添加标记线
        [self addSubview:_tagLine];
        self.contentSize=CGSizeMake(_tabWidth*_viewArr.count, 0);
        
    }else{
        [self updateTag:index];
        
        [_viewArr enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame=CGRectMake(0, idx*_tabHeight, _tabWidth, _tabHeight);
            [self addSubview:obj];
            [self setListener:obj index:idx];
            
        }];
        [self addSubview:_tagLine];
        
        self.contentSize=CGSizeMake(0, _tabHeight*_viewArr.count);
    }
  
}

-(void)setListener:(UIView *) arr index:(NSInteger) index{
    arr.tag=index;   //设置传递的参数
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuAction:)];
    arr.userInteractionEnabled=YES;
    [arr addGestureRecognizer:tableViewGesture];
    
}
-(void)menuAction:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger index = views.tag;   //获取上面view设置的tag
    
    //更新标记
    [self updateTagLine:index];
    
    if (_clickBlock){
        _clickBlock(index);
    }
    
}

-(void)autoTabOffset:(NSInteger)index{
    //水平滚动的时候,计算偏移量
    if(_direction==horizontal){
        //获取scrollview宽度
        NSInteger maxWidth=self.frame.size.width;
        CGFloat currOffset=_tabWidth*index;
        
        //获取scrollview移动了的距离
        CGFloat pointx= self.contentOffset.x;
        if(_tagIndex<index){ //往后滚
            
            NSInteger equal_value=maxWidth%_tabWidth;
            if(equal_value==0){ //假如tab宽度等分屏幕,说明屏幕右边一定能完全显示一个tab
                //直接计算一个tab宽度偏移
                if(currOffset>=maxWidth){
                    //偏移一个tab长度
                    [self setContentOffset:CGPointMake(pointx+_tabWidth, 0)];
                }
            }else{ //tab宽度不等分屏幕,说明屏幕右边肯定有一个tab显示不全
                //显示不全的时候,我们需要将不全的部分偏移也计算进去
                
                if((currOffset+_tabWidth)>=maxWidth){
                    //偏移一个tab长度
                    [self setContentOffset:CGPointMake(pointx+_tabWidth, 0)];
                }
                
            }
      
        }else{ //往前滚
            NSLog(@"移动了的距离---%f---当前tag--%f",pointx,currOffset);
            
            if(currOffset==0){//假如回滚到第一格,初始化偏移量
                [self setContentOffset:CGPointMake(0, 0)];
                return;
            }
            if(currOffset<pointx){
                //往后回滚一格
                [self setContentOffset:CGPointMake((pointx-_tabWidth), 0)];
            }
            
        }
        
        
    }else{
        //获取scrollview宽度
        NSInteger maxWidth=self.frame.size.height;
        CGFloat currOffset=_tabHeight*index;
        
        //获取scrollview移动了的距离
        CGFloat pointy= self.contentOffset.y;
        if(_tagIndex<index){ //往后滚
            
            NSInteger equal_value=maxWidth%_tabHeight;
            if(equal_value==0){ //假如tab宽度等分屏幕,说明屏幕右边一定能完全显示一个tab
                //直接计算一个tab宽度偏移
                if(currOffset>=maxWidth){
                    //偏移一个tab长度
                    [self setContentOffset:CGPointMake(pointy+_tabHeight, 0)];
                }
            }else{ //tab宽度不等分屏幕,说明屏幕右边肯定有一个tab显示不全
                //显示不全的时候,我们需要将不全的部分偏移也计算进去
                
                if((currOffset+_tabHeight)>=maxWidth){
                    //偏移一个tab长度
                    [self setContentOffset:CGPointMake(pointy+_tabHeight, 0)];
                }
                
            }
            
        }else{ //往前滚
            NSLog(@"移动了的距离---%f---当前tag--%f",pointy,currOffset);
            
            if(currOffset==0){//假如回滚到第一格,初始化偏移量
                [self setContentOffset:CGPointMake(0, 0)];
                return;
            }
            if(currOffset<pointy){
                //往后回滚一格
                [self setContentOffset:CGPointMake((pointy-_tabHeight), 0)];
            }
            
        }
        
        
        
    }
    
}
/**
 计算每个tab的偏移方法
 
 @param index 点击个tag下标
 */
-(void)tabOffset:(NSInteger)index{
//    _tagIndex=index;
    
    //水平滚动的时候,计算偏移量
    if(_direction==horizontal){
        //获取scrollview宽度
        NSInteger maxWidth=self.frame.size.width;
        //获取当前点击的tab所处的位置大小
        CGFloat maxW=_tabWidth*index;
        //判断tab是否处于大于屏幕一半的位置,并计算出偏移量
        CGFloat offset_halfmaxWidth=maxW-maxWidth/2;
        //当tab偏移量不足tab宽度时,计算出最小的偏移量
        CGFloat itemOffset=offset_halfmaxWidth+_tabWidth/2;
        
        //当偏移量>0的时候,
        if(offset_halfmaxWidth>0){
            //假如偏移量小于一个tab的宽度,说明还没有到最初始位置,可以执行偏移
            if(offset_halfmaxWidth<_tabWidth){
                [self setContentOffset:CGPointMake(itemOffset, 0)];
                return;
            }
            NSInteger maxCont=_tabWidth*_viewArr.count;
            //获取偏移的页数,减1的作用是我们的偏移是从0开始的,所以需要减去一个屏幕长度
            NSInteger remainder_x=maxCont/maxWidth-1;
            //获取最后一页的偏移量
            NSInteger remainder_=maxCont%maxWidth;
            
            //获取到最大偏移量
            NSInteger maxOffset=remainder_x*maxWidth+remainder_;
            
            
            //假如我们的计算的偏移量小于最大偏移,说明是可以偏移的
            if(itemOffset<=maxOffset){
                //假如偏移量大于一个tab的宽度,判断
                if(itemOffset<=_tabWidth){  //当点击的偏移量小于tab的宽度的时候,归零偏移量
                    [self setContentOffset:CGPointMake(0, 0)];
                    return;
                }else{
                    [self setContentOffset:CGPointMake(itemOffset, 0)];
                }
                
            }else{
                [self setContentOffset:CGPointMake(maxOffset, 0)];
            }
        }else if(offset_halfmaxWidth<0){
            //判断往后滚的偏移量小于0但是却和半个tab宽度之和要大于0的时候,说明还可以进行微调滚动,
            if(itemOffset>0){
                [self setContentOffset:CGPointMake(itemOffset, 0)];
                return;
            }
            //最小偏移小于0,说明往前滚,将偏移重置为初始位置
            [self setContentOffset:CGPointMake(0, 0)];
        }else{
            [self setContentOffset:CGPointMake(0, 0)];
        }
    }
    //垂直滚动,基本和水平滚动差不多,只是将tab宽高对换
    else{
        //获取scrollview宽度
        NSInteger maxWidth=self.frame.size.height;
        //获取当前点击的tab所处的位置大小
        CGFloat maxW=_tabHeight*index;
        //判断tab是否处于大于屏幕一半的位置,并计算出偏移量
        CGFloat offset_halfmaxWidth=maxW-maxWidth/2;
        //当tab偏移量不足tab宽度时,计算出最小的偏移量
        CGFloat itemOffset=offset_halfmaxWidth+_tabHeight/2;
        
        //当偏移量>=0的时候,
        if(offset_halfmaxWidth>=0){
            //假如偏移量小于一个tab的宽度,说明还没有到最初始位置,可以执行偏移
            if(offset_halfmaxWidth<=_tabHeight){
                [self setContentOffset:CGPointMake(0, itemOffset)];
                return;
            }
            NSInteger maxCont=_tabHeight*_viewArr.count;
            //获取偏移的页数,减1的作用是我们的偏移是从0开始的,所以需要减去一个屏幕长度
            NSInteger remainder_x=maxCont/maxWidth-1;
            //获取最后一页的偏移量
            NSInteger remainder_=maxCont%maxWidth;
            
            //获取到最大偏移量
            NSInteger maxOffset=remainder_x*maxWidth+remainder_;
            
            
            //假如我们的计算的偏移量小于最大偏移,说明是可以偏移的
            if(itemOffset<=maxOffset){
                //假如偏移量大于一个tab的宽度,判断
                if(itemOffset<=_tabHeight){  //当点击的偏移量小于tab的宽度的时候,归零偏移量
                    [self setContentOffset:CGPointMake(0, 0)];
                    return;
                }else{
                    [self setContentOffset:CGPointMake(0, itemOffset)];
                }
                
            }else{
                [self setContentOffset:CGPointMake(0, maxOffset)];
            }
        }else if(offset_halfmaxWidth<0){
            //判断往后滚的偏移量小于0但是却和半个tab宽度之和要大于0的时候,说明还可以进行微调滚动,
            if(itemOffset>0){
                [self setContentOffset:CGPointMake(0, itemOffset)];
                return;
            }
            //最小偏移小于0,说明往前滚,将偏移重置为初始位置
            [self setContentOffset:CGPointMake(0, 0)];
        }
        else{
            [self setContentOffset:CGPointMake(0, 0)];
        }
        
    }
    
}
-(void)updateTag:(NSInteger)index{
    [self tabOffset:index];
    _tagLine.frame=CGRectMake(index*_tabWidth, _tabHeight-tagLineheight-1, _tabWidth, tagLineheight);
}
/**
 更新标记线位置
 
 @param index tab位置下标
 */
-(void)updateTagLine:(NSInteger)index{
    if(_tagIndex==index){ //如果标记重复,为了节省消耗,直接中断
        return;
    }
    //点击了
    if(openAutoCorrection){
        [self tabOffset:index];
        
    }else{
        [self autoTabOffset:index];
        
    }
    if(_direction==horizontal){
        //标记线切换动画
        [UIView animateWithDuration:0.1 animations:^{
            _tagLine.frame=CGRectMake(index*_tabWidth, _tabHeight-tagLineheight-0.5, _tabWidth, tagLineheight);
        } completion:^(BOOL finished) {
            _tagIndex=index;

        }];
        
    }else{
        //标记线切换动画
        [UIView animateWithDuration:0.1 animations:^{
            _tagLine.frame=CGRectMake(_tabWidth-tagLineheight-0.5, _tabHeight*index, tagLineheight, _tabHeight);
        } completion:^(BOOL finished) {
            _tagIndex=index;

        }];
        
    }

}

/**
 初始化一些参数
 */
-(void)initView{
    self.tagLine=[[UIView alloc]init];
    self.tagLine.backgroundColor=tagLineColor;  //默认标记线为红色
    self.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGPoint point= scrollView.contentOffset;
    
}

//要是布局控件，必须在这里面写他的位置
- (void)layoutSubviews{
    //假如我们view中还有其他控件,在这个方法中添加
}

@end
