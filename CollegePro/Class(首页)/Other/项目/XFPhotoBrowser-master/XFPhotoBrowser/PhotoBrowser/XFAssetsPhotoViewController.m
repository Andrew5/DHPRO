//
//  XFAssetsPhotoViewController.m
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/5.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import "XFAssetsPhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "XFAssetsModel.h"
#import "XFSelectedAssetsViewController.h"
#import "XFAssetsCollectionViewCell.h"
#import "XFTakePhotoCollectionViewCell.h"
#import "XFAssetsModel.h"
#import "UIView+SDAutoLayout.h"
#import "XFHUD.h"
#import "XFAssetsLibraryModel.h"
#import "XFAssetsLibraryData.h"
#import "XFAssetsLibraryAccessFailureView.h"
#import "XFPhotoAlbumViewController.h"
#import "XFCameraViewController.h"
#import "XFBrowerViewController.h"

static NSString *firstItemIdentifier = @"XFTakePhotoCollectionViewCell";
static NSString *aidentifier = @"XFAssetsCollectionViewCell";

@interface XFAssetsPhotoViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) XFSelectedAssetsViewController *selectedAssetsView;

@property (strong, nonatomic) NSMutableArray *groupArray;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *selectedArray;

@property (strong, nonatomic) XFBrowerViewController *browerViewController;
@end

@implementation XFAssetsPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:firstItemIdentifier bundle:nil] forCellWithReuseIdentifier:firstItemIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:aidentifier bundle:nil] forCellWithReuseIdentifier:aidentifier];
    
    self.browerViewController = (XFBrowerViewController *)self.navigationController;
    
    self.selectedAssetsView = [XFSelectedAssetsViewController makeView];
    self.selectedAssetsView.maxPhotosNumber = self.browerViewController.maxPhotosNumber;
    XFWeakSelf;
    self.selectedAssetsView.deleteAssetsBlock = ^(XFAssetsModel *model) {
        [wself.selectedArray removeObject:model];
        for ( XFAssetsModel *dmodel in wself.dataArray ) {
            if ( [dmodel.modelID isEqual:model.modelID] ) {
                dmodel.selected = false;
                break;
            }
        }
        [wself.collectionView reloadData];
    };
    self.selectedAssetsView.confirmBlock = ^() {
        if ( wself.browerViewController.callback ) {
            wself.browerViewController.callback([wself.selectedArray copy]);
            [wself didCancelBarButtonAction];
        }
    };
    [self.bottomView addSubview:self.selectedAssetsView.view];
    [self addChildViewController:self.selectedAssetsView];
    self.selectedAssetsView.view.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    if ( !self.assetsGroup ) {
        [self setupData];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assetsLibraryChange) name:ALAssetsLibraryChangedNotification object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(didCancelBarButtonAction)];
}

- (void)didCancelBarButtonAction {
    [self dismissViewControllerAnimated:true completion:^{
        self.browerViewController = nil;
    }];
}

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup {
    _assetsGroup = assetsGroup;
    self.title = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    XFWeakSelf;
    [XFAssetsLibraryData getAssetsWithGroup:assetsGroup successBlock:^(NSArray *array) {
        [wself.dataArray removeAllObjects];
        [wself.dataArray addObjectsFromArray:array];
        [XFHUD dismiss];
        [wself.collectionView reloadData];
    }];
}

- (void)assetsLibraryChange {
//    NSLog(@"通知方法");
    
    XFWeakSelf;
    [self.groupArray removeAllObjects];
    
    [XFAssetsLibraryData getLibraryGroupWithSuccess:^(NSArray *array) {
        [wself.groupArray addObjectsFromArray:array];
        wself.title = [[wself.groupArray.firstObject group] valueForProperty:ALAssetsGroupPropertyName];
        [XFAssetsLibraryData getAssetsWithGroup:[wself.groupArray.firstObject group] successBlock:^(NSArray *array) {
            
            [wself.dataArray removeAllObjects];
            [wself.dataArray addObjectsFromArray:array];
            [XFHUD dismiss];
            
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[wself.selectedArray copy]];
            for ( XFAssetsModel *smodel in wself.selectedArray ) {
                for ( XFAssetsModel *cmodel in wself.dataArray ) {
                    if ( [smodel.modelID isEqual:cmodel.modelID] ) {
                        cmodel.selected = true;
                        smodel.selected = true;
                    }
                }
                if ( !smodel.selected ) {
                    [tempArray removeObject:smodel];
                }
            }
            if ( tempArray.count != wself.selectedArray.count ) {
                [wself.selectedArray removeAllObjects];
                [wself.selectedArray addObjectsFromArray:tempArray];
            }
            [wself.collectionView reloadData];
        }];
    } failBlcok:^(NSError *error) {
        [XFHUD dismiss];
        XFAssetsLibraryAccessFailureView *view = [XFAssetsLibraryAccessFailureView makeView];
        [wself.view addSubview:view];
        view.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    }];
}

