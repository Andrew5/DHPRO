//
//  CheckoutViewController.m
//  shiku
//
//  Created by txj on 15/5/14.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "CheckoutViewController.h"
#import "Checkout2TableViewCell.h"
#import "Checkout3TableViewCell.h"
#import "CartBackend.h"
#import "RegionView.h"
#import "RegionMode.h"
#import "CooperativeBackend.h"
#define TableCellFooter @"CheckoutTableViewCellFooter"
#define TableCellHeader @"CheckoutTableViewCellHeader"
#define TableCell @"CheckoutTableViewCell"
#define TableCell2 @"Checkout2TableViewCell"
#define TableCell3 @"Checkout3TableViewCell"


@interface CheckoutViewController ()<RefionViewDelegate>
{
    NSString * logisticsTager;
    NSString * area_id;
    UILabel * couponLabel;
    UILabel * logisticsLabel;
}

@property(nonatomic ,strong)CartBackend * Cart_Backend;

@property(nonatomic ,strong)CooperativeBackend * Cooperative_Backend;

@property(nonatomic ,strong)NSMutableArray * express_Arr;

@property(nonatomic ,strong)UITextField * couponTF;

@property(nonatomic ,strong)RegionView * m_RegionView;

@property(nonatomic ,strong)UIButton * logisticsButt;

@property(nonatomic ,strong)NSDictionary * couponDict;

@end

@implementation CheckoutViewController

-(instancetype)initWithExpress:(NSString *)price
{
    self=[self init];
    if (self) {
        expressprice=price;
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.Userbackend=[UserBackend shared];
    
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
}

-(void)loadData
{
    [[self.Userbackend requestAddressList:self.filter withUser:self.user]
     subscribeNext:[self didLoadData]];
}

- (void(^)(RACTuple *))didLoadData
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        RACTupleUnpack(FILTER *filter,
                       NSArray *list) = parameters;
        self.filter=filter;
       
        if (list.count>0) {
            [ec.view removeFromSuperview];
            for (int i = 0; i<[list count]; i++) {
                ADDRESS * address = [list objectAtIndex:i];
                if ([address.default_address integerValue] ==1) {
                    [self didAddressSelected:address];
                }
            }
        }
        else
        {
            ec=[EmptyViewController shared];
        }
    };
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    lastvalues=@[@"商品合计",@"优惠券",@"重量",@"运费"];
    
    self.title=@"确认订单";
    self.navigationItem.leftBarButtonItem=[self tbarBackButton];
    self.view.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    self.express_Arr = [NSMutableArray array];
    self.cart=[Cart shared];
    self.backend=[OrderBackend new];
    self.Cart_Backend = [CartBackend new];
    self.Cooperative_Backend = [CooperativeBackend new];
    self.checkoutBtn.layer.cornerRadius=5;
    self.checkoutBtn.backgroundColor=[UIColor redColor];//MAIN_COLOR;
    [self.checkoutBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
//    self.tableView.allowsSelection = NO;   
    [self.tableView registerNib:[UINib nibWithNibName:TableCell bundle:nil] forCellReuseIdentifier:TableCell];
     [self.tableView registerNib:[UINib nibWithNibName:TableCell2 bundle:nil] forCellReuseIdentifier:TableCell2];
    [self.tableView registerNib:[UINib nibWithNibName:TableCell3 bundle:nil] forCellReuseIdentifier:TableCell3];
    [self.tableView registerNib:[UINib nibWithNibName:TableCellHeader bundle:nil] forHeaderFooterViewReuseIdentifier:TableCellHeader];
    [self.tableView registerNib:[UINib nibWithNibName:TableCellFooter bundle:nil] forHeaderFooterViewReuseIdentifier:TableCellFooter];
    @weakify(self)
    [RACObserve(self.cart.total, goods_price)
     subscribeNext:^(id x) {
         @strongify(self);
         [self renderTotal];
     }];
//    [self.cart wantTotal];
    
//    [[self.Cart_Backend requestGetLogistics:[self GetNumber]]
//     subscribeNext:[self disGetLogistics]];
    [self addListener:self.emptyAddressContainer action:@selector(addressTapped)];
    [self addListener:self.addressContainer action:@selector(addressTapped)];
//    [self addListener:self.couponContainer action:@selector(couponTapped)];
    [self createRegionView];
////用户优惠身份
//    [[self.Cooperative_Backend RequestCooperativeMemberIdentity:[NSString stringWithFormat:@"%@",self.user.user_id]] subscribeNext:[self disCooperative]];
    [self Showprogress];
    [[self.Cooperative_Backend RequestCooperativegetCouponCode] subscribeNext:[self disCouponCode]];
}

