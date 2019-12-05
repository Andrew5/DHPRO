//
//  Options.h
//  Air Hockey
//
//  Created by iD Student Account on 7/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Options : UIViewController {
	
	BOOL volumeBool;
	BOOL airBool;
	BOOL easyBool;
	BOOL fxBool;
	IBOutlet UISwitch * volumeSw;
	IBOutlet UISwitch * airSw;
	IBOutlet UISwitch * fxSw;
	IBOutlet UISegmentedControl * segSw;
	IBOutlet UISegmentedControl * scoreSw;
	IBOutlet UISegmentedControl * goalSw;
}

-(IBAction) exit;
-(IBAction) theme;
-(IBAction) volumeSwitch: (id) sender;
-(IBAction) fxSwitch: (id) sender;
-(IBAction) airSwitch: (id) sender;
-(IBAction) difficultySwitch: (id) sender;
-(IBAction) scoreSwitch: (id) sender;
-(IBAction) goalSwitch: (id) sender;

@end
