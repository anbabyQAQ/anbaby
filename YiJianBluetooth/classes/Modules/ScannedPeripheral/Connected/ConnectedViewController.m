//
//  ConnectedViewController.m
//  YiJianBluetooth
//
//  Created by tyl on 16/8/17.
//  Copyright © 2016年 LEI. All rights reserved.
//

#import "ConnectedViewController.h"

@interface ConnectedViewController ()

@end

@implementation ConnectedViewController
@synthesize devicesTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    devicesTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCR_W, SCR_H)];
    devicesTable.delegate=self;
    devicesTable.dataSource=self;
    [devicesTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self setExtraCellLineHidden:devicesTable];
    devicesTable.backgroundColor=UIColorFromRGB(0xf3f3f3);
    [self.view addSubview:devicesTable];
    devicesTable.delegate = self;
    devicesTable.dataSource = self;
    
    [self initLeftBarButtonItem];
}

#pragma mark Table View Data Source delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *NailCellIdentifier = @"NailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NailCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NailCellIdentifier];
    }
    

    cell.textLabel.text = @"SADFA";
    
    return cell;
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
