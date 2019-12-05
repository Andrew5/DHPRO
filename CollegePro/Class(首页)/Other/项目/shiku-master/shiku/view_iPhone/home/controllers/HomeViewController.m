//
//  HomeViewController.m
//  shiku
//
//  Created by txj on 15/4/2.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "HomeViewController.h"
#import "CategoryViewController.h"


#define ADHEADER_HEIGHT 120.f
#define SECTION2_CELL_HEIGHT 120
#define SECTION3_CELL_HEIGHT 85
#define SECTION4_CELL_HEIGHT 180
#define SECTION5_CELL_HEIGHT 260

#define SECTION_HEADER_VIEW @"HomeSectionHeaderViewCell"
#define SECTION_FOOTER_VIEW @"SECTION_FOOTER_VIEW"

#define SECTION_CELL_1 @"AdHeaderCell"
#define SECTION_CELL_2 @"HomeSection2CollectionViewCell"
#define SECTION_CELL_3 @"HomeSection3CollectionViewCell"
#define SECTION_CELL_4 @"HomeSection4CollectionViewCell"
#define SECTION_CELL_4TypeTG @"HomeSection4TypeTGCollectionViewCell"
#define SECTION_CELL_4TypeXLB @"HomeSection4TypeXLBCollectionViewCell"
#define SECTION_CELL_4TypeXSG @"HomeSection4TypeXSGCollectionViewCell"


@interface HomeViewController ()

@end

@implementation HomeViewController
- (void)setup
{
    self.backend=[HomeBackend new];
    
//    [self loadData];
}
-(void)loadData
{
    [[self.backend requestHomeItems]
     subscribeNext:[self didLoadData]];
}
- (void(^)(RACTuple *))didLoadData
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        self.homeItem=(HomeItems *)parameters;
#pragma mark - CollectionView
        self.collectionView.backgroundColor=BG_COLOR;
        [self.collectionView reloadData];
//        if (self.datalist.count>0) {
//            [self.collectionView reloadData];
//            [ec.view removeFromSuperview];
//        }
//        else
//        {
//            ec=[EmptyViewController shared];
//            [self.view addSubview:[[EmptyViewController shared] view]];
//            ec.titleLabel.text=@"没有品位";
//            ec.iconLable.text=@"\U0000B01A";
//            ec.view.frame=self.navigationController.view.frame;
//            
//        }
        [self.collectionView.pullToRefreshView stopAnimating];
        [progressbar hide:YES];
    };
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    if (ISIOS7PLUS) {
//        self.automaticallyAdjustsScrollViewInsets=NO;
//        self.edgesForExtendedLayout=UIRectEdgeAll;
//    }
    
    [progressbar show:YES];
	
    nav = (UDNavigationController *)self.navigationController;
    [nav setAlph:1];
    
    #pragma mark - TopBar
    self.navigationItem.leftBarButtonItem=[self tBarIconButtonItem:@"\U0000A14A" action:@selector(leftBarButtonItemTouched)];
    self.navigationItem.rightBarButtonItem=[self tBarIconButtonItem:@"\U0000A08A" action:@selector(rightBarButtonItemTouched)];
    UIView *searchFieldView=[self tToolbarSearchField:SEARCH_FIELD_WIDTH withheight:40 isbecomeFirstResponder:NO action:@selector(searchFieldTouched) textFieldDelegate:self];
    searchFieldView.autoresizingMask=YES;
    self.navigationItem.titleView=searchFieldView;
    
    //修复ios8原生bug  4个cell中间会出现留白
    double offsetWidth=(NSInteger)screenSize.width%2;
    pointX=offsetWidth==0?0:(2-offsetWidth)/2;
    
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(-pointX, 0, screenSize.width+pointX*2, screenSize.height-65) collectionViewLayout:[UICollectionViewFlowLayout new]];
    self.collectionView.backgroundColor=BG_COLOR;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    
    [self.collectionView registerClass:[AdHeaderCollectionViewCell class] forCellWithReuseIdentifier:SECTION_CELL_1];
    
    [self.collectionView registerNib:[UINib nibWithNibName:SECTION_CELL_2 bundle:nil] forCellWithReuseIdentifier:SECTION_CELL_2];
    
    [self.collectionView registerNib:[UINib nibWithNibName:SECTION_CELL_3 bundle:nil] forCellWithReuseIdentifier:SECTION_CELL_3];
    
    [self.collectionView registerNib:[UINib nibWithNibName:SECTION_CELL_4 bundle:nil] forCellWithReuseIdentifier:SECTION_CELL_4];
    [self.collectionView registerNib:[UINib nibWithNibName:SECTION_CELL_4TypeTG bundle:nil] forCellWithReuseIdentifier:SECTION_CELL_4TypeTG];
    [self.collectionView registerNib:[UINib nibWithNibName:SECTION_CELL_4TypeXLB bundle:nil] forCellWithReuseIdentifier:SECTION_CELL_4TypeXLB];
    [self.collectionView registerNib:[UINib nibWithNibName:SECTION_CELL_4TypeXSG bundle:nil] forCellWithReuseIdentifier:SECTION_CELL_4TypeXSG];
    @weakify(self)
    [self.collectionView addPullToRefreshWithActionHandler:^{
        @strongify(self)
        [self loadData];
        CGPoint point = self.collectionView.contentOffset;
        point.y = 0;
        self.collectionView.contentOffset = point;
    }];
    [self.collectionView.pullToRefreshView setTitle:@"下拉刷新" forState:SVPullToRefreshStateStopped];
    [self.collectionView.pullToRefreshView setTitle:@"立即刷新" forState:SVPullToRefreshStateTriggered];
    self.collectionView.showsInfiniteScrolling = NO;
    
    [self setup];
}

