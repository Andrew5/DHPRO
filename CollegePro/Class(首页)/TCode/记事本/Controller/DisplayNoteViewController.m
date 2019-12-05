//
//  DisplayNoteViewController.m
//  Test
//
//  Created by Rillakkuma on 2018/3/16.
//  Copyright © 2018年 Rillakkuma. All rights reserved.
//

#import "DisplayNoteViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "EditNoteViewController.h"

@interface DisplayNoteViewController ()<UIScrollViewDelegate>
{
	int musicIndex;
	
}


@property (retain, nonatomic) UIScrollView *displayView;
@property (retain, nonatomic) UIImageView *imageView;
@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UILabel *contentLabel;
@property (retain, nonatomic) AVAudioPlayer *audioPlayer;
//@property (retain, nonatomic) id<ContactCtrlDelegate> delegate;
@property (retain, nonatomic) NSData *soundData;
@property (retain, nonatomic) UISwitch *mySwitch;
@end

@implementation DisplayNoteViewController
@synthesize messageIndex = _messageIndex;
@synthesize messages = _messages;
@synthesize messageTitle = _messageTitle;
@synthesize isSearchResult = _isSearchResult;
@synthesize message = _message;
@synthesize displayView = _displayView;
@synthesize imageView = _imageView;
@synthesize titleLabel = _titleLabel;
@synthesize contentLabel = _contentLabel;
//@synthesize delegate = _delegate;
@synthesize audioPlayer = _audioPlayer;
@synthesize soundData = _soundData;
@synthesize mySwitch = _mySwitch;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(edit)];
	self.navigationItem.rightBarButtonItem = editButton;
//	[editButton release];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kUserSwitchState, nil]];
	
	[self viewLoad];
	
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self viewLoad];
	
	if (self.mySwitch.on && self.audioPlayer)
	{
		[self.audioPlayer play];
	}
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[self.audioPlayer stop];
	
}

- (void)viewLoad
{
	if (self.isSearchResult) {
		for (int i=0; i<[self.messages count]; i++) {
			if ([[self.messages objectAtIndex:i] title] == self.messageTitle) {
				self.messageIndex = i;
				self.message = [self.messages objectAtIndex:i];
			}
		}
	}
	else{
		self.message = [self.messages objectAtIndex:self.messageIndex];
	}
	
	NSLog(@"%@",self.message.backgroundImage);
	
	if ([self.message.backgroundImage isEqualToString:@"1.jpg"]) {
		musicIndex = 0;
	}
	else if ([self.message.backgroundImage isEqualToString:@"2.jpg"]) {
		musicIndex = 1;
	}
	else if ([self.message.backgroundImage isEqualToString:@"3.jpg"]) {
		musicIndex = 2;
	}
	else if ([self.message.backgroundImage isEqualToString:@"4.jpg"]) {
		musicIndex = 3;
	}
	
	switch (musicIndex) {
		case 0:
		{
			self.soundData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"donotleave" ofType:@"mp3"]];
			self.audioPlayer = [[AVAudioPlayer alloc] initWithData:self.soundData error:nil];
			break;
		}
		case 1:
		{
			self.soundData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"goodbye" ofType:@"mp3"]];
			self.audioPlayer = [[AVAudioPlayer alloc] initWithData:self.soundData error:nil];
			break;
		}
		case 2:
		{
			self.soundData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"3" ofType:@"mp3"]];
			self.audioPlayer = [[AVAudioPlayer alloc] initWithData:self.soundData error:nil];
			break;
		}
		case 3:
		{
			self.soundData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"mp3"]];
			self.audioPlayer = [[AVAudioPlayer alloc] initWithData:self.soundData error:nil];
			break;
		}
		default:
			break;
	}
	
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.message.backgroundImage]];
	imageView.frame = CGRectMake(0.0, 64.0, DH_DeviceWidth, DH_DeviceHeight-64);
	//    imageView.contentMode = UIViewContentModeScaleToFill;
	//    self.imageView = imageView;
	[self.view addSubview:imageView];
