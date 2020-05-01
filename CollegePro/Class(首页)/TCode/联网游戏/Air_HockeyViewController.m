//
//  Air_HockeyViewController.m
//  Air Hockey
//
//  Created by iD Student Account on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Air_HockeyViewController.h"
#import "Menu.h"
#import "Options.h"

@implementation Air_HockeyViewController

@synthesize audioPlayer;
@synthesize puckSound;

-(IBAction) pauseButton
{
	isPaused = TRUE;
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Pause Menu" 
                                               message: nil 
                                               delegate:self 
                                               cancelButtonTitle:@"Resume" 
                                               otherButtonTitles: @"Exit", @"Restart", nil]; 
    [alert show]; 
//    [alert release];
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex
{
	if ([alertView.title isEqual: @"Pause Menu"])
	{
		if (buttonIndex == 0) // Restart
		{
			isPaused = FALSE;
		}
		if (buttonIndex == 1) // Restart
		{
			Menu * pageView = [[Menu alloc] initWithNibName: nil bundle: nil];
			pageView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:pageView animated:YES completion:nil];
//            [pageView release];
			[self.audioPlayer pause];

		}
		if (buttonIndex == 2) // Exit
		{
			paddleP1.center = CGPointMake(163, 90);
			paddleP2.center = CGPointMake(164, 370);
			puck.center = CGPointMake(164, 228);
			
			score1.text = @"0";
			score2.text = @"0";
			score11 = 0;
			score22 = 0;
			score111 = @"0";
			score222 = @"0";
			
			puckXSpeed = 0;
			puckYSpeed = 0;
			
			secTime = 0;
			totTime = 0;
			minTime = 0;
			
			isPaused = FALSE;
		
		}
		
	}
	if ([alertView.title isEqual: p2Color])
	{
		if (buttonIndex == 0)
		{
			Menu * pageView = [[Menu alloc] initWithNibName: nil bundle: nil];
			pageView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:pageView animated:YES completion:nil];
//            [pageView release];
			[self.audioPlayer pause];
		}
		if (buttonIndex == 1)
		{
			paddleP1.center = CGPointMake(163, 90);
			paddleP2.center = CGPointMake(150, 300);
			puck.center = CGPointMake(156, 235);
			
			score1.text = @"0";
			score2.text = @"0";
			score11 = 0;
			score22 = 0;
			score111 = @"0";
			score222 = @"0";
			
			puckXSpeed = 0;
			puckYSpeed = 0;
			
			secTime = 0;
			totTime = 0;
			minTime = 0;
			
			isPaused = FALSE;
		}
		
	}
	if ([alertView.title isEqual: p1Color])
	{
		if (buttonIndex == 0)
		{
			Menu * pageView = [[Menu alloc] initWithNibName: nil bundle: nil];
			pageView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:pageView animated:YES completion:nil];
//            [pageView release];
			[self.audioPlayer pause];
		}
		if (buttonIndex == 1)
		{
			paddleP1.center = CGPointMake(152, 100);
			paddleP2.center = CGPointMake(150, 300);
			puck.center = CGPointMake(156, 235);
			
			score1.text = @"0";
			score2.text = @"0";
			score11 = 0;
			score22 = 0;
			score111 = @"0";
			score222 = @"0";
			
			puckXSpeed = 0;
			puckYSpeed = 0;
			
			secTime = 0;
			totTime = 0;
			minTime = 0;
			
			isPaused = FALSE;
		}
	}
	
		
	
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


