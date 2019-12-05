#import "UserViewController.h"
#import "UserViewCL1CollectionViewCell.h"
#import "UserViewCL2CollectionViewCell.h"
#import "UserViewCL3CollectionViewCell.h"
#import "UserEditViewController.h"
#import "CategoryViewController.h"
#import "InformationController.h"
#import "CouponController.h"
#import "CoopViewController.h"
#import "AddressListViewController.h"
//配置列表
#import "LogisticsViewController.h"//物流
#import "IntegrationController.h"//积分
#import "mymoneyViewController.h"//钱包
#import "MyfarmViewController.h"//农场
#import "ApplyRefundViewController.h"//电话
#import "OrderManager.h"

@interface UserViewController ()<OrderDelegate>
@property (nonatomic,strong)NSString* president;

@end

#define CollectionView1Cell @"UserViewCL1CollectionViewCell"
#define CollectionView2Cell @"UserViewCL2CollectionViewCell"
#define CollectionView3Cell @"UserViewCL3CollectionViewCell"

@implementation UserViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self VerfyLogin];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    ISLoadedUserInfo = NO;
}
- (void (^)(USER *))didGetUserInfoSuccess {
   
    return ^(USER *user) {
         [self hideHUDView];
         self.user = user;
        self.user.token = [[[App shared] currentUser] token];
        if (!user.user_id) {
            [self.collectionView2 reloadData];
            [self.emptyUserContainer setHidden:NO];
            self.headerImageView.image = [UIImage imageNamed:@"nopic.jpg"];
        } else {
            if (self.user.authorized) {
                [self.emptyUserContainer setHidden:YES];
                [self setUserInfo:user];
            }
            else {
                [self.emptyUserContainer setHidden:NO];
            }


        }
    };
}
-(void)updateIcon:(NSNotification *)notification{
    USER *ob = notification.object;
   NSLog(@"%@--头像，，%@--名字",ob.avatarimg,ob.name);
    
    _usernameLabel.text = ob.name;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:ob.avatarimg]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    self.backend = [UserBackend new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateIcon:) name:@"updateSuyccessful" object:nil];

    section1icons = @[@"积分数量", @"优惠券", @"收藏"];
    section1titles = @[@"积分数量", @"优惠券", @"收藏"];
    
    section2icons = @[@"icon_fukuan", @"icon_fahuo", @"icon_shouhuo", @"icon_tuikuan"];
//    section2titles = @[@"待付款", @"待发货", @"待收货"];
    section2titles = @[@"待付款", @"待发货", @"待收货",@"退款"];
    section2values = @[@"0", @"0", @"0",@"0"];
    
    section3icons = @[@"icon_order", @"icon_cooperative", @"icon_logistics", @"icon_farm", @"icon_address", @"icon_mylike", @"icon_money", @"icon_seeting", @"icon_standNo"];
    section3titles = @[@"我的订单", @"合作社", @"物流", @"我的农场",@"收货地址", @"我的喜欢",@"我的钱包",@"其他设置",@"我的积分"];

    screenSize = self.view.frame.size;
    
    self.vbackgroundheader.backgroundColor = RGBCOLORV(0X7A9C5C);//[UIColor colorWithRed:0.404 green:0.557 blue:0.294 alpha:1.000];//MAIN_COLOR;
    self.vbackgroundheader.hidden = YES;
    self.usernameLabel.textColor = WHITE_COLOR;
    [self.userLevelLabel setHidden:YES];


    self.headerImageView.layer.borderColor = [UIColor colorWithRed:0.931 green:0.915 blue:0.951 alpha:1.000].CGColor;
    self.headerImageView.layer.borderWidth = 2;
    self.headerImageView.layer.cornerRadius = 45;
    [self.headerImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.headerImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.emptyUserContainer.backgroundColor = RGBCOLORV(0x7a9c5c);//MAIN_COLOR;
    [self addListener:self.vbackgroundheader action:@selector(userEditor)];

#pragma mark - CollectionView
    self.headerUserDescCollectionview.backgroundColor = WHITE_COLOR;
    [self.headerUserDescCollectionview setDataSource:self];
    [self.headerUserDescCollectionview setDelegate:self];

    self.collectionView2.backgroundColor = WHITE_COLOR;
    [self.collectionView2 setDataSource:self];
    [self.collectionView2 setDelegate:self];
    self.collectionView2.hidden = YES;
    self.collectionView3.backgroundColor = WHITE_COLOR;
//    self.collectionView3.layer.borderColor = [UIColor redColor].CGColor;
//    self.collectionView3.layer.borderWidth = 0.3;
    [self.collectionView3 setDataSource:self];
    [self.collectionView3 setDelegate:self];

    [self.headerUserDescCollectionview registerNib:[UINib nibWithNibName:CollectionView1Cell bundle:nil] forCellWithReuseIdentifier:CollectionView1Cell];

    [self.collectionView2 registerNib:[UINib nibWithNibName:CollectionView2Cell bundle:nil] forCellWithReuseIdentifier:CollectionView2Cell];

    [self.collectionView3 registerNib:[UINib nibWithNibName:CollectionView3Cell bundle:nil] forCellWithReuseIdentifier:CollectionView3Cell];
    [self addListener:self.emptyUserContainer action:@selector(showLoginView)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ExitLog) name:@"Exit" object:nil];
