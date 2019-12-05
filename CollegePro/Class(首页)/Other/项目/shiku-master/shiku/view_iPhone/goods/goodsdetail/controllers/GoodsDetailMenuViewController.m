object_getClassName//
//  GoodsDetailMenuViewController.m
//  shiku
//
//  Created by txj on 15/5/21.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "GoodsDetailMenuViewController.h"
#define SECTION_HEADER_VIEW @"GoodsDetailMenuHeaderCollectionReusableView"

#define COLLECTION_CELL1 @"GoodsDetailMenuCollectionViewCell"



@interface GoodsDetailMenuViewController ()
{
    NSString *selectName;
}

@end

@implementation GoodsDetailMenuViewController
- (id)initWithGoods:(GOODS *) anGoods
{
    self = [self init];
    if (self) {
        self.goods=anGoods;
        self.backend=[CartBackend new];
        canSubmit=NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_modalView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];

    _modalView2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideInView)];
    [_modalView2 addGestureRecognizer:tapGesture];
    //确认🔘事件
    [self.buttomBtn setBackgroundColor:MAIN_COLOR];
    [self.buttomBtn addTarget:self action:@selector(buttomBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.closeBtn addTarget:self action:@selector(hideInView) forControlEvents:UIControlEventTouchUpInside];
    
    self.coverImageView.layer.cornerRadius=5;
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    [self.collectionView registerNib:[UINib nibWithNibName:SECTION_HEADER_VIEW bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SECTION_HEADER_VIEW];
    
    [self.collectionView registerNib:[UINib nibWithNibName:COLLECTION_CELL1 bundle:nil] forCellWithReuseIdentifier:COLLECTION_CELL1];

    self.priceLabel.textColor=MAIN_COLOR;
    self.priceLabel.text=[NSString stringWithFormat:@"￥%@",self.goods.shop_price];
    
    [self.coverImageView sd_setImageWithURL:url(self.goods.img.small) placeholderImage:img_placehold];
    
    self.stepperButton.NumDecimals =0;
#pragma mark -更改过
    
    if (!self.goods.goods_attr.count == 0) {
        stocks=[self.goods.good_stocks integerValue];
        self.stocksLabel.text=[NSString stringWithFormat:@"库存：%ld件",(long)stocks];
        if (stocks>0) {
            canSubmit=YES;
             self.stepperButton.Current=1;
            self.stepperButton.Minimum=1;
            self.stepperButton.Maximum = stocks;
        }
        else
        {
            self.stepperButton.Current=0;
            self.stepperButton.Minimum=0;
            self.stepperButton.Maximum = stocks;
            canSubmit=NO;
        }
    }
    
    else{
        self.stepperButton.Current=1;
        stocks=[self.goods.good_stocks integerValue];
        self.stocksLabel.text=[NSString stringWithFormat:@"库存：%ld件",(long)stocks];
        if (stocks>0) {
            canSubmit=YES;
        }
    }

    [self.collectionView reloadData];
    
//    if (self.goods.goods_attr.count<=0) {
//        stocks=[self.goods.good_stocks integerValue];
//        self.stocksLabel.text=[NSString stringWithFormat:@"库存：%ld件",(long)stocks];
//        if (stocks>0) {
//            canSubmit=YES;
//             self.stepperButton.Current=1;
//            self.stepperButton.Minimum=1;
//            self.stepperButton.Maximum = stocks;
//        }
//        else
//        {
//             self.stepperButton.Current=0;
//            self.stepperButton.Minimum=0;
//            self.stepperButton.Maximum = stocks;
//            canSubmit=NO;
//        }
//    }
//    [self.collectionView reloadData];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    goodsNum = 1;
}
#pragma mark 加入购物车点击
-(void)buttomBtnTapped
{
    
    if (self.goods.goods_attr.count>0&&!currentSelectCategory) {
        [self.view showHUD:@"请选择规格" afterDelay:1];
    }

    else if (canSubmit&&_stocksLabel.text) {
//        goodsNum++;
        [self Showprogress];
        [[self.backend requestAddItemToCart:currentSelectCategory andGoodsId:self.goods.goods_id andGoodsNum:goodsNum WithUser:nil]
         subscribeNext:[self didUpdate:@"添加到购物车成功"]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChange:) name:@"nameValueChangeNotification" object:nil ];

    }
    
}
//监听到对应通知后所要执行的方法
-(void)doChange:(NSNotification*)notification
{
//    self.myHomeVc.tabBarItem.badgeValue =@"2000";
    ;
    for (UIView *viewTab in self.navigationController.navigationBar.subviews) {
        for (UIView *subview in viewTab.subviews) {
            NSString *strClassName = [NSString stringWithUTF8String:object_getClassName(subview)];
            if ([strClassName isEqualToString:@"UITabBarButtonBadge"] ||
                [strClassName isEqualToString:@"_UIBadgeView"]) {
                //从原视图上移除
                [subview removeFromSuperview];
                //
//                [self addSubview:subview];
                subview.frame = CGRectMake(self.view.frame.size.width-subview.frame.size.width, 0,
                                           subview.frame.size.width, subview.frame.size.height);
//                return subview;
            }
        }
    }

}
- (void(^)(RACTuple *))didUpdate:(NSString *)text
{
    @weakify(self)
    return ^(RACTuple *parameters) {
        @strongify(self)
        ResponseResult *rs=(ResponseResult *)parameters;
        [self hideHUDView];
        if (rs.success) {
            if ([self.delegate respondsToSelector:@selector(didAddToCartSuccessWithGoodsNum:)]) {
            
                [self.delegate didAddToCartSuccessWithGoodsNum:goodsNum];
            }
            [self hideInView];
        }
        else{
            [self.view showHUD:rs.messge afterDelay:2];
        }
        
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Presentation

- (IBAction)textSteperTapped:(id)sender {
    
    if (self.stepperButton.TypeChange == TextStepperFieldChangeKindNegative) {
        
        if ([self.goods.good_stocks integerValue]>=goodsNum) {
            if (goodsNum>0) {
                goodsNum--;
            }
            canSubmit=YES;
        }
        else
        {
            canSubmit=NO;
        }
        
    }
    else {
        
        if ([self.goods.good_stocks integerValue]>goodsNum) {
            goodsNum++;
            canSubmit=YES;
        }
        else
        {
            canSubmit=NO;
            
        }
    }

}

- (void) showInView:(UIView*)view
{
    goodsNum = 1;
    //  1. Hide the modal
    [[self modalView] setAlpha:0];
    
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
         [[self modalView] setAlpha:1.0];
         
         //  Slide the buttons into place
         [[self containerView] setTransform:CGAffineTransformIdentity];
         
     }
     completion:^(BOOL finished) {
         _visible = YES;
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
         [[self modalView] setAlpha:0.0];
         
         //  Slide the buttons into place
         
         t = CGAffineTransformTranslate(t, 0, [[self containerView] frame].size.height);
         [[self containerView] setTransform:t];
         
     }
     
     completion:^(BOOL finished) {
         [[self view] removeFromSuperview];
         _visible = NO;
         _shrunkView=nil;
         if ([self.delegate respondsToSelector:@selector(hideFinished)]) {
             [self.delegate hideFinished];
         }
     }];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.goods.goods_attr.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//页眉页脚展示的内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headView;
    
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        GoodsDetailMenuHeaderCollectionReusableView *_headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SECTION_HEADER_VIEW forIndexPath:indexPath];
        _headView.titleLabel1.text=@"规格";
        _headView.titleLabel1.textAlignment = NSTextAlignmentCenter;
        headView=_headView;
        
    }
