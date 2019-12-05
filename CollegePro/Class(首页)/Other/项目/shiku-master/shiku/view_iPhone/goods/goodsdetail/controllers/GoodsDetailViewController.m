#import "GoodsDetailViewController.h"
#import "SearchViewController.h"
#import "CartViewController.h"
#import "AppDelegate.h"
#import "HomeViewControllernew.h"
#define SECTION_CELL_0 @"GoodsDetailSection0CollectionViewCell"
#define SECTION_CELL_1 @"GoodsDetailSection1CollectionViewCell"
#define SECTION_CELL_2 @"GoodsDetailSection2CollectionViewCell"
#define DETAIL_ROW_CELL @"GoodsDetailMore1CollectionViewCell"
#define DETAIL_IMAGE_CELL @"GoodsDetailMore2CollectionViewCell"

#define SECTION_CELL_1_HEIGHT 120
#define SECTION_CELL_2_HEIGHT 60

#define SECTION_SHARE_HEIGHT 40
#define SECTION_SHARE_CELL @"GoodsDetailShareViewCell"

@interface GoodsDetailViewController () {
    NSArray *currDetailInfo;
}
@property(nonatomic, strong) GoodsDetailMenuViewController *menu;
@end

@implementation GoodsDetailViewController
- (void)shareGoods {
//    [self showSharedView:self.goods goodsID:nil couponCode:nil];
    [self showSharedView:self.goods goodsID:nil couponCode:nil goodstitle:nil goodsinfor:nil imgUrl:nil shareUrl:nil];

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backend = [GoodsBackend new];
        self.cartBackend = [CartBackend new];
        self.userBackend = [UserBackend shared];
    }
    return self;
}

- (instancetype)initWithGoods:(COLLECT_GOODS *)anGoods {
    self = [self init];
    self.goods_id = anGoods.goods_id;
    return self;
}
-(void)searchFieldTouched{
    SearchViewController *sc=[SearchViewController new];
    
    [self showViewController:sc sender:nil];
}
#pragma mark 去购物车
-(void)car_goods{
    if (_FromCartVC) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    CartViewController *uc = [CartViewController new];
    uc.fromVCState = FROM_GOODSVC;
    [self.navigationController pushViewController:uc animated:YES];
}

-(void)tbarCallback{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    App *app = [App shared];
    @weakify(self)
    [RACObserve(app, currentUser) subscribeNext:^(USER *user) {
        @strongify(self);
        self.user = user;

    }];
    self.user = [app currentUser];

    self.view.backgroundColor = BG_COLOR;
    section2icons = GOODS_DETAIL_TAB_ICONS;
    section2titles = GOODS_DETAIL_TAB_ICONS_TITLE;
    sectionCells = @[SECTION_CELL_0, SECTION_CELL_1, SECTION_CELL_2, SECTION_SHARE_CELL, DETAIL_ROW_CELL, DETAIL_IMAGE_CELL];

    double offsetWidth = (NSInteger) self.navigationController.view.frame.size.width % 4;
    CGFloat pointX = offsetWidth == 0 ? 0 : (4 - offsetWidth) / 2;
    collectionViewFrame = CGRectMake(-pointX, 0, self.navigationController.view.frame.size.width + pointX * 2,[UIScreen mainScreen].bounds.size.height);//self.navigationController.view.frame.size.height - 118
   
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)
                                             collectionViewLayout:[UICollectionViewFlowLayout new]];

    self.collectionView.backgroundColor = BG_COLOR;
    [self.view addSubview:self.collectionView];

//加入购车
    int barHeight = 60;
    int btnHeight = 34;
    int marginH = 10;
//    int btnWidth = (int) (self.navigationController.view.frame.size.width / 4 - marginH * 1.5);
//加入购车者界面
    //self.navigationController.view.frame.size.height
    bottomBarContainer = [[UIView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-barHeight , self.navigationController.view.frame.size.width, barHeight)];
    bottomBarContainer.backgroundColor = WHITE_COLOR;
    [self.view addSubview:bottomBarContainer];
    
