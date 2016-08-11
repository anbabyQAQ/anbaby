//
//  ShoppingMallViewController.m
//  YiJianBluetooth
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "ShoppingMallViewController.h"

@interface ShoppingMallViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)NSArray *shoppingMallArray;
@property (weak, nonatomic) IBOutlet UITableView *shoppingMallTableView;

@end

@implementation ShoppingMallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商城";
    
    self.shoppingMallArray = @[@"商品",@"血压仪",@"血糖仪",@"温度计"];
    
    [self setExtraCellLineHidden:self.shoppingMallTableView];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.shoppingMallArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = self.shoppingMallArray[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = [UIFont systemFontOfSize:text_size_between_normalAndSmall];
    cell.textLabel.textColor = [UIColor darkTextColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 58;
    
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
