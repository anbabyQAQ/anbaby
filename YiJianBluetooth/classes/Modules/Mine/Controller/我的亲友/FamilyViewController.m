//
//  FamilyViewController.m
//  YiJianBluetooth
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "FamilyViewController.h"
#import "PersonalInfoViewController.h"
#import "UsersDao.h"
#import "User.h"
#import "GetUserFamilyThred.h"
@interface FamilyViewController ()<UITableViewDataSource, UITableViewDelegate>{
    User *_user;
}

@property(nonatomic, strong)NSMutableArray *familyArray;
@property (weak, nonatomic) IBOutlet UITableView *familyTableView;

@end

@implementation FamilyViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.translucent=NO;
    self.tabBarController.tabBar.translucent=NO;
 
    
    self.familyArray = [NSMutableArray arrayWithArray:[UsersDao getAllUsers]];
    [self.familyTableView reloadData];
                        
}
- (NSArray *)familyArray{
    if (_familyArray==nil) {
        _familyArray = [[NSMutableArray alloc]init];
    }
    return _familyArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的亲友";
    
    [self setExtraCellLineHidden:self.familyTableView];
    [self initLeftBarButtonItem];

    [self initrightBarButtonItem:@"添加" action:@selector(measureTemp)];
    
    [self getData];
}
-(void)measureTemp{

    PersonalInfoViewController *person = [[PersonalInfoViewController alloc] initWithUser:nil WithMaster:nil andEditable:YES];
    [self.navigationController pushViewController:person animated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.familyArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    User *user = self.familyArray[indexPath.row];
    cell.textLabel.text = user.name;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
    cell.textLabel.textColor = [UIColor darkTextColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    User *user = self.familyArray[indexPath.row];

    
    PersonalInfoViewController *person = [[PersonalInfoViewController alloc] initWithUser:user WithMaster:nil andEditable:YES];
    [self.navigationController pushViewController:person animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 58;
    
}

#pragma mark ========我的亲友列表请求
-(void)getData{

    GetUserFamilyThred *family = [[GetUserFamilyThred alloc] initWithAid:@"" withToken:@""];
    [family requireonPrev:^{
         [self showHud:@"请求中..." onView:self.view];
    } success:^(NSDictionary *response) {
        NSLog(@"%@", response);
        [self hideHud];
    } unavaliableNetwork:^{
        [self hideHud];
        [self showToast:@"网络未连接"];
    } timeout:^{
        [self hideHud];
        [self showToast:@"网络连接超时"];
    } exception:^(NSString *message) {
        [self hideHud];
        if (message) {
            [self showToast:message];
        }else{
            [self showToast:@"位置错误"];
        }
    }];
    
    
    
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