////用户优惠身份
//-(void (^)(RACTuple*))disCooperative
//{
//    @weakify(self)
//    return ^(RACTuple *parameters) {
//        @strongify(self)
//        ResponseResult *rs = (ResponseResult *) parameters;
//        NSLog(@"%@",rs.data);
//    };
//}

-(void (^)(RACTuple*))disCouponCode
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        [self hideHUDView];
        NSDictionary *rs = (NSDictionary *) parameters;
        self.couponTF.text = [rs objectForKey:@"coupon_code"];
    };
}

-(NSNumber *)GetNumber
{
    SHOP_ITEM * item = [self.cart.checkout_shop_list objectAtIndex:0];
     CART_GOODS * goods =[item.cart_goods_list objectAtIndex:item.section];
    return goods.rec_id;
}

-(NSMutableArray *)Getgoods_idArr
{
    NSMutableArray * GoodsArr = [NSMutableArray array];
    for (int i = 0; i<[self.cart.checkout_shop_list count]; i++) {
        SHOP_ITEM * item = [self.cart.checkout_shop_list objectAtIndex:i];
        CART_GOODS * goods =[item.cart_goods_list objectAtIndex:item.section];
        [GoodsArr addObject:goods.rec_id];
    }
    
    return GoodsArr;
}

- (void (^)(RACTuple *))disGetLogistics
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
         ResponseResult *rs = (ResponseResult *) parameters;
        NSLog(@"%@",rs.data);
        if (rs.data) {
            self.express_Arr = [rs.data objectForKey:@"expressList"];
        }
    };
}

-(void)createRegionView
{
    self.m_RegionView = [[RegionView alloc]initWithFrame:CGRectMake(0, 0, 100, 150) cartGoods_id:[self GetNumber]];
//    self.m_RegionView.frame = CGRectMake(90, 305, 80, 150);
//    [self.m_RegionView cartGoods_id:[self GetNumber]];
    self.m_RegionView.layer.borderColor = [UIColor grayColor].CGColor;
    self.m_RegionView.layer.borderWidth = .3;
    self.m_RegionView.layer.cornerRadius = 5;
    self.m_RegionView.hidden = YES;
    self.m_RegionView.m_delegate = self;
    [self.tableView addSubview:self.m_RegionView];
}

-(void)SelecateCell:(RegionMode *)mode Tag:(NSInteger)Tag
{
    self.m_RegionView.hidden = YES;
    logisticsTager =[NSString stringWithFormat:@"%ld", (long)mode.expressType];
   
    [self.logisticsButt setTitle:mode.Name forState:UIControlStateNormal];
    [self Showprogress];
    [[self.Cart_Backend requestexpress_money:[self Getgoods_idArr] to_area_id:area_id express_type:logisticsTager] subscribeNext:[self logisticsexpress_money]];
}

//运费`
-(void (^)(RACTuple*))logisticsexpress_money
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        [self hideHUDView];
        ResponseResult * rs=(ResponseResult *)parameters;
        expressprice = [rs.data objectForKey:@"money"];
        [self renderTotal];
        [self.tableView reloadData];

    };
}

- (IBAction)callbackKeyboard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

-(void)renderTotal
{
    self.totalPrice.text=[NSString stringWithFormat:@"￥%.2f",[self.cart.total.goods_price floatValue]+[expressprice floatValue]-[couponvalue floatValue]];
}
#pragma 优惠券选择
-(void)couponTapped
{
    CouponController *control=[[CouponController alloc] initWithCheckOut:self.cart.total];
    control.delegate=self;
    [self showNavigationView:control];
}
-(void)didCouponSelected:(COLLECT_GOODS *)coupon
{
    couponname=coupon.sub_title1;
    couponvalue=coupon.shop_price;
    [self renderTotal];
    [self.tableView reloadData];
}

#pragma 地址选择
-(void)addressTapped
{
    AddressListViewController *control=[[AddressListViewController alloc] initWithCheckOut];
    control.delegate=self;
    [self showNavigationView:control];
}
#pragma AddressListControllerDelegate
-(void)didAddressSelected:(ADDRESS *)address
{
    area_id = [NSString stringWithFormat:@"%@",address.district];
    [self.emptyAddressContainer setHidden:YES];
    self.consigneeLabel.text=address.consignee;
    self.teleLabel.text=address.tel;
    self.addressLabel.text=[NSString stringWithFormat:@"%@%@%@%@,%@",address.province_name,address.city_name,address.district_name,address.address,address.zipcode];
    self.cart.address=address;
    [self.addressLabel alignTop];
}

