//
//  GCTurnBasedMatchHelper.h
//  spinningyarn
//
//  Created by Ray Wenderlich on 10/8/11.
//  Copyright 2011 Razeware LLC. All rights reserved.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol GCTurnBasedMatchHelperDelegate
- (void)enterNewGame:(GKTurnBasedMatch *)match;
- (void)layoutMatch:(GKTurnBasedMatch *)match;
- (void)takeTurn:(GKTurnBasedMatch *)match;
- (void)recieveEndGame:(GKTurnBasedMatch *)match;
- (void)sendNotice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match;
@end

@interface GCTurnBasedMatchHelper : NSObject <GKTurnBasedMatchmakerViewControllerDelegate, GKTurnBasedEventListener,GCTurnBasedMatchHelperDelegate> {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    UIViewController *presentingViewController;
    
    GKTurnBasedMatch *currentMatch;
    
    id <GCTurnBasedMatchHelperDelegate> delegate;
}

@property (nonatomic, retain) id <GCTurnBasedMatchHelperDelegate> delegate;
@property (assign, readonly) BOOL gameCenterAvailable;
@property (nonatomic, retain) GKTurnBasedMatch *currentMatch;

+ (GCTurnBasedMatchHelper *)sharedInstance;
- (void)authenticateLocalUser;
- (void)authenticationChanged;
- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController:(UIViewController *)viewController;

@end
