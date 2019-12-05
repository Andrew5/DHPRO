
//
//  HomeViewControllernew.m
//  shiku
//
//  Created by Rilakkuma on 15/7/23.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "HomeViewControllernew.h"
#import "App.h"
#import "Backend.h"
#import "HomeClassifyCollectionViewCell.h"
#import "HomeHeaderCollectionViewCell.h"
#import "ConCollectionViewCell.h"
#import "AddCarView.h"
#import "GoodsDetailMenuViewController.h"
#import "HomeNewBackend.h"
#import "Cart.h"
#import "SearchViewController.h"
#import "UserViewController.h"
#import "AppDelegate.h"
#define nibHname @"HomeHeaderCollectionViewCell"
static NSString *homeHeaderDefaultIdentifier =@"HomeHeaderCollectionViewCellID";
#define nib2Name @"HomeClassifyCollectionViewCell"
static NSString *homeClassDefaultIdentifier =@"HomeClassifyCollectionViewCellID";
#define nibName @"ConCollectionViewCell"
static NSString *conDefaultIdentifier =@"ConCollectionViewCellID";

#define defaultName @"Cell"


//#import <DKFilterView/DKFilterView.h>

@interface HomeViewControllernew ()<GoodsDetailMenuViewControllerDelegate,HomeNewDelegate,HomeHeaderCollectionViewCellDelegate,UserLoginViewControllerDelegate>
{
    //关注
    int Num;
    
    NSString *IDStr;
    UIButton *anbtn;//top按钮
    NSString *goodsID;
    
    NSString *mname;//农户姓名
    NSString *startNum;//评星


    NSInteger selectedTag;//分类选中状态
    AddCarView *addcarVC;//添加购物车事件


    NSMutableArray *nameArray;
    NSMutableArray *imgArray;
    NSMutableDictionary *dict;
}
/**
 * 关注
 */
@property (strong, nonatomic)  UIButton *btnAttention1;
/**
 * banner图片
 */
@property (strong, nonatomic)  UIImageView *imageIcon1;
/**
 * 头像按钮
 */
@property (strong, nonatomic)  UIButton *btnIcon1;
/**
 * 标题
 */
@property (strong, nonatomic)  UILabel *labelTitle1;
/**
 * 关注量
 */
@property (strong, nonatomic)  UILabel *labelAttentionStr1;
/**
 * 销售量
 */
@property (strong, nonatomic)  UILabel *labelSalesVolume1;

/**
 * 图片标题
 */
@property (strong, nonatomic) NSString *imageTitle;

@property(strong, nonatomic)NSMutableArray * Name_Arr;

@property(strong, nonatomic)NSMutableArray * Item_Arr;

@property(strong, nonatomic)NSDictionary * data_Dict;

@property(strong, nonatomic) HomeNewBackend *homeNewbackend;

@property (nonatomic,strong) NSNumber *good_id;

@property (nonatomic,strong)GoodsDetailMenuViewController* menu;


@end

