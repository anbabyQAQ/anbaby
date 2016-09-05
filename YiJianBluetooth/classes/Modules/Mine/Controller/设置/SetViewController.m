//
//  SetViewController.m
//  YiJianBluetooth
//
//  Created by 孙程雷Mac on 16/9/5.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "SetViewController.h"
#import "GuanYuWoMenViewController.h"
#import "PasswordXiuGaiViewController.h"
#import "FanKui0ViewController.h"
@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *setTableView;
@property(nonatomic, strong)NSArray *setArray;
@end
static NSString *cellIdent = @"setcell";
@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置";
    self.setArray = @[@"修改密码",@"用户反馈",@"关于我们"];
    [self addTableView];
    [self initLeftBarButtonItem];
}
-(void)addTableView{

    self.setTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCR_W, 120) style:(UITableViewStylePlain)];
    self.setTableView.delegate = self;
    self.setTableView.dataSource = self;
      [self.setTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdent];
    self.setTableView.scrollEnabled = NO;
    [self.view addSubview:self.setTableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent forIndexPath:indexPath];
    cell.textLabel.text = self.setArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    if (indexPath.row == 0) {
        PasswordXiuGaiViewController *password = [[PasswordXiuGaiViewController alloc] init];
        [self.navigationController pushViewController:password animated:YES];
    }else if (indexPath.row == 1){
    
        FanKui0ViewController *fankui = [[FanKui0ViewController alloc] init];
        [self.navigationController pushViewController:fankui animated:YES];
    }else{
    
        GuanYuWoMenViewController *guanyuVC = [[GuanYuWoMenViewController alloc] init];
        [self.navigationController pushViewController:guanyuVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 40;
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