//加入购车者分界线
    UIView *bottomBarTopLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, 1)];
    bottomBarTopLine.backgroundColor = RGBCOLORV(0xd2d2d2);
    [bottomBarContainer addSubview:bottomBarTopLine];
//农场 加入喜欢 加入购物车 结算
    UIButton *farmerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    farmerBtn.frame = CGRectMake(marginH, (barHeight - btnHeight) / 2, btnHeight, btnHeight);
    [farmerBtn setImage:[UIImage imageNamed:@"ic_select_dian_pu"] forState:(UIControlStateNormal)];
     farmerBtn.imageEdgeInsets = UIEdgeInsetsMake(0,5,12,5);
    [farmerBtn setTitle:@"农场" forState:UIControlStateNormal];
    farmerBtn.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
    [farmerBtn setTitleColor:[UIColor colorWithRed:0.408 green:0.553 blue:0.290 alpha:1.000] forState:UIControlStateNormal];
    farmerBtn.titleEdgeInsets = UIEdgeInsetsMake(30, -50, 3, 2);
    farmerBtn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [farmerBtn addTarget:self action:@selector(addfarmerMethod) forControlEvents:UIControlEventTouchUpInside];
    [bottomBarContainer addSubview:farmerBtn];

    
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    likeBtn.frame = CGRectMake(farmerBtn.frame.origin.x+farmerBtn.frame.size.width+12, (barHeight - btnHeight) / 2, btnHeight+6, btnHeight);
    [likeBtn setImage:[UIImage imageNamed:@"ic_like_goods"] forState:(UIControlStateNormal)];
    likeBtn.imageEdgeInsets = UIEdgeInsetsMake(0,8,12,7);
    [likeBtn setTitle:@"加入喜欢" forState:UIControlStateNormal];
    likeBtn.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
    [likeBtn setTitleColor:[UIColor colorWithRed:0.898 green:0.341 blue:0.098 alpha:1.000] forState:UIControlStateNormal];
    likeBtn.titleEdgeInsets = UIEdgeInsetsMake(28, -60, 0, -6);
    likeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [likeBtn addTarget:self action:@selector(addlikeMethod) forControlEvents:UIControlEventTouchUpInside];
    [bottomBarContainer addSubview:likeBtn];

    float widthW =btnHeight+farmerBtn.frame.origin.x+farmerBtn.frame.size.width+btnHeight;
    
    UIButton *addToCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addToCartBtn.frame = CGRectMake(widthW, (barHeight - btnHeight) / 2, (self.navigationController.view.frame.size.width-widthW)/2, btnHeight);
    addToCartBtn.layer.cornerRadius = 6;
    addToCartBtn.backgroundColor = RGBCOLORV(0xf19001);
    [addToCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addToCartBtn addTarget:self action:@selector(addToCartBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [bottomBarContainer addSubview:addToCartBtn];

    
    UIButton *directBuyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    directBuyBtn.frame = CGRectMake(10+widthW+addToCartBtn.frame.size.width, (barHeight - btnHeight) / 2, (self.navigationController.view.frame.size.width-widthW)/2-13, btnHeight);
    directBuyBtn.layer.cornerRadius = 6;
    directBuyBtn.backgroundColor = RGBCOLORV(0xeb6100);
    [directBuyBtn setTitle:@"结算" forState:UIControlStateNormal];
    [directBuyBtn addTarget:self action:@selector(addToCartBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [bottomBarContainer addSubview:directBuyBtn];


    for (NSString *str in sectionCells) {
        [self.collectionView registerNib:[UINib nibWithNibName:str bundle:nil]
              forCellWithReuseIdentifier:str];
    }
    [self Showprogress];
    [RACObserve(self, goods_id) subscribeNext:^(id goods_id) {
        @strongify(self);
        [[self.backend requestGoodsWithId:goods_id]
                subscribeNext:[self didLoadGoods]];
    }];
    
    [[self.backend requestGoodsDetailsWithId:_goods_id]
            subscribeNext:^(RACTuple *parameters) {
                @strongify(self)
                self.goods_detail_info = (GOODS_DETAIL_INFO *) parameters;
                
                currDetailInfo = self.goods_detail_info.item_info;
                
                [self.collectionView setDataSource:self];
                [self.collectionView setDelegate:self];
                [self.collectionView reloadData];
            }];
    
    
    
    anbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    anbtn.frame =CGRectMake([UIScreen mainScreen].bounds.size.width-75,[UIScreen mainScreen].bounds.size.height-200,40,40);
    [anbtn setTitle:@"\U0000D15A" forState:UIControlStateNormal];
    anbtn.layer.cornerRadius=20;
    anbtn.titleLabel.font=[UIFont fontWithName:@"iconfont" size:35];
    [anbtn setTintColor:WHITE_COLOR];
    anbtn.backgroundColor=MAIN_COLOR;
    anbtn.layer.masksToBounds =YES;
    [anbtn addTarget:self action:@selector(btnclickAnbtn:) forControlEvents:UIControlEventTouchUpInside];
    anbtn.hidden=YES;
    [self.view addSubview:anbtn];
    
    //返回按钮  进入购物车按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 8, 70, 70);
    [leftBtn addTarget:self action:@selector(callbackVC) forControlEvents:(UIControlEventTouchUpInside)];
    [leftBtn setImage:[UIImage imageNamed:@"iii_back"] forState:UIControlStateNormal];
    [self.view addSubview:leftBtn];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(screenSize.width-67, 10, 70, 70);
    [rightBtn addTarget:self action:@selector(car_goods) forControlEvents:(UIControlEventTouchUpInside)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"ic_cart_add"] forState:(UIControlStateNormal)];
    [self.view addSubview:rightBtn];
    //添加角标控件
    lbCartBadge = [UILabel new];
    lbCartBadge.layer.cornerRadius=10;
    lbCartBadge.layer.masksToBounds =YES;
    [lbCartBadge setNumberOfLines:0];
    lbCartBadge.lineBreakMode = NSLineBreakByWordWrapping;
    lbCartBadge.font=FONT_SMALL;
    lbCartBadge.textAlignment=NSTextAlignmentCenter;
    lbCartBadge.textColor=WHITE_COLOR;
    lbCartBadge.backgroundColor=MAIN_COLOR2;
    [rightBtn addSubview:lbCartBadge];
    [lbCartBadge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightBtn).offset(-12);
        make.top.equalTo(rightBtn).offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];    
}
//去农场
-(void)addfarmerMethod{

    if(_fromHomeNew)
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    HomeViewControllernew *new = [[HomeViewControllernew alloc]init];
    new.midStr = self.goods.shop_id;
    [self.navigationController pushViewController:new animated:YES];
    
}
-(void)addlikeMethod{
    if (!_user.authorized) {
      UserLoginViewController *uc= [UserLoginViewController new];
        [self showNavigationView:uc];
        return;
    }
//    [[self.backend requestAddItemToLikeList:self.goods_name andGoodsId:[NSString stringWithFormat:@"%ld",self.goods_number] subscribeNext:[self didUpdate:@"添加成功"]];
    [self Showprogress];
    [[self.cartBackend requestAddItemToLikeList:_goods.goods_name andGoodsId:[NSString stringWithFormat:@"%d",[self.goods_id intValue]] andGoodsNum:[_goods.goods_number intValue] WithUser:_user ]subscribeNext:
        [self didUpdate:@"添加成功"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UDNavigationController *navi = (UDNavigationController*)self.navigationController;
    navi.alphaView.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate.viewController setTabBarHidden:YES animated:YES];
    if ([Cart shared].Num == 0) {
        lbCartBadge.hidden = YES;
    }
    else{
        lbCartBadge.hidden = NO;

        lbCartBadge.text = [NSString stringWithFormat:@"%ld",(long)[Cart shared].Num];

    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UDNavigationController *navi = (UDNavigationController*)self.navigationController;
    navi.alphaView.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appdelegate.viewController setTabBarHidden:NO animated:YES];
//    _FromCartVC = NO;

}

-(void)callbackVC{
    [self.navigationController popViewControllerAnimated:YES];
//    [self popoverPresentationController];
}
- (void)btnclickAnbtn:(UIButton *)sender{
    _collectionView.contentOffset = CGPointMake(0, 0);
}
- (void (^)(RACTuple *))didLoadGoods {
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)

        self.goods = (GOODS *) parameters;
        [self.collectionView setDataSource:self];
        [self.collectionView setDelegate:self];
        [self.collectionView reloadData];
        [self hideHUDView];
    };
}

