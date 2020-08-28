//
//  QQListViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/12/7.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "QQListViewController.h"
#import "HYBSectionModel.h"
#import "HYBHeaderView.h"
static NSString *kCellIdentfier = @"UITableViewCell";
static NSString *kHeaderIdentifier = @"HeaderView";
@interface QQListViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sectionDataSources;
@end

@implementation QQListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:self.tableView];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self.tableView registerClass:[UITableViewCell class]
		   forCellReuseIdentifier:kCellIdentfier];
	[self.tableView registerClass:[HYBHeaderView class] forHeaderFooterViewReuseIdentifier:kHeaderIdentifier];
    // Do any additional setup after loading the view.
}
- (NSMutableArray *)sectionDataSources {
	if (_sectionDataSources == nil) {
		_sectionDataSources = [[NSMutableArray alloc] init];
		
		for (NSUInteger i = 0; i < 20; ++i) {
			HYBSectionModel *sectionModel = [[HYBSectionModel alloc] init];
			sectionModel.isExpanded = NO;
			sectionModel.sectionTitle = [NSString stringWithFormat:@"section: %ld", (unsigned long)i];
			NSMutableArray *itemArray = [[NSMutableArray alloc] init];
			for (NSUInteger j = 0; j < 10; ++j) {
				HYBCellModel *cellModel = [[HYBCellModel alloc] init];
				cellModel.title = [NSString stringWithFormat:@"标哥出品：section=%ld, row=%ld", (unsigned long)i, (unsigned long)j];
				[itemArray addObject:cellModel];
			}
			sectionModel.cellModels = itemArray;
			
			[_sectionDataSources addObject:sectionModel];
		}
	}
	
	return _sectionDataSources;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.sectionDataSources.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	HYBSectionModel *sectionModel = self.sectionDataSources[section];
	
	return sectionModel.isExpanded ? sectionModel.cellModels.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentfier
															forIndexPath:indexPath];
	HYBSectionModel *sectionModel = self.sectionDataSources[indexPath.section];
	HYBCellModel *cellModel = sectionModel.cellModels[indexPath.row];
	cell.textLabel.text = cellModel.title;
	
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	HYBHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeaderIdentifier];
	
	HYBSectionModel *sectionModel = self.sectionDataSources[section];
	view.model = sectionModel;
	view.expandCallback = ^(BOOL isExpanded) {
		[tableView reloadSections:[NSIndexSet indexSetWithIndex:section]
				 withRowAnimation:UITableViewRowAnimationFade];
	};
	
	return view;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 44;
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
