//
//  AddNoteTableViewController.m
//  Test
//
//  Created by Rillakkuma on 2018/3/16.
//  Copyright © 2018年 Rillakkuma. All rights reserved.
//

#import "AddNoteTableViewController.h"
#import "ContactCtrlDelegate.h"
#import "string.h"
#import "Message.h"

@interface AddNoteTableViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
	NSString *background;
}

@property (retain, nonatomic) UITextField *titleField;
@property (retain, nonatomic) UITextView *contentView;
//@property (retain, nonatomic) id<ContactCtrlDelegate> delegate;//开放delegate

@property (retain, nonatomic) UIScrollView *scrollView;
@property (retain, nonatomic) UIPageControl *pageControl;
@property (retain, nonatomic) UIView *myPanelView;
@property (retain, nonatomic) UILabel *panelTitle;

@end

@implementation AddNoteTableViewController
@synthesize messages = _messages;
@synthesize audioPlayer = _audioPlayer;

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize myPanelView = _myPanelView;
@synthesize panelTitle = _panelTitle;
@synthesize titleField = _titleField;
@synthesize contentView = _contentView;
//@synthesize delegate = _delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	[self setupui];
}
- (void)setupui{
	self.navigationItem.title = @"新建";
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:125.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = cancelButton;
//	[cancelButton release];
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButton;
//	[saveButton release];
	
	//    isSetBackground = NO;
	//制定选择面板视图
	UIView *panelView = [[UIView alloc] initWithFrame:CGRectMake(0.0, -180.0, DH_DeviceWidth, 180.0)];
	panelView.backgroundColor = [UIColor yellowColor];
	self.myPanelView = panelView;
	[self.tableView addSubview:panelView];
	panelView.layer.opacity = 0.0;
//	[panelView release];
	//面板标题
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, DH_DeviceWidth, 30.0)];
	titleLabel.backgroundColor = [UIColor lightGrayColor];
	titleLabel.text = @"背景设置";
	titleLabel.textAlignment = NSTextAlignmentCenter;
	self.panelTitle = titleLabel;
	[self.myPanelView addSubview:titleLabel];
//	[titleLabel release];
	//完成按钮
	
	UIButton *newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	newButton.frame = CGRectMake(250.0, 5.0, 60.0, 20.0);
	[newButton setTitle:@"完成" forState:UIControlStateNormal];
	[newButton addTarget:self action:@selector(saveBackground) forControlEvents:UIControlEventTouchUpInside];
	[self.myPanelView addSubview:newButton];
	
	//滚动选择面板
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 30.0, DH_DeviceWidth, 140.0)];
	scrollView.delegate = self;
	scrollView.contentSize = CGSizeMake(DH_DeviceWidth*6, 140.0);
	self.scrollView = scrollView;
	scrollView.showsHorizontalScrollIndicator = NO;
	//    scrollView.layer.opacity = 0.0;
	[self.myPanelView addSubview:scrollView];
//	[scrollView release];
	
	for (int i=0; i<6; i++) {
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DH_DeviceWidth*i, 0.0, DH_DeviceWidth, 140.0)];
		imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",(i+3)%4+1]];
		[self.scrollView addSubview:imageView];
//		[imageView release];
	}
	
	[self.scrollView scrollRectToVisible:CGRectMake(DH_DeviceWidth, 0.0, DH_DeviceWidth, 140.0) animated:NO];
	background = @"1.jpg";
	self.scrollView.pagingEnabled = YES;
	
	UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0, 150.0, DH_DeviceWidth, 20.0)];
	self.pageControl = pageControl;
	pageControl.numberOfPages = 4;
	pageControl.currentPage = 0;
	[panelView addSubview:pageControl];
//	[pageControl release];
	
	UILabel *seperator = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 170.0, DH_DeviceWidth, 10.0)];
	seperator.backgroundColor = [UIColor grayColor];
	[panelView addSubview:seperator];
//	[seperator release];
	
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidesKeyboard)];
	[self.view addGestureRecognizer:gestureRecognizer];
//	[gestureRecognizer release];
	
	self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:background]];
	
	UIView *displayView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, DH_DeviceWidth, 416.0)];
	self.tableView.tableHeaderView = displayView;
//	[displayView release];
	
	UITextField *titleField = [[UITextField alloc] initWithFrame:CGRectMake(95.0, 70.0, 200.0, 30.0)];
	self.titleField = titleField;
	titleField.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
	titleField.placeholder = @"输入标题";
	titleField.text = @"";
	//    titleField.textColor = [UIColor yelloColor];
	titleField.borderStyle = UITextBorderStyleRoundedRect;
	titleField.delegate = self;
	titleField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	//    titleField.keyboardType = UIKeyboardTypeTwitter;
	titleField.returnKeyType = UIReturnKeyNext;
	titleField.font = [UIFont systemFontOfSize:20.0];
	[self.tableView.tableHeaderView addSubview:titleField];