@implementation HomeViewControllernew
@synthesize getDate;
@synthesize collectionViewS;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    app.viewController.tabBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.viewController.tabBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    selectedTag = 0;
    getDate = [[HomeGetdata alloc]init];
    self.Name_Arr = [NSMutableArray array];
    self.Item_Arr = [NSMutableArray array];
    dict = [NSMutableDictionary dictionary];

    [self getFarmerdata];
    [self getAttentionList];

        //添加搜索框
    UIView *searchFieldView=[self tToolbarSearchField:[UIScreen mainScreen].bounds.size.width-100 withheight:20
                               isbecomeFirstResponder:false action:@selector(searchFieldTouched) textFieldDelegate:self];
    searchFieldView.autoresizingMask=YES;
    self.navigationItem.titleView=searchFieldView;
    
    //导航栏添加左右按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 10, 30, 30);
    [leftBtn setImage:[UIImage imageNamed:@"iii_03"] forState:UIControlStateNormal];
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 10);
    [leftBtn addTarget:self action:@selector(clickleftButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtnItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=leftBarBtnItem;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(10, 10, 30, 20);
    [rightBtn setImage:[UIImage imageNamed:@"iii_05"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightBarBtn;
    
    
    //创建CollectionView
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0.5;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    collectionViewS=[[UICollectionView alloc] initWithFrame:CGRectMake(0, -5, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) collectionViewLayout:flowLayout];
    collectionViewS.delegate = self;
    collectionViewS.dataSource = self;
    collectionViewS.backgroundColor = [UIColor colorWithRed:0.898 green:0.902 blue:0.906 alpha:1.000];
    //注册相对应的CollectionView
    [collectionViewS registerNib:[UINib nibWithNibName:nibHname bundle:nil] forCellWithReuseIdentifier:homeHeaderDefaultIdentifier];
    [collectionViewS registerNib:[UINib nibWithNibName:nib2Name bundle:nil] forCellWithReuseIdentifier:homeClassDefaultIdentifier];
    [collectionViewS registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellWithReuseIdentifier:conDefaultIdentifier];
    [self.view addSubview:collectionViewS];

    anbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    anbtn.frame =CGRectMake([UIScreen mainScreen].bounds.size.width-55,[UIScreen mainScreen].bounds.size.height-120,40,40);
    [anbtn setTitle:@"\U0000D15A" forState:UIControlStateNormal];
    anbtn.layer.cornerRadius=20;
    anbtn.titleLabel.font=[UIFont fontWithName:@"iconfont" size:35];
    [anbtn setTintColor:WHITE_COLOR];
    anbtn.backgroundColor=[UIColor colorWithRed:0.384 green:0.529 blue:0.275 alpha:1.000];//MAIN_COLOR;
    anbtn.layer.masksToBounds =YES;
    [anbtn addTarget:self action:@selector(btnclickAnbtn:) forControlEvents:UIControlEventTouchUpInside];
    anbtn.hidden=YES;
    [self.view addSubview:anbtn];

}

- (void)btnclickAnbtn:(UIButton *)sender{
    collectionViewS.contentOffset = CGPointMake(0, 0);
}
- (void)getAttentionList
{
    NSUserDefaults *attentionUser = [NSUserDefaults standardUserDefaults];
    isAttention = NO;
    _attentionList = [NSMutableArray arrayWithArray:[attentionUser objectForKey:@"attentionList"]];
    
    if (_attentionList.count<1) {
        _attentionList = [NSMutableArray array];
        [self getAttentionData];
        return;
    }
    
    [self chekAttention];

}
//判断是否关注
- (void)chekAttention
{
    
    for(NSString * str in _attentionList)
    {
        if ([str isEqualToString:_midStr]) {
            isAttention = YES;
        }
    }
    [self.collectionViewS reloadData];

}

//得到关注数
-(void)getAttentionData{
    NSString *urlStr1 = [NSString stringWithFormat:@"%@/member_favs/lists",url_share];
    NSMutableDictionary * parmeter = [[NSMutableDictionary alloc]init];
    [self Showprogress];
    [parmeter setObject:[NSString stringWithFormat:@"{\"mid\":\"%@\"}",_midStr]
                 forKey:@"data"];
    [[[Backend alloc] init] POST:urlStr1 parameters:parmeter success:^(AFHTTPRequestOperation *operation,id json) {
        [self hideHUDView];
        NSArray *dataArr = json[@"data"][@"list"];
        for(NSDictionary *dic in dataArr)
        {
            [_attentionList addObject:dic[@"mid"]];
        }
        [self chekAttention];
        [self saveAttention];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHUDView];

    }];
    
}
- (void)saveAttention
{
    NSUserDefaults *attentionUser = [NSUserDefaults standardUserDefaults];
    
    [attentionUser setObject:_attentionList forKey:@"attentionList"];
    
    [attentionUser synchronize];
}
//备注：数据请求 这里没写好 后期需优化
#pragma mark --得到农民的数据
-(void)getFarmerdata{
    NSString *urlStr1 = [NSString stringWithFormat:@"%@/member_shop/get",url_share];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"mid":_midStr}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    [self Showprogress];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [manager POST:urlStr1  parameters:@{@"data":jsonStr}
      success:^(AFHTTPRequestOperation *operation,id json) {
          SBJsonParser *parser = [[SBJsonParser alloc]init];
          NSDictionary *dictArray = [parser objectWithString:operation.responseString];
          NSMutableArray *s = json[@"data"][@"items"];
          getDate.covers = json[@"data"][@"covers"];
          for (int i =0; i<s.count; i++) {
              NSString *y = s[i][@"img"];
              mname = s[i][@"mname"];
              startNum = s[i][@"rates"];
              [getDate.goodsImage addObject:y];

          }
          getDate.introduce = dictArray[@"data"][@"voice"];//农场介绍
          //标题
          if (dictArray[@"data"][@"title"] == nil) {
              
          }
          else{
              
              getDate.title = dictArray[@"data"][@"title"];

          }
         
          //销售量

          //关注量
          getDate.shop_rates = json[@"data"][@"rates"];
          
          
          //购买量
          
          
          //地图
          if (dictArray[@"data"][@"map_image_url"] == nil) {

          }
          else{
              getDate.mapImage =dictArray[@"data"][@"map_image_url"];

          }

          //items
          NSArray *itemsArray = dictArray[@"data"][@"items"];
          
          if (itemsArray.count == 0 ) {
              NSLog(@"空");
          }
          else{
              
              getDate.items =dictArray[@"data"][@"items"];
  
          }
          /*********************************丅商品详情丅******************************************/
          
          //分类
          NSArray *items_cateArray =dictArray[@"data"][@"items_cate"];
          if (items_cateArray.count == 0) {
              NSLog(@"空");
              
          }else{
              getDate.items_cate = dictArray[@"data"][@"items_cate"];
          }
          if (getDate.items) {
              [dict setObject:getDate.items forKey:@"1"];
          }

          NSDictionary * m_dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"所有商品",@"name",@"1",@"id", nil];
          [self.Name_Arr addObject:m_dict];
        for (int i = 0; i< getDate.items_cate.count; i++)
        {
            NSString *idStr = getDate.items_cate[i][@"id"];
            NSMutableArray *u = [NSMutableArray array];
            [self.Name_Arr addObject:getDate.items_cate[i]];
            for (int j = 0; j<getDate.items.count; j++) {
                
                if ([getDate.items[j][@"cate_id"] isEqual:idStr]) {
                    [u addObject:getDate.items[j]];
                }
                else{
                    
                }
            }
            [dict setObject:u forKey:idStr];
            self.Item_Arr = self.Item_Arr = [dict objectForKey:[[self.Name_Arr objectAtIndex:0] objectForKey:@"id"]];
            
        }
         

          /*********************************↑↑↑↑商品详情↑↑↑↑******************************************/

          //covers
          NSArray *coversArray =dictArray[@"data"][@"covers"];
          if (coversArray.count == 0) {
              NSLog(@"空");

          }
          else{
              getDate.covers = dictArray[@"data"][@"covers"];
          }
          
          NSArray *memberArray = dictArray[@"data"][@"member"];
          if (memberArray.count  == 0) {

          }
          else {
                //头像
                getDate.img = dictArray[@"data"][@"member"][@"img"];
                //地址
                getDate.address = dictArray[@"data"][@"member"][@"address"];
                  //电话号码
                getDate.tele= dictArray[@"data"][@"member"][@"tele"];
                  //90人已认购
                getDate.favss = dictArray[@"data"][@"member"][@"favs"];
                  //销量
                getDate.sales = dictArray[@"data"][@"member"][@"sales"];
              }
          //评语标题
          if ([dictArray[@"data"][@"content"] isEqual:@" "]) {

          }
          else{
              getDate.content = dictArray[@"data"][@"content"];
          }
          [self hideHUDView];

           [collectionViewS reloadData];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {

              printf("失败");
              [self hideHUDView];
          }
     ];

}

-(void)searchFieldTouched{
    SearchViewController *uc = [SearchViewController new];
    [self.navigationController pushViewController:uc animated:YES];
}


-(void)clickRightButton{
    
}
-(void)clickleftButton{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (collectionViewS.contentOffset.y > [UIScreen mainScreen].bounds.size.height/2) {
        anbtn.hidden = NO;
    }else{
        anbtn.hidden = YES;
    }
}
//快速加购物车
-(void)carGoodsMethod:(UIButton*)sender{
    [self Showprogress];
    NSInteger anGoodID = [getDate.items[sender.tag][@"id"]integerValue];
    NSNumber *goodId = [NSNumber numberWithInteger:anGoodID];
    self.homeNewbackend = [[HomeNewBackend alloc]init];
    self.homeNewbackend.delegate = self;
    [self.homeNewbackend requestGoodsWithId:goodId];
}
- (void)sendDataBack:(GOODS *)anGood
{
    _menu = [[GoodsDetailMenuViewController alloc]initWithGoods:anGood];
    [self hideHUDView];
    _menu.delegate =self;
    AppDelegate *app= (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.viewController.tabBar.hidden = YES;
    [[self menu]showInView:[self view]];
}
- (void)didAddToCartSuccessWithGoodsNum:(NSInteger)num {
    
    [self.view showHUD:@"关注成功" afterDelay:1];
    [Cart AddNumWithGoodsNum:num];
    [Cart saveCartNum];
    
}
- (void)hideFinished
{
    
}


- (void) showInView:(UIView*)view
{
    self.tabBarController.tabBarController.tabBar.hidden= YES;
    //  1. Hide the modal
    _containerView.hidden = NO;
    //    [[self modalView] setAlpha:0];
    
    //  2. Install the modal view
    [[view superview] addSubview:[self view]];
    
    _shrunkView = view;
    
    [[self view] setFrame:_shrunkView.frame];
    
    //  3. Show the buttons
    [[self containerView] setTransform:CGAffineTransformMakeTranslation(0, [[self containerView] frame].size.height)];
    
    //  4. Animate everything into place
    [UIView
     animateWithDuration:0.3
     animations:^{
         
         
         //  Shrink the main view by 15 percent
         CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, .9, .9);
         [view setTransform:t];
         
         //  Fade in the modal
         //         [[self modalView] setAlpha:1.0];
         
         //  Slide the buttons into place
         [[self containerView] setTransform:CGAffineTransformIdentity];
         
     }
     completion:^(BOOL finished) {

     }];
    
}
- (void) hideInView
{
    
    //      2. Animate everything out of place
    [UIView
     animateWithDuration:0.3
     animations:^{
         
         //  Shrink the main view by 15 percent
         CGAffineTransform t = CGAffineTransformIdentity;
         [_shrunkView setTransform:t];

         //  Fade in the modal
         //         [[self modalView] setAlpha:0.0];
         
         //  Slide the buttons into place
         
         t = CGAffineTransformTranslate(t, 0, [[self containerView] frame].size.height);
         [[self containerView] setTransform:t];
         
     }
     
     completion:^(BOOL finished) {
         //         [[self modalView] removeFromSuperview];
         _shrunkView=nil;
         //         if ([self.delegate respondsToSelector:@selector(hideFinished)]) {
         //             [self.delegate hideFinished];
         //         }
     }];
    
}
#pragma mark --UICollectionViewDelegate


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1){
        return self.Name_Arr.count;
    }
    else if (section == 2){
        return self.Item_Arr.count;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell;

    if (indexPath.section == 0) {
        HomeHeaderCollectionViewCell *_cell = [HomeHeaderCollectionViewCell createCollectionView:collectionView Index:indexPath];
        _cell.delegate = self;
//        //获取一个随机整数范围在：[0,100)包括0，不包括100
//        int x = arc4random() % 3;
        if ([getDate.shop_rates intValue] == 1) {
            _cell.imageStartone.hidden = NO;
        }
        else if ([getDate.shop_rates intValue] == 2) {
            _cell.imageStartone.hidden = NO;
            _cell.imageStarttwo.hidden = NO;
            
        }
        else if ([getDate.shop_rates intValue] == 3) {
            _cell.imageStartone.hidden = NO;
            _cell.imageStartthree.hidden = NO;
            _cell.imageStarttwo.hidden = NO;
        }
        else if ([getDate.shop_rates intValue] == 4) {
            _cell.imageStartone.hidden = NO;
            _cell.imageStarttwo.hidden = NO;
            _cell.imageStartthree.hidden = NO;
            _cell.imageStartfour.hidden = NO;
            
        }
        else if ([getDate.shop_rates intValue] == 5) {
            _cell.imageStartone.hidden = NO;
            _cell.imageStarttwo.hidden = NO;
            _cell.imageStartthree.hidden = NO;
            _cell.imageStartfour.hidden = NO;
            _cell.imageStartfive.hidden = NO;
        }
        
        //产品标题图片
        NSString *imgStr = [NSString stringWithFormat:@"img_%ld",(long)indexPath.row];

        NSString *url = [Helper checkImgType:[getDate.covers objectForKey:imgStr]];
   
        [_cell.imageHeader sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                [_cell.imageHeader sd_setImageWithURL:[NSURL URLWithString:[getDate.covers objectForKey:imgStr]]];
            }
        }];
        
        [_cell.imageHeader setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _cell.imageHeader.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _cell.imageHeader.contentMode = UIViewContentModeScaleAspectFill;
        _cell.imageHeader.clipsToBounds = YES;
        //点击查看店铺
        UITapGestureRecognizer *tapGess = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personInfoAction)];
        tapGess.numberOfTapsRequired = 1; // 单击
        
        tapGess.delegate = self;
        _cell.imageHeader.userInteractionEnabled = YES;
        [_cell.imageHeader addGestureRecognizer:tapGess];
        
        //点击头像
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personInfoAction)];
        tapGes.numberOfTapsRequired = 1; // 单击
        tapGes.delegate = self;
        _cell.imageViewIcon.userInteractionEnabled = YES;
        [_cell.imageViewIcon addGestureRecognizer:tapGes];
        _cell.imageViewIcon.layer.borderColor = [UIColor whiteColor].CGColor;
        _cell.imageViewIcon.layer.borderWidth = 2;
        
        
        NSString *iconurl = [Helper checkImgType:getDate.img];
        
        [_cell.imageViewIcon sd_setImageWithURL:[NSURL URLWithString:iconurl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) {
                [_cell.imageViewIcon sd_setImageWithURL:[NSURL URLWithString:getDate.img] placeholderImage:[UIImage imageNamed:@"FarmerIcon"]];
            }
        }];

        
        _cell.labelGoodsShop.text = getDate.title;
        
        _cell.btnattention.selected = isAttention==YES?1:0;
        
        if ([getDate.favss isEqual:@" "]) {
            _cell.LabelAttention.text = @"0";//关注

        }
        else{
            _cell.LabelAttention.text = getDate.favss;//关注

        }

        if (getDate.sales == nil) {
            _cell.labelSales.text = @"0";//销售

        }else{
            _cell.labelSales.text = getDate.sales;//销售
            
        }