//	[imageView release];
	
	UIScrollView *displayView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 64.0, DH_DeviceWidth, DH_DeviceHeight-64)];
	self.displayView = displayView;
	
	displayView.backgroundColor = [UIColor clearColor];
	displayView.delegate = self;
	//    displayView.backgroundColor = [UIColor colorWithPatternImage:imageView];
	[self.view addSubview:displayView];
//	[displayView release];
	
	//    [self.displayView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:self.message.backgroundImage]]];
	//    [self.displayView bringSubviewToFront:imageView];
	//    [self.displayView setContentSize:CGSizeMake(320.0, 416.0)];
	//    self.displayView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
	//    self.displayView.scrollEnabled = YES;
	
	
	//    [self.displayView addSubview:imageView];
	//    self.displayView.
	//    self.displayView.contentSize = CGSizeMake(400.0, 500.0);
	
	UISwitch *theSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(10.0, 5.0, 50.0, 30.0)];
	theSwitch.tintColor = [UIColor grayColor];
	[theSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
	theSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kUserSwitchState];
	self.mySwitch = theSwitch;
	[self.displayView addSubview:theSwitch];
//	[theSwitch release];
	
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(95.0, 30.0, 200.0, 30.0)];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [UIColor darkGrayColor];
	titleLabel.font = [UIFont systemFontOfSize:25.0];
	titleLabel.text = self.message.title;
	titleLabel.textAlignment = NSTextAlignmentCenter;
	[self.displayView addSubview:titleLabel];
//	[titleLabel release];
	
	UILabel *createDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(95.0, 70.0, 200.0, 20.0)];
	createDateLabel.textAlignment = NSTextAlignmentRight;
	createDateLabel.text = self.message.createDate;
	createDateLabel.backgroundColor = [UIColor clearColor];
	[self.displayView addSubview:createDateLabel];
//	[createDateLabel release];
	
	UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(95.0, 100.0, 0.0, 0.0)];
	contentLabel.backgroundColor = [UIColor clearColor];
	contentLabel.textColor = [UIColor brownColor];
	contentLabel.text = self.message.content;
	contentLabel.numberOfLines = 0;
	//    contentLabel.backgroundColor = [UIColor whiteColor];
	self.contentLabel = contentLabel;
	contentLabel.font = [UIFont systemFontOfSize:15.0];
	CGSize size = CGSizeMake(320.0, 3000.0);
	CGSize labelSize = [contentLabel.text sizeWithFont:contentLabel.font constrainedToSize:size];
	[contentLabel setFrame:CGRectMake(95.0, 100.0, 200.0, labelSize.height)];
	NSLog(@"%f",contentLabel.frame.size.height);
	[self.displayView addSubview:contentLabel];
	
//	[contentLabel release];
	
	//    [self.displayView setContentSize:CGSizeMake(320.0, self.contentLabel.frame.size.height+200.0)];
	self.displayView.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.contentLabel.frame.size.height+200.0, 0.0);
}

- (void)edit
{
	EditNoteViewController *edit = [[EditNoteViewController alloc] initWithStyle:UITableViewStylePlain];
	edit.messageIndex = self.messageIndex;
	edit.messages = self.messages;
	edit.message = self.message;
	//    edit.delegate = self;
	
	UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:edit];
//	[edit release];
	
	[self presentViewController:navigation animated:YES completion:^{}];
	
//	[navigation release];
}

//- (void)callBack:(id)sender
//{
//    self.messages = sender;
//
//    [self.delegate callBack:self.messages];
//}

-(void)switchToggled:(UISwitch *)theSwitch
{
	NSLog(@"%d", theSwitch.on);
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:theSwitch.on forKey:kUserSwitchState];
	[defaults synchronize];
	
	if (theSwitch.on) {
		[self.audioPlayer play];
	}
	else{
		[self.audioPlayer stop];
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
