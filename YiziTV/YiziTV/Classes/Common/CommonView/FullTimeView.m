//
//  FullTimeView.m
//  ios2688webshop
//
//  Created by wangchan on 16/2/23.
//  Copyright © 2016年 zhangzl. All rights reserved.
//

#import "FullTimeView.h"
#define screenWith  [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height
@interface FullTimeView()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView*fullPickView;
    
    NSInteger yearRange;
    NSInteger dayRange;
    NSInteger startYear;
    
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;

    NSInteger selectedWeekDay;
    //    NSDateFormatter *dateFormatter;
    NSCalendar *calendar;
}
@end

@implementation FullTimeView

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        [self config];
    }
    return self;
}
-(void)config
{
    CGFloat perWidth=self.frame.size.width;
    CGFloat height=self.frame.size.height;
    //0
   
    
    
    fullPickView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, perWidth, height)];
    fullPickView.dataSource=self;
    fullPickView.delegate=self;
    [self addSubview:fullPickView];
    
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger year=[comps year];
    
    startYear=year-15;
    yearRange=20;
    selectedYear=2000;
    selectedMonth=1;
    selectedDay=1;
    dayRange=[self isAllDay:startYear andMonth:1];
    
    
    
    
    UIToolbar * pickTitle=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, perWidth, 40)];
    pickTitle.barStyle=UIBarStyleDefault;
    [self addSubview:pickTitle];
    
    
    UIButton * rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(perWidth-60, 0, 40, 40)];
    
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor customColorWithString:@"28904e"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(finishBtn) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem * rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    
    UIButton * cancleBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor customColorWithString:@"909290"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleBtn) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem * leftItem=[[UIBarButtonItem alloc]initWithCustomView:cancleBtn];
    
    UIBarButtonItem * spaceBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    NSArray * Btnarray=[NSArray arrayWithObjects:leftItem,spaceBtn,rightItem, nil];
    
    pickTitle.items=Btnarray;

}
//默认时间的处理
-(void)setCurDate:(NSDate *)curDate
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:curDate];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    NSInteger weekDay = [comps weekday];
    
    selectedYear=year;
    selectedMonth=month;
    selectedDay=day;
    selectedWeekDay = weekDay;
    
    dayRange=[self isAllDay:year andMonth:month];
    
    [fullPickView selectRow:year-startYear inComponent:0 animated:true];
    [fullPickView selectRow:month-1 inComponent:1 animated:true];
    [fullPickView selectRow:day-1 inComponent:2 animated:true];
    
    //默认刚开始颜色是蓝色
    _rowYear = [fullPickView selectedRowInComponent:0];
    _rowMonth = [fullPickView selectedRowInComponent:1];
    _rowDay = [fullPickView selectedRowInComponent:2];
  
    [fullPickView reloadAllComponents];
    
    

}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return yearRange;
        }
            break;
        case 1:
        {
            return 12;
        }
            break;
        case 2:
        {
            return dayRange;
        }
            break;
               default:
            break;
    }
    return 0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 60;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(screenWith*component/6.0, 0,screenWith/6.0, 30)];
    label.font=[UIFont fontWithName:TextFontName size:16];
    label.tag=component*100+row;
    label.textAlignment=NSTextAlignmentCenter;
    switch (component) {
        case 0:
        {
            label.frame=CGRectMake(5, 0,screenWith/4.0, 30);
            label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            if (row==_rowYear) {
                label.textColor = [UIColor customColorWithString:@"0d0e0d"];
            }
        }
            break;
        case 1:
        {
            label.frame=CGRectMake(screenWith/4.0, 0, screenWith/8.0, 30);
            label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            if (row==_rowMonth) {
                label.textColor = [UIColor customColorWithString:@"0d0e0d"];
            }
        }
            break;
        case 2:
        {
            label.frame=CGRectMake(screenWith*3/8, 0, screenWith/8.0+20, 60);
            NSString *str1 = [NSString stringWithFormat:@"%ld日",(long)row+1];
            
            NSString *str2 = [str1 stringByAppendingFormat:@"\n%@",[self getWeeklyWithRow:row]];
            label.numberOfLines = 0;
            NSString *b = [str2 substringFromIndex:3];
            NSRange range = [str2 rangeOfString:b];
            NSMutableAttributedString* attribute = [[NSMutableAttributedString alloc] initWithString: str2];
            [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}range:range];
            [attribute addAttributes:@{NSForegroundColorAttributeName:[UIColor customColorWithString:@"0d0e0d"]}range:range];
            [label setText: str2];
//
            if (row==_rowDay) {
               label.textColor = [UIColor customColorWithString:@"0d0e0d"];                [label setAttributedText: attribute];
            }
        }
            break;
            
        default:
            break;
    }
    return label;
}

