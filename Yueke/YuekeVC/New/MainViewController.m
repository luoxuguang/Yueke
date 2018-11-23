//
//  MainViewController.m
//  Yueke
//
//  Created by luo on 2018/11/19.
//  Copyright © 2018 luoxuguang. All rights reserved.
//

#import "MainViewController.h"
#import "HeadView.h"

@interface MainViewController ()

@property (nonatomic,strong) HeadView *headView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headView];
    [self.headView reloadData];
}

-(HeadView *)headView{
    if (!_headView) {
        _headView = [[HeadView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, self.view.frame.size.width, 50)];
    }
    return _headView;
}

@end
