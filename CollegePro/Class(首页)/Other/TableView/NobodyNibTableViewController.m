//
//  NobodyNibTableViewController.m
//  Test
//
//  Created by Rillakkuma on 2016/12/20.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "NobodyNibTableViewController.h"
#import "NobodyNibTableTableViewCell.h"
#import "SYAccountListCellDelegate.h"
#import "MultiParamButton.h"

#define kCellIdentify @"NobodyNibTableTableViewCell"

@interface NobodyNibTableViewController ()<UITableViewDelegate,UITableViewDataSource,SYAccountListCellDelegate>{
	CGFloat cellHeight;
}
@property (retain, nonatomic) UITableView *tableViewMy;
@property (nonatomic, strong) NSDictionary* paramDic;
@property (nonatomic, strong) NSMutableArray* datas;

@end

@implementation NobodyNibTableViewController
@synthesize datas;
- (id)init
{
	self = [super init];
	
	if (self)
	{
		_paramDic = @{@"one":@"one", @"two":@2, @"third":@(3)};
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	datas = [NSMutableArray array];
	[datas addObject:@"你的世界"];
	[datas addObject:@"我的世界"];
	[datas addObject:@"他的世界"];
	UIButton *buttonName = [UIButton buttonWithType:UIButtonTypeCustom];
	[buttonName setFrame:CGRectMake(10, 64, 100, 30)];
	[buttonName setTitle:@"我的世界" forState:(UIControlStateNormal)];
	[buttonName setBackgroundColor:[UIColor blueColor]];
	buttonName.titleLabel.font = [UIFont systemFontOfSize:17];
	[buttonName addTarget:self action:@selector(choose) forControlEvents:(UIControlEventTouchUpInside)];
	[self.view addSubview:buttonName];
	
	_tableViewMy = [[UITableView alloc] initWithFrame:CGRectMake(0.0 , 64+30+20 ,DH_DeviceWidth ,200) style:UITableViewStylePlain];
	_tableViewMy.dataSource = self;
	_tableViewMy.delegate = self;
	_tableViewMy.tableFooterView = [UIView new];
	[self.view addSubview:_tableViewMy];
	
	[_tableViewMy registerClass:[NobodyNibTableTableViewCell class] forCellReuseIdentifier:kCellIdentify];

}
- (void)choose{
	NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
	for (int i=0; i<3; i++) {
		NSString *s = [[NSString alloc] initWithFormat:@"hello %d",i];
		[datas addObject:s];
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
		[indexPaths addObject: indexPath];
	}
	cellHeight = datas.count*50;
	if (cellHeight>(DH_DeviceHeight - 114)) {
		_tableViewMy.height = DH_DeviceHeight - 114;
	}else{
		_tableViewMy.height =datas.count*50;
	}
	
	[_tableViewMy beginUpdates];
	[_tableViewMy insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
	[_tableViewMy reloadData];
	[_tableViewMy endUpdates];
	
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *ID =@"UITableViewCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
	}
	cell.textLabel.text = datas[indexPath.row];
	/*
	 1、dequeueReuseableCellWithIdentifier:与dequeueReuseableCellWithIdentifier:forIndexPath:的区别：
	前者不必向tableView注册cell的Identifier，但需要判断获取的cell是否为nil；
	后者则必须向table注册cell，可省略判断获取的cell是否为空，因为无可复用cell时runtime将使用注册时提供的资源去新建一个cell并返回
	*/
	if (indexPath.row == 1) {
//		NobodyNibTableTableViewCell *cell = [_tableViewMy dequeueReusableCellWithIdentifier:kCellIdentify forIndexPath:indexPath];
//		
//		return cell;
		NobodyNibTableTableViewCell *cell2 = [_tableViewMy dequeueReusableCellWithIdentifier:kCellIdentify forIndexPath:indexPath];
		cell2.block = ^(NSString *str){
			NSLog(@"%@", str);
		};
		//		LBEquiRunParamsTableCell *cell2 = [tableViewParams dequeueReusableCellWithIdentifier:idefntif forIndexPath:indexPath];
		
		return cell2;


	}

 
	
	
//	NSDictionary* paramDic = @{@"one":@"one", @"two":@2, @"third":@(3)};
//	
//	MultiParamButton* multiParamButton = [[MultiParamButton alloc] init];
//	[multiParamButton setFrame:CGRectMake(0, 5, 40, 40)];
//	multiParamButton.center = cell.contentView.center;
//	[multiParamButton setBackgroundColor:[UIColor grayColor]];
//	[multiParamButton addTarget:self action:@selector(multiParamButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//	[cell.contentView addSubview:multiParamButton];
//	
//	multiParamButton.multiParamDic = paramDic;

	
	return cell;
	
}
- (void)accountListCell:(NobodyNibTableTableViewCell *)cell didTapButton:(UIButton *)button
{
	NSLog(@"Cell : %@ , Button : %@", cell, button);
}

- (void)multiParamButtonClicked:(UIButton* )button
{
//	MultiParamButton* multiParamButton = (MultiParamButton* )button;
//	
//	NSLog(@"Vvvverify : %@", multiParamButton.multiParamDic);
	
//	//获取button所属的视图控制器，如果视图控制器都能获取，还有什么不能获取呢？
//	for(UIView* next = [button superview]; next; next = next.superview)
//	{
//		UIResponder *nextResponder = [next nextResponder];
//		
//		if ([nextResponder isKindOfClass:[NobodyNibTableTableViewCell class]])
//		{
//			cell = (NobodyNibTableTableViewCell* )nextResponder;
//			
//			break;
//		}
//	}
//	NSLog(@"param : %@", multiParamButtonController.paramDic);
	
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	if (indexPath.row == 2) {
//		return 10;
//	}
	return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	/*
	总结：
	1.自定义cell时，
	若使用nib，使用 registerNib: 注册，dequeue时会调用 cell 的 -(void)awakeFromNib
	不使用nib，使用 registerClass: 注册, dequeue时会调用 cell 的 - (id)initWithStyle:withReuseableCellIdentifier:
	2.需不需要注册？
	使用dequeueReuseableCellWithIdentifier:可不注册，但是必须对获取回来的cell进行判断是否为空，若空则手动创建新的cell；
	使用dequeueReuseableCellWithIdentifier:forIndexPath:必须注册，但返回的cell可省略空值判断的步骤。
	 */
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
