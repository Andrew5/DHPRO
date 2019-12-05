//
//  OrderViewController.m
//  shiku
//
//  Created by txj on 15/5/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "OrderListViewController.h"
#import "ShippingViewController.h"

#define TableCellFooter @"OrderListTableViewCellFooter"
#define TableCellHeader @"OrderListTableViewCellHeader"
#define TableCell @"OrderListTableViewCell"
@interface OrderListViewController ()

@end

@implementation OrderListViewController

-(instancetype)init
{
    self=[super init];
    if (self) {
        self.filter=[FILTER new];
    }
    return self;
}
-(instancetype)initWithOrderStatus:(NSInteger)status
{
    self=[self init];
    self.filter.status=[[NSNumber alloc] initWithInteger:status];
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setup];
//    [self loadData];
}
- (void)sendEorrBack
{
    [self hideHUDView];
    [self.view showHUD:@"加载失败" afterDelay:1.5];
}
- (void)setup
{
    self.backend=[OrderBackend new];
    self.backend.delegate =self;

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
            ec.titleLabel.text=@"您还没有订单";
            ec.iconLable.text=@"\U0000B24A";
             ec.subTitleLabel.text=@"";
            ec.view.frame=self.tableView.frame;
            [self.view addSubview:[ec view]];
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
    [[self.backend requestOrderListWithUser:self.filter withUser:self.user]
     subscribeNext:[self didLoadData]];
}
-(void)loadDataMore
{
    [self Showprogress];
    int p=[self.filter.pagenation.page intValue];
    p++;
    self.filter.pagenation.page=[[NSNumber alloc] initWithInt:p];
    [[self.backend requestOrderListWithUser:self.filter withUser:self.user]
     subscribeNext:[self didLoadDataMore]];
}
- (void(^)(RACTuple *))didLoadData
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        [self hideHUDView];
        RACTupleUnpack(FILTER *filter,
                       NSArray *list) = parameters;
        self.filter=filter;
        self.datalist=[[NSMutableArray alloc] initWithArray:list];
        if (self.datalist.count>0) {
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
            [ec.view removeFromSuperview];
        }
        else
        {
            ec=[EmptyViewController shared];
            
            ec.view.frame=self.tableView.frame;
            ec.titleLabel.text=@"您还没有订单";
            ec.iconLable.text=@"\U0000B24A";
            ec.subTitleLabel.text=@"";
            ec.view.frame=self.tableView.frame;
            [self.view addSubview:[ec view]];
            
        }
        [self.tableView.pullToRefreshView stopAnimating];
         self.tableView.showsInfiniteScrolling = filter.pagenation.more;
        
    };
    
}
- (void(^)(RACTuple *))didLoadDataMore
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        [self hideHUDView];
        RACTupleUnpack(FILTER *filter,
                       NSArray *list) = parameters;
        self.filter=filter;
        [self.datalist addObjectsFromArray:list];
        self.tableView.showsInfiniteScrolling = filter.pagenation.more;
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
    };
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"我的订单";
    self.navigationItem.leftBarButtonItem=[self tbarBackButton];
    self.view.backgroundColor=BG_COLOR;
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];

    
    ThreeStageSegmentView *tssView=[[ThreeStageSegmentView alloc] initWithButtonsName:@[@"全部",@"待付款",@"待发货",@"待收货",@"已完成"] frame:CGRectMake(0, 0,screenSize.width, 40)];
    tssView.delegate=self;
    tssView.backgroundColor=WHITE_COLOR;
    [self.threeSegmentBtn addSubview:tssView];
    
    [tssView changeSelectedIndex:[self.filter.status integerValue]];
    
    [self.tableView registerNib:[UINib nibWithNibName:TableCell bundle:nil] forCellReuseIdentifier:TableCell];
    [self.tableView registerNib:[UINib nibWithNibName:TableCellHeader bundle:nil] forHeaderFooterViewReuseIdentifier:TableCellHeader];
    [self.tableView registerNib:[UINib nibWithNibName:TableCellFooter bundle:nil] forHeaderFooterViewReuseIdentifier:TableCellFooter];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- ThreeStageSegmentViewDelegate
