//
//  LeftViewController.m
//  Yueke
//
//  Created by luo on 2018/11/15.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import "LeftViewController.h"

#define kTBCityIconXUEYUAN TBCityIconInfoMake(@"\U0000e62c", 24, [UIColor blackColor])
#define kTBCityIconSTORE TBCityIconInfoMake(@"\U0000e62c", 24, [UIColor blackColor])
#define kTBCityIconKECHENG TBCityIconInfoMake(@"\U0000e62c", 24, [UIColor blackColor])
@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIButton *exitBtn;
@property (nonatomic,strong) NSArray *dataArr;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(20);
        make.left.mas_equalTo(self.view).offset(30);
        make.width.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-50);
    }];
    
    [self.view addSubview:self.exitBtn];
    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50);
        make.left.mas_equalTo(self.view).offset(30);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
        
    }];
    self.dataArr = @[@{@"icon":@"iconfont_学员",@"name":@"学员管理"},
                     @{@"icon":@"iconfont_门店",@"name":@"门店管理"},
                     @{@"icon":@"iconfont_课程",@"name":@"课程管理"}
                     ];
}

#pragma mark  ---delegate datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSDictionary *dict = self.dataArr [indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[dict objectForKey:@"icon"]];
    cell.textLabel.text = [dict objectForKey:@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = [UIColor colorWithHex:0x666666];
    return cell;
}


#pragma mark ----lazy load
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 65;
        _tableView.tableHeaderView = self.headView;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-50, 240)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, 80, 80)];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 40;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:@"avator.jpeg"];
        [_headView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(90, 100, _headView.frame.size.width-115, 80)];
        label.text = @"C-GO Fitness";
        [_headView addSubview:label];
    }
    return _headView;
}
-(UIButton *)exitBtn{
    if (!_exitBtn) {
        _exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_exitBtn setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        _exitBtn.titleLabel.textColor = [UIColor colorWithHex:0x999999];
        _exitBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _exitBtn;
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
