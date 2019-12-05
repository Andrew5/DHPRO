//
//  EditNoteViewController.m
//  MusicJoy
//
//  Created by MaKai on 12-12-6.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import "EditNoteViewController.h"

@interface EditNoteViewController ()

@end

@implementation EditNoteViewController
{
    NSString *background;
    BOOL isSetBackground;
}

@synthesize messageIndex = _messageIndex;
@synthesize messages = _messages;
@synthesize message = _message;
//@synthesize delegate = _delegate;

@synthesize titleField = _titleField;
@synthesize contentView = _contentView;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"编辑";
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:125.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButton;
//    [saveButton release];
	
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
//    [cancelButton release];
	
    isSetBackground = NO;
    //制定选择面板视图
    UIView *panelView = [[UIView alloc] initWithFrame:CGRectMake(0.0, -180.0, 320.0, 180.0)];
    panelView.backgroundColor = [UIColor yellowColor];
    self.myPanelView = panelView;
    [self.tableView addSubview:panelView];
    panelView.layer.opacity = 0.0;
//    [panelView release];
    //面板标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 30.0)];
    titleLabel.backgroundColor = [UIColor grayColor];
    titleLabel.text = @"背景设置";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.panelTitle = titleLabel;
    [self.myPanelView addSubview:titleLabel];
//    [titleLabel release];
	
    //完成按钮
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    newButton.frame = CGRectMake(250.0, 5.0, 60.0, 20.0);
    [newButton setTitle:@"完成" forState:UIControlStateNormal];
    [newButton addTarget:self action:@selector(saveBackground) forControlEvents:UIControlEventTouchUpInside];
    [self.myPanelView addSubview:newButton];
    
    //滚动选择面板
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 30.0, 320.0, 140.0)];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(320.0*6, 140.0);
    self.scrollView = scrollView;
    scrollView.showsHorizontalScrollIndicator = NO;
    //    scrollView.layer.opacity = 0.0;
    [self.myPanelView addSubview:scrollView];
//    [scrollView release];
	
    for (int i=0; i<6; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320.0*i, 0.0, 320.0, 140.0)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",(i+3)%4+1]];
        [self.scrollView addSubview:imageView];
//        [imageView release];
    }
    
    [self.scrollView scrollRectToVisible:CGRectMake(320.0, 0.0, 320.0, 140.0) animated:NO];
    self.scrollView.pagingEnabled = YES;
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0, 150.0, 320.0, 20.0)];
    self.pageControl = pageControl;
    pageControl.numberOfPages = 4;
    pageControl.currentPage = 0;
    [panelView addSubview:pageControl];
//    [pageControl release];
	
    UILabel *seperator = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 170.0, 320.0, 10.0)];
    seperator.backgroundColor = [UIColor grayColor];
    [panelView addSubview:seperator];
//    [seperator release];
	
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidesKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
//    [gestureRecognizer release];

    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.message.backgroundImage]];
    
    UIView *displayView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 416.0)];
    self.tableView.tableHeaderView = displayView;
//    [displayView release];
	
    
    UITextField *titleField = [[UITextField alloc] initWithFrame:CGRectMake(95.0, 70.0, 200.0, 30.0)];
    self.titleField = titleField;
    titleField.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    titleField.text = self.message.title;
    titleField.delegate = self;
    titleField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    titleField.borderStyle = UITextBorderStyleRoundedRect;
//    titleField.keyboardType = UIKeyboardTypeTwitter;
    titleField.returnKeyType = UIReturnKeyDefault;
    titleField.font = [UIFont systemFontOfSize:20.0];
    [self.tableView.tableHeaderView addSubview:titleField];
//    [titleField release];
	
    UIButton *showButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    showButton.frame = CGRectMake(200.0, 15.0, 100.0, 30.0);
    [showButton setTitle:@"选择面板" forState:UIControlStateNormal];
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
    contentView.text = self.message.content;
    contentView.scrollEnabled = YES;
    contentView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    contentView.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    contentView.keyboardType = UIKeyboardTypeTwitter;
    contentView.font = [UIFont systemFontOfSize:15.0];
    [self.tableView.tableHeaderView addSubview:contentView];
//    [contentView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveBackground
{
    isSetBackground = YES;
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
    [self.scrollView scrollRectToVisible:CGRectMake(320.0, 30.0, 320.0, 140.0) animated:NO];
    self.myPanelView.layer.opacity = 0.0;
}

- (void)showScrollView
{
    self.tableView.contentInset = UIEdgeInsetsMake(180.0, 0.0, 0.0, 0.0);
    //    CGRect rect = CGRectMake(0.0, self.tableView.frame.origin.y-104.0, 320.0, 416.0);
    [self.tableView setContentOffset:CGPointMake(0.0, -180.0) animated:YES];
    //    [self.tableView scrollRectToVisible:rect animated:YES];
    self.myPanelView.layer.opacity = 1.0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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


- (void)save
{
    int i;
    for (i=0; i<[self.messages count]; i++) {
        if ([[[self.messages objectAtIndex:i] title] isEqualToString:self.titleField.text] && self.messageIndex != i) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题重复，请重拟" message:@"\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            
            [alertView show];
//            [alertView release];
            break;
        }
    }
    if (i == [self.messages count]) {
        if (![self.message.title isEqualToString:self.titleField.text]||![self.message.content isEqualToString:self.contentView.text]||(![self.message.backgroundImage isEqualToString:background]&&isSetBackground))
        {
//            NSLog(@"problem");
            [self.messages removeObjectAtIndex:self.messageIndex];
            self.message.title = self.titleField.text;
            self.message.content = self.contentView.text;
            if (![self.message.backgroundImage isEqualToString:background]&&isSetBackground)
            {
                self.message.backgroundImage = background;
            }
            [self.messages insertObject:self.message atIndex:self.messageIndex];
            
//            [self.delegate callBack:self.messages];
            
            NSString *fullpath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"notes.archive"];
            [NSKeyedArchiver archiveRootObject:self.messages toFile:fullpath];
        }
        [self dismissViewControllerAnimated:YES completion:^{}];
    
    }
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:^{}];
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

@end