#pragma mark 加购物车
- (void)addToCartBtnTapped {
    if (![self.user authorized]) {
        
        UserLoginViewController *c = [UserLoginViewController new];
        c.delegate = self;
        [self showNavigationView:c];
    }
    else {

        [bottomBarContainer setHidden:YES];

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        if (!_menu) {
            _menu = [[GoodsDetailMenuViewController alloc] initWithGoods:self.goods];
            self.menu.delegate = self;
        }
        [[self menu] showInView:[self view]];
        
    }
}

- (void)authencateUserSuccess:(USER *)user authController:(UserLoginViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma PopMenuViewControllerDelegate

- (void)hideFinished {
    [bottomBarContainer setHidden:NO];
}

- (void)didAddToCartSuccessWithGoodsNum:(NSInteger)num {
    
    [self.view showHUD:@"添加成功" afterDelay:1];
    [Cart AddNumWithGoodsNum:num];
    [Cart saveCartNum];
    [self.collectionView reloadData];
    if ([Cart shared].Num == 0) {
        lbCartBadge.hidden = YES;
    }
    else{
        lbCartBadge.hidden = NO;
        lbCartBadge.text = [NSString stringWithFormat:@"%ld",(long)[Cart shared].Num];
        
    }
//    lbCartBadge.text=[NSString stringWithFormat:@"%ld",(long)[Cart shared].Num];
}

#pragma mark -- UICollectionViewDataSource
//2  6
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 3) {
        return 4;
    }
    else if (section > 4) {
        CATEGORY *a = currDetailInfo[section - 4];
        if (!a.children) {
            return 1;
        }
        return a.children.count;
    }
    return 1;
}
//1  5
//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return  currDetailInfo.count;
}
//4
//每个UICollectionView展示的内容s
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *cell;
//banner图片
    if (indexPath.section == 0) {
        GoodsDetailSection0CollectionViewCell *_cell = [collectionView
                dequeueReusableCellWithReuseIdentifier:SECTION_CELL_0
                                          forIndexPath:indexPath];
        NSLog(@"%@",self.goods);
        _cell.goods = self.goods;
        [_cell bind];
        cell = _cell;
    }
    else if (indexPath.section == 1) {// 评分 销售 分享
        GoodsDetailShareViewCell *_cell = [collectionView
                dequeueReusableCellWithReuseIdentifier:SECTION_SHARE_CELL
                                          forIndexPath:indexPath];
        
        _cell.goods = self.goods;
        _cell.delegate = self;
        [_cell bind];
        cell = _cell;
    }
    else if (indexPath.section == 2) {//标题价钱
        GoodsDetailSection1CollectionViewCell *_cell = [collectionView
                dequeueReusableCellWithReuseIdentifier:SECTION_CELL_1
                                          forIndexPath:indexPath];
        _cell.goods = self.goods;
        _cell.delegate = self;
        [_cell bind];
        cell = _cell;
    }
    else if (indexPath.section == 3) {//产品信息 生产过程 产地 评价
        GoodsDetailSection2CollectionViewCell *_cell = [collectionView
                dequeueReusableCellWithReuseIdentifier:SECTION_CELL_2
                                          forIndexPath:indexPath];
        [_cell.coverImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _cell.coverImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _cell.coverImage.contentMode = UIViewContentModeScaleAspectFill;
        _cell.coverImage.clipsToBounds = YES;
        [_cell.coverImage setBackgroundImage:[UIImage imageNamed:section2icons[indexPath.row]] forState:UIControlStateNormal];
        _cell.nameLabel.text = section2titles[(NSUInteger) indexPath.row];
        _cell.nameLabel.textColor = RGBCOLORV(0x999999);
        cell = _cell;
    } else {
        //4:商品名称  类目 品种 周期 规模 时间 柏志奇 品牌 方式 认证 口感 直径 色泽 外观17
        CATEGORY *c = currDetailInfo[indexPath.section - 4];
        if (!c.children) {
            GoodsDetailMore1CollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:DETAIL_ROW_CELL forIndexPath:indexPath];
            _cell.textLabel1.text = c.name;
            _cell.textLabel2.text = c.value;
            [_cell.coverImageView setHidden:YES];

//            if ([c.value isKindOfClass:[NSString class]]) {
//                _cell.textLabel2.text = c.value;
//            }
//            else {
//                _cell.textLabel2.text = @"无";
//            }
            cell = _cell;
        }
        else {
            //当section为18的时候 加载图片的row
            GoodsDetailMore2CollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:DETAIL_IMAGE_CELL forIndexPath:indexPath];
            
            CATEGORY *cl = c.children[indexPath.row];
            [_cell.coverImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
            _cell.coverImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            _cell.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
            _cell.coverImageView.clipsToBounds = YES;
            [_cell.coverImageView sd_setImageWithURL:url(cl.img.small) placeholderImage:img_placehold_long];
            cell = _cell;
        }
    }
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//3  7
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
//banner图片展示
    if (indexPath.section == 0) {
        size = CGSizeMake(self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height / 5*2);
    } else if (indexPath.section == 1) {
        size = CGSizeMake(self.navigationController.view.frame.size.width, SECTION_SHARE_HEIGHT);
    } else if (indexPath.section == 2) {
        GoodsDetailSection1CollectionViewCell * cell = (GoodsDetailSection1CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        UICo=ectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        
        [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        size = CGSizeMake(self.navigationController.view.frame.size.width, cell.frame.size.height+85);

    } else if (indexPath.section == 3) {
        size = CGSizeMake(CGRectGetWidth(collectionView.bounds) / 4, SECTION_CELL_2_HEIGHT);
    } else {
        CATEGORY *c = currDetailInfo[indexPath.section - 4];
        if (c.children) {
            size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width / 2);
        } else {
            size = CGSizeMake(CGRectGetWidth(collectionView.bounds), 40);
        }
    }
    return size;
}
//10
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;

}
//9
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

    return 0;
}
//8 11
//定义section间 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets ei;
    if (section == 2) {
        ei = UIEdgeInsetsMake(0, 0, 5, 0);
    }
    else if (section == 4) {
        ei = UIEdgeInsetsMake(5, 0, 0, 0);
    }
    else {
        ei = UIEdgeInsetsZero;
    }

    return ei;
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {


    if (indexPath.section == 3) {
        GoodsDetailMoreViewController *wc = [
                [GoodsDetailMoreViewController alloc]
                initWithGoods:self.goods
                  andTabIndex:indexPath.row];
        [self showNavigationViewMainColor:wc];
    }
}

//返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1||indexPath.section == 2) {
        return NO;
    }
    return YES;
}

- (void (^)(RACTuple *))didUpdate:(NSString *)text {
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        ResponseResult *rs = (ResponseResult *) parameters;
        if (rs.success) {

            [self.view showHUD:text afterDelay:2];

        }
        else {

            [self.view showHUD:rs.messge afterDelay:2];
        }
        [[self.backend requestGoodsWithId:self.goods_id]
                subscribeNext:[self didLoadGoods]];

    };
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_collectionView.contentOffset.y > [UIScreen mainScreen].bounds.size.height/2) {
        anbtn.hidden = NO;
    }else{
        anbtn.hidden = YES;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    float offY = scrollView.contentOffset.y;

    float contentHeight = scrollView.contentSize.height;

    float boundsHeight = scrollView.bounds.size.height;

    int d = contentHeight - boundsHeight > 0 ? (contentHeight - boundsHeight) : 0;

    if (offY >= d + 50) {

        GoodsDetailMoreViewController *wc = [[GoodsDetailMoreViewController alloc] initWithGoods:self.goods andTabIndex:0];
        [self showNavigationViewMainColor:wc];
    }
}
- (void)dealloc
{
    
}
@end
