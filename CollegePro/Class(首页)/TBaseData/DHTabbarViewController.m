//
//  DHTabbarViewController.m
//  CollegePro
//
//  Created by jabraknight on 2019/8/11.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "DHTabbarViewController.h"
@interface CTabViewCell : UIView

-(void)drawRoundRect:(CGContextRef)context x:(CGFloat)x y:(CGFloat)y width:(CGFloat)w height:(CGFloat)h;

@end
@implementation CTabViewCell
- (void) drawRect: (CGRect) aRect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    int margin = 2;
    CGFloat width = self.frame.size.width - margin * 2;
    CGFloat height = self.frame.size.height - margin * 2;
    
    [self drawRoundRect:context x:margin y:margin+1 width:width height:height];
}

-(void)drawRoundRect:(CGContextRef)context x:(CGFloat)x y:(CGFloat)y width:(CGFloat)w height:(CGFloat)h{
    
    // background color
    CGContextSetRGBStrokeColor(context, CTABBAR_CELL_R, CTABBAR_CELL_G, CTABBAR_CELL_B, CTABBAR_CELL_A);
    CGContextSetRGBFillColor(context, CTABBAR_CELL_R, CTABBAR_CELL_G, CTABBAR_CELL_B, CTABBAR_CELL_A);
    CGContextSetLineWidth(context, 0.2);
    CGFloat radius = 4.0;
    
    CGRect rrect = CGRectMake(x, y, w, h);
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    
    // draw round rect
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}
@end

@interface DHTabbarViewController ()

@end

@implementation DHTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        _tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, CTABBAR_TOP, CTABBAR_WIDTH, CTABBAR_HEIGHT)];
        _tabBar.delegate = self;
        [self.view addSubview:_tabBar];
        
        _tabBarItems = [[NSMutableArray alloc] initWithCapacity:0];
        
        // tab background
        UIImageView *bk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CTABBAR_BGIMG_NAME]];
        
        [_tabBar insertSubview:bk atIndex:0];
        // selected item background
        _selectedCellBack = [[CTabViewCell alloc] initWithFrame:CGRectZero];
        _selectedCellBack.backgroundColor = [UIColor clearColor];
        [_tabBar insertSubview:_selectedCellBack atIndex:1];
    }
    return self;
}


- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated{
    
    _viewControllers = [viewControllers copy];
    [_tabBarItems removeAllObjects];
    
    UIViewController *ctrl;
    for(ctrl in _viewControllers){
        UITabBarItem *tmp= [[UITabBarItem alloc] initWithTitle:ctrl.title image:ctrl.tabBarItem.image tag:-1];
        tmp.badgeValue = ctrl.tabBarItem.badgeValue;
        [_tabBarItems addObject:tmp];
    }
    [_tabBar setItems:_tabBarItems];
    [self activateViewControllerAt:0];
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    NSUInteger idx = [_tabBarItems indexOfObject:item];
    [self activateViewControllerAt:(int)idx];
}


- (void)activateViewControllerAt:(int)index{
    
    selectedIndex = index;
    _selectedViewController = (UIViewController *)[_viewControllers objectAtIndex:index];
    _tabBar.selectedItem = (UITabBarItem *)[_tabBarItems objectAtIndex:index];
    
    // view controller
    UIViewController *vc = (UIViewController *)[_viewControllers objectAtIndex:index];
    vc.view.frame = CGRectMake(0, 0, CTABBAR_WIDTH, CTABBAR_TOP);
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:vc.view];
    
    // tab item background
    float width = 320 / [_viewControllers count];
    float offset = width * index;
    
    CGRect rect = _selectedCellBack.frame;
    _selectedCellBack.frame = CGRectMake(offset, rect.origin.y, width, CTABBAR_HEIGHT);
}


- (void)hideTabBar:(BOOL)b animated:(BOOL)b2{
    
    CGRect rect = _tabBar.frame;
    rect.origin.y = (b) ? CTABBAR_TOP+CTABBAR_HEIGHT : CTABBAR_TOP;
    
    CGRect rect2 =     _selectedViewController.view.frame;
    rect2.size.height =  (b) ? CTABBAR_TOP+CTABBAR_HEIGHT : CTABBAR_TOP;
    
    if(b2){
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationDuration:0.3];
    }
    _tabBar.frame = rect;
    _selectedViewController.view.frame = rect2;
    if(b2){
        [UIView commitAnimations];
    }
}


- (NSUInteger)selectedIndex{
    return selectedIndex;
}


- (void)setSelectedIndex:(NSUInteger)index{
    [self activateViewControllerAt:(int)index];
}

- (void)dealloc {
    
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
