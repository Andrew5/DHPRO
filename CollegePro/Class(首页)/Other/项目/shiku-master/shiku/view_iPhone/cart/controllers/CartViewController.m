//
//  CartViewController.m
//  shiku
//
//  Created by txj on 15/5/11.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "CartViewController.h"
#import "CheckoutViewController.h"
#import "AppDelegate.h"
#define TableCellFooter @"CartTableViewCell"
#define TableCellHeader @"CartTableViewCellHeader"
#define TableCell @"CartTableViewCell"

@interface CartViewController ()

@end

@implementation CartViewController
- (void)setup {
    self.backend = [CartBackend new];
    App *app = [App shared];
    @weakify(self)
    [RACObserve(app, currentUser) subscribeNext:^(USER *user) {
        @strongify(self);
        self.user = user;
        if ([user authorized]) {
            [self loadData];
            [ec.view removeFromSuperview];
        }
        else {
            ec = [EmptyViewController shared];
            [self.view addSubview:[ec view]];
            ec.titleLabel.text = @"您还没有喜欢的商品";
            ec.iconLable.text = @"\U0000A04A";
            ec.view.frame = self.navigationController.view.frame;
        }
    }];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        @strongify(self)

        [self loadData];

        CGPoint point = self.tableView.contentOffset;
        point.y = 0;
        self.tableView.contentOffset = point;
    }];
    [RACObserve(self.cart.total, goods_price)
            subscribeNext:^(id x) {
                @strongify(self);
                 self.totalPrice.text = self.cart.total.goods_price;
            }];
    [RACObserve(self, cart)
            subscribeNext:^(id x) {
                @strongify(self);
                self.title = [NSString stringWithFormat:@"购物车(%ld)", (long)self.cart.Num];
            }];

    [self.cart wantTotal];
    [self.tableView.pullToRefreshView setTitle:@"下拉刷新" forState:SVPullToRefreshStateStopped];
    [self.tableView.pullToRefreshView setTitle:@"立即刷新" forState:SVPullToRefreshStateTriggered];
    self.tableView.showsInfiniteScrolling = NO;

    [self loadData];

}

- (void)loadData {
    [self Showprogress];
    [[self.backend requestCartListWithUser:self.user]
            subscribeNext:[self didLoadData]];
}

- (void)loadDataMore {
    [self Showprogress];
    [[self.backend requestCartListWithUser:self.user]
            subscribeNext:[self didLoadDataMore]];
}

- (void (^)(RACTuple *))didLoadData {
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        [self hideHUDView];
        RACTupleUnpack(FILTER *filter,
                NSArray *list) = parameters;
        self.cart = [Cart shared];

        self.cart.shop_list = [[NSMutableArray alloc] initWithArray:list];
        if (self.cart.shop_list.count > 0) {
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
            [ec.view removeFromSuperview];
        }
        else {
            ec = [EmptyViewController shared];
            [self.view addSubview:[[EmptyViewController shared] view]];
            ec.titleLabel.text = @"您还没有喜欢的商品";
            ec.iconLable.text = @"\U0000A04A";
            ec.view.frame = self.navigationController.view.frame;
           
        }
        
        if ([self.cart getTotalAmount] == 0) {
            
            topRightBtn.hidden = YES;
        }
        else{
            
            self.bottomBarContainer.hidden = NO;
            
            topRightBtn.hidden = NO;
        }
    };

}
- (void)goSBack
{
    if (self.fromVCState ==FROM_GOODSVC||self.fromVCState== FROM_SEARCHVC) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void (^)(RACTuple *))didLoadDataMore {
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        [self hideHUDView];
        RACTupleUnpack(FILTER *filter,
                NSArray *list) = parameters;
        [self.cart.shop_list addObjectsFromArray:list];
        self.tableView.showsInfiniteScrolling = filter.pagenation.more;
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
    };

}

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (instancetype)initWithBackBtn {
    self = [self init];
    if (self) {
        isShowBackBtn = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.fromVCState) {
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        app.viewController.tabBarHidden = YES;
    }
    
    isAllSelect = NO;
    issectionSelected = NO;
    isrowSelected = NO;
    isTableCellEdit = NO;
    [self.cart.select_shop_list removeAllObjects];
    self.totalPrice.text = @"0.00";
//    [self.cart.shop_list removeAllObjects];

    //更新购物车数据
    [self loadData];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.fromVCState) {
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        app.viewController.tabBarHidden = NO;
    }
}
-(void)callbackVC{
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    if (isShowBackBtn) {
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];//[self tbarBackButtonWhite];
    }
    self.title = @"购物车";

    //右侧购物车按钮
    topRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    topRightBtn.frame = CGRectMake(0, 0, 80, 40);
