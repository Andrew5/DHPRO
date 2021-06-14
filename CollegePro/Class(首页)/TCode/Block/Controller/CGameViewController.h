//
//  CGameViewController.h
//  CollegePro
//
//  Created by jabraknight on 2021/6/14.
//  Copyright © 2021 jabrknight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCTurnBasedMatchHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGameViewController : BaseViewController<UITextFieldDelegate, GCTurnBasedMatchHelperDelegate>
{

    __weak IBOutlet UITextView *mainTextController;
    __weak IBOutlet UIView *inputView;
    __weak IBOutlet UITextField *textInputField;
    __weak IBOutlet UILabel *characterCountLabel;
    __weak IBOutlet UILabel *statusLabel;
}
- (void) animateTextField: (UITextField*) textField up: (BOOL) up;
- (IBAction)updateCount:(id)sender;
- (IBAction)presentGCTurnViewController:(id)sender;
- (IBAction)sendTurn:(id)sender;
@end

NS_ASSUME_NONNULL_END
