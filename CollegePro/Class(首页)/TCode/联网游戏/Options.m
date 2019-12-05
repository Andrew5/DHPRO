//
//  Options.m
//  Air Hockey
//
//  Created by iD Student Account on 7/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Themes.h"
#import "Options.h"
#import "Menu.h"



@implementation Options

-(IBAction) exit
{
	Menu * pageView = [[Menu alloc] initWithNibName: nil bundle: nil];
	pageView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentViewController:pageView animated:YES completion:nil];

//    [pageView release];
}

-(IBAction) theme
{
	Themes * pageView = [[Themes alloc] initWithNibName: nil bundle: nil];
	pageView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentViewController:pageView animated:YES completion:nil];

//    [pageView release];
}

-(IBAction) volumeSwitch : (id) sender
{
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
		[defaults setBool: volumeSw.on forKey: @"Volume Control"];
		[defaults synchronize];

}

-(IBAction) fxSwitch : (id) sender
{
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

	[defaults setBool: fxSw.on forKey: @"FX Control"];	
	[defaults synchronize];
	
}

-(IBAction) airSwitch : (id) sender
{
	
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];	
	[defaults setBool: airSw.on forKey: @"Air Control"];
	[defaults synchronize];
	
}


-(IBAction) difficultySwitch : (id) sender
{
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	UISegmentedControl * difficultyS = (UISegmentedControl *) sender;
	int selectedSegment = difficultyS.selectedSegmentIndex;
	
	[defaults setInteger: selectedSegment forKey: @"Difficulty Control"];
	[defaults synchronize];
}

-(IBAction) scoreSwitch : (id) sender
{
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	UISegmentedControl * scoreS = (UISegmentedControl *) sender;
	int selectedScore = scoreS.selectedSegmentIndex;
	
	[defaults setInteger: selectedScore forKey: @"Score Control"];
	[defaults synchronize];
}

-(IBAction) goalSwitch : (id) sender
{
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	UISegmentedControl * goalS = (UISegmentedControl *) sender;
	int goalScore = goalS.selectedSegmentIndex;
	
	[defaults setInteger: goalScore forKey: @"Goal Control"];
	[defaults synchronize];
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
	//VOLUME
	
	if([defaults boolForKey: @"Volume Control"])
	{
		volumeSw.on = TRUE;
	}
	if([defaults boolForKey: @"Volume Control"] == FALSE)
	{
		volumeSw.on = FALSE;
	}
	
	//AIR

	if([defaults boolForKey: @"Air Control"])
	{
		airSw.on = TRUE;
	}
	if([defaults boolForKey: @"Air Control"] == FALSE)
	{
		airSw.on = FALSE;
	}
	
	//FX
	
	if([defaults boolForKey: @"FX Control"])
	{
		fxSw.on = TRUE;
	}
	if([defaults boolForKey: @"FX Control"] == FALSE)
	{
		fxSw.on = FALSE;
	}
	
	//AI
	
	if([defaults integerForKey: @"Difficulty Control"] == 0)
	{
		segSw.selectedSegmentIndex = 0;
	}
	if([defaults integerForKey: @"Difficulty Control"] == 1)
	{
		segSw.selectedSegmentIndex = 1;
	}
	if([defaults integerForKey: @"Difficulty Control"] == 2)
	{
		segSw.selectedSegmentIndex = 2;
	}
	
	//AI
	
	if([defaults integerForKey: @"Goal Control"] == 0)
	{
		goalSw.selectedSegmentIndex = 0;
	}
	if([defaults integerForKey: @"Goal Control"] == 1)
	{
		goalSw.selectedSegmentIndex = 1;
	}
	if([defaults integerForKey: @"Goal Control"] == 2)
	{
		goalSw.selectedSegmentIndex = 2;
	}
	
	//MAX SCORE
	
	if([defaults integerForKey: @"Score Control"] == 0)
	{
		scoreSw.selectedSegmentIndex = 0;
	}
	if([defaults integerForKey: @"Score Control"] == 1)
	{
		scoreSw.selectedSegmentIndex = 1;
	}
	if([defaults integerForKey: @"Score Control"] == 2)
	{
		scoreSw.selectedSegmentIndex = 2;
	}
	if([defaults integerForKey: @"Score Control"] == 3)
	{
		scoreSw.selectedSegmentIndex = 3;
	}
	if([defaults integerForKey: @"Score Control"] == 4)
	{
		scoreSw.selectedSegmentIndex = 4;
	}
	if([defaults integerForKey: @"Score Control"] == 5)
	{
		scoreSw.selectedSegmentIndex = 5;
	}
	if([defaults integerForKey: @"Score Control"] == 6)
	{
		scoreSw.selectedSegmentIndex = 6;
	}
	if([defaults integerForKey: @"Score Control"] == 7)
	{
		scoreSw.selectedSegmentIndex = 7;
	}
	if([defaults integerForKey: @"Score Control"] == 8)
	{
		scoreSw.selectedSegmentIndex = 8;
	}
	if([defaults integerForKey: @"Score Control"] == 9)
	{
		scoreSw.selectedSegmentIndex = 9;
	}
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


//- (void)dealloc {
//    [super dealloc];
//}


@end
