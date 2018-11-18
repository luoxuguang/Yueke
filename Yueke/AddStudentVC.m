//
//  AddStudentVC.m
//  Yueke
//
//  Created by luo on 2018/9/19.
//  Copyright © 2018年 luoxuguang. All rights reserved.
//

#import "AddStudentVC.h"

;


@interface AddStudentVC () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITextField *nameField;
@property (nonatomic,strong) UITextField *storeField;
@property (nonatomic,strong) UITextField *courseField;
@property (nonatomic,strong) UITextField *yearField;
@property (nonatomic,strong) UITextField *heigthField;
@property (nonatomic,strong) UITextField *weightField;
@property (nonatomic,strong) UITextField *phoneField;
@property (nonatomic) BOOL isWoman;

@end

@implementation AddStudentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    switch (self.addType) {
        case ADDCOURSE:
        {
            self.navigationItem.title = @"添加课程";
        }
            break;
        case ADDSTUDENT:
        {
            self.navigationItem.title = @"添加学员";
        }
            break;
        case ADDSTORE:
        {
            self.navigationItem.title = @"添加门店";
        }
            break;
    }
    self.view.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.view addSubview:self.tableView];
    
}


-(void)saveUser{
    switch (self.addType) {
        case ADDSTUDENT:
        {
            if (self.nameField.text.length==0) {
                [JohnAlertManager showAlertWithType:JohnTopAlertTypeError title:@"请输入学员姓名！"];
                return;
            }
            [MBProgressHUD showMessage:@"请稍后..." toView:self.view];
            NSDictionary *dict = @{@"token":user_token,
                                   @"name":self.nameField.text,
                                   @"sex":_isWoman?@"1":@"0",
                                   @"yearold":self.yearField.text?self.yearField.text:@"",
                                   @"weight":self.weightField.text?self.weightField.text:@"",
                                   @"heigth":self.heigthField.text?self.heigthField.text:@"",
                                   };
            [BasicNetWorking POST:[NSString stringWithFormat:@"%@%@",BaseUrl,API_addUser] parameters:dict success:^(id responseObject) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (self.AddSuccessBlock) {
                    self.AddSuccessBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }
            break;
        case ADDSTORE:
        {
            if (self.storeField.text.length==0) {
                [JohnAlertManager showAlertWithType:JohnTopAlertTypeError title:@"请输入门店名称！"];
                return;
            }
            [MBProgressHUD showMessage:@"请稍后..." toView:self.view];
            NSDictionary *dict = @{@"token":user_token,
                                   @"name":self.storeField.text
                                   };
            [BasicNetWorking POST:[NSString stringWithFormat:@"%@%@",BaseUrl,API_addStore] parameters:dict success:^(id responseObject) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [JohnAlertManager showAlertWithType:JohnTopAlertTypeSuccess title:@"门店添加成功！"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [JohnAlertManager showAlertWithType:JohnTopAlertTypeError title:@"网络出错了哦！"];
            }];
        }
            break;
        case ADDCOURSE:
        {
            if (self.courseField.text.length==0) {
                [JohnAlertManager showAlertWithType:JohnTopAlertTypeError title:@"请输入课程名称！"];
                return;
            }
            [MBProgressHUD showMessage:@"请稍后..." toView:self.view];
            NSDictionary *dict = @{@"token":user_token,
                                   @"name":self.courseField.text
                                   };
            [BasicNetWorking POST:[NSString stringWithFormat:@"%@%@",BaseUrl,API_addCourse] parameters:dict success:^(id responseObject) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [JohnAlertManager showAlertWithType:JohnTopAlertTypeSuccess title:@"课程添加成功！"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [JohnAlertManager showAlertWithType:JohnTopAlertTypeError title:@"网络出错了哦！"];
            }];
        }
            break;
    }
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.addType == ADDSTUDENT) {
        return 6;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    switch (indexPath.row) {
        case 0:
        {
            switch (self.addType) {
                case ADDSTUDENT:
                {
                    [cell addSubview:self.nameField];
                }
                    break;
                case ADDSTORE:
                {
                    [cell addSubview:self.storeField];
                }
                    break;
                case ADDCOURSE:
                {
                    [cell addSubview:self.courseField];
                }
                    break;
            }
            
        }
            break;
        case 1:
        {
            cell.textLabel.textColor = [UIColor colorWithHex:0x666666];
            cell.textLabel.font = [UIFont systemFontOfSize:14.0];
            if (_isWoman) {
                cell.textLabel.text =[NSString stringWithFormat:@"选择性别:   女"];
                
            }else{
                cell.textLabel.text =[NSString stringWithFormat:@"选择性别:   男"];
            }
        }
            break;
        case 2:
        {
            [cell addSubview:self.yearField];
        }
            break;
        case 3:
        {
            [cell addSubview:self.heigthField];
        }
            break;
        case 4:
        {
            [cell addSubview:self.weightField];
        }
            break;
        case 5:
        {
            [cell addSubview:self.phoneField];
        }
            break;
    }
    
    if (indexPath.row==1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
         cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *womanAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"女");
            self.isWoman = YES;
            [self.tableView reloadData];
        }];
        UIAlertAction *manAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.isWoman = NO;
            [self.tableView reloadData];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           
        }];
        [alertController addAction:manAction];
        [alertController addAction:womanAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
}




