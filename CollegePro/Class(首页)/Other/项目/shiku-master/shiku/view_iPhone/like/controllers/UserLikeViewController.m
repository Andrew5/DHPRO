//
//  UserLikeViewController.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "UserLikeViewController.h"

#define tablecell @"UserLikeTableViewCell"

@interface UserLikeViewController ()<GoodsDetailShareViewCellDelegate>

@end

@implementation UserLikeViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
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
            ec.titleLabel.text=@"您还没有喜欢的商品";
            ec.iconLable.text=@"\U0000B01A";
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
    [self Showprogress];
    [[self.backend requestUserLikeList:self.filter withUser:self.user]
     subscribeNext:[self didLoadData]];
}
-(void)loadDataMore
{
     [self Showprogress];
    int p=[self.filter.pagenation.page intValue];
    p++;
    self.filter.pagenation.page=[[NSNumber alloc] initWithInt:p];
    [[self.backend requestUserLikeList:self.filter withUser:self.user]
     subscribeNext:[self didLoadDataMore]];
}
- (void(^)(RACTuple *))didLoadData
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        [self hideHUDView];
        RACTupleUnpack(FILTER *filter,
                       NSArray *goodslist) = parameters;
        self.filter=filter;
        userLikeList=[[NSMutableArray alloc] initWithArray:goodslist];
        if (userLikeList.count>0) {
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
            [ec.view removeFromSuperview];
        }
        else
        {
            ec=[EmptyViewController shared];
            [self.view addSubview:[[EmptyViewController shared] view]];
            ec.titleLabel.text=@"您还没有喜欢的商品";
            ec.iconLable.text=@"\U0000B01A";
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
        [self hideHUDView];
        RACTupleUnpack(FILTER *filter,
                       NSArray *goodslist) = parameters;
        self.filter=filter;
       [userLikeList addObjectsFromArray:goodslist];
        self.tableView.showsInfiniteScrolling = filter.pagenation.more;
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
    };
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"我的喜欢";
    if (isHaveBackBtn) {
        self.navigationItem.leftBarButtonItem=[self tbarBackButton];
    }
    GoodsDetailShareViewCell *good = [[GoodsDetailShareViewCell alloc]init];
    good.delegate = self;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection = NO;
    [self.tableView registerNib:[UINib nibWithNibName:tablecell bundle:nil]  forCellReuseIdentifier:tablecell];
    
    [self setup];
    [self loadData];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ExitLog) name:@"Exit" object:nil];

}
- (void)ExitLog
{
    userLikeList = nil;
    [self.tableView reloadData];
}
#pragma mark Table Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return userLikeList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserLikeTableViewCell *cell = (UserLikeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tablecell forIndexPath:indexPath];
    cell.goods=[userLikeList objectAtIndex:indexPath.row];
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    cell.ulDelegate=self;
    [cell bind];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserLikeTableViewCell *cell=(UserLikeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    COLLECT_GOODS *cg=[COLLECT_GOODS new];
    cg.rec_id=cell.goods.goods_id;
    GoodsDetailViewController *control=[[GoodsDetailViewController alloc] initWithGoods:cell.goods];
    [self showViewController:control sender:self];

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    CheckoutTableViewCellHeader *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableCellHeader];
    //    view.shop_item=[self.cart.checkout_shop_list objectAtIndex:section];
    //    view.shop_item.section=section;
    //    //    headerView.delegate=self;
    //    [view bind];
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //    CheckoutTableViewCellFooter *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableCellFooter];
    //    view.shop_item=[self.cart.shop_list objectAtIndex:section];
    //    view.shop_item.section=section;
    //    [view bind];
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


#pragma mark - SWTableViewDelegate

// click event on left utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
}

// click event on right utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    UserLikeTableViewCell *fcell=(UserLikeTableViewCell *)cell;
    [self tableViewCellDelTaped:fcell.goods];
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
#pragma UserLikeTableCellDelegate
-(void)didSharedBtnTapped:(COLLECT_GOODS *)goods
{
    
    [self showSharedView:nil goodsID:nil couponCode:nil goodstitle:@"食库"     goodsinfor:goods.name imgUrl:nil shareUrl:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)tableViewCellDelTaped:(COLLECT_GOODS *)goods
{
    NSMutableArray *items=[[NSMutableArray alloc] initWithArray:@[goods]];
    [[self.backend requestRemoveUserLikeItems:items]
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

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    //    [rightUtilityButtons sw_addUtilityButtonWithColor:
    //     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
    //                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
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
