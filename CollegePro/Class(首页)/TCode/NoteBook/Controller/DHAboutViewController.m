//
//  DHAboutViewController.m
//  Test
//
//  Created by Rillakkuma on 2018/3/16.
//  Copyright © 2018年 Rillakkuma. All rights reserved.
//

#import "DHAboutViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface DHAboutViewController ()
@property (retain, nonatomic) AVAudioPlayer *audioPlayer;
@property (retain, nonatomic) UISwitch *mySwitch;
@end

@implementation DHAboutViewController
@synthesize audioPlayer = _audioPlayer;
@synthesize mySwitch = _mySwitch;
- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupUI];
    // Do any additional setup after loading the view.
}
- (void)setupUI{
	self.view.backgroundColor = [UIColor colorWithRed:125.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0];
	
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:125.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0];
	NSData *soundData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"goodbye" ofType:@"mp3"]];
	self.audioPlayer = [[AVAudioPlayer alloc] initWithData:soundData error:nil];
	
	UISwitch *theSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(10.0, 70.0, 50.0, 30.0)];
	theSwitch.tintColor = [UIColor grayColor];
	[theSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
	theSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kUserSwitchState];
	self.mySwitch = theSwitch;
	[self.view addSubview:theSwitch];
//	[theSwitch release];
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test.jpg"]];
	imageView.frame = CGRectMake(115.0, 30.0, 80.0, 80.0);
	[self.view addSubview:imageView];
//	[imageView release];
	
	UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.0, 100.0, 150.0, 30.0)];
	nameLabel.font = [UIFont boldSystemFontOfSize:20.0];
	nameLabel.backgroundColor = [UIColor clearColor];
	nameLabel.textAlignment = NSTextAlignmentCenter;
	nameLabel.text = @"Da Hai";
	[self.view addSubview:nameLabel];
//	[nameLabel release];
	
	UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 140.0, 250.0, 30.0)];
	descriptionLabel.font = [UIFont systemFontOfSize:18.0];
	descriptionLabel.backgroundColor = [UIColor clearColor];
	descriptionLabel.textAlignment = NSTextAlignmentCenter;
	descriptionLabel.text = @"©Copyright iBokan, 2012";
	[self.view addSubview:descriptionLabel];
//	[descriptionLabel release];
	
	self.navigationItem.title = @"About This App";
}
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
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if (self.mySwitch.on) {
		[self.audioPlayer play];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self.audioPlayer stop];
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
