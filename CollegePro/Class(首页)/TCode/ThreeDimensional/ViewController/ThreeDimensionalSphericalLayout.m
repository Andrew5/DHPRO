//
//  ThreeDimensionalSphericalLayout.m
//  CollegePro
//
//  Created by jabraknight on 2019/8/12.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "ThreeDimensionalSphericalLayout.h"
#import "SphericaLayout.h"
@interface ThreeDimensionalSphericalLayout ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation ThreeDimensionalSphericalLayout

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}
- (void)createUI{
    SphericaLayout *sphericalLayout = [SphericaLayout alloc];
    UICollectionView * collect  = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DH_DeviceWidth, DH_DeviceHeight) collectionViewLayout:sphericalLayout];
    collect.delegate=self;
    collect.dataSource=self;
    //这里设置的偏移量是为了无缝进行循环的滚动，具体在上一篇博客中有解释
    collect.contentOffset = CGPointMake(DH_DeviceWidth, DH_DeviceHeight);
    [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [self.view addSubview:collect];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//我们返回30的标签
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 30;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    label.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    [cell.contentView addSubview:label];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<200) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y+10*400);
    }else if(scrollView.contentOffset.y>11*400){
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y-10*400);
    }
    if (scrollView.contentOffset.x<160) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x+10*320,scrollView.contentOffset.y);
    }else if(scrollView.contentOffset.x>11*320){
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x-10*320,scrollView.contentOffset.y);
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
