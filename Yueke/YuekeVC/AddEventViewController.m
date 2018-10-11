//
//  AddEventViewController.m
//  Yueke
//
//  Created by luo on 2018/9/28.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import "AddEventViewController.h"
#import "ZHPickView.h"
#import "SelStudentsViewController.h"
@interface AddEventViewController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) UITextField *nameField;
@property (nonatomic,strong) UITextField *storeField;
@property (nonatomic,strong) UITextField *courseField;

@property (nonatomic,strong) UITextField *dateField;
@property (nonatomic,strong) UITextField *startDateField;
@property (nonatomic,strong) UITextField *endDateField;

@property (nonatomic,strong) NSMutableArray *dataArr; //日期数组
@property (nonatomic,strong) NSMutableArray *studentArr;
@property (nonatomic,strong) NSMutableArray *storeArr;
@property (nonatomic,strong) NSMutableArray *courseArr;
@property (nonatomic,copy) NSString *hour;

@end

@implementation AddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加课程";
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!self.model.relid) {
        self.dateField.text = [YKTool getTimeWithStr:@"YYYY-MM-dd" Date:self.model.startDate];
        self.startDateField.text = [NSString stringWithFormat:@"%@",self.dataArr[self.model.cellNum]];
        self.endDateField.text = [NSString stringWithFormat:@"%ld%@",[[self.startDateField.text substringToIndex:2] integerValue]+1,[self.startDateField.text substringFromIndex:2]];
        _hour = self.startDateField.text;
    }else{
        _hour = [YKTool getTimeWithStr:@"HH:mm" Date:self.model.startDate];
        self.nameField.text = self.model.username;
        self.storeField.text = self.model.storeName;
        self.courseField.text = self.model.courseName;
        self.dateField.text = [YKTool getTimeWithStr:@"YYYY-MM-dd" Date:self.model.startDate];
        self.startDateField.text =  _hour;
        self.endDateField.text = [YKTool getTimeWithStr:@"HH:mm" Date:self.model.endDate];
        UIBarButtonItem *todayItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteClicked:)];
        todayItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = todayItem;
    }
    
    [self.view addSubview:self.tableView];
    [self requestData];
}
-(void)deleteClicked:(UIBarButtonItem *)item{
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"确定删除此次约课吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==1) {
        NSDictionary *param = @{@"token":user_token,@"relid":self.model.relid};
        [BasicNetWorking POST:[NSString stringWithFormat:@"%@%@",BaseUrl,API_delCourseForUser] parameters:param success:^(id responseObject) {
            if (self.ADDSUCCESSBLOCK) {
                self.ADDSUCCESSBLOCK();
            }
            [JohnAlertManager showAlertWithType:JohnTopAlertTypeSuccess title:@"约课删除成功！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } failure:^(NSError *error) {
            
        }];
    }
}
-(void)requestData{
    [MBProgressHUD showMessage:@"正在初始化数据..." toView:self.view];
    //查询所有门店
    NSDictionary *param = @{@"token":user_token};
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [BasicNetWorking POST:[NSString stringWithFormat:@"%@%@",BaseUrl,API_allStore] parameters:param success:^(id responseObject) {
        self.storeArr = [NSMutableArray arrayWithArray:responseObject];
        if (self.storeArr.count) {
          self.storeField.text = [[[self.storeArr firstObject] objectForKey:@"collegename"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        
    }];
    
    dispatch_group_enter(group);
    [BasicNetWorking POST:[NSString stringWithFormat:@"%@%@",BaseUrl,API_allCourse] parameters:param success:^(id responseObject) {
        dispatch_group_leave(group);
        self.courseArr = [NSMutableArray arrayWithArray:responseObject];
        if (self.courseArr.count) {
            self.courseField.text = [[[self.courseArr firstObject] objectForKey:@"name"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    } failure:^(NSError *error) {
        
    }];
    //查询所有学员
    dispatch_group_enter(group);
    [BasicNetWorking POST:[NSString stringWithFormat:@"%@%@",BaseUrl,API_findUser] parameters:param success:^(id responseObject) {
        dispatch_group_leave(group);
        self.studentArr = [NSMutableArray arrayWithArray:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
    //界面刷新
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
         [MBProgressHUD hideHUDForView:self.view];
        
    });
}

-(void)addCurse{
    [MBProgressHUD showMessage:@"请稍后..." toView:self.view];
    __block NSString *userId = nil;
    [self.studentArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[[obj objectForKey:@"name"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] isEqualToString:self.nameField.text]) {
            userId = [obj objectForKey:@"fid"];
        }
    }];
    __block NSString *storeId = nil;
    [self.storeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[[obj objectForKey:@"collegename"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] isEqualToString:self.storeField.text]) {
            storeId = [obj objectForKey:@"fid"];
        }
    }];
    __block NSString *courseId = nil;
    [self.courseArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[[obj objectForKey:@"name"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] isEqualToString:self.courseField.text]) {
            courseId = [obj objectForKey:@"fid"];
        }
    }];
    NSString *startDate = [YKTool nsstringConversionNSDate:[NSString stringWithFormat:@"%@ %@:00",self.dateField.text,self.startDateField.text]];
    NSString *endDate = [YKTool nsstringConversionNSDate:[NSString stringWithFormat:@"%@ %@:00",self.dateField.text,self.endDateField.text]];
    NSDictionary *param = @{@"token":user_token,
                            @"userId":userId,
                            @"courseId":courseId,
                            @"collegeid":storeId,
                            @"startdate":startDate,
                            @"enddate":endDate
                            };
    if (self.model.relid) {
        param = @{@"token":user_token,
                  @"userId":userId,
                  @"courseId":courseId,
                  @"collegeid":storeId,
                  @"startdate":startDate,
                  @"relid":self.model.relid,
                  @"enddate":endDate
                  };
    }
    [BasicNetWorking POST:[NSString stringWithFormat:@"%@%@",BaseUrl,API_addCourseForUser] parameters:param success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.ADDSUCCESSBLOCK) {
            self.ADDSUCCESSBLOCK();
        }
        if (self.model.relid) {
            [JohnAlertManager showAlertWithType:JohnTopAlertTypeSuccess title:@"约课修改成功！"];
        }else{
            [JohnAlertManager showAlertWithType:JohnTopAlertTypeSuccess title:@"约课添加成功！"];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    switch (indexPath.row) {
        case 0:
        {
            [cell addSubview:self.nameField];
        }
            break;
        case 1:
        {
            [cell addSubview:self.courseField];
        }
            break;
        case 2:
        {
            [cell addSubview:self.storeField];
        }
            break;
        case 3:
        {
            [cell addSubview:self.dateField];
        }
            break;
        case 4:
        {
            [cell addSubview:self.startDateField];
        }
            break;
        case 5:
        {
            [cell addSubview:self.endDateField];
        }
            break;
            
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            [self showStudents];
        }
            break;
        case 1:
        {
            ZHPickView *pickView = [[ZHPickView alloc] init];
             NSMutableArray *nameArr = [[NSMutableArray alloc]init];
            [self.courseArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [nameArr addObject:[[obj objectForKey:@"name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }];
            [pickView setDataViewWithItem:nameArr centerStr:nil title:@"选择课程" isNext:NO column:1];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr)
            {
                self.courseField.text = selectedStr;
            };
        }
            break;
        case 2:
        {
            ZHPickView *pickView = [[ZHPickView alloc] init];
            NSMutableArray *nameArr = [[NSMutableArray alloc]init];
            [self.storeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [nameArr addObject:[[obj objectForKey:@"collegename"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }];
            [pickView setDataViewWithItem:nameArr centerStr:nil title:@"选择门店" isNext:NO column:1];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr)
            {
                self.storeField.text = selectedStr;
            };
        }
            break;
        case 3:
        {
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDateViewWithTitle:@"选择日期"];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr)
            {
                self.dateField.text = selectedStr;
            };
        }
            break;
        case 4:
        {
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDataViewWithItem:@[@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21"] centerStr:self.startDateField.text.length>0?self.startDateField.text:_hour title:@"起始时间" isNext:NO column:2];
            [pickView showPickView:self];
            @weakify(self)
            pickView.block = ^(NSString *selectedStr)
            {
                @strongify(self)
                
                if (self.endDateField.text.length) {
                    if ([selectedStr integerValue]>[self.endDateField.text integerValue]) {
                        [JohnAlertManager showAlertWithType:JohnTopAlertTypeError title:@"请选择正确的时间！"];
                    }else{
                        self.startDateField.text = selectedStr;
                        self.hour = selectedStr;
                    }
                }else{
                    self.startDateField.text = selectedStr;
                    self.endDateField.text = [NSString stringWithFormat:@"%ld%@",[[selectedStr substringToIndex:2] integerValue]+1,[selectedStr substringFromIndex:2]];
                    self.hour = selectedStr;
                }
                
            };
        }
            break;
        case 5:
        {
            ZHPickView *pickView = [[ZHPickView alloc] init];
            BOOL isNext = self.endDateField.text.length>0?NO:YES;
            [pickView setDataViewWithItem:@[@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22"] centerStr:self.endDateField.text.length>0?self.endDateField.text:_hour title:@"结束时间" isNext:isNext column:2];
            [pickView showPickView:self];
             @weakify(self)
            pickView.block = ^(NSString *selectedStr)
            {
                @strongify(self)
                if (self.startDateField.text.length) {
                    if ([selectedStr integerValue]<[self.startDateField.text integerValue]) {
                        [JohnAlertManager showAlertWithType:JohnTopAlertTypeError title:@"请选择正确的时间！"];
                    }else{
                         self.endDateField.text = selectedStr;
                    }
                }else{
                    self.endDateField.text = selectedStr;
                }
                
            };
        }
            break;
    }
}

-(void)showStudents{
    NSMutableArray *nameArr = [[NSMutableArray alloc]init];
    [self.studentArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [nameArr addObject:[[obj objectForKey:@"name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }];
    SelStudentsViewController *vc = [[SelStudentsViewController alloc]init];
    vc.students = nameArr;
    vc.SelectBlock = ^(NSString *name) {
        self.nameField.text = name;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(30, 5, ScreenWidth-60, 45);
        [saveBtn addTarget:self action:@selector(addCurse) forControlEvents:UIControlEventTouchUpInside];
        if (self.model.relid) {
           [saveBtn setTitle:@"修改" forState:UIControlStateNormal];
        }else{
            [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        }
        
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn setBackgroundColor:BlueColor];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        [view addSubview:saveBtn];
        _tableView.tableFooterView = view;
    }
    return _tableView;
}
-(UITextField *)nameField{
    if (!_nameField) {
        _nameField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 60)];
        _nameField.tintColor = BlueColor;
        _nameField.placeholder = @"请选择学员";
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 60)];
        label.text = @"学员:";
        _nameField.leftView = label;
        _nameField.enabled = NO;
        _nameField.font = [UIFont systemFontOfSize:15.0];
        _nameField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _nameField;
}
-(UITextField *)storeField{
    if (!_storeField) {
        _storeField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 60)];
        _storeField.tintColor = BlueColor;
        _storeField.placeholder = @"请选择门店";
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 60)];
        label.text = @"门店:";
        _storeField.leftView = label;
        _storeField.enabled = NO;
        _storeField.font = [UIFont systemFontOfSize:15.0];
        _storeField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _storeField;
}
-(UITextField *)courseField{
    if (!_courseField) {
        _courseField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 60)];
        _courseField.tintColor = BlueColor;
        _courseField.placeholder = @"请选择课程";
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 60)];
        label.text = @"课程:";
        _courseField.leftView = label;
        _courseField.enabled = NO;
        _courseField.font = [UIFont systemFontOfSize:15.0];
        _courseField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _courseField;
}
-(UITextField *)startDateField{
    if (!_startDateField) {
        _startDateField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 60)];
        _startDateField.tintColor = BlueColor;
        _startDateField.placeholder = @"请选择起始时间";
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 60)];
        label.text = @"起始时间:";
        _startDateField.leftView = label;
        _startDateField.enabled = NO;
        _startDateField.font = [UIFont systemFontOfSize:15.0];
        _startDateField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _startDateField;
}
-(UITextField *)endDateField{
    if (!_endDateField) {
        _endDateField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 60)];
        _endDateField.tintColor = BlueColor;
        _endDateField.placeholder = @"请选择结束时间";
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 60)];
        label.text = @"结束时间:";
        _endDateField.leftView = label;
        _endDateField.enabled = NO;
        _endDateField.font = [UIFont systemFontOfSize:15.0];
        _endDateField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _endDateField;
}
-(UITextField *)dateField{
    if (!_dateField) {
        _dateField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 60)];
        _dateField.tintColor = BlueColor;
        _dateField.placeholder = @"日期";
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 60)];
        label.text = @"日期:";
        _dateField.leftView = label;
        _dateField.enabled = NO;
        _dateField.font = [UIFont systemFontOfSize:15.0];
        _dateField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _dateField;
}
-(NSMutableArray *)studentArr{
    if (!_studentArr) {
        _studentArr = [[NSMutableArray alloc]init];
    }
    return _studentArr;
}
-(NSMutableArray *)courseArr{
    if (!_courseArr) {
        _courseArr = [[NSMutableArray alloc]init];
    }
    return _courseArr;
}
-(NSMutableArray *)storeArr{
    if (!_storeArr) {
        _storeArr = [[NSMutableArray alloc]init];
    }
    return _storeArr;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]initWithObjects:@"9:00",@"9:30",@"10:00",@"10:30",@"11:00",@"11:30",@"12:00",@"12:30",@"13:00",@"13:30",@"14:00",@"14:30",@"15:00",@"15:30",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00",@"19:30",@"20:00",@"20:30",@"21:00",@"21:30",@"22:00", nil];
    }
    return _dataArr;
}
@end
