//
//  Menu.h
//  Air Hockey
//
//  Created by iD Student Account on 7/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Menu : UIViewController {
	
	BOOL computerOn;
	BOOL pauseOn;
	IBOutlet UIImageView * logoImage;
	int counter;


}

-(IBAction) playButton;
-(IBAction) optionsButton;
-(IBAction) creditsButton;
-(IBAction) scoresButton;

@end