//        return cell;
        cell = _cell;
    }
    else if (indexPath.section == 1){
        HomeClassifyCollectionViewCell * cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:homeClassDefaultIdentifier forIndexPath:indexPath];
        cell1.labelTitle.text = [NSString stringWithFormat:@"%@",[self.Name_Arr[indexPath.row] objectForKey:@"name"]];
        cell1.layer.cornerRadius = 2;
        cell1.labelTitle.clipsToBounds = YES;
        cell1.labelTitle.textColor = [UIColor blackColor];
        cell1.backgroundColor = [UIColor colorWithRed:0.996 green:1.000 blue:1.000 alpha:1.000];
        cell1.tag = indexPath.row;

        if (cell1.tag == selectedTag) {
            cell1.backgroundColor = [UIColor colorWithRed:0.384 green:0.529 blue:0.275 alpha:1.000];
            cell1.labelTitle.textColor = [UIColor whiteColor];
        }
        else{
            cell1.labelTitle.textColor = [UIColor blackColor];
            cell1.backgroundColor = [UIColor whiteColor];
        }

        return cell1;
    }
    else if (indexPath.section == 2){
        ConCollectionViewCell * cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:conDefaultIdentifier forIndexPath:indexPath];
        NSDictionary * dictt = [self.Item_Arr  objectAtIndex:indexPath.row];
                
        
        //产品标题图片
        NSString *url = [Helper checkImgType:dictt[@"img"]];
    
        [cell1.imageGoods sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if ((error)) {
                [cell1.imageGoods sd_setImageWithURL:[NSURL URLWithString:dictt[@"img"]]];
            }
        }];
        
        [cell1.imageGoods setContentScaleFactor:[[UIScreen mainScreen] scale]];
        cell1.imageGoods.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        cell1.imageGoods.contentMode = UIViewContentModeScaleAspectFill;
        cell1.imageGoods.clipsToBounds = YES;
        
        [cell1.btnCargoods addTarget:self action:@selector(carGoodsMethod:) forControlEvents:(UIControlEventTouchUpInside)];
        CGSize maxSize = CGSizeMake(SCREEM_W-20,SCREEM_H/5*2);
        if (dictt[@"title"]) {
          CGSize size = [self labelAutoCalculateRectWith:dictt[@"title"] FontSize:14 MaxSize:maxSize];
            cell1.viewH.constant = size.height+38;

        }
        cell1.labelTitle.text = dictt[@"title"];
        
        if (getDate.sales == nil) {
            cell1.labelSall.text = @"0人已认购";

        }else{
            cell1.labelSall.text = [NSString stringWithFormat:@"%@人已认购",[dictt objectForKey:@"sales"]];
        }

            cell1.labelNum.text = [NSString stringWithFormat:@"¥%@",dictt[@"price"]];
        
        return cell1;
    }
    return  cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat ScreemW = [UIScreen mainScreen].bounds.size.width;
    CGFloat flag = 1.05;
    if (ScreemW==320.0) {
        flag = 1.1;
    }
    if (indexPath.section == 0) {
        return CGSizeMake(ScreemW,ScreemW*269*flag/375);
        
    }else if (indexPath.section  == 1){
        return CGSizeMake(70,23);
    }
    else if(indexPath.section == 2){
        return CGSizeMake([UIScreen mainScreen].bounds.size.width,screenSize.height/5*2);
        
    }
    return CGSizeMake(5, 5);
}
- (CGFloat)minimumInteritemSpacing {
    return 0;
}
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [[self layoutAttributesForElementsInRect:rect] mutableCopy];
    
    return attributes;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 1) {
        return 3;
    }
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 1) {
        return 10;
    }

    return 0;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        return UIEdgeInsetsMake(10, 10, 10, 13);
    }

    return UIEdgeInsetsMake(5, 5, 5, 5);
}
#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{


    if (indexPath.section == 1) {
        HomeClassifyCollectionViewCell *cell1 = (HomeClassifyCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        cell1.selected = YES;
        cell1.backgroundColor = [UIColor colorWithRed:0.384 green:0.529 blue:0.275 alpha:1.000];
        cell1.labelTitle.textColor = [UIColor whiteColor];

        if (selectedTag != cell1.tag) {
            HomeClassifyCollectionViewCell *previousCell = (HomeClassifyCollectionViewCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:selectedTag inSection:indexPath.section]];
            previousCell.labelTitle.textColor = [UIColor blackColor];
            previousCell.backgroundColor = [UIColor colorWithRed:0.996 green:1.000 blue:1.000 alpha:1.000];
            selectedTag = cell1.tag;
        }
        
        self.Item_Arr = [dict objectForKey:[[self.Name_Arr objectAtIndex:indexPath.row] objectForKey:@"id"]];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section+1];
        [collectionView reloadSections:indexSet];
    }
    if (indexPath.section == 2) {
     
        goodsID =  getDate.items[indexPath.row][@"id"];
        GoodsDetailViewController *personInfo = [[GoodsDetailViewController alloc]init];
        personInfo.fromHomeNew = YES;
        id result;
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        if ([f respondsToSelector:@selector(numberFromString:)]) {
            result=[f numberFromString:goodsID];
        }
        if(!(result))
        {
            result=goodsID;
        }
        personInfo.goods_id = result;
 //去导航栏
        [self.navigationController pushViewController:personInfo animated:YES];
    }
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)diffClassify:(UIButton *)sender{
    if (sender.selected == YES) {
        sender.backgroundColor = [UIColor whiteColor];

    }else{
        sender.backgroundColor = [UIColor colorWithRed:0.404 green:0.557 blue:0.294 alpha:1.000];
    }
    sender.selected =! sender.selected;
}

