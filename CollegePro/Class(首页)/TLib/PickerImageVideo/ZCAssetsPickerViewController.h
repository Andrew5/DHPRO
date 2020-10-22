//
//  ZCAssetsPickerViewController.h
//  ZCAssetsPickerController

#import <UIKit/UIKit.h>

@protocol ZCAssetsPickerViewControllerDelegate <NSObject>

- (void)finishPickWithSelectedAssets:(NSArray *)selectedAsset;

@end

/**
 选取类型
 - ChooseTypePhoto: 照片
 - ChooseTypeVideo: 视频
 - ChooseTypeMedia: 照片和视频
 */
typedef NS_ENUM(NSInteger, ChooseType)
{
    ChooseTypePhoto,
    ChooseTypeVideo,
    ChooseTypeMedia,
};

@interface ZCAssetsPickerViewController : UIViewController

@property (nonatomic,assign) NSInteger maximumNumbernMedia;//最大选取数量

@property (nonatomic,assign) ChooseType type;//选取类型

@property (nonatomic,weak) id<ZCAssetsPickerViewControllerDelegate> delegate;

@property (nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic,assign) CGRect CollectionFrame;//collectionView的frame


@end
