//
//  IncludeNibTableViewController.m
//  Test
//
//  Created by Rillakkuma on 2016/12/20.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "IncludeNibTableViewController.h"
#import "IncludeNibTableViewCell.h"
#define kCellIdentify @"IncludeNibTableViewCell"
@interface IncludeNibTableViewController ()

@end

@implementation IncludeNibTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

		[_table registerNib:[UINib nibWithNibName:@"IncludeNibTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentify];

	
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	IncludeNibTableViewCell *cell = [_table dequeueReusableCellWithIdentifier:kCellIdentify forIndexPath:indexPath];

//	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//	if (cell == nil) {
//		cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
//	}
	
	return cell;
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
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