-(void) gameUpdate
{
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	computerOn = [defaults boolForKey: @"Player Control"];
	easyOn = [defaults boolForKey: @"Difficulty Control"];
	
	if (secTime < 6000)
	{
		secTime++;
	}
	else 
	{
		minTime++;
		secTime = 0;
	}
	totTime++;
	
	if(isPaused == FALSE)
	{
		int rightWall = 296;
		int topWall = 24;
		int bottomWall = 440;
		int leftWall = 24;
		
		if([defaults integerForKey: @"Difficulty Control"] == 0)
		{
		
			if (computerOn == TRUE)
			{
		
			if(paddleP1.center.x > 40 && paddleP1.center.y > 40 && paddleP1.center.x < 280)
			{	
		
				if(puck.center.y < 240)
				{
					if (puck.center.y > paddleP1.center.y + 40)
					{
						if (puck.center.x > paddleP1.center.x + 60)
						{
							paddleP1.center = CGPointMake(paddleP1.center.x + 2, paddleP1.center.y);
						}
						else if (puck.center.x < paddleP1.center.x - 60)
						{
							paddleP1.center = CGPointMake(paddleP1.center.x - 2, paddleP1.center.y);
						}
						else if (puck.center.x > paddleP1.center.x - 60)
						{
							if (puck.center.x > paddleP1.center.x)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x + 1, paddleP1.center.y);
							}
							else if (puck.center.x < paddleP1.center.x)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x - 1, paddleP1.center.y);
							}
						}
				
						paddleP1.center = CGPointMake(paddleP1.center.x, paddleP1.center.y + 1);
				
						if(testPaddle1 < 100)
						{
							paddleP1.center = CGPointMake(paddleP1.center.x, paddleP1.center.y * 1.01);
						}
					}
					else
					{
						if(paddleP1.center.y > 40)
						{
							paddleP1.center = CGPointMake(paddleP1.center.x, paddleP1.center.y - 1);
						}
						if (puck.center.x > paddleP1.center.x)
						{
							paddleP1.center = CGPointMake(paddleP1.center.x + 2, paddleP1.center.y);
						}
						if (puck.center.x < paddleP1.center.x)
						{
							paddleP1.center = CGPointMake(paddleP1.center.x - 2, paddleP1.center.y);
						}
					}
			
				}
				else 
				{
					if (puck.center.y > paddleP1.center.y + 40)
					{
						if (puck.center.x > paddleP1.center.x + 60)
						{
							paddleP1.center = CGPointMake(paddleP1.center.x + 2, paddleP1.center.y);
							if(puck.center.y > 70)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x, paddleP1.center.y - 1);
							}
						}
						if (puck.center.x < paddleP1.center.x - 60)
						{
							paddleP1.center = CGPointMake(paddleP1.center.x - 2, paddleP1.center.y);
						
							if(puck.center.y > 70)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x, paddleP1.center.y - 1);
							
						}
					}
					if (puck.center.x > paddleP1.center.x - 60)
					{
						if (puck.center.x > paddleP1.center.x)
						{
							paddleP1.center = CGPointMake(paddleP1.center.x + 1, paddleP1.center.y);
							
						}
						else if (puck.center.x < paddleP1.center.x)
						{
							paddleP1.center = CGPointMake(paddleP1.center.x - 1, paddleP1.center.y);					
						}
					}
					if(paddleP1.center.y > 70)
					{
						paddleP1.center = CGPointMake(paddleP1.center.x, paddleP1.center.y - 1);
					}
					
				}
			}
			if(paddleP1.center.y < 60)
			{
				if (testPaddle1 < 90 && puck.center.x > 240)
				{
					paddleP1.center = CGPointMake(paddleP1.center.x - 3, paddleP1.center.y);
				}
				if (testPaddle1 < 90 && puck.center.x < 80)
				{
					paddleP1.center = CGPointMake(paddleP1.center.x + 3, paddleP1.center.y);
				}
			}
		}
		else if (paddleP1.center.x <= 40)
		{
			paddleP1.center = CGPointMake(41, paddleP1.center.y);
		}
		else if (paddleP1.center.x >= 280)
		{
			paddleP1.center = CGPointMake(279, paddleP1.center.y);
		}
		else if (paddleP1.center.y <= 40)
		{
			paddleP1.center = CGPointMake(paddleP1.center.x, 41);
		}
		
	}
		}
		else if ([defaults integerForKey: @"Difficulty Control"] == 1)
		{
			
			if (computerOn == TRUE)
			{
				
				if(paddleP1.center.x > 40 && paddleP1.center.y > 40 && paddleP1.center.x < 280)
				{	
					
					if(puck.center.y < 240)
					{
						if (puck.center.y > paddleP1.center.y + 40)
						{
							if (puck.center.x > paddleP1.center.x + 60)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x + 2, paddleP1.center.y);
							}
							else if (puck.center.x < paddleP1.center.x - 60)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x - 2, paddleP1.center.y);
							}
							else if (puck.center.x > paddleP1.center.x - 60)
							{
								if (puck.center.x > paddleP1.center.x)
								{
									paddleP1.center = CGPointMake(paddleP1.center.x + 1, paddleP1.center.y);
								}
								else if (puck.center.x < paddleP1.center.x)
								{
									paddleP1.center = CGPointMake(paddleP1.center.x - 1, paddleP1.center.y);
								}
							}
							
							paddleP1.center = CGPointMake(paddleP1.center.x, paddleP1.center.y + 1);
							
							if(testPaddle1 < 100)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x, paddleP1.center.y * 1.03);
							}
						}
						else
						{
							if(paddleP1.center.y > 40)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x, paddleP1.center.y - 1);
							}
							if (puck.center.x > paddleP1.center.x)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x + 2, paddleP1.center.y);
							}
							if (puck.center.x < paddleP1.center.x)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x - 2, paddleP1.center.y);
							}
						}
						
					}
					else 
					{
						if (puck.center.y > paddleP1.center.y + 40)
						{
							if (puck.center.x > paddleP1.center.x + 60)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x + 2, paddleP1.center.y);
								if(puck.center.y > 70)
								{
									paddleP1.center = CGPointMake(paddleP1.center.x, paddleP1.center.y - 1);
								}
							}
							if (puck.center.x < paddleP1.center.x - 60)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x - 2, paddleP1.center.y);
								
								if(puck.center.y > 70)
								{
									paddleP1.center = CGPointMake(paddleP1.center.x, paddleP1.center.y - 1);
									
								}
							}
							if (puck.center.x > paddleP1.center.x - 60)
							{
								if (puck.center.x > paddleP1.center.x)
								{
									paddleP1.center = CGPointMake(paddleP1.center.x + 1, paddleP1.center.y);
									
								}
								else if (puck.center.x < paddleP1.center.x)
								{
									paddleP1.center = CGPointMake(paddleP1.center.x - 1, paddleP1.center.y);					
								}
							}
							if(paddleP1.center.y > 70)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x, paddleP1.center.y - 1);
							}
							
						}
					}
					if(paddleP1.center.y < 60)
					{
						if (testPaddle1 < 90 && puck.center.x > 240)
						{
							paddleP1.center = CGPointMake(paddleP1.center.x - 3, paddleP1.center.y);
						}
						if (testPaddle1 < 90 && puck.center.x < 80)
						{
							paddleP1.center = CGPointMake(paddleP1.center.x + 3, paddleP1.center.y);
						}
					}
				}
				else if (paddleP1.center.x <= 40)
				{
					paddleP1.center = CGPointMake(41, paddleP1.center.y);
				}
				else if (paddleP1.center.x >= 280)
				{
					paddleP1.center = CGPointMake(279, paddleP1.center.y);
				}
				else if (paddleP1.center.y <= 40)
				{
					paddleP1.center = CGPointMake(paddleP1.center.x, 41);
				}
				
			}
		}
		else if ([defaults integerForKey: @"Difficulty Control"] == 2)
		{
			
			if (computerOn == TRUE)
			{
				
				if(paddleP1.center.x > 40 && paddleP1.center.y > 40 && paddleP1.center.x < 280)
				{	
					
					if(puck.center.y < 240)
					{
						if (puck.center.y > paddleP1.center.y + 40)
						{
							if (puck.center.x > paddleP1.center.x + 60)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x + 2, paddleP1.center.y);
							}
							else if (puck.center.x < paddleP1.center.x - 60)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x - 2, paddleP1.center.y);
							}
							else if (puck.center.x > paddleP1.center.x - 60)
							{
								if (puck.center.x > paddleP1.center.x)
								{
									paddleP1.center = CGPointMake(paddleP1.center.x + 1, paddleP1.center.y);
								}
								else if (puck.center.x < paddleP1.center.x)
								{
									paddleP1.center = CGPointMake(paddleP1.center.x - 1, paddleP1.center.y);
								}
							}
							
							paddleP1.center = CGPointMake(paddleP1.center.x, paddleP1.center.y + 1);
							
							if(testPaddle1 < 100)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x, paddleP1.center.y * 1.05);
							}
						}
						else
						{
							if(paddleP1.center.y > 40)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x, paddleP1.center.y - 1);
							}
							if (puck.center.x > paddleP1.center.x)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x + 2, paddleP1.center.y);
							}
							if (puck.center.x < paddleP1.center.x)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x - 2, paddleP1.center.y);
							}
						}
						
					}
					else 
					{
						if (puck.center.y > paddleP1.center.y + 40)
						{
							if (puck.center.x > paddleP1.center.x + 60)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x + 2, paddleP1.center.y);
								if(puck.center.y > 70)
								{
									paddleP1.center = CGPointMake(paddleP1.center.x, paddleP1.center.y - 1);
								}
							}
							if (puck.center.x < paddleP1.center.x - 60)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x - 2, paddleP1.center.y);
								
								if(puck.center.y > 70)
								{
									paddleP1.center = CGPointMake(paddleP1.center.x, paddleP1.center.y - 1);
									
								}
							}
							if (puck.center.x > paddleP1.center.x - 60)
							{
								if (puck.center.x > paddleP1.center.x)
								{
									paddleP1.center = CGPointMake(paddleP1.center.x + 1, paddleP1.center.y);
									
								}
								else if (puck.center.x < paddleP1.center.x)
								{
									paddleP1.center = CGPointMake(paddleP1.center.x - 1, paddleP1.center.y);					
								}
							}
							if(paddleP1.center.y > 70)
							{
								paddleP1.center = CGPointMake(paddleP1.center.x, paddleP1.center.y - 1);
							}
							
						}
					}
					if(paddleP1.center.y < 60)
					{
						if (testPaddle1 < 90 && puck.center.x > 240)
						{
							paddleP1.center = CGPointMake(paddleP1.center.x - 3, paddleP1.center.y);
						}
						if (testPaddle1 < 90 && puck.center.x < 80)
						{
							paddleP1.center = CGPointMake(paddleP1.center.x + 3, paddleP1.center.y);
						}
					}
				}
				else if (paddleP1.center.x <= 40)
				{
					paddleP1.center = CGPointMake(41, paddleP1.center.y);
				}
				else if (paddleP1.center.x >= 280)
				{
					paddleP1.center = CGPointMake(279, paddleP1.center.y);
				}
				else if (paddleP1.center.y <= 40)
				{
					paddleP1.center = CGPointMake(paddleP1.center.x, 41);
				}
				
			}
		}

	if(airOn == FALSE)
	{
			puckXSpeed = puckXSpeed/1.03;
			puckYSpeed = puckYSpeed/1.03;
	}



	
	
	if(paddle2Speed < 3)
	{
		paddle2Speed = 3;
	}
	if(paddle1Speed < 3)
	{
		paddle1Speed = 3;
	}
	
	puckNext = puckFirst;
	puckFirst = puck.center;
	puckSpeed = sqrt(((puckFirst.x - puckNext.x) * (puckFirst.x - puckNext.x)) + ((puckFirst.y - puckNext.y)*(puckFirst.y - puckNext.y)));
	
	puck.center = CGPointMake(puck.center.x + puckXSpeed, puck.center.y + puckYSpeed);
	if(puck.center.x >= rightWall)
	{
		puckXSpeed = -(puckXSpeed);
		puck.center = CGPointMake(rightWall + puckXSpeed, puck.center.y);
		if (isSoundEffect)
		{
			[self.puckSound play];
		}
	}
	else if (puck.center.x <= leftWall)
	{
		puckXSpeed = -(puckXSpeed);
		puck.center = CGPointMake(leftWall + puckXSpeed, puck.center.y);
		if (isSoundEffect)
		{
			[self.puckSound play];
		}
	}
	
	if(puck.center.y >= bottomWall && (puck.center.x < goalStart || puck.center.x > goalEnd))
	{
		puckYSpeed = -(puckYSpeed);
		puck.center = CGPointMake(puck.center.x, bottomWall + puckYSpeed);
		if (isSoundEffect)
		{
			[self.puckSound play];
		}
	}
	else if (puck.center.y <= topWall && (puck.center.x < goalStart || puck.center.x > goalEnd))
	{
		puckYSpeed = -(puckYSpeed);
		puck.center = CGPointMake(puck.center.x, topWall + puckYSpeed);
		if (isSoundEffect)
		{
			[self.puckSound play];
		}
	}
	
	if (puck.center.y <= 0)
	{
		score11++;
		score111 = [NSString stringWithFormat: @"%i", score11];
		score1.text = score111;
		puck.center = CGPointMake(160, 200);
		puckXSpeed = 0;
		puckYSpeed = 0;
		
	}
	
	if (puck.center.y >= 480)
	{
		score22++;
		score222 = [NSString stringWithFormat: @"%i", score22];
		score2.text = score222;
		puck.center = CGPointMake(160, 280);
		puckXSpeed = 0;
		puckYSpeed = 0;
	}
	
	
	testPaddle1 = sqrt(((puck.center.x - paddleP1.center.x) * (puck.center.x - paddleP1.center.x)) + ((puck.center.y - paddleP1.center.y)*(puck.center.y - paddleP1.center.y)));
	testPaddle2 = sqrt(((puck.center.x - paddleP2.center.x) * (puck.center.x - paddleP2.center.x)) + ((puck.center.y - paddleP2.center.y)*(puck.center.y - paddleP2.center.y)));
	
	if(computerOn)
	{
		if([defaults integerForKey: @"Difficulty Control"] == 0)
		{
			if(testPaddle1 <= 60)
			{
			
				puckContactP1 = CGPointMake((2.0/5.0 * (paddleP1.center.x - puck.center.x)), (2.0/5.0 * (paddleP1.center.y - puck.center.y)));
				puckYSpeed = paddle1Speed * -(puckContactP1.y/25);
				puckXSpeed = paddle1Speed * -(puckContactP1.x/25);
				if (isSoundEffect)
				{
					[self.puckSound play];
				}

			}
		}
		else if([defaults integerForKey: @"Difficulty Control"] == 1)
		{
			if(testPaddle1 <= 60)
			{
			
				puckContactP1 = CGPointMake((2.0/5.0 * (paddleP1.center.x - puck.center.x)), (2.0/5.0 * (paddleP1.center.y - puck.center.y)));
				puckYSpeed = paddle1Speed * -(puckContactP1.y/15);
				puckXSpeed = paddle1Speed * -(puckContactP1.x/15);
				if (isSoundEffect)
				{
					[self.puckSound play];
				}
			
			}
		}
		else if([defaults integerForKey: @"Difficulty Control"] == 2)
		{
			if(testPaddle1 <= 60)
			{
				puckContactP1 = CGPointMake((2.0/5.0 * (paddleP1.center.x - puck.center.x)), (2.0/5.0 * (paddleP1.center.y - puck.center.y)));
				puckYSpeed = paddle1Speed * -(puckContactP1.y/10);
				puckXSpeed = paddle1Speed * -(puckContactP1.x/10);
				if (isSoundEffect)
				{
					[self.puckSound play];
				}
				
			}
		}
	}
	else 
	{
		if(testPaddle1 <= 60)
		{
			puckContactP1 = CGPointMake((2.0/5.0 * (paddleP1.center.x - puck.center.x)), (2.0/5.0 * (paddleP1.center.y - puck.center.y)));
			puckYSpeed = paddle1Speed * -(puckContactP1.y/25);
			puckXSpeed = paddle1Speed * -(puckContactP1.x/25);
			if (isSoundEffect)
			{
				[self.puckSound play];
			}
			
		}
	}

	if(testPaddle2 <= 60)
	{
		puckContactP2 = CGPointMake((2.0/5.0 * (paddleP2.center.x - puck.center.x)), (2.0/5.0 * (paddleP2.center.y - puck.center.y)));
		puckYSpeed = paddle2Speed * (-puckContactP2.y/25);
		puckXSpeed = paddle2Speed * (-puckContactP2.x/25);
		if (isSoundEffect)
		{
			[self.puckSound play];
		}
	}
	
	if (score11 == [defaults integerForKey: @"Score Control"] + 1)
	{
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle: p2Color message: nil delegate:self cancelButtonTitle: nil otherButtonTitles: @"Exit",  @"New Game", nil]; [alert show];
//        [alert release];
		if  ([defaults integerForKey: @"Score Control"] + 1 == 7)
		{
			if (computerOn)
			{
				if ([defaults integerForKey: @"Difficulty Control"] == 0)
				{
					if(score11 - score22 > [defaults integerForKey: @"Score 1 Easy"] - [defaults integerForKey: @"Score 2 Easy"])
					{
						[defaults setInteger: score11 forKey: @"Score 1 Easy"];
						[defaults setInteger: score22 forKey: @"Score 2 Easy"];
					}
					if(totTime < [defaults integerForKey: @"Total Easy Time"] || [defaults integerForKey: @"Total Easy Time"] == 0)
					{
						[defaults setInteger: totTime/100 forKey: @"Total Easy Time"];
						[defaults setInteger: secTime/100 forKey: @"Sec Easy Time"];
						[defaults setInteger: minTime forKey: @"Min Easy Time"];
					}
					[defaults synchronize];
				}
				else if ([defaults integerForKey: @"Difficulty Control"] == 1)
				{
					if(score11 - score22 > [defaults integerForKey: @"Score 1 Medium"] - [defaults integerForKey: @"Score 2 Medium"])
					{
						[defaults setInteger: score11 forKey: @"Score 1 Medium"];
						[defaults setInteger: score22 forKey: @"Score 2 Medium"];
					}
					if(totTime < [defaults integerForKey: @"Total Medium Time"] || [defaults integerForKey: @"Total Medium Time"] == 0)
					{
						[defaults setInteger: totTime/100 forKey: @"Total Medium Time"];
						[defaults setInteger: secTime/100 forKey: @"Sec Medium Time"];
						[defaults setInteger: minTime forKey: @"Min Medium Time"];
					}
					[defaults synchronize];
				}
				else if ([defaults integerForKey: @"Difficulty Control"] == 2)
				{
					if(score11 - score22 > [defaults integerForKey: @"Score 1 Hard"] - [defaults integerForKey: @"Score 2 Hard"])
					{
						[defaults setInteger: score11 forKey: @"Score 1 Hard"];
						[defaults setInteger: score22 forKey: @"Score 2 Hard"];
					}
					if(totTime < [defaults integerForKey: @"Total Hard Time"] || [defaults integerForKey: @"Total Hard Time"] == 0)
					{
						[defaults setInteger: totTime/100 forKey: @"Total Hard Time"];
						[defaults setInteger: secTime/100 forKey: @"Sec Hard Time"];
						[defaults setInteger: minTime forKey: @"Min Hard Time"];
					}
					[defaults synchronize];
				}
			}
			else 
			{
				if(score11 - score22 > [defaults integerForKey: @"Score 1 2P"])
				{
					[defaults setInteger: score11 forKey: @"Score 1 2P"];
					[defaults setInteger: score22 forKey: @"Score 2 2P"];
					NSLog(@"%i", totTime);
				}
				else if(score22 - score11 > [defaults integerForKey: @"Score 2 2P"])
				{
					[defaults setInteger: score11 forKey: @"Score 1 2P"];
					[defaults setInteger: score22 forKey: @"Score 2 2P"];
					NSLog(@"%i", totTime);
				}
				if(totTime < [defaults integerForKey: @"Total 2P Time"]  || [defaults integerForKey: @"Total 2P Time"] == 0)
				{
					[defaults setInteger: totTime/100 forKey: @"Total 2P Time"];
					[defaults setInteger: secTime/100 forKey: @"Sec 2P Time"];
					[defaults setInteger: minTime forKey: @"Min 2P Time"];
				}
				[defaults synchronize];
			}
		}
		
		isPaused = TRUE;
		score11 = 0;
		score1.text = @"0";
		score111 = @"0";
		score22 = 0;
		score2.text = @"0";
		score222 = @"0";
	}
	
	if (score22 == [defaults integerForKey: @"Score Control"] + 1)
	{
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle: p1Color message: nil delegate:self cancelButtonTitle: nil otherButtonTitles: @"Exit", @"New Game", nil]; [alert show];
//        [alert release];
		if  ([defaults integerForKey: @"Score Control"] + 1 == 7)
		{
				if(score11 - score22 > [defaults integerForKey: @"Score 1 2P"])
				{
					[defaults setInteger: score11 forKey: @"Score 1 2P"];
					[defaults setInteger: score11 forKey: @"Score 1 2P"];
					[defaults synchronize];
				}
		}
		
		isPaused = TRUE;
		score22 = 0;
		score2.text = @"0";
		score222 = @"0";
		score11 = 0;
		score1.text = @"0";
		score111 = @"0";
	}
	}
	
	
	
	
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
	minTime = 0;
	secTime = 0;
	totTime = 0;
	
	isSoundEffect = [defaults boolForKey: @"FX Control"];
	
	NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/A_room_broom_guy_and_a_mirror.mp3", [[NSBundle mainBundle] resourcePath]]];
	self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];	
	[self.audioPlayer prepareToPlay];
	
	NSURL *url2 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/puck Hit.mp3", [[NSBundle mainBundle] resourcePath]]];
	self.puckSound = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:nil];	
	[self.puckSound prepareToPlay];
	

	easyOn = [defaults boolForKey: @"Difficulty Control"];
	soundOn = [defaults boolForKey: @"Volume Control"];
	airOn = [defaults boolForKey: @"Air Control"];
	isPaused = [defaults boolForKey: @"Pause Control"];
	
	if(airOn)
	{
		NSLog(@"Air is on");
	}
	else 
	{	
		airOn = FALSE;
		NSLog(@"Air is off");
	}
	
	if(soundOn)
	{
		[self.audioPlayer play];
	}
	
	puckSpeed = 0;
	puckXSpeed = 0;
	puckYSpeed = 0;
	
	score2.transform = CGAffineTransformRotate(score2.transform, M_PI);

	bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,460)];
	if ([defaults integerForKey: @"BG Control"] == 0)
	{
		if ([defaults integerForKey: @"Goal Control"] == 0)
		{
			bgImage.image = [UIImage imageNamed: @"air hokey small.png"];
			goalStart = 140;
			goalEnd = 183;
		}
		else if ([defaults integerForKey: @"Goal Control"] == 1)
		{
			bgImage.image = [UIImage imageNamed: @"air hokey.png"];
			goalStart = 120;
			goalEnd = 214;
		}
		else if ([defaults integerForKey: @"Goal Control"] == 2)
		{
			bgImage.image = [UIImage imageNamed: @"air hokey wide.png"];
			goalStart = 96;
			goalEnd = 233;
		}
	}
	else if ([defaults integerForKey: @"BG Control"] == 1)
	{
		if ([defaults integerForKey: @"Goal Control"] == 0)
		{
			bgImage.image = [UIImage imageNamed: @"night hockey thin.png"];
			goalStart = 140;
			goalEnd = 183;
		}
		else if ([defaults integerForKey: @"Goal Control"] == 1)
		{
			bgImage.image = [UIImage imageNamed: @"night hockey.png"];
			goalStart = 120;
			goalEnd = 214;
		}
		else if ([defaults integerForKey: @"Goal Control"] == 2)
		{
			bgImage.image = [UIImage imageNamed: @"night hockey wide.png"];
			goalStart = 96;
			goalEnd = 233;
		}
		score1.textColor = [UIColor whiteColor];
		score2.textColor = [UIColor whiteColor];
	}
	else if ([defaults integerForKey: @"BG Control"] == 2)
	{
		if ([defaults integerForKey: @"Goal Control"] == 0)
		{
			bgImage.image = [UIImage imageNamed: @"water hockey thin.png"];
			goalStart = 140;
			goalEnd = 183;
		}
		else if ([defaults integerForKey: @"Goal Control"] == 1)
		{
			bgImage.image = [UIImage imageNamed: @"water hockey.png"];
			goalStart = 120;
			goalEnd = 214;
		}
		else if ([defaults integerForKey: @"Goal Control"] == 2)
		{
			bgImage.image = [UIImage imageNamed: @"water hockey wide.png"];
			goalStart = 96;
			goalEnd = 233;
		}
		score1.textColor = [UIColor yellowColor];
		score2.textColor = [UIColor yellowColor];
	}
	[self.view addSubview: bgImage];
	[self.view sendSubviewToBack: bgImage];
	
	puck = [[UIImageView alloc]initWithFrame:CGRectMake(144,208,40,40)];
	if ([defaults integerForKey: @"Puck Control"] == 0)
	{
		puck.image = [UIImage imageNamed: @"black puck.png"];
	}
	else if ([defaults integerForKey: @"Puck Control"] == 1)
	{
		puck.image = [UIImage imageNamed: @"puck.png"];
	}
	[self.view addSubview: puck];

	//PADDLE 1
	paddleP1 = [[UIImageView alloc]initWithFrame:CGRectMake(123,50,80,80)];
	if ([defaults integerForKey: @"P2 Control"] == 0)
	{
		paddleP1.image = [UIImage imageNamed: @"red paddle.png"];
		p1Color = @"Red Player Wins";
	}
	else if ([defaults integerForKey: @"P2 Control"] == 1)
	{
		paddleP1.image = [UIImage imageNamed: @"blue paddle.png"];
		p1Color = @"Blue Player Wins";
	}
	else if ([defaults integerForKey: @"P2 Control"] == 2)
	{
		paddleP1.image = [UIImage imageNamed: @"purple paddle.png"];
		p1Color = @"Purple Player Wins";
	}
	else if ([defaults integerForKey: @"P2 Control"] == 3)
	{
		paddleP1.image = [UIImage imageNamed: @"green paddle.png"];
		p1Color = @"Green Player Wins";
	}
	[self.view addSubview: paddleP1];
	
	
	//PADDLE 2
	paddleP2 = [[UIImageView alloc]initWithFrame:CGRectMake(123,330,80,80)];
	if ([defaults integerForKey: @"P1 Control"] == 0)
	{
		paddleP2.image = [UIImage imageNamed: @"red paddle.png"];
		p2Color = @"Red Player Wins";
	}
	else if ([defaults integerForKey: @"P1 Control"] == 1)
	{
		paddleP2.image = [UIImage imageNamed: @"blue paddle.png"];
		p2Color = @"Blue Player Wins";
	}
	else if ([defaults integerForKey: @"P1 Control"] == 2)
	{
		paddleP2.image = [UIImage imageNamed: @"purple paddle.png"];
		p2Color = @"Purple Player Wins";
	}
	else if ([defaults integerForKey: @"P1 Control"] == 3)
	{
		paddleP2.image = [UIImage imageNamed: @"green paddle.png"];
		p2Color = @"Green Player Wins";
	}
	[self.view addSubview: paddleP2];
	
	
	
	[NSTimer scheduledTimerWithTimeInterval: .01 target: self selector: @selector (gameUpdate) userInfo: nil repeats: YES];
}

