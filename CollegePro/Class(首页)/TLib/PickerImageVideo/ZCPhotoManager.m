//
//  ZCPhotoManager.m
//  ZCAssetsPickerController
//
#import "ZCPhotoManager.h"

@interface ZCPhotoManager ()

@property (nonatomic,strong) NSArray <PHFetchResult *>*fetchResults;

@property (nonatomic,strong) NSArray *mediaTypes;

@end

@implementation ZCPhotoManager

- (id)initWithMediaTypes:(NSArray *)mediaTypes
{
    self = [super init];
    if (self) {
        self.mediaTypes = mediaTypes;
    }
    return self;
}

- (PHFetchResult *)assetsInAssetCollection:(PHAssetCollection *)album
{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType in %@", self.mediaTypes];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    return [PHAsset fetchAssetsInAssetCollection:(PHAssetCollection *)album options:options];
}

//获取相册
- (NSMutableArray *)showAlbums
{
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    self.fetchResults = @[smartAlbums, topLevelUserCollections];
    
    NSMutableArray *albums = [NSMutableArray array];
    
    for (PHFetchResult *fetchResult in self.fetchResults)
    {
        for (PHCollection *collection in fetchResult) {
            if ([collection isKindOfClass:[PHAssetCollection class]])
            {
                PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                PHFetchResult *assets = [self assetsInAssetCollection:assetCollection];
                if (assets.count > 0) {
                    if (assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                        [albums insertObject:assetCollection atIndex:0];
                    } else {
                        [albums addObject:assetCollection];
                    }
                }
                
            }
        }
    }
    return albums;
}


@end
