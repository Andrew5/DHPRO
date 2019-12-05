//
//  PopMenuViewController.m
//  shiku
//
//  Created by txj on 15/5/21.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "PopMenuViewController.h"

@interface PopMenuViewController ()

@property (nonatomic, readonly, getter = isVisible) BOOL visible;
@property (nonatomic, assign) BOOL shrinksParentView;
@property (nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *stocksLabel;

@property (nonatomic, strong) IBOutlet UIView *modalView;
@property (nonatomic, strong) IBOutlet UIView *containerView;

@property (nonatomic, strong) IBOutlet  UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *buttons;

@property (nonatomic, assign) CGFloat minimumButtonHeight;
@property (nonatomic, assign) CGFloat maximumButtonWidth;

@property (nonatomic, assign) UIView *shrunkView;
@end

@implementation PopMenuViewController
- (id)init
{
    self = [super init];
    if (self) {
        
        //A dark gray color is the default
        _backgroundColor = [UIColor grayColor];
        
        //  The modal view
        _modalView = [UIView new];
        [_modalView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
        
        _modalView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideInView)];
        [_modalView addGestureRecognizer:tapGesture];
        
        
        //  The visible view
        _containerView = [UIView new];
        [_containerView setBackgroundColor:_backgroundColor];
        
        //  The button wrapper
//        _buttonWrapper = [UIScrollView new];
        
        //_collectionView=[UICollectionView new];
        
//        // Cancel Button Index
//        _cancelButtonIndex = -1;
        
        //  Minimum Button Height
        _minimumButtonHeight = 24;
        
        //  Maximum button width
        _maximumButtonWidth = 340;
        
        //  Visible
        _visible = NO;
        
        //  Should the parent view shrink down?
        _shrinksParentView = NO;
        
    }
    return self;
}
- (id)initWithCollectionView:(UICollectionView *) anCollectionView
{
    self = [self init];
    if (self) {
        _collectionView = anCollectionView;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     
     1. Set view to be transparent - with autoresizing
     2. Add a modal overlay - with autoresizing
     3. Add a sheet that's one third of the screen
     4. Put a scroll view in there
     5. Render the buttons
     
     */
    
    //  1. Set view to be transparent - with autoresizing
    [[self view] setOpaque:NO];
    [[self view] setBackgroundColor:[UIColor clearColor]];
    [[self view] setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    
    //  2. Add a modal overlay - with autoresizing
    [[self view] addSubview:_modalView];
    [_modalView setFrame:[[self view] bounds]];
    [_modalView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    
    //  3. Add a sheet that's one third of the screen
    [[self view] addSubview:_containerView];
    
    // Position at the bottom of the screen
    CGRect frame = [[self view] bounds];
    frame.origin.y = frame.size.height-(frame.size.height*2/3.0);
    frame.size.height=frame.size.height*2/ 3.0;
    [_containerView setFrame:frame];
    [_containerView setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth)];
    
    //4.Put a CollectionView in there;
//    [_buttonView addSubview:_collectionView];
//    [_collectionView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//    [_collectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
}
#pragma mark - Presentation

- (void) showInView:(UIView*)view
{
    
    //  1. Hide the modal
    [[self modalView] setAlpha:0];
    
    //  2. Install the modal view
    [[view superview] addSubview:[self view]];
    
    _shrunkView = view;
    
    [[self view] setFrame:[[[self view] superview] bounds]];
    
    //  3. Show the buttons
    [[self containerView] setTransform:CGAffineTransformMakeTranslation(0, [[self containerView] frame].size.height)];
    
    //  4. Animate everything into place
    [UIView
     animateWithDuration:0.3
     animations:^{
         
         
         //  Shrink the main view by 15 percent
         CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, .9, .9);
         [view setTransform:t];
         
         //  Fade in the modal
         [[self modalView] setAlpha:1.0];
         
         //  Slide the buttons into place
         [[self containerView] setTransform:CGAffineTransformIdentity];
         
     }
     completion:^(BOOL finished) {
         _visible = YES;
     }];
    
}

- (void) hideInView
{
    
//      2. Animate everything out of place
    [UIView
     animateWithDuration:0.3
     animations:^{
         
         //  Shrink the main view by 15 percent
         CGAffineTransform t = CGAffineTransformIdentity;
         [_shrunkView setTransform:t];
         
         //  Fade in the modal
         [[self modalView] setAlpha:0.0];
         
         //  Slide the buttons into place
         
         t = CGAffineTransformTranslate(t, 0, [[self containerView] frame].size.height);
         [[self containerView] setTransform:t];
         
     }
     
     completion:^(BOOL finished) {
         [[self view] removeFromSuperview];
         _visible = NO;
         if ([self.delegate respondsToSelector:@selector(hideFinished)]) {
             [self.delegate hideFinished];
         }
     }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
