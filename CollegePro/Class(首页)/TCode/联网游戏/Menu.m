//
//  Menu.m
//  Air Hockey
//
//  Created by iD Student Account on 7/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Menu.h"
#import "Air_HockeyViewController.h"
#import "Options.h"
#import "Credits.h"
#import "scores.h"


@implementation Menu
-(void) gameUpdate
{	
	static BOOL loadingScreen = TRUE;
	
	if(loadingScreen)
	{
		if (counter >= 200)
		{
			if (logoImage.alpha > 0)
			{
				logoImage.alpha -= .04;
			}
			else 
			{
				loadingScreen = FALSE;
			}

		}
		counter++;
	}
	else
	{
		logoImage.hidden = TRUE;
	}

	
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex
{
	if ([alertView.title isEqual: @"Choose Mode"])
	{
		NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
		pauseOn = TRUE;
		[defaults setBool: pauseOn forKey: @"Pause Control"];
		[defaults synchronize];
		if (buttonIndex == 1)
		{
			pauseOn = FALSE;
			computerOn = TRUE;
			[defaults setBool: computerOn forKey: @"Player Control"];
			[defaults setBool: pauseOn forKey: @"Pause Control"];
			[defaults synchronize];
			
			
			Air_HockeyViewController * pageView = [[Air_HockeyViewController alloc] initWithNibName: nil bundle: nil];
			pageView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			[self presentModalViewController: pageView animated: YES];
//            [pageView release];
		}
		if (buttonIndex == 2)
		{
			pauseOn = FALSE;
			computerOn = FALSE;
			[defaults setBool: computerOn forKey: @"Player Control"];
			[defaults setBool: pauseOn forKey: @"Pause Control"];
			[defaults synchronize];
			
			
			Air_HockeyViewController * pageView = [[Air_HockeyViewController alloc] initWithNibName: nil bundle: nil];
			pageView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			[self presentModalViewController: pageView animated: YES];
//            [pageView release];
		}
		
	}
	
	
	
}



-(IBAction) optionsButton
{
	Options * pageView = [[Options alloc] initWithNibName: nil bundle: nil];
	pageView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController: pageView animated: YES];
//    [pageView release];
}

-(IBAction) creditsButton
{
	Credits * pageView = [[Credits alloc] initWithNibName: nil bundle: nil];
	pageView.modalTransitionStyle = UIModalTransitionStylePartialCurl;
	[self presentModalViewController: pageView animated: YES];
//    [pageView release];
}

-(IBAction) scoresButton
{
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Best time scores will only be recorded when you play to 7" message: nil delegate:self cancelButtonTitle: @"Ok" otherButtonTitles:  nil];
    [alert show];
//    [alert release];
	scores * pageView = [[scores alloc] initWithNibName: nil bundle: nil];
	pageView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController: pageView animated: YES];
//    [pageView release];
}

-(IBAction) playButton
{
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Choose Mode" message: nil delegate:self cancelButtonTitle: @"Cancel" otherButtonTitles: @"1 Player",  @"2 Players", nil];
    [alert show];
//    [alert release];

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
	[NSTimer scheduledTimerWithTimeInterval: .01 target: self selector: @selector (gameUpdate) userInfo: nil repeats: YES];
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