//    topRightBtn.hidden = YES;
    topRightBtn.backgroundColor = [UIColor clearColor];
    [topRightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    topRightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    topRightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [topRightBtn addTarget:self action:@selector(topRightBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:topRightBtn];
    if (self.fromVCState) {
        self.navigationItem.leftBarButtonItem = [self tbarBackButtonWhite];
    }
    isTableCellEdit = NO;
    
    self.checkoutBtn.layer.cornerRadius = 5;
    self.checkoutBtn.backgroundColor = [UIColor redColor];//MAIN_COLOR;
    [self.checkoutBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self.tableView registerNib:[UINib nibWithNibName:TableCell bundle:nil] forCellReuseIdentifier:TableCell];
    [self.tableView registerNib:[UINib nibWithNibName:TableCellHeader bundle:nil] forHeaderFooterViewReuseIdentifier:TableCellHeader];
    
    self.checkbox = [[QCheckBox alloc] initWithDelegate:self checkBoxIconSize:20];
    self.checkbox.frame = CGRectMake(10, 15, 60, 30);
    self.checkbox.delegate = self;
    [self.checkbox setImage:[UIImage imageNamed:@"icon1_03"] forState:UIControlStateNormal];
    [self.checkbox setImage:[UIImage imageNamed:@"icon1_10"] forState:UIControlStateSelected];
    [self.checkbox setTitle:@"全选" forState:UIControlStateNormal];
    [self.checkbox.titleLabel setFont:[UIFont systemFontOfSize:MEDIUM_TEXT_SIZE]];
    [self.checkbox setTitleColor:TEXT_COLOR_BLACK forState:UIControlStateNormal];
    [self.bottomBarContainer addSubview:self.checkbox];
//    self.bottomBarContainer.hidden = YES;
    [self.checkbox setChecked:NO];
    //购物车
    [self setup];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ExitLog) name:@"Exit" object:nil];

   
}
- (void)ExitLog
{
    self.cart.shop_list = nil;
    
    [self.tableView reloadData];
}
#pragma 右边按钮点击

- (void)topRightBtnTapped {
    if (isTableCellEdit) {
        isTableCellEdit = NO;
        [topRightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    else {
        isTableCellEdit = YES;
        [topRightBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    [self.tableView reloadData];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Table Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_cart.shop_list.count > 0) {
        return self.cart.shop_list.count;

    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_cart.shop_list.count > 0) {
        SHOP_ITEM *gl = self.cart.shop_list[section];
        return gl.cart_goods_list.count;
    }
    return 0;
}
#pragma -mark 崩溃
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CartTableViewCell *cell = (CartTableViewCell *) [tableView dequeueReusableCellWithIdentifier:TableCell forIndexPath:indexPath];
    
    if ([self.cart.shop_list count]>0) {
        SHOP_ITEM *item = self.cart.shop_list[indexPath.section];
        cell.cartItem = item.cart_goods_list[indexPath.row];
        cell.delegate = self;
        cell.cartItem.indexPath = indexPath;
        cell.cartItem.isInEditMode = isTableCellEdit;
        //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cartItem.isSeleced = NO;

    }
        [cell bind];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CartTableViewCell *cell = (CartTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    SHOP_ITEM *item = self.cart.shop_list[indexPath.section];

    GOODS *cg = [GOODS new];
    cg.goods_id = cell.cartItem.goods_id;
    
    //去导航栏
    GoodsDetailViewController *control = [[GoodsDetailViewController alloc] initWithGoods:cg];
    control.FromCartVC = YES;
    control.mid =item.rec_id;
    [self.navigationController pushViewController:control animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CartTableViewCellHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableCellHeader];
    if ([self.cart.shop_list count]>0) {
        headerView.shop_item = self.cart.shop_list[section];
        headerView.shop_item.section = section;
        headerView.delegate = self;
    }
    
    [headerView bind];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//全选按钮
- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    if (!issectionSelected && !isrowSelected) {
        if (checked) {
            isAllSelect = YES;
            [self.cart selectAllItems];
            isAllSelect = NO;
            
        }
        else {
            if ([self.cart isAllItemsSelected]) {
                [self.cart removeAllSelectItems];
            }
        }
//        [self wantTotal];
    }
}

#pragma mark TableCellDelegate

//数量改变
- (void)didCartItemQuantityTaped:(CartTableViewCell *)cell {
    
    if (cell.cartItem.goods_number>0) {
        [[self.backend requestCartGoodsNum:cell.cartItem]
         subscribeNext:[self didUpdateCount]];
        return;
    }
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:1];
    [items addObject:cell.cartItem];
    [[self.backend requestRemoveCartItems:items]
     subscribeNext:[self didUpdate:@"删除成功"]];


}

//添加喜欢列表
- (void)didCartItemBuy:(CART_GOODS *)item
{
    NSLog(@"%@",[item description]);
    NSMutableArray *items = [[NSMutableArray alloc]initWithCapacity:1];
    [items addObject:item];
    NSString *goodName = item.goods_name;
    NSInteger goodId = [item.goods_id integerValue];

    [[self.backend requestAddItemToLikeList:goodName andGoodsId:[NSString stringWithFormat:@"%ld",(long)goodId] andGoodsNum:item.goods_number WithUser:self.user] subscribeNext:[self didUpdate:@"添加成功"]];
}

- (void)didCartItemDrop:(CART_GOODS *)item {
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:1];
    [items addObject:item];
    [[self.backend requestRemoveCartItems:items]
            subscribeNext:[self didUpdate:@"删除成功"]];
   
}
- (void (^)(RACTuple *))didUpdate:(NSString *)text {
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        ResponseResult *rs = (ResponseResult *) parameters;
        if (rs.success) {
           
            [self.view showHUD:text afterDelay:2];
            [self loadData];
        }
        else {
            [self.view showHUD:rs.messge afterDelay:2];
        }

    };
}

