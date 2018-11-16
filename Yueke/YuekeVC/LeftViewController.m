//
//  LeftViewController.m
//  Yueke
//
//  Created by luo on 2018/11/15.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftViewCell.h"

#define kTBCityIconXUEYUAN TBCityIconInfoMake(@"\U0000e62c", 24, [UIColor blackColor])
#define kTBCityIconSTORE TBCityIconInfoMake(@"\U0000e62c", 24, [UIColor blackColor])
#define kTBCityIconKECHENG TBCityIconInfoMake(@"\U0000e62c", 24, [UIColor blackColor])
@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArr;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(50);
        make.left.right.mas_equalTo(self.view).offset(0);
        make.bottom.mas_equalTo(self.view).offset(-50);
    }];
    
    self.dataArr = @[@{@"icon":kTBCityIconXUEYUAN,@"name":@"学员管理"},
                     @{@"icon":kTBCityIconSTORE,@"name":@"门店管理"},
                     @{@"icon":kTBCityIconKECHENG,@"name":@"课程管理"}
                     ];
}

#pragma mark  ---delegate datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftViewCell"];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LeftViewCell" owner:self options:nil];
    if ([nib count]>0)
    {
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *dict = self.dataArr [indexPath.row];
    [cell showWithDic:dict];
    
    return cell;
}


#pragma mark ----lazy load
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
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