//    [self VerfyLogin];

}
- (void)VerfyLogin
{
    self.user = [[App shared] currentUser];
//    NSLog(@"%@",self.user);
     [self Showprogress];
    [[self.backend requestUser:nil]
     subscribeNext:[self didGetUserInfoSuccess]];
    ISLoadedUserInfo = YES;
    [self.headerUserDescCollectionview reloadData];
    [self.collectionView2 reloadData];

}
//获取关注优惠和喜欢的数量
- (void)likeandAttentionandprivilege:(USER *)user
{
    
    self.labelAttention.text = user.attentionNum;
    self.labelLike.text = user.likeNum;
}
- (void)ExitLog
{
    self.user = [[App shared] currentUser];
    [self Showprogress];
    [[self.backend requestUser:nil]
     subscribeNext:[self didGetUserInfoSuccess]];
    [self.headerUserDescCollectionview reloadData];
    [self.collectionView2 reloadData];
}

- (void)userEditor {
    ISLoadedUserInfo = NO;
    UserEditViewController *uec = [UserEditViewController new];
    [self showNavigationView:uec];
}

- (void)searchFieldTouched {
    SearchViewController *sc = [SearchViewController new];
    [self showNavigationViewMainColor:sc];
}

- (void)showLoginView {
    UserLoginViewController *c = [UserLoginViewController new];
    c.delegate = self;
    [self showNavigationView:c];
}

- (void)authencateUserSuccess:(USER *)user authController:(UserLoginViewController *)controller {
    [self.emptyUserContainer setHidden:YES];
    [[App shared] setCurrentUser:user];
    [self Showprogress];
    [[self.backend requestUser:(AccessToken*)user.token]
            subscribeNext:[self didGetUserInfoSuccess]];
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUserInfo:(USER *)user {
    NSString *url = [Helper checkImgType:user.avatarimg];
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"成功");
        if (error) {
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:url]];
        }
    }];
    [self.headerImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.headerImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.clipsToBounds = YES;

    self.usernameLabel.text = user.name;
    if (!user.rank_level) {
        self.userLevelLabel.text = @"V0";
    }
    else {
        self.userLevelLabel.text = [NSString stringWithFormat:@"V%@", user.rank_level];
    }
    [self likeandAttentionandprivilege:user];
    [self.headerUserDescCollectionview reloadData];
    [self.collectionView2 reloadData];
}

#pragma mark - TopBar

- (void)leftBarButtonItemTouched {
    CategoryViewController *cc = [[CategoryViewController alloc] initWithBackBtn];
    [self showNavigationViewMainColor:cc];
}