#pragma mark Table Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cart.checkout_shop_list.count+5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section>self.cart.checkout_shop_list.count-1)
    {
        return 1;
    }
    else{
//        return favoriteList.count;
    SHOP_ITEM *gl=[self.cart.checkout_shop_list objectAtIndex:section];
    return gl.cart_goods_list.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger w = CGRectGetWidth(self.view.frame);
    UITableViewCell *ucell;
    if(indexPath.section>self.cart.checkout_shop_list.count-1)
    {
        
        if (indexPath.section==self.cart.checkout_shop_list.count) {
            
            NSString * CellName = [NSString stringWithFormat:@"CellName%ld",(long)indexPath.row];
            UITableViewCell * mc = [tableView dequeueReusableCellWithIdentifier:CellName];
            if (nil==mc) {
                mc = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellName];
            }
            if (!couponLabel) {
                couponLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 80, 30)];
                couponLabel.text = @"优惠码:";
                couponLabel.backgroundColor = [UIColor clearColor];
                couponLabel.font = [UIFont systemFontOfSize:14];
                [mc.contentView addSubview:couponLabel];
            }
            
           
            if (!self.couponTF) {
                self.couponTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 10, w - 160, 30)];
                self.couponTF.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
                self.couponTF.font = [UIFont systemFontOfSize:15.0];
                self.couponTF.textAlignment = NSTextAlignmentLeft;
                self.couponTF.backgroundColor = [UIColor clearColor];
                self.couponTF.clearButtonMode = UITextFieldViewModeNever;
                self.couponTF.borderStyle = UITextBorderStyleRoundedRect;
                self.couponTF.placeholder = @"请输入优惠码";
                self.couponTF.returnKeyType = UIReturnKeyNext;
                [mc.contentView addSubview:self.couponTF];
            }
            
            UIButton * couponButt = [UIButton buttonWithType:UIButtonTypeCustom];
            couponButt.frame = CGRectMake(w-65, 10, 60, 30);
            [couponButt setTitle:@"使用" forState:UIControlStateNormal];
            couponButt.titleLabel.font = [UIFont systemFontOfSize:12];
            [couponButt setBackgroundImage:[UIImage imageNamed:@"buttBac.png"] forState:UIControlStateNormal];
            [couponButt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [couponButt addTarget:self action:@selector(couponClick:) forControlEvents:UIControlEventTouchUpInside];
            [mc.contentView addSubview:couponButt];
            
            if (!logisticsLabel) {
                logisticsLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 80, 30)];
                logisticsLabel.text = @"物流方式:";
                logisticsLabel.backgroundColor = [UIColor clearColor];
                logisticsLabel.font = [UIFont systemFontOfSize:14];
                [mc.contentView addSubview:logisticsLabel];

            }
            
            UIImageView * img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiala.png"]];
            img.frame = CGRectMake(85, 12, 8, 8);

            if (!self.logisticsButt) {
                self.logisticsButt  = [UIButton buttonWithType:UIButtonTypeCustom];
                self.logisticsButt.frame = CGRectMake(90, 60, 100, 30);
                self.logisticsButt.titleLabel.font = [UIFont systemFontOfSize:12];
                [self.logisticsButt setTitle:@"请选择" forState:UIControlStateNormal];
                [self.logisticsButt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                self.logisticsButt.layer.borderWidth = 0.5;
                self.logisticsButt.layer.borderColor =  LIGHT.CGColor;
                self.logisticsButt.layer.cornerRadius = 3;
                self.logisticsButt.layer.masksToBounds = YES;
                [self.logisticsButt addTarget:self action:@selector(logisticsClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.logisticsButt addSubview:img];
                [mc.contentView addSubview:self.logisticsButt];
            }
           
             ucell=mc;
        }
        else
        {
            Checkout3TableViewCell *mc=(Checkout3TableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableCell3 forIndexPath:indexPath];
            if(indexPath.section==self.cart.checkout_shop_list.count+1)
            {//商品合计
                mc.nameLabel.text=@"商品合计";
                mc.valueLabel.text=[NSString stringWithFormat:@"￥%@",self.cart.total.goods_price];
            }
            else if(indexPath.section==self.cart.checkout_shop_list.count+2)
            {//优惠
                 mc.nameLabel.text=@"优惠";
                if (!couponvalue) {
                    mc.valueLabel.text=@"￥0.00";
                }
                else
                mc.valueLabel.text= [NSString stringWithFormat:@"-￥%@",couponvalue];
            }
            else if(indexPath.section==self.cart.checkout_shop_list.count+3)
            {//重量
                 mc.nameLabel.text=@"重量";
                mc.valueLabel.text=[NSString stringWithFormat:@"%@kg",self.cart.total.goods_weight];
            }
            else if(indexPath.section==self.cart.checkout_shop_list.count+4)
            {//运费
                mc.nameLabel.text=@"运费";
                if (!expressprice) {
                    mc.valueLabel.text=@"￥0.00";
                }
                else
                mc.valueLabel.text=[NSString stringWithFormat:@"￥%@",expressprice];
            }

            
            ucell=mc;
        }
    }
    else{
    
        CheckoutTableViewCell *cell = (CheckoutTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableCell forIndexPath:indexPath];
        SHOP_ITEM *item=[self.cart.checkout_shop_list objectAtIndex:indexPath.section];
        //    cell.delegate = self;
        cell.cartItem=[item.cart_goods_list objectAtIndex:indexPath.row];
        cell.cartItem.indexPath=indexPath;
        //    cell.cartItem.isInEditMode=isTableCellEdit;
        
        [cell bind];
        ucell=cell;
    }
    ucell.selectionStyle=UITableViewCellSelectionStyleNone;
    return ucell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section>self.cart.checkout_shop_list.count-1)
    {
        if (indexPath.section==self.cart.checkout_shop_list.count) {
            
            return 100;
        }
        return 40;
    }
    return 85;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==self.cart.checkout_shop_list.count) {
        return 10;
    }
    else if(section>self.cart.checkout_shop_list.count-1)
    {
        return CGFLOAT_MIN;
    }
    return 40.0;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==self.cart.checkout_shop_list.count) {
        return 10;
    }
    else if(section>self.cart.checkout_shop_list.count-1)
    {
        return CGFLOAT_MIN;
    }
    return 40.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section>self.cart.checkout_shop_list.count-1)
    {
        return nil;
    }

    CheckoutTableViewCellHeader *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableCellHeader];
    view.shop_item=[self.cart.checkout_shop_list objectAtIndex:section];
    view.shop_item.section=section;
    [view bind];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section>self.cart.checkout_shop_list.count-1)
    {
        return nil;
    }

    CheckoutTableViewCellFooter *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:TableCellFooter];
    view.shop_item=[self.cart.shop_list objectAtIndex:section];
    view.shop_item.section=section;
    [view bind];
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//优惠劵确认按钮
-(void)couponClick:(UIButton *)sender
{
    [self Showprogress];
    if (self.couponTF.text&&self.couponTF.text.length>0) {
        [[self.backend requestcouponCode:self.couponTF.text totalPrice:self.cart.total.goods_price items:[self Getgoods_idArr]] subscribeNext:[self didCouponData]];
    }
}

