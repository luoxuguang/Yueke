//
//  StudentsViewController.m
//  Yueke
//
//  Created by Lance on 2018/9/8.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import "StudentsViewController.h"
#import "AddStudentVC.h"
#import "HJLoginExample03_VC.h"
#import <PopoverView.h>
@interface StudentsViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation StudentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"学员";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *todayItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addStudent:)];
    todayItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = todayItem;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self findAllStudents];//请求网络数据
    }];
    [self.tableView.mj_header beginRefreshing];
    
    

}
-(void)findAllStudents{
    NSDictionary *dict = @{@"token":user_token};
    [BasicNetWorking POST:[NSString stringWithFormat:@"%@%@",BaseUrl,API_findUser] parameters:dict success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.dataArr removeAllObjects];
        self.dataArr = [NSMutableArray arrayWithArray:responseObject];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        
    }];
}

-(void)addStudent:(UIBarButtonItem *)sender{
    
    PopoverAction *addStore = [PopoverAction actionWithImage:[UIImage imageNamed:@"addStore"] title:@"添加门店" handler:^(PopoverAction *action) {
        AddStudentVC *add = [[AddStudentVC alloc]init];
        add.addType = ADDSTORE;
        add.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:add animated:YES];
    }];
    PopoverAction *addCourse = [PopoverAction actionWithImage:[UIImage imageNamed:@"addCourse"] title:@"添加课程" handler:^(PopoverAction *action) {
        AddStudentVC *add = [[AddStudentVC alloc]init];
        add.addType = ADDCOURSE;
        add.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:add animated:YES];
    }];
    PopoverAction *addStudent = [PopoverAction actionWithImage:[UIImage imageNamed:@"addStudent"] title:@"添加学员" handler:^(PopoverAction *action) {
        AddStudentVC *add = [[AddStudentVC alloc]init];
        add.addType = ADDSTUDENT;
        @weakify(self)
        add.AddSuccessBlock = ^{
            @strongify(self)
            [self.tableView.mj_header beginRefreshing];
        };
        add.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:add animated:YES];
    }];
    PopoverAction *exit = [PopoverAction actionWithImage:[UIImage imageNamed:@"exit"] title:@"退出登录" handler:^(PopoverAction *action) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定退出登录吗？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
        [alertView show];
    }];
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.showShade = YES; // 显示阴影背景
    [popoverView showToPoint:CGPointMake(ScreenWidth-15, SafeAreaTopHeight) withActions:@[addStore,addCourse,addStudent,exit]];
    
}
-(void)deleteStudentWithIndex:(NSInteger)index{
    NSDictionary *dict = self.dataArr[index];
    NSDictionary *param = @{@"token":user_token,@"userId":[dict objectForKey:@"fid"]};
    [BasicNetWorking POST:[NSString stringWithFormat:@"%@%@",BaseUrl,API_deleteUser] parameters:param success:^(id responseObject) {
        [JohnAlertManager showAlertWithType:JohnTopAlertTypeSuccess title:@"学员已删除！"];
        [self.dataArr removeObjectAtIndex:index];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //只要实现这个方法，就实现了默认滑动删除！！！！！
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // 删除数据
        [self deleteStudentWithIndex:indexPath.row];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dict = self.dataArr[indexPath.row];
    cell.textLabel.text = [[dict objectForKey:@"name"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        HJLoginExample03_VC *login = [[HJLoginExample03_VC alloc]init];
        login.hidesBottomBarWhenPushed = YES;
        login.isLogin = YES;
        [self.navigationController pushViewController:login animated:YES];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"user_token"];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSDictionary *dict = @{@"token":user_token
                               };
        
        [BasicNetWorking POST:[NSString stringWithFormat:@"%@%@",BaseUrl,API_logout] parameters:dict success:^(id responseObject) {
            [JohnAlertManager showAlertWithType:JohnTopAlertTypeSuccess title:@"你已退出登录！"];
            
        } failure:^(NSError *error) {
            [JohnAlertManager showAlertWithType:JohnTopAlertTypeError title:@"网络出错了哦！"];
        }];
    }
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 60;
//        _tableView.editing = YES;
    }
    return _tableView;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
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