- (void (^)(RACTuple *))didUpdateCount {
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        ResponseResult *rs = (ResponseResult *) parameters;
        if (rs.success) {
            [self loadData];
        }
        else {
            [self.view showHUD:rs.messge afterDelay:2];
        }

    };
}
#pragma mark  打钩选择
- (void)cartTableViewCell:(CartTableViewCell *)cell didSelect:(BOOL)selected {
    if (!issectionSelected && !isScroll && !isAllSelect) {
        isrowSelected = YES;
        NSInteger section = cell.cartItem.indexPath.section;
        SHOP_ITEM *oldgl = [self.cart.shop_list objectAtIndex:section];
        NSString *key = [NSString stringWithFormat:@"%ld", (long) section];

        SHOP_ITEM *gl;
        gl = [self.cart.select_shop_list objectForKey:key];

        if (!gl) {
            gl = [[SHOP_ITEM alloc] init];
            gl.name = oldgl.name;
            gl.rec_id = oldgl.rec_id;
            gl.cart_goods_list = [[NSMutableArray alloc] init];
            [self.cart.select_shop_list setObject:gl forKey:key];
        }

        cell.cartItem.isSeleced = selected;

        if (selected) {
            [gl.cart_goods_list addObject:cell.cartItem];
            if ([self.cart isAllItemsSelected]) {
                [self.checkbox setChecked:YES];
            }
        }
        else {
            [gl.cart_goods_list removeObject:cell.cartItem];
            if (gl.cart_goods_list.count == 0) {
                [self.cart.select_shop_list removeObjectForKey:key];
            }
            [self.checkbox setChecked:NO];
        }

        if (oldgl.cart_goods_list.count == gl.cart_goods_list.count) {
            oldgl.isSeleced = YES;
        }
        else {
            oldgl.isSeleced = NO;
        }
        isrowSelected = NO;
//        [self wantTotal];

        [self.cart wantTotal];
        
    }
}
- (void)wantTotal
{
    NSInteger totalCount = 0;
    CGFloat totalWeight = 0.0;
    CGFloat totalPrice = 0.0;
    for (NSString *key in self.cart.select_shop_list.allKeys) {
        SHOP_ITEM *item= [self.cart.select_shop_list objectForKey:key];
//        [self..checkout_shop_list addObject:item];
        totalCount+= item.cart_goods_list.count;
        for (CART_GOODS *cd in item.cart_goods_list) {
            totalWeight+=cd.goods_weight*cd.goods_number;
            totalPrice+=cd.goods_price*cd.goods_number;
        }
    }
    self.totalPrice.text = [NSString stringWithFormat:@"%.2f",totalPrice];

}
#pragma mark CartTableViewCellHeaderDelegate

