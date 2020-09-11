//
//  DHNoteListViewController.m
//  Test
//
//  Created by Rillakkuma on 2018/3/16.
//  Copyright © 2018年 Rillakkuma. All rights reserved.
//

#import "DHNoteListViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ContactCtrlDelegate.h"

#import "AddNoteTableViewController.h"
#import "Message.h"
#import "DisplayNoteViewController.h"
#import <CoreGraphics/CoreGraphics.h>

#import "DHMainViewController.h"

@interface DHNoteListViewController ()<UIScrollViewDelegate,UISearchDisplayDelegate>
@property (retain, nonatomic) AVAudioPlayer *audioPlayer;



@property (retain, nonatomic) NSMutableArray *messages;
//所有message的title
@property (retain, nonatomic) NSMutableArray *messageTitles;
@property (retain, nonatomic) NSMutableArray *searchResult;

@property (retain, nonatomic) UISearchBar *mySearchBar;
@property (retain, nonatomic) UISearchDisplayController *mySearchDisplayController;

@end

@implementation DHNoteListViewController
{
	NSString *background;
}
@synthesize audioPlayer = _audioPlayer;
@synthesize messages = _messages;
@synthesize messageTitles = _messageTitles;
@synthesize searchResult = _searchResult;
@synthesize mySearchBar = _mySearchBar;
@synthesize mySearchDisplayController = _mySearchDisplayController;


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	//取消搜索状态
	[self.mySearchDisplayController setActive:NO animated:NO];
	
	[self.tableView reloadData];
}
- (void)back{
//	pop;
//	UIViewController *viewCtl = self.navigationController.viewControllers[2];
//
//	[self.navigationController popToViewController:viewCtl animated:YES];
//	dis;
//	[self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
	//  当本视图控制器dismiss 完成后注册通知，名为“dismiss”
	[self dismissViewControllerAnimated:NO completion:^{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"dismiss" object:self];
	}];  
	
//	DHMainViewController *homeVC = [[DHMainViewController alloc] init];
//	UIViewController *target = nil;
//	for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
//		if ([controller isKindOfClass:[homeVC class]]) { //这里判断是否为你想要跳转的页面
//			target = controller;
//		}
//	}
//	if (target) {
//		[self.navigationController popToViewController:target animated:YES]; //跳转
//	}

	
}
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.title = @"Notes";
	
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:125.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0];
	
	self.tableView.backgroundColor = [UIColor colorWithRed:125.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0];
	//    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"open1.jpg"]];
	
//	UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonSystemItemCancel target:self action:@selector(back)];
//	self.navigationItem.backBarButtonItem = backBarButtonItem;
//	[backBarButtonItem release];
	
	
	UIBarButtonItem *mybackmarks = [ [ UIBarButtonItem alloc ]
									initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
									target: self
									action: @selector(back)
									];
	
	
	UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(addNote)];
	self.navigationItem.leftBarButtonItems = @[mybackmarks,addBarButtonItem];
//	[addBarButtonItem release];
	
	UIBarButtonItem *removeBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除全部" style:UIBarButtonItemStylePlain target:self action:@selector(removeAll)];
	self.navigationItem.rightBarButtonItem = removeBarButtonItem;
//	[removeBarButtonItem release];
	
	NSString *fullpath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"notes.archive"];
	self.messages = [NSKeyedUnarchiver unarchiveObjectWithFile:fullpath];
	if (!self.messages) {
		self.messages = [NSMutableArray array];
	}
	self.searchResult = [NSMutableArray array];
	
	
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, DH_DeviceWidth, 44.0)];
	headerView.backgroundColor = [UIColor colorWithRed:125.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0];
	self.tableView.tableHeaderView = headerView;
//	[headerView release];
	//添加搜索栏
	UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, DH_DeviceWidth, 44.0)];
	searchBar.placeholder = @"search";
	searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	searchBar.backgroundColor = [UIColor colorWithRed:125.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0];
	[self.tableView.tableHeaderView addSubview:searchBar];
	self.mySearchBar = searchBar;