#pragma mark - 初始化数据
- (void)setupData {
    XFWeakSelf;
    
    [self.groupArray removeAllObjects];
    [XFAssetsLibraryData getLibraryGroupWithSuccess:^(NSArray *array) {
        [wself.groupArray addObjectsFromArray:array];
        wself.title = [[wself.groupArray.firstObject group] valueForProperty:ALAssetsGroupPropertyName];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHGROUP" object:[wself.groupArray copy]];
        [XFAssetsLibraryData getAssetsWithGroup:[wself.groupArray.firstObject group] successBlock:^(NSArray *array) {
            [wself.dataArray removeAllObjects];
            [wself.dataArray addObjectsFromArray:array];
            [XFHUD dismiss];
            
            if ( wself.browerViewController.selectedAssets ) {
                for ( XFAssetsModel *smodel in wself.browerViewController.selectedAssets ) {
                    for ( XFAssetsModel *cmodel in wself.dataArray ) {
                        if ( [smodel.modelID isEqual:cmodel.modelID] ) {
                            cmodel.selected = true;
                        }
                    }
                }
                
                [wself.selectedArray removeAllObjects];
                [wself.selectedArray addObjectsFromArray:wself.browerViewController.selectedAssets];
                
                [wself.selectedAssetsView addModelWithData:wself.browerViewController.selectedAssets];
                
                wself.browerViewController.selectedAssets = nil;
            }
            
            [wself.collectionView reloadData];
        }];
        
    } failBlcok:^(NSError *error) {
        [XFHUD dismiss];
        XFAssetsLibraryAccessFailureView *view = [XFAssetsLibraryAccessFailureView makeView];
        [wself.view addSubview:view];
        view.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ( 0 == indexPath.item ) {
        XFTakePhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:firstItemIdentifier forIndexPath:indexPath];
        return cell;
    }else {
        XFAssetsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:aidentifier forIndexPath:indexPath];
        XFAssetsModel *model = self.dataArray[indexPath.item - 1];
        cell.model = model;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ( 0 == indexPath.item ) {
        XFWeakSelf;
        XFCameraViewController *cameraViewController = [XFCameraViewController new];
        cameraViewController.takePhotosBlock = ^(XFAssetsModel *pmodel) {
        
            [wself.selectedArray addObject:pmodel];
            [wself.selectedAssetsView addModelWithData:@[pmodel]];
            
            [collectionView reloadData];
        };
        [self presentViewController:cameraViewController animated:true completion:nil];
    }else {
        
        if ( self.browerViewController.maxPhotosNumber == 0 ) {
            [self changeDataWithIndexPath:indexPath];
        }else {
            XFAssetsModel *model = self.dataArray[indexPath.item - 1];
            
            if ( model.selected ) {
                [self changeDataWithIndexPath:indexPath];
            }else {
                if ( self.selectedArray.count < self.browerViewController.maxPhotosNumber ) {
                    [self changeDataWithIndexPath:indexPath];
                }else {
                    [XFHUD overMaxNumberWithNumber:self.browerViewController.maxPhotosNumber];
                }
            }
        }
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(4.f, 4.f, 4.f, 4.f);
}

- (void)changeDataWithIndexPath:(NSIndexPath *)indexPath {
    
    XFAssetsModel *model = self.dataArray[indexPath.item - 1];
    
    if ( model.selected ) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self.selectedArray copy]];
        for ( XFAssetsModel *smodel in self.selectedArray) {
            if ( [smodel.modelID isEqual:model.modelID] ) {
                [tempArray removeObject:smodel];
            }
        }
        [self.selectedArray removeAllObjects];
        [self.selectedArray addObjectsFromArray:[tempArray copy]];
        [self.selectedAssetsView deleteModelWithData:@[model]];
    }else {
        [self.selectedArray addObject:model];
        [self.selectedAssetsView addModelWithData:@[model]];
    }
    model.selected = !model.selected;
    [self.collectionView reloadData];
}

- (NSMutableArray *)dataArray {
    if ( !_dataArray ) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)selectedArray {
    if ( !_selectedArray ) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

- (NSMutableArray *)groupArray {
    if ( !_groupArray ) {
        _groupArray = [NSMutableArray array];
    }
    return _groupArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.dataArray removeAllObjects];
    self.dataArray = nil;
    
    [self.selectedArray removeAllObjects];
    self.selectedArray = nil;
    
    [self.groupArray removeAllObjects];
    self.groupArray = nil;
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