-(void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	UITouch * myTouch = [[event allTouches]anyObject];
    
    ///???:NSUInteger转int类型问题
	int touchCount = (int)[touches count];
	NSArray * touchesArray = [touches allObjects];
	
	for (int i = 0; i < touchCount; i++)
	{
		myTouch = [touchesArray objectAtIndex: i];
		CGPoint touchLoc = [myTouch locationInView: self.view];
		NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
		computerOn = [defaults boolForKey: @"Player Control"];
		
		if (computerOn == FALSE)
		{

			if (touchLoc.y < (self.view.bounds.size.height / 2) - 40)
			{
				pad1Next = pad1First;
				pad1First = touchLoc;
				paddleP1.center = touchLoc;
				paddle1Speed = sqrt(((pad1First.x - pad1Next.x) * (pad1First.x - pad1Next.x)) + ((pad1First.y - pad1Next.y)*(pad1First.y - pad1Next.y)));
				if (paddle1Speed > 30)
				{
					paddle1Speed = 30;
				}
			}
		}
		if (touchLoc.y > (self.view.bounds.size.height / 2) + 40)
		{
			pad2Next = pad2First;
			pad2First = touchLoc;
			paddleP2.center = touchLoc;
			paddle2Speed= sqrt(((pad2First.x - pad2Next.x) * (pad2First.x - pad2Next.x)) + ((pad2First.y - pad2Next.y)*(pad2First.y - pad2Next.y)));
			if (paddle2Speed > 30)
			{
				paddle2Speed = 30;
			}

		}
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

//- (void)viewDidUnload {
//    // Release any retained subviews of the main view.
//    // e.g. self.myOutlet = nil;
//    [paddleP1 release];
//    [paddleP2 release];
//    [puck release];
//}
//- (void)dealloc {
//    [super dealloc];
//}

@end
