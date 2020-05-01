//
//  scores.m
//  Air Hockey
//
//  Created by iD Student Account on 7/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "scores.h"
#import "Menu.h"

@implementation scores

-(IBAction) exit
{
	Menu * pageView = [[Menu alloc] initWithNibName: nil bundle: nil];
	pageView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentViewController:pageView animated:YES completion:nil];

//    [pageView release];
}

-(IBAction) easy
{
	
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];	
    score1.text = [NSString stringWithFormat: @"%li", (long)[defaults integerForKey: @"Score 1 Easy"]];
    score2.text = [NSString stringWithFormat: @"%li", (long)[defaults integerForKey: @"Score 2 Easy"]];
    gameT.text = [NSString stringWithFormat: @"%li:%li", (long)[defaults integerForKey: @"Min Easy Time"], (long)[defaults integerForKey: @"Sec Easy Time"]];
	gameMode.text = @"Easy";
}

-(IBAction) meduim
{
	
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];	
    score1.text = [NSString stringWithFormat: @"%li", (long)[defaults integerForKey: @"Score 1 Medium"]];
    score2.text = [NSString stringWithFormat: @"%li", (long)[defaults integerForKey: @"Score 2 Medium"]];
    gameT.text = [NSString stringWithFormat: @"%li:%li", (long)[defaults integerForKey: @"Min Medium Time"], (long)[defaults integerForKey: @"Sec Medium Time"]];
	gameMode.text = @"Medium";
}

-(IBAction) hard
{
	
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];	
    score1.text = [NSString stringWithFormat: @"%li", (long)[defaults integerForKey: @"Score 1 Hard"]];
    score2.text = [NSString stringWithFormat: @"%li", (long)[defaults integerForKey: @"Score 2 Hard"]];
    gameT.text = [NSString stringWithFormat: @"%li:%li", (long)[defaults integerForKey: @"Min Hard Time"], (long)[defaults integerForKey: @"Sec Hard Time"]];
	gameMode.text = @"Hard";
}
-(IBAction) player2
{
	
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];		
    score1.text = [NSString stringWithFormat: @"%li", (long)[defaults integerForKey: @"Score 1 2P"]];
    score2.text = [NSString stringWithFormat: @"%li", (long)[defaults integerForKey: @"Score 2 2P"]];
    gameT.text = [NSString stringWithFormat: @"%li:%li", (long)[defaults integerForKey: @"Min 2P Time"], (long)[defaults integerForKey: @"Sec 2P Time"]];
	gameMode.text = @"2 Player";
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
    score1.text = [NSString stringWithFormat: @"%li", (long)[defaults integerForKey: @"Score 1 Easy"]];
    score2.text = [NSString stringWithFormat: @"%li", (long)[defaults integerForKey: @"Score 2 Easy"]];
    gameT.text = [NSString stringWithFormat: @"%li:%li", (long)[defaults integerForKey: @"Min Easy Time"], (long)[defaults integerForKey: @"Sec Easy Time"]];
	gameMode.text = @"Easy";
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

//- (void)dealloc {
//    [super dealloc];
//}


@end
