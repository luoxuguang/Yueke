//
//  BaseNavigationController.m
//  Yueke
//
//  Created by Lance on 2018/9/8.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationBar.barStyle = UIBarStyleBlack;
//    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"1"
                                                                style:UIBarButtonItemStylePlain
                                                               target:nil
                                                               action:nil];
    self.navigationBar.tintColor =
    [UIColor blackColor];
    
    //主要是以下两个图片设置
    self.navigationBar.backIndicatorImage = [UIImage imageNamed:@"iconfont_返回"];
    self.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"iconfont_返回"];
    
    self.navigationItem.backBarButtonItem = backItem;
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]}forState:UIControlStateNormal];//将title 文字的颜色改为透明
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]}forState:UIControlStateHighlighted]; //将title 文字的颜色改为透明
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
