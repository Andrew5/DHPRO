//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "SlideMenuViewController.h"

@implementation SlideMenuViewController
@synthesize cellIdentifier;
@synthesize tableViewMy;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.isShowleftBtn = NO;
    [self createUI];
}
-(void)createUI{
    tableViewMy = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DH_DeviceWidth, DH_DeviceHeight) style:UITableViewStylePlain];
    tableViewMy.delegate = self;
    tableViewMy.dataSource = self;
    tableViewMy.tableFooterView = [UIView new];
    [self.view addSubview:tableViewMy];
}
#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"leftMenuCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
	switch (indexPath.row)
	{
		case 0:
			cell.textLabel.text = @"Home";
			break;
			
		case 1:
			cell.textLabel.text = @"Profile";
			break;
			
		case 2:
			cell.textLabel.text = @"Friends";
			break;
			
		case 3:
			cell.textLabel.text = @"Sign Out";
			break;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc ;
    switch (indexPath.row)
    {
        case 0:{
            Class cls =  NSClassFromString(@"DHAdressViewController");
            if (!cls) return;
            vc = [[cls alloc] init];
            [SlideNavigationController sharedInstance].leftMenu = vc;

        }
            break;
            
        case 1:{
//            Class cls =  NSClassFromString(@"ProfileViewController");
//            if (!cls) return;
//            vc = [[cls alloc] init];

        }
            break;
            
        case 2:
//            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"FriendsViewController"];
            break;
            
        case 3:
            [[SlideNavigationController sharedInstance] popViewControllerAnimated:YES];
            return;
            break;
    }
    [[SlideNavigationController sharedInstance] switchToViewController:vc withCompletion:nil];
}

@end
