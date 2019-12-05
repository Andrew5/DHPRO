//
//  FavViewController.m
//  shiku
//
//  Created by txj on 15/5/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "InformationController.h"
#import "InformationTableViewCell.h"

#define TableCell @"InformationTableViewCell"

@interface InformationController ()

@end

@implementation InformationController

-(instancetype)initWithBackBtn:(BOOL)isWithBack
{
    self=[self init];
    if (self) {
        isHaveBackBtn=isWithBack;
    }
    return self;
}

- (void)setup
{
    self.backend=[UserBackend shared];
    self.filter=[FILTER new];
    App *app = [App shared];
    @weakify(self)
    [RACObserve(app, currentUser) subscribeNext:^(USER *user) {
        @strongify(self);
        self.user = user;
        if ([user authorized])
        {
            [self loadData];
            [ec.view removeFromSuperview];
        }
        else
        {
            ec=[EmptyViewController shared];
            [self.view addSubview:[[EmptyViewController shared] view]];
            ec.titleLabel.text=@"您还没有消息";
            ec.iconLable.text=@"\U0000A08A";
            ec.subTitleLabel.text=@"";
            ec.view.frame=self.navigationController.view.frame;
        }
    }];
    [self.tableView addPullToRefreshWithActionHandler:^{
        @strongify(self)
        
        [self loadData];
        
        CGPoint point = self.tableView.contentOffset;
        point.y = 0;
        self.tableView.contentOffset = point;
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self)
        [self loadDataMore];
    }];
    [self.tableView.pullToRefreshView setTitle:@"下拉刷新" forState:SVPullToRefreshStateStopped];
    [self.tableView.pullToRefreshView setTitle:@"立即刷新" forState:SVPullToRefreshStateTriggered];
    self.tableView.showsInfiniteScrolling = NO;
    
}
-(void)loadData
{
    [[self.backend requestInfomationList:self.filter withUser:self.user]
     subscribeNext:[self didLoadData]];
}
-(void)loadDataMore
{
    int p=[self.filter.pagenation.page intValue];
    p++;
    self.filter.pagenation.page=[[NSNumber alloc] initWithInt:p];
    [[self.backend requestUserFavList:self.filter withUser:self.user]
     subscribeNext:[self didLoadDataMore]];
}
- (void(^)(RACTuple *))didLoadData
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        RACTupleUnpack(FILTER *filter,
                       NSArray *goodslist) = parameters;
        self.filter=filter;
        favoriteList=[[NSMutableArray alloc] initWithArray:goodslist];
        if (favoriteList.count>0) {
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
            [ec.view removeFromSuperview];
        }
        else
        {
            ec=[EmptyViewController shared];
            [self.view addSubview:[[EmptyViewController shared] view]];
            ec.titleLabel.text=@"您还没有消息";
            ec.iconLable.text=@"\U0000A08A";
            ec.subTitleLabel.text=@"";
            ec.view.frame=self.navigationController.view.frame;
            
        }
        [self.tableView.pullToRefreshView stopAnimating];
        
    };
    
}
- (void(^)(RACTuple *))didLoadDataMore
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        RACTupleUnpack(FILTER *filter,
                       NSArray *goodslist) = parameters;
        self.filter=filter;
        [favoriteList addObjectsFromArray:goodslist];
        self.tableView.showsInfiniteScrolling = filter.pagenation.more;
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
    };
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"我的消息";
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection = NO;
    [self.tableView registerNib:[UINib nibWithNibName:TableCell bundle:nil]  forCellReuseIdentifier:TableCell];
    
    [self.view addSubview:self.tableView];
    
//    if (isHaveBackBtn) {
        self.navigationItem.leftBarButtonItem=[self tbarBackButton];
//    }
    
    [self setup];

}


#pragma mark Table Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return favoriteList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    InformationTableViewCell *cell = (InformationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableCell forIndexPath:indexPath];
    
    //cell.leftUtilityButtons = [self leftButtons];
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    cell.goods=[favoriteList objectAtIndex:indexPath.row];
    [cell bind];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    InformationTableViewCell *cell=(InformationTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    
//    GoodsDetailViewController *control=[[GoodsDetailViewController alloc] initWithGoods:cell.goods];
//    [self showNavigationView:control];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


#pragma mark - SWTableViewDelegate
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                icon:[UIImage imageNamed:@"check.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:1.0]
                                                icon:[UIImage imageNamed:@"clock.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
                                                icon:[UIImage imageNamed:@"cross.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
                                                icon:[UIImage imageNamed:@"list.png"]];
    
    return leftUtilityButtons;
}


// click event on left utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
}

// click event on right utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    InformationTableViewCell *fcell=(InformationTableViewCell *)cell;
    [self favTableViewCellDelTaped:fcell.goods];
}

// utility button open/close event
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
}

// prevent multiple cells from showing utilty buttons simultaneously
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

// prevent cell(s) from displaying left/right utility buttons
- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    return YES;
}
-(void)favTableViewCellDelTaped:(GOODS *)product
{
    NSMutableArray *items=[[NSMutableArray alloc] initWithArray:@[product]];
    [[self.backend requestRemoveInfomationItems:items]
     subscribeNext:[self didUpdate]];
}
- (void(^)(RACTuple *))didUpdate
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        ResponseResult *rs=(ResponseResult *)parameters;
        if (rs.success) {
            [self.view showHUD:@"删除成功" afterDelay:2];
            [self loadData];
        }
        else{
            [self.view showHUD:rs.messge afterDelay:2];
        }
        
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
