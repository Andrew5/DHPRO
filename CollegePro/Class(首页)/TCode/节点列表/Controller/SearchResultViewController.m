//
//  SearchResultViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/11/28.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "SearchResultViewController.h"
#import "ContactModel.h"
@interface SearchResultViewController ()<UITableViewDataSource,UITableViewDelegate>
{
	UITableView *_tableViewMy;
	NSMutableArray *_dataSource;
	UILabel *_footerLabel;
}
@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	_dataSource = [NSMutableArray array];

	_tableViewMy = [[UITableView alloc]init];
	_tableViewMy.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	_tableViewMy.delegate = self;
	_tableViewMy.dataSource = self;
//	[_tableViewMy registerClass:[<#UITableViewCell#> class]forCellReuseIdentifier:NSStringFromClass([<#UITableViewCell#> class])];
	_tableViewMy.tableFooterView = [UIView new];
	[self.view addSubview:_tableViewMy];
	_footerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _tableViewMy.frame.size.width, 40)];
	_footerLabel.textAlignment = NSTextAlignmentCenter;
	_footerLabel.textColor = [UIColor lightGrayColor];
	if (_dataSource.count==0) {
		_footerLabel.text = @"无结果";
		_tableViewMy.tableFooterView = _footerLabel;
	}else{
		_footerLabel.text = @"";
	}
    // Do any additional setup after loading the view.
}

#pragma -mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellId = @"cellId";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//	if (cell == nil) {
//		cell = [[[NSBundle mainBundle] loadNibNamed:@"UITableViewCell" owner:nil options:nil]firstObject];
//	}
	
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	if (_dataSource.count>0) {
		ContactModel *friend = _dataSource[indexPath.row];
		//		NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:_dataSource[indexPath.row] options:(NSJSONReadingAllowFragments) error:nil];
		//		[self setValuesForKeysWithDictionary:_dataSource[indexPath.row]];
		NSLog(@"返回的数据:%@--%ld",friend.Name,_dataSource.count);
		
		cell.textLabel.text = [NSString stringWithFormat:@"%@",friend.Name];
//		[cell.photoIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[USERDEFAULTS objectForKey:@"url"],friend.HeadUrl]] placeholderImage:[UIImage imageNamed:@"EaseUIResource.bundle/user"] completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
//		}];

	}else{
		if (_dataSource.count==0) {
			_footerLabel.text = @"无结果";
			_tableViewMy.tableFooterView = _footerLabel;
		}else{
			_footerLabel.text = @"";
		}
		
	}
	return cell;
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = (UITableViewCell*)[self tableView:_tableViewMy cellForRowAtIndexPath:indexPath];
	return cell.frame.size.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	ContactModel *friend = _dataSource[indexPath.row];
	
	[self dismissViewControllerAnimated:YES completion:^{
		
		if (self.delegate&&[self.delegate respondsToSelector:@selector(selectPersonWithUserId:userName:photo:HX_UserID:)]) {
			[self.delegate selectPersonWithUserId:friend.EmpId userName:friend.Name photo:friend.HeadUrl HX_UserID:friend.HX_UserID];
		}
	}];
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
	NSLog(@"Entering:%@ ",searchController.searchBar.text);

}
-(void)updateAddressBookData:(NSArray *)AddressBookDataArray{
	
	
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