//	[searchBar release];
	
	UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.mySearchBar contentsController:self];
	searchDisplayController.delegate= self;
	searchDisplayController.searchResultsDelegate = self;
	searchDisplayController.searchResultsDataSource = self;
	self.mySearchDisplayController = searchDisplayController;
//	[searchDisplayController release];
//	uisearchcontroller
//    UISearchController
    // Do any additional setup after loading the view.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
	if (tableView == self.mySearchDisplayController.searchResultsTableView)
	{
		return [self.searchResult count];
	}
	else
	{
		return [self.messages count];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"Why");
	
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
	}
	if (tableView == self.mySearchDisplayController.searchResultsTableView) {
		cell.textLabel.text = [self.searchResult objectAtIndex:indexPath.row];
		cell.textLabel.font = [UIFont systemFontOfSize:20.0];
		for (int i=0; i<[self.messages count]; i++) {
			if (cell.textLabel.text == [[self.messages objectAtIndex:i] title]) {
				cell.detailTextLabel.text = [[self.messages objectAtIndex:i] createDate];
			}
		}
		cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
		cell.detailTextLabel.textColor = [UIColor darkGrayColor];
		//        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
	}
	else
	{
		cell.textLabel.text = [[self.messages objectAtIndex:indexPath.row] title];
		cell.textLabel.font = [UIFont systemFontOfSize:20.0];
		cell.detailTextLabel.text = [[self.messages objectAtIndex:indexPath.row] createDate];
		cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
		cell.detailTextLabel.textColor = [UIColor darkGrayColor];
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[self.messages removeObjectAtIndex:indexPath.row];
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	NSString *fullpath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"notes.archive"];
	[NSKeyedArchiver archiveRootObject:self.messages toFile:fullpath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	DisplayNoteViewController *display = [[DisplayNoteViewController alloc] init];
	if (tableView == self.mySearchDisplayController.searchResultsTableView) {
		display.messageTitle = [self.searchResult objectAtIndex:indexPath.row];
		display.messages = self.messages;
		display.isSearchResult = YES;
	}
	else{
		display.messageIndex = indexPath.row;
		display.messages = self.messages;
		display.isSearchResult = NO;
	}
	//    display.delegate = self;
	[self.navigationController pushViewController:display animated:YES];
//	[display release];
}


//- (void)callBack:(id)sender
//{
//    self.messages = sender;
//
//}

- (void)addNote
{
	AddNoteTableViewController *addNote = [[AddNoteTableViewController alloc] initWithStyle:UITableViewStylePlain];
	//    addNote.delegate = self;
	addNote.messages = self.messages;
	//    addNote.backgroundImage = background;
	UINavigationController *addNavigation = [[UINavigationController alloc] initWithRootViewController:addNote];
	
	addNavigation.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	
	[self presentViewController:addNavigation animated:YES completion:^{
		//        [UIView animateWithDuration:0.5 animations:^{
		//            [UIView setAnimationTransition:UIViewAnimationOptionTransitionFlipFromLeft forView:addNote.view cache:YES];
		//        }];
	}];
	
//	[addNote release];
//	[addNavigation release];
}

- (void)removeAll
{
	[self.messages removeAllObjects];
	[self.tableView reloadData];
	
	NSString *fullpath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"notes.archive"];
	[NSKeyedArchiver archiveRootObject:self.messages toFile:fullpath];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	NSLog(@"%@",self.messages);
	[self.searchResult removeAllObjects];
	self.messageTitles = [NSMutableArray array];
	for (int i=0; i<[self.messages count]; i++) {
		[self.messageTitles addObject:[[self.messages objectAtIndex:i] title]];
	}
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains %@",searchString];
	[self.searchResult addObjectsFromArray:[self.messageTitles filteredArrayUsingPredicate:predicate]];
	NSLog(@"%@",self.searchResult);
	return YES;
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