-(NSString*)getWeeklyWithRow:(NSInteger)row
{

    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:row];
    [_comps setMonth:selectedMonth];
    [_comps setYear:selectedYear];
    
    NSDate *_date = [calendar dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [calendar components:NSCalendarUnitWeekday fromDate:_date];
    NSInteger _weekday = [weekdayComponents weekday];
    
    switch (_weekday) {
        case 1:
            return @"周一";
            break;
        case 2:
            return @"周二";
            break;
        case 3:
            return @"周三";
            break;
        case 4:
            return @"周四";
            break;
        case 5:
            return @"周五";
            break;
        case 6:
            return @"周六";
            break;
        case 7:
            return @"周日";
            break;
            
        default:
            break;
    }
    
    return nil;
}
// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
            
        case 0:
        {
            selectedYear=startYear + row;
            dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
            [fullPickView reloadComponent:2];
            _rowYear = row;
        }
            break;
        case 1:
        {
            selectedMonth=row+1;
            dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
            [fullPickView reloadComponent:2];
            _rowMonth = row;
        }
            break;
        case 2:
        {
            selectedDay=row+1;
            _rowDay = row;
        }
            break;
                default:
            break;
    }
    
//    NSString*string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld ",(long)selectedYear,(long)selectedMonth,(long)selectedDay];
//    
//    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
//    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate*inputDate = [inputFormatter dateFromString:string];
//    NSLog(@"date= %@", inputDate);
//    
//    //获取的GMT时间，要想获得某个时区的时间，以下代码可以解决这个问题
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: inputDate];
//    NSDate *localeDate = [inputDate  dateByAddingTimeInterval: interval];
//    NSLog(@"%@", localeDate);
//    if ([self.delegate respondsToSelector:@selector(didFinishPickView:)]) {
//        [self.delegate didFinishPickView:inputDate];
//    }

    [pickerView reloadAllComponents];
}
-(NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month
{
    int day=0;
    switch(month)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day=31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day=30;
            break;
        case 2:
        {
            if(((year%4==0)&&(year%100!=0))||(year%400==0))
            {
                day=29;
                break;
            }
            else
            {
                day=28;
                break;
            }
        }
        default:
            break;
    }
    return day;
}

-(void)finishBtn
{
    NSString*string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld ",(long)selectedYear,(long)selectedMonth,(long)selectedDay];
    
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate*inputDate = [inputFormatter dateFromString:string];
    NSLog(@"date= %@", inputDate);
    
    //获取的GMT时间，要想获得某个时区的时间，以下代码可以解决这个问题
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate: inputDate];
//    NSDate *localeDate = [inputDate  dateByAddingTimeInterval: interval];
//    NSLog(@"%@", localeDate);
    if ([self.delegate respondsToSelector:@selector(didFinishPickView:)]) {
        [self.delegate didFinishPickView:inputDate];
    }

    [UIView animateWithDuration:0.3 animations:^{
      
        [self removeFromSuperview];
    }];
}
-(void)cancleBtn
{
   [self removeFromSuperview];

}
@end
