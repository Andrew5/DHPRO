//
//  CGameViewController.m
//  CollegePro
//
//  Created by jabraknight on 2021/6/14.
//  Copyright © 2021 jabrknight. All rights reserved.
//

#import "CGameViewController.h"

@interface CGameViewController ()

@end

@implementation CGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    textInputField.delegate = self;
    [GCTurnBasedMatchHelper sharedInstance].delegate = self;
    
    textInputField.enabled = NO;
    statusLabel.text = @"Welcome.  Press Game Center to get started";
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (IBAction)presentGCTurnViewController:(id)sender {
    [[GCTurnBasedMatchHelper sharedInstance]
     findMatchWithMinPlayers:1 maxPlayers:12 viewController:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)updateCount:(id)sender {
    UITextField *tf = (UITextField *)sender;
    NSUInteger len = tf.text.length;//[tf.text length];
    NSUInteger remain = 250 - len;
    characterCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)remain];
    if (remain < 0) {
        characterCountLabel.textColor = [UIColor redColor];
    } else {
        characterCountLabel.textColor = [UIColor blackColor];
    }
}

- (IBAction)sendTurn:(id)sender {
    GKTurnBasedMatch *currentMatch = [[GCTurnBasedMatchHelper sharedInstance] currentMatch];
    NSString *newStoryString;
    if ([textInputField.text length] > 250) {
        newStoryString = [textInputField.text substringToIndex:249];
    } else {
        newStoryString = textInputField.text;
    }
    
    NSString *sendString = [NSString stringWithFormat:@"%@ %@", mainTextController.text, newStoryString];
    NSData *data = [sendString dataUsingEncoding:NSUTF8StringEncoding ];
    mainTextController.text = sendString;
    
    NSUInteger currentIndex = [currentMatch.participants indexOfObject:currentMatch.currentParticipant];
    GKTurnBasedParticipant *nextParticipant;
    
    NSUInteger nextIndex = (currentIndex + 1) % [currentMatch.participants count];
    nextParticipant = [currentMatch.participants objectAtIndex:nextIndex];
    
    for (int i = 0; i < [currentMatch.participants count]; i++) {
        nextParticipant = [currentMatch.participants objectAtIndex:((currentIndex + 1 + i) % [currentMatch.participants count ])];
        if (nextParticipant.matchOutcome != GKTurnBasedMatchOutcomeQuit) {
            NSLog(@"isnt' quit %@", nextParticipant);
            break;
        } else {
            NSLog(@"nex part %@", nextParticipant);
        }
    }
    
    if ([data length] > 3800) {
        for (GKTurnBasedParticipant *part in currentMatch.participants) {
            part.matchOutcome = GKTurnBasedMatchOutcomeTied;
        }
        [currentMatch endMatchInTurnWithMatchData:data completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            }
        }];
        statusLabel.text = @"Game has ended";
    } else {
        
        [currentMatch endTurnWithNextParticipant:nextParticipant matchData:data completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"%@", error);
                self->statusLabel.text = @"Oops, there was a problem.  Try that again.";
            } else {
                self->statusLabel.text = @"Your turn is over.";
                self->textInputField.enabled = NO;
            }
        }];
    }
    NSLog(@"Send Turn, %@, %@", data, nextParticipant);
    textInputField.text = @"";
    characterCountLabel.text = @"250";
    characterCountLabel.textColor = [UIColor blackColor];
}


- (void)checkForEnding:(NSData *)matchData {
    if ([matchData length] > 3000) {
        statusLabel.text = [NSString stringWithFormat:@"%@, only about %u letter left", statusLabel.text, 4000 - [matchData length]];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
    NSLog(@"text view up");
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 210; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    
    int textFieldMovement = movement * 0.75;
    inputView.frame = CGRectOffset(inputView.frame, 0, movement);
    mainTextController.frame = CGRectMake(mainTextController.frame.origin.x, mainTextController.frame.origin.y, mainTextController.frame.size.width, mainTextController.frame.size.height + textFieldMovement);
    [UIView commitAnimations];
    NSLog(@"%f", mainTextController.frame.size.height);
}

#pragma mark - GCTurnBasedMatchHelperDelegate

- (void)enterNewGame:(GKTurnBasedMatch *)match {
    NSLog(@"Entering new game...");
    statusLabel.text = @"Player 1's Turn (that's you)";
    textInputField.enabled = YES;
    mainTextController.text = @"Once upon a time";
}

- (void)layoutMatch:(GKTurnBasedMatch *)match {
    NSLog(@"Viewing match where it's not our turn...");
    NSString *statusString;
    
    if (match.status == GKTurnBasedMatchStatusEnded) {
        statusString = @"Match Ended";
    } else {
        int playerNum = [match.participants indexOfObject:match.currentParticipant] + 1;
        statusString = [NSString stringWithFormat:@"Player %d's Turn", playerNum];
    }
    statusLabel.text = statusString;
    textInputField.enabled = NO;
    NSString *storySoFar = [NSString stringWithUTF8String:[match.matchData bytes]];
    mainTextController.text = storySoFar;
    [self checkForEnding:match.matchData];
}

- (void)recieveEndGame:(GKTurnBasedMatch *)match {
    [self layoutMatch:match];
}

- (void)sendNotice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Another game needs your attention!" message:notice preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *enter = [UIAlertAction actionWithTitle:@"Sweet!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:enter];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)takeTurn:(GKTurnBasedMatch *)match {
    NSLog(@"Taking turn for existing game...");
    int playerNum = [match.participants indexOfObject:match.currentParticipant] + 1;
    NSString *statusString = [NSString stringWithFormat:@"Player %d's Turn (that's you)", playerNum];
    statusLabel.text = statusString;
    textInputField.enabled = YES;
    if ([match.matchData bytes]) {
        NSString *storySoFar = [NSString stringWithUTF8String:[match.matchData bytes]];
        mainTextController.text = storySoFar;
        [self checkForEnding:match.matchData];
    }
}
/// 读取实例变量，并把这些数据写到coder中去。序列化数据
- (void)encodeWithCoder:(nonnull NSCoder *)coder {
   //[coder encodeObject:object forKey:@"key"];
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
}
///设置我们期望的childViewController的界面的大小
- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}
///在这些情况下该方法会被调用，当前viewController没有使用auto layout布局，childrenViewController的view使用了autoLayout布局
- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    return CGSizeZero;;
}
///通知当前VC，根据新的size调整UI
- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}
///当容器viewControllerViewWillTransitionTosize：withTransitionCoordinator：被调用时（我们重写这个方法时要调用super），sizeForChildContentContainer方法将被调用
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}
///viewController的view的size被他的parent Controller改变时，会触发这个方法
- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    
}

- (void)setNeedsFocusUpdate {
    
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
    return YES;
}

- (void)updateFocusIfNeeded {
    
}

@end