- (void)threeStageSegmentView:(ThreeStageSegmentView *)segment
             didSelectAtIndex:(NSInteger)index
{
    self.filter.pagenation.page=[[NSNumber alloc] initWithInt:1];
    switch (index) {
        case 1:
            self.filter.status=[[NSNumber alloc] initWithInt:0];
            break;
        case 2:
            self.filter.status=[[NSNumber alloc] initWithInt:1];
            break;
        case 3:
            self.filter.status=[[NSNumber alloc] initWithInt:2];
            break;
        case 4:
            self.filter.status=[[NSNumber alloc] initWithInt:4];
            break;

        case 0:
        default:
            self.filter.status=nil;
            break;
    }
    
    [self.datalist removeAllObjects];
    [self.tableView reloadData];
    [self Showprogress];
    [[self.backend requestOrderListWithUser:self.filter withUser:self.user]
     subscribeNext:[self didLoadData]];
}


#pragma mark Table Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datalist.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return favoriteList.count;
    ORDER *od=[self.datalist objectAtIndex:section];
    return od.shop_item.cart_goods_list.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderListTableViewCell *cell = (OrderListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableCell forIndexPath:indexPath];
    ORDER *item=[self.datalist objectAtIndex:indexPath.section];
    //    cell.delegate = self;
    cell.cartItem=[item.shop_item.cart_goods_list objectAtIndex:indexPath.row];
//    cell.cartItem.indexPath=indexPath;
    //    cell.cartItem.isInEditMode=isTableCellEdit;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell bind];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return 75;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        OrderDetailViewController *control=[[OrderDetailViewController alloc] initWithOrder:[self.datalist objectAtIndex:indexPath.section]];
//        control.delegate=self;
        
        [self showNavigationView:control];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 100.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderListTableViewCellHeader *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableCellHeader];
    ORDER *o=[self.datalist objectAtIndex:section];
    view.order=o;
    view.order.shop_item.section=section;
    //    headerView.delegate=self;
    [view bind];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    OrderListTableViewCellFooter *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableCellFooter];
    ORDER *o=[self.datalist objectAtIndex:section];
    view.order=o;
    view.delegate=self;
    view.order.shop_item.section=section;
    [view bind];
    return view;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma OrderListTableViewCellFooterDelegate
- (void)didQFKTaped:(ORDER *)anOrder
{
    PaymentViewController *p=[[PaymentViewController alloc] initWithOrder:anOrder];
    [self showNavigationView:p];
}
//物流信息
- (void)didCKWLTaped:(ORDER *)anOrder
{
    
    ShippingViewController *wc=[[ShippingViewController alloc] initWithTitle:@"物流信息" withUrl:[NSString stringWithFormat:@"%@com=%@&num=%@",url_ckwl,anOrder.shipping_item.shipping_code,anOrder.shipping_item.shipping_sn] popController:NO andAnorder:anOrder];
    [self showNavigationView:wc];
}
- (void)didCKXQTapped:(ORDER *)anOrder
{
    
    OrderDetailViewController *control=[[OrderDetailViewController alloc] initWithOrder:anOrder];
    //        control.delegate=self;
    
    [self showNavigationView:control];
}
- (void)didQRSHTaped:(ORDER *)anOrder
{
    [[self.backend requestConfirmOrder:anOrder]
    subscribeNext:[self didUpdate:@"确认收货成功"]];
}
-(void)didGBJYTaped:(ORDER *)anOrder
{
    [[self.backend requestCloseOrder:anOrder]
     subscribeNext:[self didUpdate:@"关闭交易成功"]];
}
- (void(^)(RACTuple *))didUpdate:(NSString *)text
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        ResponseResult *rs=(ResponseResult *)parameters;
        if (rs.success) {
            [self.view showHUD:text afterDelay:2];
            [self loadData];
        }
        else{
            [self.view showHUD:rs.messge afterDelay:2];
        }
        [self.tableView reloadData];
        
    };
}

- (void)didSCDDTaped:(ORDER *)anOrder
{
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