//    else
//    {
//        headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SECTION_FOOTER_VIEW forIndexPath:indexPath];
//    }
//    //    else if([kind isEqual:UICollectionElementKindSectionFooter])
//    //    {
//    //        headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"hxwHeader" forIndexPath:indexPath];
//    //    }
    return headView;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell * cell;
    //cell.backgroundColor = [UIColor colorWithRed:((10 * indexPath.row) / 255.0) green:((20 * indexPath.row)/255.0) blue:((30 * indexPath.row)/255.0) alpha:1.0f];
//    if(indexPath.section==0)
//    {
    GoodsDetailMenuCollectionViewCell *_cell=[collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION_CELL1 forIndexPath:indexPath];
    
    if(self.goods.goods_attr)
    {
      CATEGORY *cate =[self.goods.goods_attr objectAtIndex:indexPath.row];
      _cell.titleLabel1.text=cate.name;
      _cell.titleLabel1.lineBreakMode = NSLineBreakByWordWrapping;
      _cell.titleLabel1.numberOfLines = 0;
      _cell.titleLabel1.textAlignment = NSTextAlignmentCenter;

    }
    else
    {
        _cell.titleLabel1.text=@"默认";
    }
    
//        _cell.AdItems=self.homeItem.section1List;
//        _cell.delegate=self;
//        [_cell bind];
    cell = _cell;