-(void(^)(RACTuple*))didCouponData
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        [self hideHUDView];
        ResponseResult * rs=(ResponseResult *)parameters;
        couponvalue= [rs.data objectForKey:@"youhui"];
        self.couponDict = [NSDictionary dictionaryWithDictionary:rs.data];
        [self renderTotal];
        [self.tableView reloadData];
    };


}

//物流方式
-(void)logisticsClick:(UIButton *)sender
{
    
    if (area_id&&area_id.length>0) {
        self.m_RegionView.frame = CGRectMake(90, 265, 100, 120);
        self.m_RegionView.hidden = NO;
        self.m_RegionView.m_delegate = self;
    }
    else
    {
        [self ShowHDImgView:@"请先选择收货地址"];
    
    }
}

//结算按钮
- (IBAction)checkoutBtnTapped:(id)sender {
    
    if (self.cart.address&&logisticsTager) {
        [[self.backend requestAddOrder:self.cart express_type:logisticsTager quanData:self.couponDict to_area_id:area_id]
         subscribeNext:[self didUpdate]];;
        return;
    }
    if (!self.cart.address) {
        [self.view showHUD:@"请选择收货地址" afterDelay:0.5];
        return;
    }
    if (!logisticsTager) {
        [self.view showHUD:@"请选择物流方式" afterDelay:0.5];
    }
    

    return;
   //
   
}
- (void(^)(RACTuple *))didUpdate
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        ORDER *p=(ORDER *)parameters;
        PaymentViewController *ch=[[PaymentViewController alloc] initWithOrder:p];
        [self showNavigationView:ch];
    };
}

-(void)goBack
{
    [self.cart.select_shop_list removeAllObjects];
    [self.cart.checkout_shop_list removeAllObjects];
    [super goBack];
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