#pragma mark - TopBar
-(void)leftBarButtonItemTouched
{
    CategoryViewController *cc=[[CategoryViewController alloc] initWithBackBtn];
    [self showNavigationViewMainColor:cc];
}
-(void)rightBarButtonItemTouched
{
//    InformationController *ifc=[InformationController new];
//    [self showNavigationView:ifc];
    
    static QRCodeReaderViewController *reader = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        reader                        = [QRCodeReaderViewController new];
        reader.modalPresentationStyle = UIModalPresentationFormSheet;
    });
    reader.delegate = self;
    
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        NSLog(@"Completion with result: %@", resultAsString);
    }];
    
    [self presentViewController:reader animated:YES completion:NULL];
}
-(void)searchFieldTouched
{
    SearchViewController *sc=[SearchViewController new];
    [self showNavigationViewMainColor:sc];
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫码" message:result delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section==0)
        return 1;
    
    else if(section==1)
        return self.homeItem.section1List.count;
//        return 8;
    else if(section==2)
        return 1;
    else if(section==3)
        return self.homeItem.section3List.count;
    return self.homeItem.section5List.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell * cell;
    //cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
    if(indexPath.section==0)
    {
        AdHeaderCollectionViewCell *_cell=[collectionView dequeueReusableCellWithReuseIdentifier:SECTION_CELL_1 forIndexPath:indexPath];
        _cell.AdItems=self.homeItem.section0List;
        _cell.delegate=self;
        [_cell bind];
        cell = _cell;
    }
    else if(indexPath.section==1)
    {
        HomeSection2CollectionViewCell * _cell = [collectionView dequeueReusableCellWithReuseIdentifier:SECTION_CELL_2 forIndexPath:indexPath];
        _cell.adItem=[self.homeItem.section1List objectAtIndex:indexPath.row];
        [_cell bind];
        cell=_cell;

    }
    else if(indexPath.section==2)
    {
        HomeSection3CollectionViewCell * _cell = [collectionView dequeueReusableCellWithReuseIdentifier:SECTION_CELL_3 forIndexPath:indexPath];
        _cell.aditem1=[self.homeItem.section2List objectAtIndex:0];
        _cell.aditem2=[self.homeItem.section4List objectAtIndex:0];
        [_cell bind];
        cell=_cell;
        
    }
    else if(indexPath.section==3)
    {
        AdItem *ai=[self.homeItem.section3List objectAtIndex:indexPath.row];
        if ([ai.adTypeInt intValue]==0) {
            HomeSection4TypeXSGCollectionViewCell * _cell = [collectionView dequeueReusableCellWithReuseIdentifier:SECTION_CELL_4TypeXSG forIndexPath:indexPath];
            _cell.aditem=ai;
            [_cell bind];
            cell=_cell;
        }
        else if([ai.adTypeInt intValue]==1) {
            HomeSection4TypeXLBCollectionViewCell * _cell = [collectionView dequeueReusableCellWithReuseIdentifier:SECTION_CELL_4TypeXLB forIndexPath:indexPath];
            _cell.aditem=ai;
            [_cell bind];
            cell=_cell;
        }
        else if([ai.adTypeInt intValue]==2) {
            HomeSection4TypeTGCollectionViewCell * _cell = [collectionView dequeueReusableCellWithReuseIdentifier:SECTION_CELL_4TypeTG forIndexPath:indexPath];
            _cell.aditem=ai;
            [_cell bind];
            cell=_cell;
        }
        else {
            HomeSection4CollectionViewCell * _cell = [collectionView dequeueReusableCellWithReuseIdentifier:SECTION_CELL_4 forIndexPath:indexPath];
            _cell.aditem=ai;
            [_cell bind];
            cell=_cell;
        }
        
    }

//    else if(indexPath.section==1)
//    {
//        HomeShipCollectionViewCell * _cell = [collectionView dequeueReusableCellWithReuseIdentifier:SECTION_CELL_2 forIndexPath:indexPath];
//        _cell.shipItem=[self.homeItem.shipList objectAtIndex:indexPath.row];
//        [_cell bind];
//        cell=_cell;
//        
//    }
//    else if(indexPath.section==2)
//    {
//        HomeNotifyCollectionViewCell * _cell = [collectionView dequeueReusableCellWithReuseIdentifier:SECTION_CELL_3 forIndexPath:indexPath];
//        _cell.items=self.homeItem.notifiList;
//        //cell.backgroundColor= [UIColor blackColor];
//        [_cell bind];
//        cell=_cell;
//    }
//    else if(indexPath.section==3)
//    {
//        ProductCategoryCell * _cell = [collectionView dequeueReusableCellWithReuseIdentifier:SECTION_CELL_4 forIndexPath:indexPath];
//        _cell.productCategory=[self.homeItem.hotsItemCateList objectAtIndex:indexPath.row];
//        [_cell bind];
//        cell=_cell;
//        
//    }
//    else if(indexPath.section==4)
//    {
//        ProductListCollectionViewCell * _cell = [collectionView dequeueReusableCellWithReuseIdentifier:SECTION_CELL_5 forIndexPath:indexPath];
//        //_cell.frame=CGRectMake(10, 10, cell.frame.size.width-20, cell.frame.size.height-20);
//        _cell.product=[self.homeItem.hotsItemList objectAtIndex:indexPath.row];
//        
//        [_cell bind];
//        cell=_cell;
//        
//    }
//    else {
//        ProductListCollectionViewCell * _cell = [collectionView dequeueReusableCellWithReuseIdentifier:SECTION_CELL_5 forIndexPath:indexPath];
//        cell.frame=CGRectMake(10, 10, cell.frame.size.width-20, cell.frame.size.height-20);
//        cell=_cell;
//    }
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if(indexPath.section==0)
    {
        size=CGSizeMake(CGRectGetWidth(collectionView.bounds), ADHEADER_HEIGHT);
    }
    else if(indexPath.section==1){
        size=CGSizeMake(CGRectGetWidth(collectionView.bounds)/4, SECTION2_CELL_HEIGHT);
    }
    else if(indexPath.section==2){
        size=CGSizeMake(CGRectGetWidth(collectionView.bounds), SECTION3_CELL_HEIGHT);
    }
    else if(indexPath.section==3){
        size=CGSizeMake(CGRectGetWidth(collectionView.bounds), screenSize.width/2+60);
    }
    else{
        size=CGSizeMake((screenSize.width-30)/2, SECTION5_CELL_HEIGHT);
    }
    return size;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets ei;
    
    if(section==3){
        ei=UIEdgeInsetsZero;
        collectionViewLayout.minimumLineSpacing=0;
        collectionViewLayout.minimumInteritemSpacing=0;
    }
    else if(section==2){
        ei=UIEdgeInsetsMake(10, 0, 10,0);
        collectionViewLayout.minimumLineSpacing=0;
        collectionViewLayout.minimumInteritemSpacing=0;
    }
    else
    {
        collectionViewLayout.minimumLineSpacing=0;
        collectionViewLayout.minimumInteritemSpacing=0;
        ei=UIEdgeInsetsZero;
    }
    
    return ei;
}
//设置页眉尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
//    if (section>=3) {
//        return CGSizeMake(screenSize.width, 30);
//    }
    return CGSizeMake(screenSize.width, 0);
}
//设置页脚尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
//    if (section>=2) {
//        return CGSizeMake(screenSize.width, 10);
//    }
    return CGSizeZero;
}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *headView;
//
//    if([kind isEqual:UICollectionElementKindSectionHeader])
//    {
//        HomeSectionHeaderViewCell *_headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SECTION_HEADER_VIEW forIndexPath:indexPath];
//        _headView.label.textColor=TEXT_COLOR;
//        if (indexPath.section==3) {
//            _headView.label.text=@"分类推荐";
//
//        }
//        else{
//            _headView.label.text=@"热门推荐";
//        }
//        headView=_headView;
//
//    }
//    else
//    {
//        headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SECTION_FOOTER_VIEW forIndexPath:indexPath];
//    }
//    //    else if([kind isEqual:UICollectionElementKindSectionFooter])
//    //    {
//    //        headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"hxwHeader" forIndexPath:indexPath];
//    //    }
//    return headView;
//}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        TopicViewController *gl=[TopicViewController new];
        [self showNavigationViewMainColor:gl];
    }
    else{
        GoodsListViewController *gl=[GoodsListViewController new];
        [self showNavigationViewMainColor:gl];
    }
