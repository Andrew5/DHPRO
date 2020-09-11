//
//  WaveProgressViewController.m
//  Test
//
//  Created by Rillakkuma on 2018/3/19.
//  Copyright © 2018年 Rillakkuma. All rights reserved.
//

#import "WaveProgressViewController.h"

#import "DemoViewController.h"
#import "DemoTableViewController.h"

@interface WaveProgressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray *controlArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WaveProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DH_DeviceWidth, DH_DeviceHeight) style:UITableViewStylePlain];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.backgroundColor = [UIColor whiteColor];
	
	[self.view addSubview:self.tableView];
	
	
	self.controlArray=@[@"Demo1",@"Demo2"];
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

	
	
    // Do any additional setup after loading the view.
}
#pragma -mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.controlArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	cell.textLabel.text=self.controlArray[indexPath.row];
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	if (indexPath.row==0) {
		DemoViewController *vc=[[DemoViewController alloc] init];
		[self.navigationController pushViewController:vc animated:YES];
	}else if (indexPath.row==1){
		DemoTableViewController  *vc=[[DemoTableViewController alloc] init];
		[self.navigationController pushViewController:vc animated:YES];
	}
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
