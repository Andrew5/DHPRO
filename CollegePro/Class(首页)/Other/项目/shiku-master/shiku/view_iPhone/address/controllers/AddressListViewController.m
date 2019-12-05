//
//  AddressLIstViewController.m
//  shiku
//
//  Created by txj on 15/5/15.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "AddressListViewController.h"
#define TableCell @"AddressTableViewCell"
@interface AddressListViewController ()

@end

@implementation AddressListViewController
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
            ec.titleLabel.text=@"您还没有收货地址";
            ec.subTitleLabel.text=@"";
            ec.iconLable.text=@"\U0000B01A";
            ec.view.frame=self.tableView.frame;

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
    [[self.backend requestAddressList:self.filter withUser:self.user]
     subscribeNext:[self didLoadData]];
}
-(void)loadDataMore
{
    [self Showprogress];
    int p=[self.filter.pagenation.page intValue];
    p++;
    self.filter.pagenation.page=[[NSNumber alloc] initWithInt:p];
    [[self.backend requestAddressList:self.filter withUser:self.user]
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
        self.address_list=[[NSMutableArray alloc] initWithArray:list];
        if (self.address_list.count>0) {
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
            [ec.view removeFromSuperview];
        }
        else
        {
            ec=[EmptyViewController shared];
            [self.view addSubview:[[EmptyViewController shared] view]];
            ec.titleLabel.text=@"您还没有收货地址";
            ec.subTitleLabel.text=@"";
            ec.iconLable.text=@"\U0000B01A";
            ec.view.frame=self.tableView.frame;

            
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
                       NSArray *list) = parameters;
        self.filter=filter;
        [self.address_list addObjectsFromArray:list];
        self.tableView.showsInfiniteScrolling = filter.pagenation.more;
        [self.tableView reloadData];
        [self.tableView.infiniteScrollingView stopAnimating];
        
    };
    
}


-(instancetype)init
{
    self=[super init];
    if (self) {
        
    }
    return self;
}
-(instancetype)initWithCheckOut
{
    _initType=1;
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(_initType==1)
    {
        self.title=@"选择收货地址";
        
    }
    else{
        self.title=@"管理收货地址";
        
    }
    
    [self.addNewAddressBtn setHidden:NO];
    self.addNewAddressBtn.layer.cornerRadius=5;
    self.addNewAddressBtn.backgroundColor=MAIN_COLOR;
    self.navigationItem.leftBarButtonItem=[self tbarBackButton];
//    topRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    topRightBtn.frame = CGRectMake(0, 0, 80, 40);
//    topRightBtn.backgroundColor=[UIColor clearColor];
//    [topRightBtn setTitle:@"添加" forState:UIControlStateNormal];
//    topRightBtn.titleLabel.font=[UIFont systemFontOfSize:18];
//    topRightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [topRightBtn setTitleColor:TEXT_COLOR_BLACK forState:UIControlStateNormal];
//    [topRightBtn addTarget:self action:@selector(topRightBtnTapped) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:topRightBtn];

    
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
//    self.tableView.allowsSelection = NO;
    [self.tableView registerNib:[UINib nibWithNibName:TableCell bundle:nil] forCellReuseIdentifier:TableCell];
    
//    [self getTestData];
    [self setup];
    
}

-(void)topRightBtnTapped
{
    ADDRESS *add=[[ADDRESS alloc] init];
    add.province_name=@"";
    add.city_name=@"杭州市";
    add.district_name=@"西湖区";
    AddressEdiViewController *c=[[AddressEdiViewController alloc] initWithAddress:add];
    c.delegate=self;
    [self showNavigationView:c];

}
-(void)getTestData
{
    self.address_list=[NSMutableArray new];
    for (int i=1; i<4; i++) {
        ADDRESS *add=[ADDRESS new];
        add.consignee=[NSString stringWithFormat:@"收件人%d",i];
        add.tel=@"12345678956";
        add.address=[NSString stringWithFormat:@"浙江省杭州市西湖区详细地址%d",i];
        [self.address_list addObject:add];
    }
}
#pragma AddressEditViewDelgate
-(void)didAddressUpdate:(ADDRESS *)address controller:(AddressEdiViewController *)controller msg:(NSString *)msg
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    [self.view showHUD:msg afterDelay:2];
    [self loadData];
}

#pragma mark Table Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return favoriteList.count;
    return self.address_list.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AddressTableViewCell *cell = (AddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableCell forIndexPath:indexPath];
    cell.address=[self.address_list objectAtIndex:indexPath.row];
    if(_initType!=1){
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;
    }
    if (indexPath.row==0) {
//        cell.backgroundColor=MAIN_COLOR;
//        cell.coverImage.image=[UIImage imageNamed:@"icon2612505.png"];
//        cell.addressLabel.textColor=WHITE_COLOR;
//        cell.teleLabel.textColor=WHITE_COLOR;
//        cell.consigneeLabel.textColor=WHITE_COLOR;
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(cell.contentView.frame), CGRectGetHeight(cell.contentView.frame))];
        image.image=[UIImage imageNamed:[NSString stringWithFormat:@"back_address.png"]];
        [cell.contentView addSubview:image];
        
    }
    [cell bind];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_initType==1)
    {//选择地址
        SEL sel=@selector(didAddressSelected:);
        if([self.delegate respondsToSelector:sel])
        {
            [self.delegate didAddressSelected:self.address_list[indexPath.row]];
            [self goBack];
        }
    }
    else
    {//编辑地址
        AddressEdiViewController *c=[[AddressEdiViewController alloc] initWithAddress:self.address_list[indexPath.row]];
        c.delegate=self;
        [self showNavigationView:c];
    }
    //    FavTableViewCell *cell=(FavTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    //    ProductDetailViewV2Controller *control=[[ProductDetailViewV2Controller alloc] initWithProductID:cell.product.productID user:[[App shared] currentUser]];
    //    control.delegate=self;
    //
    //    [self showNavigationView:control];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
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

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath      //当在Cell上滑动时会调用此函数

{
    return  UITableViewCellEditingStyleDelete;  //返回此值时,Cell会做出响应显示Delete按键,点击Delete后会调用下面的函数,别给传递UITableViewCellEditingStyleDelete参数
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath//对选中的Cell根据editingStyle进行操作

{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
        
    {
        AddressTableViewCell *cell = (AddressTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self tableViewCellDelTaped:cell.address];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - SWTableViewDelegate

// click event on left utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
}

// click event on right utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    AddressTableViewCell *fcell=(AddressTableViewCell *)cell;
    [self tableViewCellDelTaped:fcell.address];
}
-(void)tableViewCellDelTaped:(ADDRESS *)anAddress
{
    [[self.backend requestDelAddressWithID:[anAddress.rec_id integerValue] user:nil]
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addNewAddrBtnTapped:(id)sender {
    ADDRESS *add=[[ADDRESS alloc] init];
    add.province_name=@"浙江省";
    add.city_name=@"杭州市";
    add.district_name=@"西湖区";
    AddressEdiViewController *c=[[AddressEdiViewController alloc] initWithAddress:add];
    c.delegate=self;
    [self showNavigationView:c];
}

- (IBAction)addNewAddBtnTapped:(id)sender {
}
@end
