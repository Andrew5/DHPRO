//
//  GoodsListViewController.m
//  shiku
//
//  Created by txj on 15/5/19.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "GoodsListViewController.h"
#import "CartViewController.h"
#define TableCellFooter @"OrderListTableViewCellFooter"
#define TableCellHeader @"OrderListTableViewCellHeader"
#define TableCell @"GoodsListTableViewCell"

@interface GoodsListViewController ()<UITextFieldDelegate>

@end

@implementation GoodsListViewController

- (void)setup
{
    App *app = [App shared];
    @weakify(self)
    [RACObserve(app, currentUser) subscribeNext:^(USER *user) {
        @strongify(self);
        self.user = user;
        lbCartBadge.text=[NSString stringWithFormat:@"%d",[[Cart shared] getTotalAmount]];
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
    [self loadData];
}
-(void)loadData
{
    [self Showprogress];
    [[self.backend requestGoodsListWithFilter:self.filter]
     subscribeNext:[self didLoadData]];
}
-(void)loadDataMore
{
     [self Showprogress];
    int p=[self.filter.pagenation.page intValue];
    p++;
    self.filter.pagenation.page=[[NSNumber alloc] initWithInt:p];
    [[self.backend requestGoodsListWithFilter:self.filter]
     subscribeNext:[self didLoadDataMore]];
}
- (void(^)(RACTuple *))didLoadData
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        [self hideHUDView];
        @strongify(self)
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
            [self.view addSubview:[[EmptyViewController shared] view]];
            ec.titleLabel.text=@"没有商品";
            ec.iconLable.text=@"\U0000B01A";
            ec.view.frame=self.navigationController.view.frame;
            
        }
        [self.tableView.pullToRefreshView stopAnimating];
        self.tableView.showsInfiniteScrolling = filter.pagenation.more;
        
    };
    
}
- (void(^)(RACTuple *))didLoadDataMore
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        [self hideHUDView];
        @strongify(self)
        RACTupleUnpack(FILTER *filter,
                       NSArray *list) = parameters;
        self.filter=filter;
        [self.datalist addObjectsFromArray:list];
        self.tableView.showsInfiniteScrolling = filter.pagenation.more;
        [self.tableView reloadData];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
    };
    
}

