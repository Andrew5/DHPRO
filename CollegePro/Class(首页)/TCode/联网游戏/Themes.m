//
//  Themes.m
//  Air Hockey
//
//  Created by iD Student Account on 7/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Themes.h"
#import "Options.h"

@implementation Themes

-(IBAction) exit
{
	Options * pageView = [[Options alloc] initWithNibName: nil bundle: nil];
	pageView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentViewController:pageView animated:YES completion:nil];

//    [pageView release];
}

-(IBAction) bgSwitch : (id) sender
{
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	UISegmentedControl * bgS = (UISegmentedControl *) sender;
	int selectedSegment = (int)bgS.selectedSegmentIndex;
	
	[defaults setInteger: selectedSegment forKey: @"BG Control"];
	[defaults synchronize];
}

-(IBAction) p1Switch : (id) sender
{
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	UISegmentedControl * p1S = (UISegmentedControl *) sender;
	int selectedSegment = p1S.selectedSegmentIndex;
	
	[defaults setInteger: selectedSegment forKey: @"P1 Control"];
	[defaults synchronize];
}

-(IBAction) p2Switch : (id) sender
{
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	UISegmentedControl * p2S = (UISegmentedControl *) sender;
	int selectedSegment = p2S.selectedSegmentIndex;
	
	[defaults setInteger: selectedSegment forKey: @"P2 Control"];
	[defaults synchronize];
}

-(IBAction) puckSwitch : (id) sender
{
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	UISegmentedControl * puckS = (UISegmentedControl *) sender;
	int selectedSegment = puckS.selectedSegmentIndex;
	
	[defaults setInteger: selectedSegment forKey: @"Puck Control"];
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
	//BG
	
	if([defaults integerForKey: @"BG Control"] == 0)
	{
		bgSw.selectedSegmentIndex = 0;
	}
	if([defaults integerForKey: @"BG Control"] == 1)
	{
		bgSw.selectedSegmentIndex = 1;
	}
	if([defaults integerForKey: @"BG Control"] == 2)
	{
		bgSw.selectedSegmentIndex = 2;
	}
	
	//P1
	
	if([defaults integerForKey: @"P1 Control"] == 0)
	{
		p1Sw.selectedSegmentIndex = 0;
	}
	if([defaults integerForKey: @"P1 Control"] == 1)
	{
		p1Sw.selectedSegmentIndex = 1;
	}
	if([defaults integerForKey: @"P1 Control"] == 2)
	{
		p1Sw.selectedSegmentIndex = 2;
	}
	if([defaults integerForKey: @"P1 Control"] == 2)
	{
		p1Sw.selectedSegmentIndex = 2;
	}
	
	//P2
	
	if([defaults integerForKey: @"P2 Control"] == 0)
	{
		p2Sw.selectedSegmentIndex = 0;
	}
	if([defaults integerForKey: @"P2 Control"] == 1)
	{
		p2Sw.selectedSegmentIndex = 1;
	}
	if([defaults integerForKey: @"P2 Control"] == 2)
	{
		p2Sw.selectedSegmentIndex = 2;
	}
	if([defaults integerForKey: @"P2 Control"] == 2)
	{
		p2Sw.selectedSegmentIndex = 2;
	}
	
	//Puck
	
	if([defaults integerForKey: @"Puck Control"] == 0)
	{
		puckSw.selectedSegmentIndex = 0;
	}
	if([defaults integerForKey: @"Puck Control"] == 1)
	{
		puckSw.selectedSegmentIndex = 1;
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