#pragma mark -商品详情
-(void)detailsPage:(UITapGestureRecognizer *)tap{
//    NSString *GOODSID = [NSString string];
    GoodsDetailViewController *personInfo = [[GoodsDetailViewController alloc]init];
//    if (getDate.items.count == 0) {
//        GOODSID = @"6475";
//    }
//    else{
//        for (int i = 0; i<getDate.items.count; i++) {
//            NSLog(@"%@",getDate.items[i][@"id"]);
//            GOODSID = getDate.items[i][@"id"];
//        }
//    }
    NSString *str =goodsID;
    
    id result;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    result=[f numberFromString:str];
    if(!(result))
    {
        result=str;
    }
    personInfo.goods_id = result;
    
    [self showDetailViewController:personInfo sender:nil];

    
}

#pragma mark -查看农户详细信息
-(void)personInfoAction{
    HomePeosonInfoViewController *personInfo = [[HomePeosonInfoViewController alloc]init];
    personInfo.isAttention = isAttention;
    personInfo.midStr = _midStr;
    personInfo.imageDic = getDate.covers;
    [personInfo getChange:^(NSString *attentionNum, BOOL isAtten) {
        getDate.favss = attentionNum;
        isAttention = isAtten;
        if (isAttention) {
            [_attentionList addObject:attentionNum];
        }else
        {
            [_attentionList removeObject:attentionNum];
        }
        [self.collectionViewS reloadData];
    }];
    if (mname) {
        personInfo.mname = mname;
    }
    if (startNum) {
        personInfo.stratStr = startNum;
    }
    if (getDate.title) {
        personInfo.titleStr = getDate.title;

    }
    else{
        personInfo.titleStr=@"农场主";
    }
    
    if (getDate.sales) {
        personInfo.saleStr = getDate.sales;
        
    }
    else{
        personInfo.saleStr=@"0";
    }
    
//    if (getDate.content == nil) {
        personInfo.commentStr = getDate.introduce;
        
//    }
//    else{
//        personInfo.commentStr=@"农场介绍";
//    }
    
    if (getDate.address) {
        personInfo.addressStr = getDate.address;
        
    }
    else{
        //
        personInfo.addressStr=@"地址";
    }
    
    if (getDate.tele) {
        personInfo.teleStr = getDate.tele;
        
    }
    else{
        personInfo.teleStr=@"152456789";
    }
    
    if (getDate.title) {
        personInfo.iconImage = getDate.img;
        
    }
    else{
        //
    }
    
//    //获取一个随机整数范围在：[0,100)包括0，不包括100
//    int x = arc4random() % 3;
//    //banner
//    if (getDate.covers.count != 0) {
//        NSString *imgStr = [NSString stringWithFormat:@"img_%d",x];
//        [cell.imageHeader sd_setImageWithURL:[NSURL URLWithString:[getDate.covers objectForKey:imgStr]] placeholderImage:[UIImage imageNamed:@"ni.png"]];
//        
//    }

    if (getDate.covers != nil) {
        int x = arc4random() % 3;
        NSString *imgStr = [NSString stringWithFormat:@"img_%d",x];
        personInfo.imagU = [getDate.covers objectForKey:imgStr];
    }
    
    if (getDate.goodsImg) {
        personInfo.imagU = getDate.goodsImg;
    }
    else{
        //
    }
    
    if (getDate.mapImage) {
        personInfo.mapImage = getDate.mapImage;
        
    }
    else{

    }
    
    if ([getDate.favss isEqual:@" "]) {
        personInfo.attentionStr=@"0";

    }
    else{
        personInfo.attentionStr = getDate.favss;
        
    }
 
    [self showNavigationView:personInfo];
}