-(instancetype)init
{
    self=[super init];
    if (self) {
        self.backend=[GoodsBackend new];
    }
    return self;
}
-(instancetype)initWithFilter:(FILTER *)anFilter
{
    self=[self init];
    if (self) {
        self.filter=anFilter;
        self.title=@"搜索结果";
    }
    return self;
}
-(instancetype)initWithCategory:(CATEGORY *)anCategory
{
    self=[self init];
    if (self) {
        self.category=anCategory;
        self.title=anCategory.name;
        self.filter=[FILTER new];
        self.filter.category_id=anCategory.rec_id;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    lbCartBadge.text=[NSString stringWithFormat:@"%d",[[Cart shared] getTotalAmount]];
    
    self.navigationItem.leftBarButtonItem=[self tbarBackButtonWhite];
    self.view.backgroundColor=BG_COLOR;
    
    UIView *searchFieldView=[self tToolbarSearchField:[UIScreen mainScreen].bounds.size.width-115 withheight:20 isbecomeFirstResponder:NO action:@selector(searchFieldTouched) textFieldDelegate:self];
    searchFieldView.autoresizingMask=YES;
    self.navigationItem.titleView=searchFieldView;
    topRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    topRightBtn.frame = CGRectMake(0, 0, 40, 40);
    [topRightBtn setBackgroundImage:[UIImage imageNamed:@"icon2512505.png"] forState:UIControlStateNormal];
    topRightBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    topRightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [topRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [topRightBtn addTarget:self action:@selector(topRightBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
//    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:topRightBtn];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    
    ThreeStageSegmentView *tssView=[[ThreeStageSegmentView alloc] initWithButtonsName:@[@"综合",@"销量",@"价格",@"新品"] frame:CGRectMake(0, 0,screenSize.width, 40)];
    tssView.delegate=self;
    tssView.backgroundColor=WHITE_COLOR;
    [self.threeSegmentBtn addSubview:tssView];
    
    [self.tableView registerNib:[UINib nibWithNibName:TableCell bundle:nil] forCellReuseIdentifier:TableCell];
    
    goTop=[[UIButton alloc] initWithFrame:CGRectMake(screenSize.width-50, screenSize.height-70, 40, 40)];
    [goTop setTitle:@"\U0000D15A" forState:UIControlStateNormal];
    goTop.layer.cornerRadius=20;
    goTop.titleLabel.font=[UIFont fontWithName:@"iconfont" size:35];
    [goTop setTintColor:WHITE_COLOR];
    goTop.backgroundColor=MAIN_COLOR;
    [goTop addTarget:self action:@selector(goTop) forControlEvents:UIControlEventTouchUpInside];
    [goTop setHidden:YES];
    if (!self.filter) {
        self.filter=[FILTER new];
    }
    
    [self setup];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackKeyboard)];
    [self.tableView addGestureRecognizer:tap];
}
-(void)tapBackKeyboard{
    [self.tableView endEditing:YES];
}



-(void)searchFieldTouched
{
    SearchViewController *sc=[SearchViewController new];
    [self.navigationController pushViewController:sc animated:NO];
}
-(void)topRightBtnTapped
{
    CartViewController *cv=[[CartViewController alloc] initWithBackBtn];
    [self.navigationController pushViewController:cv animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController.view addSubview:goTop];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    lbCartBadge.text=[NSString stringWithFormat:@"%lu",(unsigned long)_datalist.count];

    [goTop removeFromSuperview];
}
-(void)goTop
{
    NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionTop];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- ThreeStageSegmentViewDelegate
- (void)threeStageSegmentView:(ThreeStageSegmentView *)segment
             didSelectAtIndex:(NSInteger)index
{

    switch (index) {
        case 1:
            self.filter.sort_field = @"sales";
            self.filter.sort_by=[self.filter.sort_by isEqualToString: @"desc"]?@"asc":@"desc";
            break;
        case 2:
            self.filter.sort_field = @"price";
            self.filter.sort_by=[self.filter.sort_by isEqualToString: @"desc"]?@"asc":@"desc";
            break;
        case 3:
            self.filter.sort_field = @"id";
            self.filter.sort_by=[self.filter.sort_by isEqualToString: @"desc"]?@"asc":@"desc";
            break;
        case 0:
        default:
            self.filter.sort_field = @"sales,id";
            self.filter.sort_by=[self.filter.sort_by isEqualToString: @"desc,desc"]?@"asc,asc":@"desc,desc";
            break;
    }
    [self loadData];
}

#pragma mark Table Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datalist.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GoodsListTableViewCell *cell = (GoodsListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableCell forIndexPath:indexPath];
    cell.goods=[self.datalist objectAtIndex:indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell bind];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
//搜索栏 页面跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailViewController *control=[[GoodsDetailViewController alloc] initWithGoods:[self.datalist objectAtIndex:indexPath.row]];
    //        control.delegate=self;
//去导航栏
    [self.navigationController pushViewController:control animated:YES];
//    [self showDetailViewController:control sender:nil];
//    [self showalphaNavigateControl:control];
    
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
    
//    OrderListTableViewCellHeader *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableCellHeader];
//    ORDER *o=[self.datalist objectAtIndex:section];
//    view.shop_item=o.shop_item;
//    view.shop_item.section=section;
//    //    headerView.delegate=self;
//    [view bind];
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    OrderListTableViewCellFooter *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableCellFooter];
//    ORDER *o=[self.datalist objectAtIndex:section];
//    view.shop_item=o.shop_item;
//    view.shop_item.section=section;
//    [view bind];
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y>0) {
        [goTop setHidden:NO];
    }
    else{
        [goTop setHidden:YES];
    }
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