//	[titleField release];
	
	UIButton *showButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
	showButton.frame = CGRectMake(200.0, 15.0, 100.0, 30.0);
	[showButton setTitle:@"选择背景" forState:UIControlStateNormal];
	//    showButton.backgroundColor = [UIColor brownColor];
	[showButton addTarget:self action:@selector(showScrollView) forControlEvents:UIControlEventTouchUpInside];
	[self.tableView.tableHeaderView addSubview:showButton];
	
	//    UITextView *createDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(95.0, 110.0, 200.0, 30.0)];
	//    createDateLabel.textAlignment = NSTextAlignmentRight;
	//    [self.tableView.tableHeaderView addSubview:createDateLabel];
	//    [createDateLabel release];
	
	UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(95.0, 120.0, 200.0, 20.0)];
	contentLabel.text = @"内容：";
	contentLabel.backgroundColor = [UIColor clearColor];
	contentLabel.font = [UIFont boldSystemFontOfSize:18.0];
	contentLabel.textColor = [UIColor darkGrayColor];
	[self.tableView.tableHeaderView addSubview:contentLabel];
	
	UITextView *contentView = [[UITextView alloc] initWithFrame:CGRectMake(95.0, 150.0, 200.0, 250.0)];
	self.contentView = contentView;
	contentView.text = @"";
	//    contentView.scrollEnabled = NO;
	contentView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
	contentView.autocapitalizationType = UITextAutocapitalizationTypeNone;
	//    contentView.keyboardType = UIKeyboardTypeDefault;
	contentView.font = [UIFont systemFontOfSize:15.0];
	[self.tableView.tableHeaderView addSubview:contentView];
//	[contentView release];
}

- (void)saveBackground
{
	switch ((int)self.scrollView.contentOffset.x) {
		case 0:
			background = @"4.jpg";
			break;
		case 320:
			background = @"1.jpg";
			break;
		case 320*2:
			background = @"2.jpg";
			break;
		case 320*3:
			background = @"3.jpg";
			break;
		case 320*4:
			background = @"4.jpg";
			break;
		case 320*5:
			background = @"1.jpg";
			break;
		default:
			break;
	}
	//    [self.tableView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
	
	self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:background]];
	self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
	self.myPanelView.layer.opacity = 0.0;
	[self.scrollView scrollRectToVisible:CGRectMake(DH_DeviceWidth, 30.0, DH_DeviceWidth, 140.0) animated:NO];
}

- (void)showScrollView
{
	self.tableView.contentInset = UIEdgeInsetsMake(180.0, 0.0, 0.0, 0.0);
	//setContentOffSet方法可超出滚动区域
	[self.tableView setContentOffset:CGPointMake(0.0, -180.0) animated:YES];
	//scrollRectToVisible方法的orign是从可滚动区域顶点开始算,但必须是相关方向有剩余区域才可超出区域,如果y坐标为正，则不会向上走
	//    [self.tableView scrollRectToVisible:CGRectMake(0.0, 80.0, 320.0, 416.0) animated:YES];
	
	//    self.tableView.contentOffset = CGPointMake(0.0, -180.0);
	self.myPanelView.layer.opacity = 1.0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	//        NSLog(@"%f",self.tableView.frame.origin.y);
	//    NSLog(@"%f",self.scrollView.frame.origin.x);
	if (scrollView.contentOffset.x != 0.0) {
		int page = (scrollView.contentOffset.x + 160.0)/320.0;
		self.pageControl.currentPage = (page+3)%4;
	}
	
	if (scrollView.contentOffset.x<10.0) {
		CGFloat minorOffset = scrollView.contentOffset.x - 0.0;
		if (scrollView.isDecelerating) {
			minorOffset = 0;
		}
		[scrollView scrollRectToVisible:CGRectMake(320.0*4+minorOffset, 0.0, 320.0, 140.0) animated:NO];
	}
	else if (scrollView.contentOffset.x>320.0*5-10.0)
	{
		CGFloat minorOffset = scrollView.contentOffset.x - 320.0*5;
		if (scrollView.isDecelerating) {
			minorOffset = 0;
		}
		[scrollView scrollRectToVisible:CGRectMake(320.0+minorOffset, 0.0, 320.0, 140.0) animated:NO];
	}
}


- (void)cancel
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)save
{
	int i;
	for (i=0; i<[self.messages count]; i++) {
		if ([[[self.messages objectAtIndex:i] title] isEqualToString:self.titleField.text]) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题重复，请重拟" message:@"\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
			
			[alertView show];
//			[alertView release];
			break;
		}
	}
	if (i == [self.messages count]) {
		Message *newMessage = [[Message alloc] init];
		newMessage.title = self.titleField.text;
		newMessage.content = self.contentView.text;
		newMessage.backgroundImage = background;
		NSDate *nowDate = [NSDate date];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"yyyy-MM-dd";
		NSString *dateString = [dateFormatter stringFromDate:nowDate];
		newMessage.createDate = dateString;
//		[dateFormatter release];
		[self.messages addObject:newMessage];
		NSLog(@"%@",self.messages);
//		[newMessage release];
		//        [self.delegate callBack:self.messages];
		[self dismissViewControllerAnimated:YES completion:^{
			//            [UIView animateWithDuration:0.5 animations:^{
			//                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:addNote.view cache:YES];
			//            }];
		}];
		
		NSString *fullpath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"notes.archive"];
		[NSKeyedArchiver archiveRootObject:self.messages toFile:fullpath];
		//    [self.delegate dismissContactCtrl:self];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	//    [textField resignFirstResponder];
	[self.contentView resignFirstResponder];
	return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
	[textField selectAll:self];
}

- (void)hidesKeyboard
{
	[self.titleField resignFirstResponder];
	[self.contentView resignFirstResponder];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
