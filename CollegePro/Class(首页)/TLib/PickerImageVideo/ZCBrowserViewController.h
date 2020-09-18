//
//  ZCBrowserViewController.h
//  ZCAssetsPickerController

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void(^ AssetSelectedBlock)(NSInteger currentIndex);

@interface ZCBrowserViewController : UIViewController

@property (nonatomic,strong) PHFetchResult *assets;

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,copy) AssetSelectedBlock assetSelectedBlock;

@end
