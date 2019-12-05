/*

    DLStarRating
    Copyright (C) 2011 David Linsin <dlinsin@gmail.com> 

    All rights reserved. This program and the accompanying materials
    are made available under the terms of the Eclipse Public License v1.0
    which accompanies this distribution, and is available at
    http://www.eclipse.org/legal/epl-v10.html

 */

#import <UIKit/UIKit.h>

#define kDefaultNumberOfStars 5
#define kNumberOfFractions 10

@protocol DLStarRatingDelegate;

@interface DLStarRatingControl : UIControl {
	int numberOfStars;
	int currentIdx;
	UIImage *star;
	UIImage *highlightedStar;
	IBOutlet id<DLStarRatingDelegate> delegate;
    BOOL isFractionalRatingEnabled;
}

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame andStars:(NSUInteger)_numberOfStars isFractional:(BOOL)isFract;
- (void)setStar:(UIImage*)defaultStarImage highlightedStar:(UIImage*)highlightedStarImage atIndex:(int)index;

@property (retain,nonatomic) UIImage *star;
@property (retain,nonatomic) UIImage *highlightedStar;
@property (nonatomic) float rating;
@property (retain,nonatomic) id<DLStarRatingDelegate> delegate;
@property (nonatomic,assign) BOOL isFractionalRatingEnabled;

@end

@protocol DLStarRatingDelegate

-(void)newRating:(DLStarRatingControl *)control :(float)rating;

@end


/*使用方法
 
 : UIViewController<DLStarRatingDelegate>
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 
 // Custom Number of Stars
	DLStarRatingControl *customNumberOfStars = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(0, 154, 320, 153) andStars:5 isFractional:YES];
 customNumberOfStars.delegate = self;
	customNumberOfStars.backgroundColor = [UIColor groupTableViewBackgroundColor];
	customNumberOfStars.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	customNumberOfStars.rating = 2.5;
	[self.view addSubview:customNumberOfStars];
 [customNumberOfStars release];
 
 // Custom Images
 DLStarRatingControl *customStarImageControl = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(0.0, 307.0, 320.0, 153.0)];
 
 // Set Custom Stars
 [customStarImageControl setStar:nil highlightedStar:[UIImage imageNamed:@"star_highlighted-darker.png"] atIndex:0];
 [customStarImageControl setStar:nil highlightedStar:[UIImage imageNamed:@"star_highlighted-darker.png"] atIndex:2];
 [customStarImageControl setStar:nil highlightedStar:[UIImage imageNamed:@"star_highlighted-darker.png"] atIndex:4];
 
 customStarImageControl.backgroundColor = [UIColor lightGrayColor];
 customStarImageControl.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
 customStarImageControl.rating = 4;
 [self.view addSubview:customStarImageControl];
 [customStarImageControl release];
 
 }
 
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 return YES;
 }
 
 #pragma mark -
 #pragma mark Delegate implementation of NIB instatiated DLStarRatingControl
 
 -(void)newRating:(DLStarRatingControl *)control :(float)rating {
	self.stars.text = [NSString stringWithFormat:@"%0.1f star rating",rating];
 }
 

 */
