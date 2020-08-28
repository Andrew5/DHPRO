//
//  DHNoteJoyViewController.m
//  Test 进入界面动画
//
//  Created by Rillakkuma on 2018/3/16.
//  Copyright © 2018年 Rillakkuma. All rights reserved.
//

#import "DHNoteJoyViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DHNoteListViewController.h"
#import "DHAboutViewController.h"

@interface DHNoteJoyViewController ()
@property (retain, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@end

@implementation DHNoteJoyViewController
@synthesize imageView = _imageView;
@synthesize audioPlayer = _audioPlayer;


- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupui];
    // Do any additional setup after loading the view.
}
- (void)dismissSelf:(NSNotificationCenter *)notification
{
	[self dismissViewControllerAnimated:YES completion:^{
		[[NSNotificationCenter defaultCenter] removeObserver:self name:@"dismiss" object:nil];
	}];
//	dis;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
	[notification addObserver:self selector:@selector(dismissSelf:) name:@"dismiss" object:nil];
	
	
	if (self.audioPlayer)
	{
		[self.audioPlayer play];
	}
	[self performSelector:@selector(nextViewToVisible) withObject:nil afterDelay:3.0];
	
}
//- (void)viewDidDisappear:(BOOL)animated
//{
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"dismiss" object:nil];
//}
- (void)setupui{
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"open1.jpg"]];
	imageView.frame = CGRectMake(0.0, 0.0, DH_DeviceWidth, DH_DeviceHeight);
	[imageView setClipsToBounds:YES];
	
	[imageView setContentMode:UIViewContentModeScaleAspectFit];
	
	imageView.frame = [UIScreen mainScreen].bounds;
	
	self.imageView = imageView;
	[self.view addSubview:imageView];
	
	NSData *soundData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"intel" ofType:@"mp3"]];
	self.audioPlayer = [[AVAudioPlayer alloc] initWithData:soundData error:nil] ;
}

- (void)nextViewToVisible
{
	DHNoteListViewController *noteListViewController = [[DHNoteListViewController alloc] initWithStyle:UITableViewStylePlain];

	UINavigationController *mainNavigation = [[UINavigationController alloc] initWithRootViewController:noteListViewController];
//	[noteListViewController release];
	
	mainNavigation.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:0];
	
	DHAboutViewController *aboutViewController = [[DHAboutViewController alloc] init];
	UINavigationController *aboutNavigation = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
//	[aboutViewController release];
	aboutNavigation.tabBarItem.title = @"About";
	aboutNavigation.tabBarItem.image = [UIImage imageNamed:@"about.png"];
	
	UITabBarController *tabBarController = [[UITabBarController alloc] init];
	[tabBarController addChildViewController:mainNavigation];
	[tabBarController addChildViewController:aboutNavigation];
	
//	[mainNavigation release];
//	[aboutNavigation release];
	//交叉融解效果
	tabBarController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	
	[self presentViewController:tabBarController animated:YES completion:^{
		//        [UIView animateWithDuration:0.5 animations:^{
		//            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:noteListViewController.view cache:YES];
		//        }];
	}];
	
//	[tabBarController release];
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
