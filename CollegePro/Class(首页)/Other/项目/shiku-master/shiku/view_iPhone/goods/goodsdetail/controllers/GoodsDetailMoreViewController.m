#import "GoodsDetailMoreViewController.h"
#import "GoodsDetailRateViewCell.h"
#import "GoodsDetailAvatarViewCell.h"
#import "MultiTextView.h"

#define SECTION_HEADER_VIEW @"GoodsDetailMoreHeaderCollectionReusableView"

#define COLLECTION1_CELL @"GoodsDetailSection2CollectionViewCell"
#define COLLECTION1_CELL_HEIGHT 75

#define COLLECTION2_CELL1 @"GoodsDetailMore1CollectionViewCell"
#define COLLECTION2_CELL1_HEIGHT 40
#define COLLECTION2_CELL2_HEIGHT 60
#define COLLECTION2_CELL2 @"GoodsDetailMore2CollectionViewCell"
#define COLLECTION2_CELL3 @"GoodsDetailMoreLogListCollectionViewCell"
#define COLLECTION2_CELL4 @"GoodsDetailMoreLogInfoListCollectionViewCell"
#define COLLECTION2_CELL5 @"GoodsDetailMoreWebViewCollectionViewCell"
#define RATE_CELL @"GoodsDetailRateViewCell"
#define AVATAR_CELL @"GoodsDetailAvatarViewCell"

@interface GoodsDetailMoreViewController ()

@end

@implementation GoodsDetailMoreViewController
- (void)setup {

    @weakify(self)
    [self.collectionView2 addPullToRefreshWithActionHandler:^{
        @strongify(self)
        [self loadData];
        CGPoint point = self.collectionView2.contentOffset;
        point.y = 0;
        self.collectionView2.contentOffset = point;
    }];
    [self loadData];

}

- (void)loadData {
    [self Showprogress];
    [[self.backend requestGoodsDetailsWithId:self.goods.goods_id]
            subscribeNext:[self didLoadData]];
}

- (void (^)(RACTuple *))didLoadData {
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        [self hideHUDView];
        self.goods_detail_info = (GOODS_DETAIL_INFO *) parameters;
        if (currentTab == 0) {
            currDetailInfo = self.goods_detail_info.item_info;
        }
        else if (currentTab == 1) {
            currDetailInfo = self.goods_detail_info.logs_list;
        }
        else if (currentTab == 2) {
            currDetailInfo = self.goods_detail_info.producer;
        }
        else if (currentTab == 3) {
            currDetailInfo = self.goods_detail_info.score;
        }

        [self.collectionView2 reloadData];
        [self.collectionView2.pullToRefreshView stopAnimating];
    };

}

