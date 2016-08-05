//
//  AlarmViewController.m
//  YiJianBluetooth
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "AlarmViewController.h"

@interface AlarmViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{

    UIPickerView *timepickerView;
    
    UILabel *labelAlermTime;
    UIButton *buttonAlermTimeDone;
    
    
    int hour;
    int min;
    
    BOOL saveAlarm;
}


@property(nonatomic, strong)NSMutableArray *arrayHour;
@property(nonatomic, strong)NSMutableArray *arrayMin;
@end

@implementation AlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)loadView{

    [super loadView];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    //定义标签时间
    labelAlermTime = [[UILabel alloc] init];
    labelAlermTime.textColor = [UIColor colorWithRed:110.0/255.0 green:250.0/255.0 blue:210.0/255.0 alpha:0.9];
    labelAlermTime.frame = CGRectMake(0, 60, 320, 80);
    labelAlermTime.text = @"设定时间";
    labelAlermTime.numberOfLines = 2;
    labelAlermTime.textAlignment = UITextAlignmentCenter;
    labelAlermTime.backgroundColor = [UIColor clearColor];
    labelAlermTime.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
    [self.view addSubview:labelAlermTime];
    
    
    buttonAlermTimeDone = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonAlermTimeDone.backgroundColor = [UIColor blueColor];
    [buttonAlermTimeDone setTitle:@"保存" forState:(UIControlStateNormal)];
    [buttonAlermTimeDone addTarget:self action:@selector(alarmtimeDone:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:buttonAlermTimeDone];
    
    
    timepickerView = [[UIPickerView alloc] init];
    timepickerView.frame = CGRectMake(60, 280, 200, 100);
    timepickerView.delegate = self;
    timepickerView.showsSelectionIndicator = YES;
    
    [timepickerView selectRow:12000 inComponent:0 animated:NO];
    [timepickerView selectRow:30000 inComponent:1 animated:NO];
    [self.view addSubview:timepickerView];
    
    
    for (int i = 0; i<24; i++) {
        NSString *tempString = [NSString  stringWithFormat:@"%i",i];
        [self.arrayHour addObject:tempString];
    }
    
    
    for (int i = 0; i<60; i++) {
        NSString *tempString = [NSString  stringWithFormat:@"%i",i];
        [self.arrayMin addObject:tempString];
    }
    
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{

    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)alarmtimeDone:(id)sender{

    saveAlarm = !saveAlarm;
    int ontimer;
    if (saveAlarm) {
        [buttonAlermTimeDone setTitle:@"取消" forState:(UIControlStateNormal)];
        NSDate *now = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
        
        NSInteger currentHour = [dateComponents hour];
        NSInteger currentMin = [dateComponents minute];
        
        int currentTotal = currentHour *3600 + currentMin * 60;
        int alarmTotal = hour *3600 + min *60;
        ontimer = alarmTotal - currentTotal;
        if (ontimer < 0)ontimer = 24 *3600 + ontimer;
        
    
        NSString *tempHour  = nil;
        if (hour < 10) {
            tempHour = [NSString stringWithFormat:@"0%i", hour];
        }else{
        
            tempHour = [NSString stringWithFormat:@"%i",hour];
        }
        
        NSString *tempMin = nil;
        if (min < 10) {
              tempMin = [NSString stringWithFormat:@"0%i", min];
        }else{
        
            tempMin = [NSString stringWithFormat:@"%i", min];
        }
        
        labelAlermTime.text = [NSString stringWithFormat:@"Alart\n%@:%@",tempHour,tempMin];
        
        
        UILocalNotification *notif1 = [[UILocalNotification alloc] init];
        notif1.fireDate = [NSDate dateWithTimeIntervalSinceNow:ontimer];
        notif1.soundName = UILocalNotificationDefaultSoundName;
        notif1.alertBody = [NSString stringWithFormat:@"Alarm on %@",labelAlermTime.text];
        [[UIApplication sharedApplication] scheduleLocalNotification:notif1];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    int i = 0;
    if (component == 0) {
        i = 24000;
    }else if (component == 1){
    
        i = 60000;
    }
    return i;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    UILabel *textlabel = [[UILabel alloc] init];
    textlabel.backgroundColor = [UIColor clearColor];
    textlabel.frame = CGRectMake(0, 0, 45, 45);
    textlabel.textAlignment = UITextAlignmentRight;
    textlabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    
    
    if (component == 0) {
        textlabel.text = [self.arrayHour objectAtIndex:(row % 24)];
    }else if (component == 1){
    
        textlabel.text = [self.arrayMin objectAtIndex:(row % 60)];
    }
    return textlabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if (component == 0) {
        hour = [[self.arrayHour objectAtIndex:row % 24] intValue];
    }else if (component == 1){
    
        min = [[self.arrayMin objectAtIndex:row % 60] intValue];
    }
}

-(NSMutableArray *)arrayHour{

    if (!_arrayHour) {
        _arrayHour = [NSMutableArray array];
    }
    return _arrayHour;
}

-(NSMutableArray *)arrayMin{

    if (!_arrayMin) {
        _arrayMin = [NSMutableArray array];
    }
    return _arrayMin;
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