-(UITextField *)nameField{
    if (!_nameField) {
        _nameField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 60)];
        _nameField.tintColor = BlueColor;
        _nameField.placeholder = @"输入学员名称(必填)";
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 60)];
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = [UIColor colorWithHex:0x666666];
        label.text = @"学员名称:";
        _nameField.leftView = label;
        _nameField.font = [UIFont systemFontOfSize:14.0];
        _nameField.textColor = [UIColor colorWithHex:0x333333];
        _nameField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _nameField;
}
-(UITextField *)storeField{
    if (!_storeField) {
        _storeField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 60)];
        _storeField.tintColor = BlueColor;
        _storeField.placeholder = @"输入门店名称(必填)";
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 60)];
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = [UIColor colorWithHex:0x666666];
        label.text = @"门店名称:";
        _storeField.leftView = label;
        _storeField.font = [UIFont systemFontOfSize:14.0];
        _storeField.textColor = [UIColor colorWithHex:0x333333];
        _storeField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _storeField;
}
-(UITextField *)courseField{
    if (!_courseField) {
        _courseField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 60)];
        _courseField.tintColor = BlueColor;
        _courseField.placeholder = @"输入课程名称(必填)";
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 60)];
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = [UIColor colorWithHex:0x666666];
        label.text = @"课程名称:";
        _courseField.leftView = label;
        _courseField.font = [UIFont systemFontOfSize:14.0];
        _courseField.textColor = [UIColor colorWithHex:0x333333];
        _courseField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _courseField;
}
-(UITextField *)heigthField{
    if (!_heigthField) {
        _heigthField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 60)];
        _heigthField.tintColor = BlueColor;
        _heigthField.placeholder = @"输入学员身高(选填)";
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 60)];
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = [UIColor colorWithHex:0x666666];
        label.text = @"学员身高:";
        _heigthField.keyboardType = UIKeyboardTypeNumberPad;
        _heigthField.leftView = label;
        _heigthField.font = [UIFont systemFontOfSize:15.0];
        _heigthField.textColor = [UIColor colorWithHex:0x333333];
        _heigthField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _heigthField;
}
-(UITextField *)weightField{
    if (!_weightField) {
        _weightField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 60)];
        _weightField.tintColor = BlueColor;
        _weightField.placeholder = @"输入学员体重(选填)";
        _weightField.keyboardType = UIKeyboardTypeNumberPad;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 60)];
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = [UIColor colorWithHex:0x666666];
        label.text = @"学员体重:";
        _weightField.leftView = label;
        _weightField.font = [UIFont systemFontOfSize:14.0];
        _weightField.textColor = [UIColor colorWithHex:0x333333];
        _weightField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _weightField;
}
-(UITextField *)yearField{
    if (!_yearField) {
        _yearField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 60)];
        _yearField.tintColor = BlueColor;
        _yearField.placeholder = @"输入学员年龄(选填)";
        _yearField.keyboardType = UIKeyboardTypeNumberPad;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 60)];
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = [UIColor colorWithHex:0x666666];
        label.text = @"学员年龄:";
        _yearField.leftView = label;
        _yearField.font = [UIFont systemFontOfSize:14.0];
        _yearField.textColor = [UIColor colorWithHex:0x333333];
        _yearField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _yearField;
}
-(UITextField *)phoneField{
    if (!_phoneField) {
        _phoneField = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 60)];
        _phoneField.tintColor = BlueColor;
        _phoneField.placeholder = @"输入学员手机号(选填)";
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 60)];
        label.font = [UIFont systemFontOfSize:14.0];
        label.textColor = [UIColor colorWithHex:0x666666];
        label.text = @"联系方式:";
        _phoneField.leftView = label;
        _phoneField.font = [UIFont systemFontOfSize:14.0];
        _phoneField.textColor = [UIColor colorWithHex:0x333333];
        _phoneField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _phoneField;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
//        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self ;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(30, 5, ScreenWidth-60, 45);
        [saveBtn addTarget:self action:@selector(saveUser) forControlEvents:UIControlEventTouchUpInside];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor colorWithHex:0x005555] forState:UIControlStateNormal];
        [saveBtn setBackgroundColor:[UIColor colorWithHex:GreenColor]];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        [view addSubview:saveBtn];
        _tableView.tableFooterView = view;
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