//    }
//    else if(indexPath.section==1)
//    {
//        HomeShipCollectionViewCell * _cell = [collectionView dequeueReusableCellWithReuseIdentifier:SECTION_CELL_2 forIndexPath:indexPath];
//        _cell.shipItem=[self.homeItem.section2List objectAtIndex:indexPath.row];
//        [_cell bind];
//        cell=_cell;
//        
//    }
//    else if(indexPath.section==2)
//    {
//        Section3CollectionViewCell * _cell = [collectionView dequeueReusableCellWithReuseIdentifier:SECTION_CELL_3 forIndexPath:indexPath];
//        _cell.aditems=self.homeItem.section3List;
//        _cell.delegate=self;
//        [_cell bind];
//        cell=_cell;
//    }
//    else if(indexPath.section==3)
//    {
//        Section4CollectionViewCell * _cell = [collectionView dequeueReusableCellWithReuseIdentifier:SECTION_CELL_4 forIndexPath:indexPath];
//        _cell.aditem=[self.homeItem.section4List objectAtIndex:indexPath.row];
//        [_cell bind];
//        cell=_cell;
//        
//    }
//    else if(indexPath.section==4)
//    {
//        Section5CollectionViewCell * _cell = [collectionView dequeueReusableCellWithReuseIdentifier:SECTION_CELL_5 forIndexPath:indexPath];
//        _cell.aditem=[self.homeItem.section5List objectAtIndex:indexPath.row];
//        [_cell bind];
//        cell=_cell;    }
//    else if(indexPath.section==5)
//    {
//        Section6CollectionViewCell * _cell = [collectionView dequeueReusableCellWithReuseIdentifier:SECTION_CELL_6 forIndexPath:indexPath];
//        _cell.aditems=self.homeItem.section6List;
//        _cell.delegate=self;
//        [_cell bind];
//        cell=_cell;
//    }
//    else {
//        ProductListV2CollectionViewCell * _cell = [collectionView dequeueReusableCellWithReuseIdentifier:SECTION_CELL_7 forIndexPath:indexPath];
//        _cell.product=[self.homeItem.section7List objectAtIndex:indexPath.row];
//        _cell.product.rowindex=indexPath.row;
//        _cell.product.rowTotalCount=self.homeItem.section7List.count;
//        //        NSLog([NSString stringWithFormat:@"%d",indexPath.row]);
//        [_cell bind];
//        cell=_cell;
//    }
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
////定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size;
    size=CGSizeMake(CGRectGetWidth(collectionView.bounds)/5,40);
    return size;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGSize size;
