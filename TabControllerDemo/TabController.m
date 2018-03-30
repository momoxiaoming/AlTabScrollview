//
//  TabController.m
//  TestTabTitle
//
//  Created by 张小明 on 2018/3/29.
//  Copyright © 2018年 张小明. All rights reserved.
//

#import "TabController.h"
#import "TabScrollview.h"
#import "TabContentView.h"

#import "PageViewController.h"
#import "Masonry.h"
@interface TabController ()
@property (nonatomic,strong)TabScrollview *tabScrollView;
@property (nonatomic,strong)TabContentView *tabContent;

@property (nonatomic,strong)NSMutableArray *tabs;

@property (nonatomic,strong)NSMutableArray *contents;

@end

@implementation TabController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Demo";
    // Do any additional setup after loading the view, typically from a nib.
    self.edgesForExtendedLayout = UIRectEdgeAll; //系统默认值,系统布局需要从状态栏开始
    self.navigationController.navigationBar.translucent = NO;  //ios6之前默认为no,ios6之后默认为ysa,NO的时候,,布局就会自动从状态栏下方开始,我们布局直接从状态栏开始,无下移ß下64
    //创建模拟数据
    
    _tabs=[[NSMutableArray alloc]initWithCapacity:20];
    _contents=[[NSMutableArray alloc]initWithCapacity:20];
    
    for(int i=0;i<10;i++){
        NSString *titleStr=[NSString stringWithFormat:@"tab%i",i];

        UILabel *tab=[[UILabel alloc]init];
        tab.textAlignment=NSTextAlignmentCenter;
        tab.text=titleStr;
        tab.textColor=[UIColor blackColor];
        

        [_tabs addObject:tab];
        
        int R = (arc4random() % 256) ;
        int G = (arc4random() % 256) ;
        int B = (arc4random() % 256) ;
        
        
        PageViewController *con=[PageViewController new];
        con.view.backgroundColor=[UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha :1];
        con.tag=titleStr;
        [_contents addObject:con];
        
    }
    
    
    
    //
    
    _tabScrollView=[[TabScrollview alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tabScrollView];
    [_tabScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
    }];

    [_tabScrollView configParameter:horizontal viewArr:_tabs tabWidth:60 tabHeight:50 index:0 block:^(NSInteger index) {

        [_tabContent updateTab:index];
    }];
    
    
    _tabContent=[[TabContentView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tabContent];

    [_tabContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(_tabScrollView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    
    [_tabContent configParam:_contents Index:0 block:^(NSInteger index) {
        [_tabScrollView updateTagLine:index];
    }];
    
    
    
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