- (instancetype)initWithGoods:(GOODS *)anGoods andTabIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        currentTab = index;
        self.goods = anGoods;
        self.backend = [GoodsBackend new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    itemicons = GOODS_DETAIL_TAB_ICONS;
    itemiconsselect = GOODS_DETAIL_TAB_ICONS_SELECTED;
    itemtitles = GOODS_DETAIL_TAB_ICONS_TITLE;

    self.title = @"商品详情";
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.view.backgroundColor = RGBCOLORV(0X7A9C5C);
    self.navigationItem.leftBarButtonItem = [self leftBarBtnItem];
    self.view.backgroundColor = BG_COLOR;
    [self.collectionView1 setDataSource:self];
    [self.collectionView1 setDelegate:self];

    [self.collectionView2 setDataSource:self];
    [self.collectionView2 setDelegate:self];

    [self.collectionView1 registerNib:[UINib nibWithNibName:COLLECTION1_CELL bundle:nil]
           forCellWithReuseIdentifier:COLLECTION1_CELL];
    [self.collectionView1 registerNib:[UINib nibWithNibName:SECTION_HEADER_VIEW bundle:nil]
           forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                  withReuseIdentifier:SECTION_HEADER_VIEW];
    [self.collectionView2 registerNib:[UINib nibWithNibName:SECTION_HEADER_VIEW bundle:nil]
           forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                  withReuseIdentifier:SECTION_HEADER_VIEW];
    [self.collectionView2 registerNib:[UINib nibWithNibName:COLLECTION2_CELL1 bundle:nil]
           forCellWithReuseIdentifier:COLLECTION2_CELL1];
    [self.collectionView2 registerNib:[UINib nibWithNibName:COLLECTION2_CELL2 bundle:nil]
           forCellWithReuseIdentifier:COLLECTION2_CELL2];
    [self.collectionView2 registerNib:[UINib nibWithNibName:COLLECTION2_CELL3 bundle:nil]
           forCellWithReuseIdentifier:COLLECTION2_CELL3];
    [self.collectionView2 registerNib:[UINib nibWithNibName:COLLECTION2_CELL4 bundle:nil]
           forCellWithReuseIdentifier:COLLECTION2_CELL4];
    [self.collectionView2 registerNib:[UINib nibWithNibName:COLLECTION2_CELL5 bundle:nil]
           forCellWithReuseIdentifier:COLLECTION2_CELL5];
    [self.collectionView2 registerNib:[UINib nibWithNibName:RATE_CELL bundle:nil]
           forCellWithReuseIdentifier:RATE_CELL];
    [self.collectionView2 registerNib:[UINib nibWithNibName:AVATAR_CELL bundle:nil]
           forCellWithReuseIdentifier:AVATAR_CELL];
    [self.collectionView2 registerNib:[UINib nibWithNibName:@"CellName" bundle:nil]
           forCellWithReuseIdentifier:@"CellName"];
    [self.collectionView2 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GradientCell"];
    [self setup];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    if (collectionView == self.collectionView1) {
        return 1;
    }
    else {
        if (currentTab == 1) {
            return 2;
        }
        return currDetailInfo.count;
    }
}
#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.collectionView1) {
        return 4;
    }
    else if (currDetailInfo.count > 0) {
        if (currentTab == 1) {
            if (section == 0) {
                return self.goods_detail_info.logs_list.count;
            }
            else {
                return self.goods_detail_info.logs_info_list.count;
            }
        }
        else {
            CATEGORY *a = currDetailInfo[section];

            if (!a.children) {
                return 1;
            }
            return a.children.count;
        }
        
    }
    else {
        return 0;
    }
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    if (collectionView == self.collectionView1) {
        GoodsDetailSection2CollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION1_CELL forIndexPath:indexPath];
       
         [_cell.coverImage setBackgroundImage:[UIImage imageNamed:itemicons[indexPath.row]] forState:UIControlStateNormal];
        
        
        _cell.nameLabel.text = itemtitles[indexPath.row];
        if (indexPath.row == currentTab) {
            _cell.nameLabel.textColor = RGBCOLORV(0x999999);
            [_cell.coverImage setBackgroundImage:[UIImage imageNamed:itemiconsselect[indexPath.row]] forState:UIControlStateNormal];

            _cell.splitView.backgroundColor = MAIN_COLOR;
            firstcell = _cell;
        }
        cell = _cell;
    }
    else {
        if (currentTab == 0) {
            CATEGORY *c = currDetailInfo[indexPath.section];
            if (!c.children) {
                GoodsDetailMore1CollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION2_CELL1 forIndexPath:indexPath];
                //全部分开的cell

                _cell.textLabel1.text = c.name;
                _cell.textLabel2.text = c.value;
                [_cell.coverImageView setHidden:YES];
                if ([c.value isKindOfClass:[NSString class]]) {
                    _cell.textLabel2.text = c.value;
                }
                else {
                    _cell.textLabel2.text = @"无";
                }

                cell = _cell;
            }
            else {
                GoodsDetailMore2CollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION2_CELL2 forIndexPath:indexPath];
                //全部展示的cell

                CATEGORY *cl = [c.children objectAtIndex:indexPath.row];
                NSString *url = [Helper checkImgType:cl.img.small];
                [_cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    //        [cell.imageGoods sd_setImageWithURL:[NSURL URLWithString:url]];
                    NSLog(@"成功");
                    if (error) {
                        [_cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:cl.img.small]];
                    }
                }];
                [_cell.coverImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
                _cell.coverImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                _cell.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
                _cell.coverImageView.clipsToBounds = YES;


                cell = _cell;
            }

        }
        else if (currentTab == 1) {
            if (indexPath.section == 0) {
                GoodsDetailMoreLogListCollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION2_CELL3 forIndexPath:indexPath];
                NSDictionary *dic = [self.goods_detail_info.logs_list objectAtIndex:indexPath.row];
                

                _cell.textLabel1.text = dic[@"name"];
                _cell.textLabel2.text = dic[@"info"];
                cell = _cell;
            }
            else if (indexPath.section == 1) {
#pragma mark -生产过程

                GoodsDetailMoreLogInfoListCollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION2_CELL4 forIndexPath:indexPath];
                
                NSDictionary *c = [self.goods_detail_info.logs_info_list objectAtIndex:indexPath.row];
                _cell.iconView.backgroundColor = MAIN_COLOR;
                _cell.iconViewWidth.constant = 20;
                _cell.iconViewHeight.constant = 20;
                _cell.iconView.layer.cornerRadius = 10;
                _cell.splitView1.backgroundColor = MAIN_COLOR;
                
                _cell.textLabelTop.text = c[@"add_time"];
                _cell.textLabelCenter.text = c[@"name"];
                _cell.textLabelbuttom.text = c[@"info"];
               
                NSString *url = [Helper checkImgType:c[@"img"]];
                
                [_cell.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

                    if (error) {
                        [_cell.imageView sd_setImageWithURL:[NSURL URLWithString:c[@"img"]]];
                    }
                }];
                [_cell.imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
                _cell.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                _cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
                _cell.imageView.clipsToBounds = YES;


                cell = _cell;
            }
        }
        else if (currentTab == 2) {
            CATEGORY *c = currDetailInfo[indexPath.section];
            if ([c.name isEqualToString:@"地图"]) {
                GoodsDetailMoreWebViewCollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION2_CELL5 forIndexPath:indexPath];
                NSArray *lng_lat = [c.value componentsSeparatedByString:@","];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.shiku.com/wap/public/getmap.html?lon=%@&lat=%@", lng_lat[0], lng_lat[1]]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [_cell.webView loadRequest:request];
                //产地 地图展示
                cell = _cell;
            }
            else {
                GoodsDetailMore1CollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION2_CELL1 forIndexPath:indexPath];
                _cell.textLabel1.text = c.name;
                _cell.textLabel2.text = c.value;
                cell = _cell;
            }
        }
        else if (currentTab == 3) {
            CATEGORY *c = currDetailInfo[indexPath.section];
            NSLog(@"%@",c);
            if ([c.type isEqualToString:@"rate"]) {
                GoodsDetailRateViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:RATE_CELL forIndexPath:indexPath];
                _cell.title.text = c.name;

                cell = _cell;
            }
            else if ([c.type isEqualToString:@"avatar"]) {
                
                    GoodsDetailAvatarViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:AVATAR_CELL forIndexPath:indexPath];
                    _cell.textLabel1.text = c.name;
                    _cell.textLabel2.text = c.value;
                    cell = _cell;
               
