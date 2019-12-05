//
//  OrderDetailViewController.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "ViewLogisticsViewController.h"

#define TableCellButtomBarFooter @"OrderButtomBarTableViewCellFooter"
#define TableCellFooter @"OrderDetailTableViewCellFooter"
#define TableCellHeader @"OrderDetailTableViewCellHeader"
#define TableCell @"OrderListTableViewCell"
#define TableCellSection0 @"ViewLogisticsTableViewCell"
#define TableCellSeciton1 @"AddressTableViewCell"
#define TableCellSection2 @"OrderDetailSection2TableViewCell"
#define TableCellSection4 @"OrderDetailSection4TableViewCell"
#define TableCellSection5 @"ViewLogisticsWebviewTableViewCell"

@interface ViewLogisticsViewController ()

@end

@implementation ViewLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"物流信息";
    self.navigationItem.leftBarButtonItem=[self tbarBackButton];
    self.view.backgroundColor=BG_COLOR;
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView registerNib:[UINib nibWithNibName:TableCellSection0 bundle:nil] forCellReuseIdentifier:TableCellSection0];
    [self.tableView registerNib:[UINib nibWithNibName:TableCellSeciton1 bundle:nil] forCellReuseIdentifier:TableCellSeciton1];
    [self.tableView registerNib:[UINib nibWithNibName:TableCellSection2 bundle:nil] forCellReuseIdentifier:TableCellSection2];
    [self.tableView registerNib:[UINib nibWithNibName:TableCellSection4 bundle:nil] forCellReuseIdentifier:TableCellSection4];
    [self.tableView registerNib:[UINib nibWithNibName:TableCellSection5 bundle:nil] forCellReuseIdentifier:TableCellSection5];
    [self.tableView registerNib:[UINib nibWithNibName:TableCell bundle:nil] forCellReuseIdentifier:TableCell];
    [self.tableView registerNib:[UINib nibWithNibName:TableCellHeader bundle:nil] forHeaderFooterViewReuseIdentifier:TableCellHeader];
    [self.tableView registerNib:[UINib nibWithNibName:TableCellFooter bundle:nil] forHeaderFooterViewReuseIdentifier:TableCellFooter];
    [self.tableView registerNib:[UINib nibWithNibName:TableCellButtomBarFooter bundle:nil] forHeaderFooterViewReuseIdentifier:TableCellButtomBarFooter];
}
-(instancetype)initWithOrder:(ORDER *)anOrder
{
    self=[super init];
    if (self) {
        self.order=anOrder;
        self.backend=[OrderBackend new];
    }
    return self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Table Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==1) {
        return self.order.shop_item.cart_goods_list.count;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *_cell;
    if (indexPath.section==0) {
        ViewLogisticsTableViewCell *cell = (ViewLogisticsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableCellSection0 forIndexPath:indexPath];
        cell.order=self.order;
//      cell.delegate = self;
        [cell bind];
        _cell=cell;
 
    }
//    else if(indexPath.section==1)
//    {
//        AddressTableViewCell *cell = (AddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableCellSeciton1 forIndexPath:indexPath];
//        cell.address=self.order.address_item;
//        cell.coverImage.image=[UIImage imageNamed:@"icon2_03.png"];
////        cell.delegate = self;
//        [cell bind];
//        _cell=cell;
//
//    }
//    else if(indexPath.section==2)
//    {
//        OrderDetailSection2TableViewCell *cell = (OrderDetailSection2TableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableCellSection2 forIndexPath:indexPath];
//        cell.order=self.order;
//        //
//        //        //    cell.delegate = self;
//        //
//        [cell bind];
//        _cell=cell;
//
//    }
    else if(indexPath.section==1)
    {
        OrderListTableViewCell *cell = (OrderListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableCell forIndexPath:indexPath];
        SHOP_ITEM *item=self.order.shop_item;
        //    cell.delegate = self;
        cell.cartItem=[item.cart_goods_list objectAtIndex:indexPath.row];
        cell.cartItem.indexPath=indexPath;
        //    cell.cartItem.isInEditMode=isTableCellEdit;
        
        [cell bind];
        _cell=cell;
    }
    else if(indexPath.section==2)
    {
        
        ViewLogisticsWebviewTableViewCell *cell = (ViewLogisticsWebviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableCellSection5 forIndexPath:indexPath];
        NSURL *url =[NSURL URLWithString:@"http://api.shiku.com/wap/public/getmap.html?lon=116.417854&lat=39.921988"];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [cell.webView loadRequest:request];
        _cell=cell;
//        OrderDetailSection4TableViewCell *cell = (OrderDetailSection4TableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableCellSection4 forIndexPath:indexPath];
//        //        cell.address=[self.address_list objectAtIndex:indexPath.row];
//        //
//        //        //    cell.delegate = self;
//        //
//        cell.order=self.order;
//        [cell bind];
//        _cell=cell;
    }
    _cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return _cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==2) {
        return 345;
    }
    return 75;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    FavTableViewCell *cell=(FavTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    //    ProductDetailViewV2Controller *control=[[ProductDetailViewV2Controller alloc] initWithProductID:cell.product.productID user:[[App shared] currentUser]];
    //    control.delegate=self;
    //
    //    [self showNavigationView:control];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 40.0;
    }
    else if(section==2)
    {
        return 10;
    }
    else if (section==0)
    {
        return 1;
    }
    
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==1) {
        return 40.0;
    }
    else if (section==0)
    {
        return 10;
    }
//    else if(section==2)
//    {
//        return 40;
//    }
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        OrderDetailTableViewCellHeader *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableCellHeader];
        view.shop_item=self.order.shop_item;
        view.shop_item.section=section;
//      headerView.delegate=self;
        [view bind];
        return view;

    }
    else if (section==0)
    {
        UIView *view=[UIView new];
        view.backgroundColor=BG_COLOR;
        return view;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==1) {
        OrderDetailTableViewCellFooter *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableCellFooter];
        view.shop_item=self.order.shop_item;
        view.shop_item.section=section;
        [view bind];
        return view;
    }
    else if (section==0)
    {
        UIView *view=[UIView new];
        view.backgroundColor=BG_COLOR;
        return view;
    }
//    else if (section==2) {
//        OrderButtomBarTableViewCellFooter *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableCellButtomBarFooter];
//        view.order=self.order;
//        view.delegate=self;
//        [view bind];
//        return view;
//    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
#pragma OrderListTableViewCellFooterDelegate
- (void)didQFKTaped:(ORDER *)anOrder
{
}
//物流信息   修改之后的
- (void)didCKWLTaped:(ORDER *)anOrder
{
//    WebHtmlViewController *wc=[[WebHtmlViewController alloc] initWithTitle:@"物流信息" withUrl:url_ckwl popController:NO];
//    [self showNavigationView:wc];
    
}
- (void)didTXFHTaped:(ORDER *)anOrder
{
}
- (void)didQRSHTaped:(ORDER *)anOrder
{
    [[self.backend requestConfirmOrder:anOrder]
     subscribeNext:[self didUpdate:@"确认收货成功"]];
}
- (void(^)(RACTuple *))didUpdate:(NSString *)text
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        ResponseResult *rs=(ResponseResult *)parameters;
        if (rs.success) {
            [self.view showHUD:text afterDelay:2];
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
