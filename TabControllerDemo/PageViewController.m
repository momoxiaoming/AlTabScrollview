//
//  PageViewController.m
//  TestTabTitle
//
//  Created by 张小明 on 2018/3/28.
//  Copyright © 2018年 张小明. All rights reserved.
//

#import "PageViewController.h"
#import "Masonry.h"
@interface PageViewController ()
@property (nonatomic,assign)BOOL isFrist;
@property (nonatomic,strong)UILabel *lab;
@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isFrist=false;
    self.view.backgroundColor=[UIColor whiteColor];
    
    _lab=[[UILabel alloc]init];
    
    [self.view addSubview:_lab];
    
    [_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    
    if(!_isFrist){
        //第一次进入,自动加载数据
//        NSLog(@"第一次进入--%@",_tag);
        _lab.text=_tag;
        _isFrist=true;
    }else{
        //不是第一次进入,不加载数据
//        NSLog(@"第二次进入--%@",_tag);

    }
    
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