- (void)rightBarButtonItemTouched {
    InformationController *ifc = [InformationController new];
    [self showNavigationView:ifc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == _headerUserDescCollectionview)//
        return section2icons.count;
    else if (collectionView == _collectionView3){
        return section3icons.count;
    }
    return 4;
}

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *cell;


    if (collectionView == self.headerUserDescCollectionview) {
        UserViewCL1CollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionView1Cell forIndexPath:indexPath];

        _cell.image1.image = [UIImage imageNamed:section2icons[indexPath.row]];//section2icons[indexPath.row];
        _cell.label2.text = section2titles[indexPath.row];
        
        _cell.label1.hidden = YES;
        
        //待付款 待发货 待收货 退款
        if (indexPath.row == 0) {
            NSInteger num =[self.user.order_fukuan integerValue];
            if (num>0) {
                _cell.label1.hidden = NO;
                num = num>99?99:num;
                _cell.label1.text = [NSString stringWithFormat:@"%ld",(long)num];
            }
        }
        else if (indexPath.row == 1) {
            NSInteger num =[self.user.order_fahuo integerValue];
            if (num>0) {
                _cell.label1.hidden = NO;
                num = num>99?99:num;
                _cell.label1.text = [NSString stringWithFormat:@"%ld",(long)num];            }
           
        }
        else if (indexPath.row == 2) {
            NSInteger num =[self.user.order_shouhuo integerValue];
            if (num>0) {
                _cell.label1.hidden = NO;
                num = num>99?99:num;
                _cell.label1.text = [NSString stringWithFormat:@"%ld",(long)num];            }
          
        }else if (indexPath.row == 3) {
            NSInteger num =[self.user.order_tuikuan integerValue];
            if (num>0) {
                _cell.label1.hidden = NO;
                num = num>99?99:num;
                _cell.label1.text = [NSString stringWithFormat:@"%ld",(long)num];            }
           
        }
        cell = _cell;
    }
    else if (collectionView == self.collectionView2) {
        UserViewCL2CollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionView2Cell forIndexPath:indexPath];
        _cell.iconLabel.hidden = YES;

        //待付款 待发货 待收货 退款
        if (indexPath.row == 0) {
            if ([OrderManager shareOrederManager].orderNum>0) {
                _cell.iconLabel.hidden = NO;
                _cell.iconLabel.text = [NSString stringWithFormat:@"%ld",(long)[OrderManager shareOrederManager].orderNum];
            }
        }
        else if (indexPath.row == 1) {
            _cell.iconLabel.hidden = NO;
            _cell.iconLabel.text = [NSString stringWithFormat:@"%ld",(long)[OrderManager shareOrederManager].sendNum];
        }
        else if (indexPath.row == 2) {
            _cell.iconLabel.hidden = NO;
            _cell.iconLabel.text = [NSString stringWithFormat:@"%ld",(long)[OrderManager shareOrederManager].recerveNum];
        }else if (indexPath.row == 3) {
            _cell.iconLabel.hidden = NO;
            _cell.iconLabel.text = [NSString stringWithFormat:@"%ld",(long)[OrderManager shareOrederManager].refundNum];
        }

        _cell.coverImage.image = [UIImage imageNamed:[section2icons objectAtIndex:indexPath.row]];
        _cell.label1.text = [section2titles objectAtIndex:indexPath.row];
       
        cell = _cell;

    }
    else {
        UserViewCL3CollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionView3Cell forIndexPath:indexPath];
        
        _cell.coverImage.image = [UIImage imageNamed:[section3icons objectAtIndex:indexPath.row]];
        _cell.label1.text = [section3titles objectAtIndex:indexPath.row];
        cell = _cell;
    }

    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    if (collectionView == self.headerUserDescCollectionview) {
        size = CGSizeMake((collectionView.frame.size.width - 10) / 4, 70);
    }
    else if (collectionView == self.collectionView2) {
        size = CGSizeMake((collectionView.frame.size.width - 10) / 3, 80);
    }
    else {
        size = CGSizeMake((collectionView.frame.size.width) / 3, (collectionView.frame.size.width) / 3);
        NSLog(@"2015-08-20--%f--",collectionView.frame.size.width);

    }
    return size;
}