////    if(indexPath.section==0)
////    {
//        size=CGSizeMake(20,40);
////    }
////    else if(indexPath.section==1){
////        size= CGSizeMake(CGRectGetWidth(collectionView.bounds)/4, SECTION2_CELL_HEIGHT);
////    }
////    else if(indexPath.section==2){
////        size=CGSizeMake(CGRectGetWidth(collectionView.bounds), SECTION3_CELL_HEIGHT-20);
////    }
////    else if(indexPath.section==3){
////        size=CGSizeMake(CGRectGetWidth(collectionView.bounds)/3.0f, SECTION4_CELL_HEIGHT);
////    }
////    else if(indexPath.section==4){
////        size=CGSizeMake(CGRectGetWidth(collectionView.bounds), SECTION3_CELL_HEIGHT);
////    }
////    else if(indexPath.section==5){
////        size=CGSizeMake(screenSize.width+2, SECTION3_CELL_HEIGHT);
////    }
////    else{
////        size=CGSizeMake(CGRectGetWidth(collectionView.bounds)/2, SECTION7_CELL_HEIGHT);
////    }
//    return size;
//}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    //    if(section==3){
    //        return 1;
    //    }
    //    else if(section==6)
    //        return 2;
    return 0;
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    //    if(section==3){
    //        return 1;
    //    }
    return 10;
}
//定义section间 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //    UIEdgeInsets ei;
    
    //    if(section==4){
    //        ei=UIEdgeInsetsMake(10, 10, 10,10);
    //    }
    //    else if(section==2){
    //        ei=UIEdgeInsetsMake(0, 0, 0,0);
    //    }
    //    else
    //    {
    //        ei=UIEdgeInsetsZero;
    //    }
    
    return UIEdgeInsetsMake(10, 10, 10,10);
}
//设置页眉尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    //    if (section==6) {
    //        return CGSizeMake(screenSize.width, 25);
    //    }
    return CGSizeMake(screenSize.width, 40);
}
//设置页脚尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
//    if (section>=1&&section<=5) {
//        return CGSizeMake(screenSize.width, 8);
//    }
    return CGSizeZero;
}
#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    currentSelectCategory = nil;
    GoodsDetailMenuCollectionViewCell * cell = (GoodsDetailMenuCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    currentSelectCategory=[self.goods.goods_attr objectAtIndex:indexPath.row];
    if (self.goods.goods_attr.count>0) {
        stocks=[self.goods.good_stocks integerValue];

//        stocks=[self.goods.good_stocks integerValue]/[currentSelectCategory.value integerValue];
        self.stocksLabel.text=[NSString stringWithFormat:@"库存：%ld件",(long)stocks];
        self.stepperButton.Minimum=1;
        self.stepperButton.Maximum = stocks;
    
        cell.backgroundColor=MAIN_COLOR;
        canSubmit=YES;

    }
    else
    {
        stocks=[self.goods.good_stocks integerValue]/[currentSelectCategory.value integerValue];

//        stocks=[self.goods.good_stocks integerValue];
        self.stocksLabel.text=[NSString stringWithFormat:@"库存：%ld件",(long)stocks];
        self.stepperButton.Minimum=1;
        self.stepperButton.Maximum = stocks;
        cell.backgroundColor=MAIN_COLOR;
        canSubmit=NO;

    }
    NSLog(@"---%@",cell.titleLabel1.text);
//    if (stocks<0) {
//        [[self.backend requestAddItemToCart:currentSelectCategory andGoodsId:self.goods.goods_id andGoodsNum:goodsNum==0?1:goodsNum WithUser:nil]
//         subscribeNext:[self didUpdate:@"添加到购物车成功"]];
//    }else{
//        [self.view showHUD:@"库存不足" afterDelay:1];
//
//    }


}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailMenuCollectionViewCell * cell = (GoodsDetailMenuCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor=WHITE_COLOR;
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}

@end
