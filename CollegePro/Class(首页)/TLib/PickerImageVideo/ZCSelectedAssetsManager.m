//
//  ZCSelectedAssetsManager.m
//  ZCAssetsPickerController

#import "ZCSelectedAssetsManager.h"
#import <UIKit/UIKit.h>

@interface ZCSelectedAssetsManager ()

@property (nonatomic,strong)NSMutableArray *selectedAssetsArray;

@end

@implementation ZCSelectedAssetsManager

+ (ZCSelectedAssetsManager *)sharedInstance
{
    static ZCSelectedAssetsManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZCSelectedAssetsManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectedAssetsArray = [NSMutableArray array];
    }
    return self;
}


- (BOOL)addAssetWithAsset:(PHAsset *)asset;
{
    if (self.selectedAssetsArray.count >= self.maximumNumbernMedia ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:[NSString stringWithFormat:@"最多选取%zd张",self.maximumNumbernMedia] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    [self.selectedAssetsArray addObject:asset];
    return YES;
}


- (void)removeAssetWithAsset:(PHAsset *)asset
{
    [self.selectedAssetsArray removeObject:asset];
}

- (NSArray *)allSelectedAssets
{
    return self.selectedAssetsArray;
}


- (void)removeAllSelectedAssets
{
    [self.selectedAssetsArray removeAllObjects];
}


@end