//                if (![c.img.small isEqualToString:@""]) {
//                    [_cell.coverImageView setHidden:NO];
//                    [_cell.coverImageView sd_setImageWithURL:url(c.img.small) placeholderImage:img_placehold_long];
//                }
                
            }
//            else if([c.type isEqualToString:@"tags"]){
//                GoodsDetailMore1CollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION2_CELL1 forIndexPath:indexPath];
//                _cell.textLabel1.text = c.name;
//                UILabel* label= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 10)];
//                label.text=@"go";
//                [_cell.contentView addSubview:label];
//                cell=_cell;
//            }
            else if (!c.children) {
                if (!c.rich_value) {
                   
                    if (currentTab==3) {
                        static NSString * CellIdentifier = @"GradientCell";
                        UICollectionViewCell * _cell  = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
                        if ([c.name isEqualToString:@"标签"]) {
                            
                            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 50, 23)];
                            label.backgroundColor = [UIColor clearColor];
                            label.text = c.name;
                            label.textColor = [UIColor grayColor];
                            label.font = [UIFont systemFontOfSize:12];
                            [_cell addSubview:label];
                            //                        NSString * cellName = [NSString stringWithFormat:@"CellName"];
                            //                        UICollectionViewCell * Cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
                            //                        if (nil==Cell) {
                            //                        }
                            //
//                            _cell = c.name;
                            MultiTextView* showLable = [self TheLabelView:c.value];
                            [_cell addSubview:showLable];
                            cell = _cell;
                        }
                        else
                        {
                            GoodsDetailMore1CollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION2_CELL1 forIndexPath:indexPath];
                            _cell.textLabel1.text = c.name;
                            _cell.textLabel2.text = c.value;
                            
                            //                    if ([c.value isKindOfClass:[NSString class]]) {
                            //                        _cell.textLabel2.text = c.value;
                            //                    }
                            //                    else {
                            //                        _cell.textLabel2.text = @"无";
                            //                    }
                            cell = _cell;
                        }
                    }
                    else
                    {
                        
                        GoodsDetailMore1CollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION2_CELL1 forIndexPath:indexPath];
                        _cell.textLabel1.text = c.name;
                        _cell.textLabel2.text = c.value;
                        
                        //                    if ([c.value isKindOfClass:[NSString class]]) {
                        //                        _cell.textLabel2.text = c.value;
                        //                    }
                        //                    else {
                        //                        _cell.textLabel2.text = @"无";
                        //                    }
                        cell = _cell;
                    
                    }
                 
                }
                else {
                    GoodsDetailMoreWebViewCollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION2_CELL5 forIndexPath:indexPath];
                    _cell.backgroundColor = [UIColor redColor];
                    [_cell.webView loadHTMLString:c.rich_value baseURL:nil];
                    cell = _cell;
                }
            }
            else {
                GoodsDetailMore2CollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION2_CELL2 forIndexPath:indexPath];
                CATEGORY *cl = c.children[indexPath.row];
                [_cell.coverImageView sd_setImageWithURL:url(cl.img.small) placeholderImage:img_placehold_long];
                cell = _cell;
            }

        }
    }
    return cell;
}
//标签
-(MultiTextView *)TheLabelView:(NSString *)str
{
    NSMutableArray* setArray_f = [[NSMutableArray alloc] initWithCapacity:5];
    [setArray_f addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor],@"Color",[UIFont systemFontOfSize:14],@"Font",nil]];
    [setArray_f addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],@"Color",[UIFont systemFontOfSize:16],@"Font",nil]];
    [setArray_f addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],@"Color",[UIFont systemFontOfSize:14],@"Font",nil]];
    [setArray_f addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor greenColor],@"Color",[UIFont systemFontOfSize:18],@"Font",nil]];
    [setArray_f addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor],@"Color",[UIFont systemFontOfSize:14],@"Font",nil]];
    [setArray_f addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor purpleColor],@"Color",[UIFont systemFontOfSize:24],@"Font",nil]];
    
    MultiTextView* showLable = [[MultiTextView alloc] initWithFrame:CGRectMake(60,0,DeviceWidth-100,30)];
    NSArray * arr = [str componentsSeparatedByString:@","];
    if (arr.count>4) {
        showLable.frame =CGRectMake(60,0,DeviceWidth-100,60);
    }
    showLable.alignmentType = Muti_Alignment_Left_Type;
    [showLable setShowText:str Setting:setArray_f];
    return showLable;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    if (collectionView == self.collectionView1) {
        size = CGSizeMake((self.view.frame.size.width) / 4.0f, COLLECTION1_CELL_HEIGHT);
    }
    else {
        if (currentTab == 0 || currentTab == 3) {
            CATEGORY *c = [currDetailInfo objectAtIndex:indexPath.section];

            if (!(!c.rich_value || [c.rich_value isEqualToString:@""])) {//
                return CGSizeMake((self.view.frame.size.width), COLLECTION2_CELL2_HEIGHT);
            }
            if ([c.name isEqualToString:@"标签"]) {
                return CGSizeMake((self.view.frame.size.width), 60);
            }
            if (!c.children) {
                return CGSizeMake((self.view.frame.size.width), COLLECTION2_CELL1_HEIGHT);
            }
            return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height / 2);

        }
        else if (currentTab == 2) {
            CATEGORY *c = [currDetailInfo objectAtIndex:indexPath.section];

            if ([c.name isEqualToString:@"地图"]) {
                return CGSizeMake((self.view.frame.size.width), self.view.frame.size.width);
            }

            return CGSizeMake((self.view.frame.size.width), COLLECTION2_CELL1_HEIGHT);
        }
        else if (currentTab == 1) {
            if (indexPath.section == 0) {
                return CGSizeMake((self.view.frame.size.width), COLLECTION2_CELL1_HEIGHT);
            }
            else {
                
                return CGSizeMake((self.view.frame.size.width), screenSize.width/2);
               
            }
        }
        else return CGSizeMake((self.view.frame.size.width), COLLECTION2_CELL1_HEIGHT);
        
    }
   
    return size;
}

