//
//  SidebarViewController.m
//  LLBlurSidebar
//
//  Created by Lugede on 14/11/20.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//

#import "SidebarViewController.h"
static SidebarViewController *singletonInstance;

@interface SidebarViewController ()<UITableViewDelegate, UITableViewDataSource>
{
	NSArray *_titleArray;
}
@property (nonatomic, retain) UITableView* menuTableView;

@end

@implementation SidebarViewController

+ (SidebarViewController *)sharedInstance
{
	return singletonInstance;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 列表
    self.menuTableView = [[UITableView alloc] initWithFrame:self.contentView.bounds];
    [self.menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.menuTableView.backgroundColor = [UIColor clearColor];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    [self.contentView addSubview:self.menuTableView];
	
	_titleArray = @[@"首页",@"物业服务",@"上门服务",@"周边产品",@"周边商铺",@"周边服务",@"社区二手",@"房屋租售",@"垂直电商",@"退出登录"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sidebarMenuCellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sidebarMenuCellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sidebarMenuCellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = _titleArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UITableViewCell *currentCell = [self.menuTableView cellForRowAtIndexPath:indexPath];

	
	self.myReturnTextBlock(currentCell.textLabel.text);

	

//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:titleArray[indexPath.row] message:nil delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
//    [alert show];
	
	
//    UIViewController *controller = nil;
//    id next = [self nextResponder];
//    while(![next isKindOfClass:[LBVerticalEleViewController class]])//这里跳不出来。。。
//    {
//        next = [next nextResponder];
//    }
//    if ([next isKindOfClass:[LBVerticalEleViewController class]])
//    {
//        controller = (LBVerticalEleViewController *)next;
//    }
//	  if ([next isKindOfClass:[LBPeripheralViewController class]]) {
//		  controller = (LBPeripheralViewController *)next;
//	  }


	
    [self showHideSidebar];
    
}

@end