/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


#define IMAGEURL(_IMAGEN_) setImageWithURL:[NSURL URLWithString:_IMAGEN_] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    
    NSLog(@"执行图片下载函数");
    
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    
    result = [UIImage imageWithData:data];
    
    return result;
    
}


#pragma mark  -关注
- (void)attentionBack:(UIButton *)sender
{   USER*user =  [App shared].currentUser;
    if (![user authorized]) {
        UserLoginViewController *userVC= [[UserLoginViewController alloc]init];
        [self showNavigationView:userVC];
        return;
    }
//    [self ShowHDImgView:LOADING];
    sender.userInteractionEnabled = NO;
    if (sender.selected) {
        [self dele:sender];
    }else
    {
        [self add:sender];
        
    }
}

-(void)add:(UIButton *)sender{
    NSString *urlStr1 = [NSString stringWithFormat:@"%@/member_favs/add",url_share];

//    NSString *urlStr1 = @"http://api.shiku.com/buyerApi/member_favs/add";
    NSMutableDictionary * parmeter = [[NSMutableDictionary alloc]init];
    [parmeter setObject:[NSString stringWithFormat:@"{\"mid\":\"%@\"}",_midStr]
                 forKey:@"data"];

    [[[Backend alloc] init] POST:urlStr1 parameters:parmeter success:^(AFHTTPRequestOperation *operation,id json) {
        //DB3A57e3f81997b82a0f
        NSString *s = json[@"status"];
        if ( [s isEqual:[NSNumber numberWithInt:0]]) {
            [self.view showHUD:json[@"result"] afterDelay:1.5];
        }else{
            isAttention = YES;
            [self.view showHUD:@"添加成功" afterDelay:1.5];
            [_attentionList addObject:_midStr];
            [self saveAttention];
           getDate.favss = [NSString stringWithFormat:@"%ld",[getDate.favss integerValue]+1];

            [self.collectionViewS reloadData];
//            [self hideHUDView];
         


        }
           sender.userInteractionEnabled = YES;
    
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        sender.userInteractionEnabled = YES;

    }];
}
-(void)dele:(UIButton *)sender{
    NSString *urlStr1 = [NSString stringWithFormat:@"%@/member_favs/delete",url_share];

//    NSString *urlStr1 = @"http://www.shiku.com/buyerApi/member_favs/delete";
    NSMutableDictionary * parmeter = [[NSMutableDictionary alloc]init];
    __block UIButton *btn =sender;
    [parmeter setObject:[NSString stringWithFormat:@"{\"mid\":\"%@\"}",_midStr]
                 forKey:@"data"];
    [[[Backend alloc] init] POST:urlStr1 parameters:parmeter success:^(AFHTTPRequestOperation *operation,id json)  {
        
        
        NSString *s = json[@"status"];
        if ( [s isEqual:[NSNumber numberWithInt:0]]) {
            [self.view showHUD:json[@"result"] afterDelay:1.5];
          
        }else{
            NSLog(@"已登录");
            btn.selected = NO;

            isAttention = NO;
            [self.view showHUD:@"已取消关注" afterDelay:1.5];
            [_attentionList removeObject:_midStr];
            [self saveAttention];
            getDate.favss = [NSString stringWithFormat:@"%ld",[getDate.favss integerValue]-1];
            [self.collectionViewS reloadData];
           
        }
         sender.userInteractionEnabled = YES;
    }
                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             sender.userInteractionEnabled = YES;

                         }
     ];
    
}
-(CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize

{
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    labelSize.height=ceil(labelSize.height);
    
    labelSize.width=ceil(labelSize.width);
    
    return labelSize;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
