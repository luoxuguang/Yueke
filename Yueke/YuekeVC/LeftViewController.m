//
//  LeftViewController.m
//  Yueke
//
//  Created by luo on 2018/11/15.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import "LeftViewController.h"
#import "UIViewController+CWLateralSlide.h"
#import "StudentsViewController.h"
#import "AddStudentVC.h"
#import "HJLoginExample03_VC.h"

#define kTBCityIconXUEYUAN TBCityIconInfoMake(@"\U0000e62c", 24, [UIColor blackColor])
#define kTBCityIconSTORE TBCityIconInfoMake(@"\U0000e62c", 24, [UIColor blackColor])
#define kTBCityIconKECHENG TBCityIconInfoMake(@"\U0000e62c", 24, [UIColor blackColor])
@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            {
                StudentsViewController *vc = [StudentsViewController new];
                [self cw_pushViewController:vc];
            }
            break;
        case 1:
        {
            AddStudentVC *add = [[AddStudentVC alloc]init];
            add.addType = ADDSTORE;
            [self cw_pushViewController:add];
        }
            break;
        case 2:
        {
            AddStudentVC *add = [[AddStudentVC alloc]init];
            add.addType = ADDCOURSE;
            [self cw_pushViewController:add];
        }
            break;
            
        
    }
    
}
-(void)logout{
    HJLoginExample03_VC *login = [[HJLoginExample03_VC alloc]init];
    login.isLogin = YES;
    [self cw_pushViewController:login];
    
    NSDictionary *dict = @{@"token":user_token
                           };
    
    [BasicNetWorking POST:[NSString stringWithFormat:@"%@%@",BaseUrl,API_logout] parameters:dict success:^(id responseObject) {
        [JohnAlertManager showAlertWithType:JohnTopAlertTypeSuccess title:@"你已退出登录！"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_token"];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    } failure:^(NSError *error) {
        [JohnAlertManager showAlertWithType:JohnTopAlertTypeError title:@"网络出错了哦！"];
    }];
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定退出登录吗？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
//    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            AddStudentVC *add = [[AddStudentVC alloc]init];
            add.addType = ADDCOURSE;
            [self cw_pushViewController:add];
        });
        
        
    }
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
        [_exitBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
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
