//
//  ServiceViewController.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/3.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "ServiceViewController.h"

@interface ServiceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong)UITableView *serviceTableView;
@property(nonatomic, strong)NSArray *serviceArray;
@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"服务";
        self.view.backgroundColor = [UIColor blackColor];
    
    self.serviceArray  = @[@"设备咨询",@"附近医生"];
    
    [self addTableView];
    
   
}
-(void)addTableView{

     self.serviceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:(UITableViewStylePlain)];
    self.serviceTableView.delegate = self;
    self.serviceTableView.dataSource = self;
    [self.view addSubview:self.serviceTableView];
    
    [self setExtraCellLineHidden:self.serviceTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.serviceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = self.serviceArray[indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 58;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
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