//定义section间 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets ei;
    if (collectionView == self.headerUserDescCollectionview) {
        collectionViewLayout.minimumLineSpacing = 0;
        collectionViewLayout.minimumInteritemSpacing = 0;
        ei = UIEdgeInsetsZero;

    }
    else if (collectionView == self.collectionView2) {
        collectionViewLayout.minimumLineSpacing = 0;
        collectionViewLayout.minimumInteritemSpacing = 0;
        ei = UIEdgeInsetsZero;

    }
    else {
        collectionViewLayout.minimumLineSpacing = 0;
        collectionViewLayout.minimumInteritemSpacing = 0;
        ei = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    return ei;
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    USER *user = [App shared].currentUser;
    if (self.user.authorized) {
        if (collectionView == self.headerUserDescCollectionview) {
            if (indexPath.row == 0) {//付款
//                IntegrationController *uc=[[IntegrationController alloc] init];
//                [self showNavigationView:uc];
                
                OrderListViewController *uc = [[OrderListViewController alloc] initWithOrderStatus:indexPath.row + 1];
            
                [self showNavigationView:uc];

            }
            else if (indexPath.row == 1) {//发货
//                CouponController *uc = [[CouponController alloc] init];
//                [self showNavigationView:uc];
                OrderListViewController *uc = [[OrderListViewController alloc] initWithOrderStatus:indexPath.row + 1];
                [self showNavigationView:uc];

            }
            else if (indexPath.row == 2) {//收货
                OrderListViewController *uc = [[OrderListViewController alloc] initWithOrderStatus:indexPath.row + 1];
                [self showNavigationView:uc];
            }
            else if (indexPath.row == 3) {//退款
                ApplyRefundViewController*uc = [ApplyRefundViewController new];
                [self showNavigationView:uc];
//                OrderListViewController *uc = [[OrderListViewController alloc] initWithOrderStatus:indexPath.row + 1];
//                [self showNavigationView:uc];

            }
        }
        else if (collectionView == self.collectionView2) {
            
        }
        else if (collectionView == self.collectionView3) {
            if (indexPath.row == 0) {//订单
                OrderListViewController *uc = [OrderListViewController new];
                [self showNavigationView:uc];
            }
            else if (indexPath.row == 1) {//合作社
//                UserLikeViewController *uc = [[UserLikeViewController alloc] initWithBackBtn:YES];
//                [self showNavigationView:uc];
                collectionView.userInteractionEnabled = NO;
                CoopViewController *uc = [CoopViewController new];
                
                App *app = [App shared];
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                [parameters setObject:[NSString stringWithFormat:@"%@",app.currentUser.token]forKey:@"token"];
                [self Showprogress];
                NSString *url = [NSString stringWithFormat:@"%@/cooperation/get",url_share];
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    collectionView.userInteractionEnabled = YES;
                    [self hideHUDView];
                    if ([responseObject[@"status"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                        _STWordView= [STWordAndPhraseView STWordAndPhraseView];
                        _STWordView.frame =CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
                        _STWordView.bgVIew.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
                
                        _STWordView.text.delegate = self;
                        _STWordView.text.tag = 1000;
                        [_STWordView.text bringSubviewToFront:_STWordView.imageVIew];
                        [_STWordView.beBtn addTarget:self action:@selector(beBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                        _STWordView.beBtn.layer.cornerRadius = 3;
                         _STWordView.beBtn.layer.masksToBounds = YES;
                        [[UIApplication sharedApplication].windows[0] addSubview:_STWordView];
                        UITapGestureRecognizer * tapcomment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCommentLabel)];//定义一个手势
                        [_STWordView addGestureRecognizer:tapcomment];//添加手势到View
                        return ;

                    }
                    else{
                        collectionView.userInteractionEnabled = YES;
                        uc.tokenStr = responseObject[@"data"][@"coupon_code"];
                        [self showNavigationViewMainColor:uc];
                    }
                    
                }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          collectionView.userInteractionEnabled = YES;

                      }];
                
            }
            else if (indexPath.row == 2) {//收货地址
                OrderListViewController *uc = [[OrderListViewController alloc] initWithOrderStatus:indexPath.row + 1];
                [self showNavigationView:uc];

//                AddressListViewController *uc = [AddressListViewController new];
//                [self showNavigationView:uc];

            }
            else if (indexPath.row == 3) {//我的农场
//                FavViewController *uc = [[FavViewController alloc] initWithBackBtn:YES];
//                [self showNavigationView:uc];
                MyfarmViewController*uc = [MyfarmViewController new];
                uc.usertoken = self.user.token;
                [self showNavigationView:uc];

            }
            else if (indexPath.row == 4) {//物流跟踪
//                LogisticsViewController *loginticsVC = [[LogisticsViewController alloc]init];
//                loginticsVC.title = @"物流跟踪";
//                [self showNavigationView:loginticsVC];
                AddressListViewController*loginticsVC = [[AddressListViewController alloc]init];
                loginticsVC.initType = 2;
                [self showNavigationView:loginticsVC];

            }
            else if (indexPath.row == 5) {//我的喜欢
                UserLikeViewController *uc = [[UserLikeViewController alloc] initWithBackBtn:YES];
                [self showNavigationView:uc];
            }
            else if (indexPath.row == 6) {//我的钱包
                mymoneyViewController *uc = [[mymoneyViewController alloc]init];
                uc.title = @"我的钱包";
                [self showNavigationView:uc];
            }
            else if (indexPath.row == 7) {//其他设置
               
                UserSettingViewController *uc = [UserSettingViewController new];
                [self showNavigationView:uc];
            }
            else if (indexPath.row == 8) {//我的积分
//                IntegrationController *uc = [IntegrationController new];
//                [self showNavigationView:uc];
                //品位
//                GradeViewController *uc = [GradeViewController new];
//                [self showNavigationView:uc];
                
            }

        }

    }
    else {
        [self showLoginView];
    }
}
-(void)tapCommentLabel
{
    [_STWordView removeFromSuperview];
    _STWordView=nil;
}
- (void)beBtnAction:(UIButton*)sender
{
    sender.userInteractionEnabled = NO;
    if (_president.length<1) {
        [[UIApplication sharedApplication].windows[0] showHUD:@"请输入社招码" afterDelay:1];
        sender.userInteractionEnabled = YES;
        return;
    }
    [[self.backend requestPresident:self.user autherCode:_president] subscribeNext:[self becomePresident:@"成为社长"]];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _president = textField.text;
    return YES;
}
- (void (^)(RACTuple*))becomePresident:(NSString*)text
{
    @weakify(self)
    return ^(RACTuple* parameters){
        @strongify(self)
        _STWordView.beBtn.userInteractionEnabled = YES;
        ResponseResult *rs =(ResponseResult*)parameters;
        if (rs.success) {
            [[UIApplication sharedApplication].windows[0] showHUD:text afterDelay:2];
        }else
        {
            
            [[UIApplication sharedApplication].windows[0] showHUD:rs.messge afterDelay:2];
        }
    };
}
//返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}
@end
