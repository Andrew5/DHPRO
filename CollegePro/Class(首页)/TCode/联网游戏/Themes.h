//
//  Themes.h
//  Air Hockey
//
//  Created by iD Student Account on 7/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Themes : UIViewController {
	
		IBOutlet UISegmentedControl * bgSw;
		IBOutlet UISegmentedControl * p1Sw;
		IBOutlet UISegmentedControl * p2Sw;
		IBOutlet UISegmentedControl * puckSw;

}

-(IBAction) bgSwitch: (id) sender;
-(IBAction) p1Switch: (id) sender;
-(IBAction) p2Switch: (id) sender;
-(IBAction) puckSwitch: (id) sender;
-(IBAction) exit;

@end
