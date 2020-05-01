//
//  Air_HockeyViewController.h
//  Air Hockey
//
//  Created by iD Student Account on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface Air_HockeyViewController : UIViewController < UIAlertViewDelegate >{
	
	//Sounds
    AVAudioPlayer * audioPlayer;
	AVAudioPlayer * puckSound;
	
    //Images
	UIImageView * paddleP1;
	UIImageView * paddleP2;
	UIImageView * puck;	
	
    //Booleans
	BOOL soundOn;
	BOOL airOn;
	BOOL easyOn;
	BOOL computerOn;
	BOOL isPaused;
	BOOL isSoundEffect;

	IBOutlet UILabel * score1;
	IBOutlet UILabel * score2;
	IBOutlet UIImageView * bgImage;
	
	float testPaddle1;
	float testPaddle2;
	float paddle1Speed;
	float paddle2Speed;
	float puckSpeed;
	float puckXSpeed;
	float puckYSpeed;
	
	CGPoint puckContactP1;
	CGPoint puckContactP2;
	
	CGPoint pad1First;
	CGPoint pad1Next;
	
	CGPoint puckFirst;
	CGPoint puckNext;
	
	CGPoint pad2First;
	CGPoint pad2Next;
	
	int score11;
	int score22;
	int goalStart;
	int goalEnd;
	int minTime;
	int secTime;
	int totTime;
	
	NSString * score111;
	NSString * score222;
	NSString * p1Color;
	NSString * p2Color;


}

@property(nonatomic, retain) AVAudioPlayer *audioPlayer;
@property(nonatomic, retain) AVAudioPlayer *puckSound;


-(IBAction) pauseButton;


@end