//定义section间 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets ei;

    if (currentTab == 1) {
        if (section == 0) {
            ei = UIEdgeInsetsMake(0, 0, 5, 0);
            collectionViewLayout.minimumLineSpacing = 0;
            collectionViewLayout.minimumInteritemSpacing = 0;
        }
        else {
            collectionViewLayout.minimumLineSpacing = 0;
            collectionViewLayout.minimumInteritemSpacing = 0;
            ei = UIEdgeInsetsZero;
        }

    }
    else {
        collectionViewLayout.minimumLineSpacing = 0;
        collectionViewLayout.minimumInteritemSpacing = 0;
        ei = UIEdgeInsetsZero;
    }

    return ei;
}

//设置页眉尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (collectionView == self.collectionView2) {

        if (currentTab == 0 || currentTab == 3) {
            if (currDetailInfo.count > 0) {
                CATEGORY *c = [currDetailInfo objectAtIndex:section];
                if (!c.children && !c.rich_value) {
                    return CGSizeZero;
                }
                else {
                    return CGSizeMake(screenSize.width, 50);
                }
            }
            else {
                return CGSizeZero;
            }
        }
        else {
            return CGSizeZero;
        }

    }
    return CGSizeZero;
}

//设置页脚尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headView;

    if (collectionView == self.collectionView2) {
        if (currentTab == 0 || currentTab == 3) {
            GoodsDetailMoreHeaderCollectionReusableView *_headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SECTION_HEADER_VIEW forIndexPath:indexPath];
            CATEGORY *c = [currDetailInfo objectAtIndex:indexPath.section];
            if ([kind isEqual:UICollectionElementKindSectionHeader]) {
                _headView.titleLabel1.text = c.name;
            }
            headView = _headView;
        }
    }
    return headView;
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"-------%ld--%ld",(long)indexPath.section,(long)indexPath.row);
    if (self.collectionView1 == collectionView) {
        GoodsDetailSection2CollectionViewCell *cell = (GoodsDetailSection2CollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];

        if (firstcell != nil && firstcell != cell) {
            firstcell.nameLabel.textColor = TEXT_COLOR_BLACK;
            [firstcell.coverImage setBackgroundImage:[UIImage imageNamed:itemicons[currentTab]] forState:UIControlStateNormal];
            firstcell.splitView.backgroundColor = WHITE_COLOR;
            firstcell = nil;
        }
        cell.nameLabel.textColor = MAIN_COLOR;
        [cell.coverImage setBackgroundImage:[UIImage imageNamed:itemiconsselect[indexPath.row]] forState:UIControlStateNormal];
        cell.splitView.backgroundColor = MAIN_COLOR;

        currentTab = indexPath.row;
        switch (indexPath.row) {
            case 0:
                currDetailInfo = self.goods_detail_info.item_info;
                break;
            case 1:
                currDetailInfo = self.goods_detail_info.logs_list;
                break;
            case 2:
                currDetailInfo = self.goods_detail_info.producer;
                break;
            case 3:
                currDetailInfo = self.goods_detail_info.score;
                break;
            default:
                break;

        }
        [self.collectionView2 reloadData];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"-------%ld--%ld",(long)indexPath.section,(long)indexPath.row);

    if (self.collectionView1 == collectionView) {
        GoodsDetailSection2CollectionViewCell *cell = (GoodsDetailSection2CollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
        cell.nameLabel.textColor = TEXT_COLOR_BLACK;
        [cell.coverImage setBackgroundImage:[UIImage imageNamed:itemicons[indexPath.row]] forState:UIControlStateNormal];
        NSLog(@"%@", itemicons[indexPath.row]);
        cell.splitView.backgroundColor = WHITE_COLOR;
    }
    
}

//返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}

@end
