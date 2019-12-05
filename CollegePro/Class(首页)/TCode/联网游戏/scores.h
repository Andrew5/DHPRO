//
//  scores.h
//  Air Hockey
//
//  Created by iD Student Account on 7/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface scores : UIViewController {

	IBOutlet UILabel * score1;
	IBOutlet UILabel * score2;
	IBOutlet UILabel * gameT;
	IBOutlet UILabel * gameMode;

}


-(IBAction) exit;
-(IBAction) easy;
-(IBAction) meduim;
-(IBAction) hard;
-(IBAction) player2;

@end