- (void)cartTableViewCellHeader:(CartTableViewCellHeader *)cell didSelect:(BOOL)selected {
    if (!isrowSelected && !isScroll && !isAllSelect) {
        issectionSelected = YES;
        NSString *key = [NSString stringWithFormat:@"%ld", (long) cell.shop_item.section];
        SHOP_ITEM *oldgl = [self.cart.shop_list objectAtIndex:cell.shop_item.section];
        SHOP_ITEM *gl;
        gl = [self.cart.select_shop_list objectForKey:key];
        if (selected) {
            oldgl.isSeleced = YES;
            if (!gl) {
                gl = [[SHOP_ITEM alloc] init];
                gl.name = oldgl.name;
                gl.rec_id = oldgl.rec_id;
                gl.cart_goods_list = [[NSMutableArray alloc] init];
                [self.cart.select_shop_list setObject:gl forKey:key];
            }
            for (CART_GOODS *cg in oldgl.cart_goods_list) {
                cg.isSeleced = YES;
                if (![gl.cart_goods_list containsObject:cg]) {
                    [gl.cart_goods_list addObject:cg];
                }
            }

            if ([self.cart isAllItemsSelected]) {
                //[self.cart selectAllItems];
                [self.checkbox setChecked:YES];
            }
        }
        else {

            if (oldgl.cart_goods_list.count == gl.cart_goods_list.count) {
                oldgl.isSeleced = NO;
                for (CART_GOODS *cg in oldgl.cart_goods_list) {
                    cg.isSeleced = NO;
                    [self.cart.select_shop_list removeObjectForKey:key];
//                    gl.select_count-=1;
//                    oldgl.select_count-=1;
                }
                [self.checkbox setChecked:NO];
            }
            else {
                issectionSelected = NO;
            }

        }

        issectionSelected = NO;
//        [self wantTotal];

        [self.cart wantTotal];
    }

}

#pragma mark TableViewScrollDelegate

//手指离开屏幕后ScrollView还会继续滚动一段时间只到停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

//    NSLog(@"结束滚动后缓冲滚动彻底结束时调用");
    isScroll = NO;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {

//    NSLog(@"结束滚动后开始缓冲滚动时调用");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //页面滚动时调用，设置当前页面的ID
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    isScroll = YES;
//    NSLog(@"滚动视图开始滚动，它只调用一次");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    NSLog(@"滚动视图结束滚动，它只调用一次");

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)checkoutBtnTapped:(id)sender {

    int ui = 90;
    int yu = 80;
    if (ui == 78||yu==80) {
        NSLog(@"成功");
    }
    else if (ui == 89 && yu == 80){
        NSLog(@"打印");

    }
    else if (ui == 89 & yu == 80){
        NSLog(@"打2印");

    }
    else if (ui == 89 | yu == 80){
        NSLog(@"打3印");

    }

//结算预览
//    [[self.backend requestGetExpressPrice:self.cart.total]
//                subscribeNext:[self didGetExpressSuccess]];
   
    [self didGetExpressSuccess];

}

//结算预览
-(void)didGetExpressSuccess
{
    if ([self.cart.select_shop_list count] > 0) {
        
        if ([self.cart.select_shop_list count]>1) {
            for (int i = 1; i<[self.cart.select_shop_list count]; i++) {
                SHOP_ITEM * item = [self.cart.select_shop_list objectForKey:[NSString stringWithFormat:@"%d",0]];
                SHOP_ITEM * item1 = [self.cart.select_shop_list objectForKey:[NSString stringWithFormat:@"%d",i]];
                if (item.rec_id!=item1.rec_id) {
                    [self.view showHUD:@"两家店的商品不能同时结算" afterDelay:1];
                    return ;
                }
            }
        }
        CheckoutViewController *ch = [[CheckoutViewController alloc] initWithExpress:@"0.00"];
        [self showNavigationView:ch];
    }
    else {
        [self.view showHUD:@"请选择需要结算的商品" afterDelay:1];
    }
}

/*
- (void (^)(RACTuple *))didGetExpressSuccess {
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)

        if ([self.cart.select_shop_list count] > 0) {
           
            if ([self.cart.select_shop_list count]>1) {
                for (int i = 1; i<[self.cart.select_shop_list count]; i++) {
                    SHOP_ITEM * item = [self.cart.select_shop_list objectForKey:[NSString stringWithFormat:@"%d",0]];
                    SHOP_ITEM * item1 = [self.cart.select_shop_list objectForKey:[NSString stringWithFormat:@"%d",i]];
                    if (item.rec_id!=item1.rec_id) {
                         [self.view showHUD:@"两家店的商品不能同时结算" afterDelay:1];
                                return ;
                            }
                        }
            }
        CheckoutViewController *ch = [[CheckoutViewController alloc] initWithExpress:(NSString *) parameters];
            [self showNavigationView:ch];
        }
        else {
            [self.view showHUD:@"请选择需要结算的商品" afterDelay:1];
        }
        
//        if (self.cart.address == nil) {
//            [self.view showHUD:@"请选择收货地址" afterDelay:1];
//        }
//        else{
//            CheckoutViewController *ch = [[CheckoutViewController alloc] initWithExpress:(NSString *) parameters];
//            [self showNavigationView:ch];
//        }
        

    };

}
*/
@end