//    if(indexPath.section==1)
//    {
//        
//        HomeShipCollectionViewCell * cell = (HomeShipCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        SearchBackendModel *sm=[[SearchBackendModel alloc] init];
//        //sm.shipTypeID=cell.shipItem.nid;
//        sm.shipTypeIDS=@"1,3,4";
//        
//        //        ProductListViewController *p=[[ProductListViewController alloc] initWithShipitem:cell.shipItem user:nil];
//        ProductListWithCategroyViewController *p=[[ProductListWithCategroyViewController alloc] initWithShipitem:cell.shipItem user:nil];
//        
//        [self showNavigationView:p];
//        //NSLog(cell.shipItem.title);
//    }
//    else if(indexPath.section==3)
//    {
//        ProductCategoryCell * cell = (ProductCategoryCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        ProductListViewController *p=[[ProductListViewController alloc] initWithProductCategory:cell.productCategory user:nil];
//        
//        [self showNavigationView:p];
//        //NSLog(cell.productCategory.name);
//    }
//    else if(indexPath.section==4)
//    {
//        ProductListCollectionViewCell * cell = (ProductListCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        
//        ProductDetailViewController *p=[[ProductDetailViewController alloc] initWithProductID:cell.product.productID user:self.user];
//        p.delegate=self;
//        
//        [self showNavigationView:p];
//        //NSLog(cell.product.name);
//    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}

//滚动图片单击
-(void)headerImageClicked:(NSInteger *)index
{
    TopicViewController *gl=[TopicViewController new];
    [self showNavigationViewMainColor:gl];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (scrollView.contentOffset.y<ADHEADER_HEIGHT) {
//        [nav setAlph:scrollView.contentOffset.y/300];
//    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        
        
//        self.searchModel.keywords=textField.text;
//        
//        ProductListViewController *plcv=[[ProductListViewController alloc] initWithSearchModel:self.searchModel user:self.user];
//        //[self showNavigationView:plcv];
//        [self.navigationController pushViewController:plcv animated:YES];
//        
//        //            在这里做你响应return键的代码
//        //            self.searchModel.keywords=textField.text;
//        //            [self doSearch];
//        //              [textField resignFirstResponder];
//        
//        
//        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

@end
