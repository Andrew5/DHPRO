//
//  ActivityIndicator.m
//  CollegePro
//
//  Created by jabraknight on 2019/7/16.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "ActivityIndicator.h"
#import "DGActivityIndicatorView.h"

@interface ActivityIndicator ()

@end

@implementation ActivityIndicator

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowleftBtn = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0f green:85/255.0f blue:101/255.0f alpha:1.0f];
    
    NSArray *activityTypes = @[@(DGActivityIndicatorAnimationTypeNineDots),
                               @(DGActivityIndicatorAnimationTypeTriplePulse),
                               @(DGActivityIndicatorAnimationTypeFiveDots),
                               @(DGActivityIndicatorAnimationTypeRotatingSquares),
                               @(DGActivityIndicatorAnimationTypeDoubleBounce),
                               @(DGActivityIndicatorAnimationTypeTwoDots),
                               @(DGActivityIndicatorAnimationTypeThreeDots),
                               @(DGActivityIndicatorAnimationTypeBallPulse),
                               @(DGActivityIndicatorAnimationTypeBallClipRotate),
                               @(DGActivityIndicatorAnimationTypeBallClipRotatePulse),
                               @(DGActivityIndicatorAnimationTypeBallClipRotateMultiple),
                               @(DGActivityIndicatorAnimationTypeBallRotate),
                               @(DGActivityIndicatorAnimationTypeBallZigZag),
                               @(DGActivityIndicatorAnimationTypeBallZigZagDeflect),
                               @(DGActivityIndicatorAnimationTypeBallTrianglePath),
                               @(DGActivityIndicatorAnimationTypeBallScale),
                               @(DGActivityIndicatorAnimationTypeLineScale),
                               @(DGActivityIndicatorAnimationTypeLineScaleParty),
                               @(DGActivityIndicatorAnimationTypeBallScaleMultiple),
                               @(DGActivityIndicatorAnimationTypeBallPulseSync),
                               @(DGActivityIndicatorAnimationTypeBallBeat),
                               @(DGActivityIndicatorAnimationTypeLineScalePulseOut),
                               @(DGActivityIndicatorAnimationTypeLineScalePulseOutRapid),
                               @(DGActivityIndicatorAnimationTypeBallScaleRipple),
                               @(DGActivityIndicatorAnimationTypeBallScaleRippleMultiple),
                               @(DGActivityIndicatorAnimationTypeTriangleSkewSpin),
                               @(DGActivityIndicatorAnimationTypeBallGridBeat),
                               @(DGActivityIndicatorAnimationTypeBallGridPulse),
                               @(DGActivityIndicatorAnimationTypeRotatingSandglass),
                               @(DGActivityIndicatorAnimationTypeRotatingTrigons),
                               @(DGActivityIndicatorAnimationTypeTripleRings),
                               @(DGActivityIndicatorAnimationTypeCookieTerminator),
                               @(DGActivityIndicatorAnimationTypeBallSpinFadeLoader)];
    
    for (int i = 0; i < activityTypes.count; i++) {
        DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)[activityTypes[i] integerValue] tintColor:[UIColor whiteColor]];
        CGFloat width = self.view.bounds.size.width / 5.0f;
        CGFloat height = self.view.bounds.size.height / 7.0f;
        
        activityIndicatorView.frame = CGRectMake(width * (i % 7), 64 + height * (int)(i / 7), width, height - 64);
        [self.view addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
