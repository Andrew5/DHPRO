//
//  HomeViewController.m
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/5.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import "HomeViewController.h"
#import "XFBrowerViewController.h"
#import "XFHUD.h"
#import "XFHomeCollectionViewCell.h"
#import "XFAssetsModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "XFAssetsLibraryAccessFailureView.h"
#import "SDAutoLayout.h"
#import "BANetManager.h"
#import "XFPreviewViewController.h"

static NSString *identifier = @"XFHomeCollectionViewCell";

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButton;

@property (strong, nonatomic) NSMutableArray<XFAssetsModel *> *dataArray;
@property (assign, nonatomic) BOOL isEdit;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = RGB(48, 48, 48);
    NSDictionary *titleTextAttributesDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:17.f],NSFontAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes = titleTextAttributesDict;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];
    
    self.isEdit = NO;
    
    [self.navigationController preferredStatusBarStyle];
}

#pragma mark - 上传图片
- (IBAction)didUploadImageAction {
    
    [XFHUD showWithContent:@"这部分直接看代码"];
//    //这里考虑到很多服务器都是1张1张的上传所以直接就遍历数组然后直接1个1个的上传
//     NSString *url = @"";
//     for (XFAssetsModel *model in self.dataArray) {
////         //这里可以自己在封装一层动态设置图片压缩的比例,动态选择上传的图片是缩略图或者原图,也可以直接进入上传方法里面修改
//         [BANetManager ba_uploadImageWithUrlString:url parameters:nil withImageArray:@[model.asset] withSuccessBlock:^(id response) {
//             
//         } withFailurBlock:^(NSError *error) {
//             
//         } withUpLoadProgress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
//             
//         }];
//     }
}

- (IBAction)didRightBarButtonAction {
    self.isEdit = !self.isEdit;
    self.rightBarButton.title = self.isEdit?@"完成":@"编辑";
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ( [collectionView numberOfItemsInSection:indexPath.section] - 1 == indexPath.item ) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 75, 75)];
        label.font = [UIFont fontWithName:@"light" size:33];
        label.text = @"+";
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
    }else {
        XFHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        XFAssetsModel *model = self.dataArray[indexPath.item];
        [cell setupModel:model index:indexPath.item];
        cell.deleteButton.hidden = !self.isEdit;
        XFWeakSelf;
        cell.deleteBlock = ^(XFAssetsModel *dmodel) {
            [wself.collectionView performBatchUpdates:^{
                [wself.collectionView deleteItemsAtIndexPaths:@[indexPath]];
                [wself.dataArray removeObject:model];
                if ( !wself.dataArray.count ) {
                    [wself didRightBarButtonAction];
                }
            } completion:^(BOOL finished) {
                [wself.collectionView reloadData];
            }];
        };
        cell.longPressBlock = ^(UILongPressGestureRecognizer *longPress) {
            switch (longPress.state) {
                case UIGestureRecognizerStateBegan:{
                    //判断手势落点位置是否在路径上
                    NSIndexPath *cindexPath = [wself.collectionView indexPathForItemAtPoint:[longPress locationInView:wself.collectionView]];
                    if (indexPath == nil) {
                        break;
                    }
                    //在路径上则开始移动该路径上的cell
                    [wself.collectionView beginInteractiveMovementForItemAtIndexPath:cindexPath];
                }
                    break;
                case UIGestureRecognizerStateChanged: {
                    //移动过程当中随时更新cell位置

                    NSIndexPath *cindexPath = [wself.collectionView indexPathForItemAtPoint:[longPress locationInView:wself.collectionView]];
                    if ( cindexPath.item != self.dataArray.count ) {
                        [wself.collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:wself.collectionView]];
                    }
                }
                    break;
                case UIGestureRecognizerStateEnded:
                    //移动结束后关闭cell移动
                    [wself.collectionView endInteractiveMovement];
                    break;
                default:
                    [wself.collectionView cancelInteractiveMovement];
                    [wself.collectionView reloadData];
                    break;
            }
        };
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ( self.dataArray.count == indexPath.item ) {
        
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if ( author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied ){
            XFAssetsLibraryAccessFailureView *view = [XFAssetsLibraryAccessFailureView makeView];
            [view show];
        }else {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
            [actionSheet showInView:self.view];
        }
    }else {
        if ( self.isEdit ) {
            [self didRightBarButtonAction];
        }else {
            XFPreviewViewController *previewViewController = [XFPreviewViewController new];
            previewViewController.showIndex = indexPath.item;
            previewViewController.hidesBottomBarWhenPushed = true;
            previewViewController.assetsArray = [NSMutableArray arrayWithArray:[self.dataArray copy]];
            XFWeakSelf;
            previewViewController.deleteImageBlock = ^(NSInteger index) {
                [wself.dataArray removeObjectAtIndex:index];
                [wself.collectionView reloadData];
            };
            [self.navigationController pushViewController:previewViewController animated:true];
        }
        
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(4.f, 4.f, 4.f, 4.f);
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return ( self.dataArray.count == indexPath.item)?NO:self.isEdit;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    if ( sourceIndexPath.item != self.dataArray.count && destinationIndexPath.item != self.dataArray.count ) {
        XFAssetsModel *model = [self.dataArray objectAtIndex:sourceIndexPath.item];
        //从资源数组中移除该数据
        [self.dataArray removeObject:model];
        //将数据插入到资源数组中的目标位置上
        [self.dataArray insertObject:model atIndex:destinationIndexPath.item];
    }else {
//        NSLog(@"%ld,%ld",sourceIndexPath.item,destinationIndexPath.item);
        if ( destinationIndexPath.item == self.dataArray.count ) {
            [collectionView moveItemAtIndexPath:destinationIndexPath toIndexPath:sourceIndexPath];
        }
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( 0 == buttonIndex ) {
        if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES ) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
//            imagePicker.allowsEditing = YES;
            [self presentViewController:imagePicker animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            }];
        }
    }else if ( 1 == buttonIndex ) {
        [XFHUD showInOpenLibary];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            XFBrowerViewController *browerViewController = [XFBrowerViewController shareBrowerManager];
//            browerViewController.maxPhotosNumber = 10;
            browerViewController.selectedAssets = [NSArray arrayWithArray:[self.dataArray copy]];
            XFWeakSelf;
            browerViewController.callback = ^(NSArray *selectedArray) {
                [wself.dataArray removeAllObjects];
                [wself.dataArray addObjectsFromArray:selectedArray];
                [wself.collectionView reloadData];
            };
            [self presentViewController:browerViewController animated:true completion:nil];
        });
    }
}

#pragma mark -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
//        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
//        NSString *url = @"http://www.zgjc678.com/jichuang/api/index.php/Index/uploads";
//        //这里可以自己在封装一层动态设置图片压缩的比例,动态选择上传的图片是缩略图或者原图,也可以直接进入上传方法里面修改
//        [BANetManager ba_uploadImageWithUrlString:url parameters:nil withImageArray:@[image] withSuccessBlock:^(id response) {
//         
//        } withFailurBlock:^(NSError *error) {
//         
//        } withUpLoadProgress:^(int64_t bytesProgress, int64_t totalBytesProgress) {
//         
//        }];
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if ( !_dataArray ) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark -
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
