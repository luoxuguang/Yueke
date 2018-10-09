//
//  HLPickView.m
//  ActionSheet
//
//  Created by 赵子辉 on 15/10/22.
//  Copyright © 2015年 zhaozihui. All rights reserved.
//

#import "ZHPickView.h"
#define SCREENSIZE UIScreen.mainScreen.bounds.size
@implementation ZHPickView
{
    UIView *bgView;
    NSArray *proTitleList;
    NSArray *minList;
    NSString *selectedStr;
    UIPickerView *pickView;
    NSInteger column;
    BOOL isDate;
}
@synthesize block;
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    isDate = NO;
    minList = @[@"00",@"30"];
    return self;
}
- (void)showPickView:(UIViewController *)vc
{
    bgView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.3f;
    [vc.view addSubview:bgView];
    
    CGRect frame = self.frame ;
    self.frame = CGRectMake(0,SCREENSIZE.height + frame.size.height, SCREENSIZE.width, frame.size.height);
    [vc.view addSubview:self];
    [UIView animateWithDuration:0.5f
                     animations:^{
                         
                         self.frame = frame;
                     }
                     completion:nil];
}
- (void)hide
{
    [bgView removeFromSuperview];
    [self removeFromSuperview];
    
    
}
- (void)setDateViewWithTitle:(NSString *)title
{
    isDate = YES;
    proTitleList = @[];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENSIZE.width, 39.5)];
    header.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, SCREENSIZE.width - 80, 39.5)];
    titleLbl.text = title;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = BlueColor;
    titleLbl.font = [UIFont systemFontOfSize:17.0];
    [header addSubview:titleLbl];
    
    
    
    UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(SCREENSIZE.width - 50, 0, 50 ,39.5)];
    [submit setTitle:@"确定" forState:UIControlStateNormal];
    [submit setTitleColor:[self getColor:@"333333"] forState:UIControlStateNormal];
    submit.backgroundColor = [UIColor whiteColor];
    submit.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:submit];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50 ,39.5)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancel.backgroundColor = [UIColor whiteColor];
    cancel.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:cancel];
    
    [self addSubview:header];
    
    // 1.日期Picker
    UIDatePicker *datePickr = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, SCREENSIZE.width, 200)];
    datePickr.backgroundColor = [UIColor whiteColor];
    // 1.1选择datePickr的显示风格
    [datePickr setDatePickerMode:UIDatePickerModeDate];
    
    // 1.2查询所有可用的地区
    //NSLog(@"%@", [NSLocale availableLocaleIdentifiers]);
    
    // 1.3设置datePickr的地区语言, zh_Han后面是s的就为简体中文,zh_Han后面是t的就为繁体中文
    [datePickr setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_CN"]];
    
    // 1.4监听datePickr的数值变化
    [datePickr addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    NSDate *date = [NSDate date];
    
    // 2.3 将转换后的日期设置给日期选择控件
    [datePickr setDate:date];
    
    [self addSubview:datePickr];
    
    float height = 240;
    self.frame = CGRectMake(0, SCREENSIZE.height - height, SCREENSIZE.width, height);
}
- (void)setDataViewWithItem:(NSArray *)items centerStr:(NSString *)centerStr title:(NSString *)title isNext:(BOOL)isNext column:(NSInteger)cln
{
    isDate = NO;
    column = cln;
    proTitleList = items;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENSIZE.width, 39.5)];
    header.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, SCREENSIZE.width - 80, 39.5)];
    titleLbl.text = title;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = BlueColor;
    titleLbl.font = [UIFont systemFontOfSize:17.0];
    [header addSubview:titleLbl];
    
    
    
    UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(SCREENSIZE.width - 50, 0, 50 ,39.5)];
    [submit setTitle:@"确定" forState:UIControlStateNormal];
    [submit setTitleColor:[self getColor:@"333333"] forState:UIControlStateNormal];
    submit.backgroundColor = [UIColor whiteColor];
    submit.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:submit];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50 ,39.5)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancel.backgroundColor = [UIColor whiteColor];
    cancel.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:cancel];

    [self addSubview:header];
    UIPickerView *pick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, SCREENSIZE.width, 200)];
    pick.dataSource = self;
    pick.delegate = self;
    pick.backgroundColor = [UIColor whiteColor];
    pickView = pick;
    [self addSubview:pick];
    
    if (centerStr&&column==2) {
        NSInteger hourRow = [items indexOfObject:[centerStr substringToIndex:2]];
        NSInteger minRow = [[centerStr substringFromIndex:3] integerValue]>=30?1:0;
        if (isNext) {
            [pick selectRow:hourRow+1 inComponent:0 animated:YES];
        }else{
            [pick selectRow:hourRow inComponent:0 animated:YES];
        }
        [pick selectRow:minRow inComponent:1 animated:YES];
    }
    
    
    float height = 240;
    self.frame = CGRectMake(0, SCREENSIZE.height - height, SCREENSIZE.width, height);
}
#pragma mark DatePicker监听方法
- (void)dateChanged:(UIDatePicker *)datePicker
{
    // 1.要转换日期格式, 必须得用到NSDateFormatter, 专门用来转换日期格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // 1.1 先设置日期的格式字符串
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    // 1.2 使用格式字符串, 将日期转换成字符串
    selectedStr = [formatter stringFromDate:datePicker.date];
}
- (void)cancel:(UIButton *)btn
{
    [self hide];
    
}

- (void)submit:(UIButton *)btn
{
    NSString *pickStr = selectedStr;
    if (!pickStr || pickStr.length == 0) {
        if(isDate) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            selectedStr = [formatter stringFromDate:[NSDate date]];
        } else {
            if([proTitleList count] > 0) {
                if (column==1) {
                    selectedStr = [NSString stringWithFormat:@"%@",proTitleList[[pickView selectedRowInComponent:0]]];
                }else{
                    selectedStr = [NSString stringWithFormat:@"%@:%@",proTitleList[[pickView selectedRowInComponent:0]],minList[[pickView selectedRowInComponent:1]]];
                }
                
            }
            
        }
    }
    block(selectedStr);
    [self hide];
   
    
}

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return column;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    if (component == 0) {
        return [proTitleList count];
    }
    return [minList count];
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return 180;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (column==1) {
        selectedStr = [NSString stringWithFormat:@"%@",proTitleList[[pickerView selectedRowInComponent:0]]];
        return;
    }
    selectedStr = [NSString stringWithFormat:@"%@:%@",proTitleList[[pickerView selectedRowInComponent:0]],minList[[pickerView selectedRowInComponent:1]]];
    
    
}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0) {
        return [proTitleList objectAtIndex:row];
    }
    return [minList objectAtIndex:row];

}


- (UIColor *)getColor:(NSString*)hexColor

{
    
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
    
}
@end

