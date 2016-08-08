//
//  AlarmClockViewController.m
//  YiJianBluetooth
//
//  Created by apple on 16/7/29.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "AlarmClockViewController.h"

@interface AlarmClockViewController ()
{

    int hour;
    int min;
    NSMutableArray *arrayHour;
    NSMutableArray *arrayMin;
}

@property (weak, nonatomic) IBOutlet UIDatePicker *timekDataPick;
@property(nonatomic, strong)NSString *dateString;
@end

@implementation AlarmClockViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商城";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更新" style:UIBarButtonItemStyleDone target:self action:@selector(dateChanged:)] ;
    
    self.timekDataPick.backgroundColor = [UIColor grayColor];
    // [datePicker setDatePickerMode:UIDatePickerModeTime];
    self.timekDataPick.datePickerMode = UIDatePickerModeTime;
    [self.timekDataPick addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
}
// datePicker日期改变会调用此方法
-(void)dateChanged:(id)sender
{
    
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    NSDate *selected = [datePicker date];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"HH:mm"];
    self.dateString  = [dateFormatter stringFromDate:selected];
    
  
}
#pragma mark ======确定按钮点击事件
- (IBAction)makeSureButtonAction:(id)sender {
    
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    
    if (notification!=nil) {
        
        NSDate *now=[NSDate new];
        
        notification.fireDate=[now dateByAddingTimeInterval:10];//10秒后通知
        
        notification.repeatInterval=0;//循环次数，kCFCalendarUnitWeekday一周一次
        
        notification.timeZone=[NSTimeZone defaultTimeZone];
        
        notification.applicationIconBadgeNumber=1; //应用的红色数字
        
        notification.soundName= UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
        
        //去掉下面2行就不会弹出提示框
        
        notification.alertBody=@"通知内容";//提示信息 弹出提示框
        
        notification.alertAction = @"打开";  //提示框按钮
        
        //notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
        
        
        
        // NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
        
        //notification.userInfo = infoDict; //添加额外的信息
        
        
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];      
        
    }
    
    
}

#pragma mark =======取消按钮点击事件
- (IBAction)cancelButtonAction:(id)sender {
    
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
