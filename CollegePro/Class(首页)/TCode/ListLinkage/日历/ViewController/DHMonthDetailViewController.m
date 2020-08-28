//
//  DHMonthDetailViewController.m
//  CollegePro
//
//  Created by jabraknight on 2019/7/4.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "DHMonthDetailViewController.h"
#import "HDMonthDetailCollectionViewCell.h"
#import "HDCollectionMonthDetailHeaderView.h"
#import "NSDate+HDExtension.h"
#import "Masonry.h"

static NSString *identifierCell = @"identifierCell";
static NSString *identifierHeader = @"identifierHeader";
@interface DHMonthDetailViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *days;
@end

@implementation DHMonthDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self hd_monthDetailCollectionConstraints];
    [self.collectionView registerClass:[HDMonthDetailCollectionViewCell class] forCellWithReuseIdentifier:identifierCell];
    [self.collectionView registerClass:[HDCollectionMonthDetailHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifierHeader];

    [self dataSourceDealing];
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(60.0, 80.0);
        layout.headerReferenceSize = CGSizeMake(0, 40);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (void)dataSourceDealing
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger year = [calendar component:(NSCalendarUnitYear) fromDate:[NSDate date]];
    
    self.days = [NSMutableArray arrayWithCapacity:self.months.count];
    for (int i = 0; i < self.months.count; i++) {
        NSInteger days = [NSDate howManyDaysInThisYear:year withMonth:self.months.count - i];
        if (i == 0) {
            NSInteger day = [calendar component:(NSCalendarUnitDay) fromDate:[NSDate date]];
            days = MIN(days, day);
        }
        [self.days addObject:@(days)];
    };
}
#pragma mark - constraints
- (void)hd_monthDetailCollectionConstraints
{
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.months.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.days[section]integerValue];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HDMonthDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    
    NSInteger days = [self.days[indexPath.section]integerValue];
    
    cell.topLabel.text = @(days - indexPath.item).stringValue;
    cell.bottomLabel.text = self.months[indexPath.section];
    
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        HDCollectionMonthDetailHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifierHeader forIndexPath:indexPath];
        headerView.label.text = self.months[indexPath.section];
        
        return headerView;
    }
    return nil;
}
- (void)collectionViewScrollToItemAtIndexpath:(NSIndexPath *)indexPath
{
    //    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionTop) animated:YES];
    UICollectionViewLayoutAttributes *attributes = [_collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    CGRect rect = attributes.frame;
    [_collectionView setContentOffset:CGPointMake(_collectionView.frame.origin.x, rect.origin.y - 100.0) animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSIndexPath *indexPath = [_collectionView indexPathsForVisibleItems].firstObject;
    
    if (_delegate && [_delegate respondsToSelector:@selector(monthDetailCollectionView:didScrollToIndexPath:)]) {
        [_delegate monthDetailCollectionView:_collectionView didScrollToIndexPath:indexPath];
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
