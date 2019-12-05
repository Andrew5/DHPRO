//
//  XFAssetsLibraryData.m
//  XFPhotoBrowser
//
//  Created by zeroLu on 16/7/6.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import "XFAssetsLibraryData.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "XFAssetsLibraryModel.h"
#import "XFAssetsModel.h"

@implementation XFAssetsLibraryData

#pragma mark - ALAssetsLibrary
+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

+ (void)getLibraryGroupWithSuccess:(void (^)(NSArray *array))successBlock failBlcok:(void (^)(NSError *error))failBlock {
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if ( author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied ){
        failBlock(nil);
    }else {
        NSMutableArray *resultArray = [NSMutableArray array];
        
        ALAssetsLibrary *assetsLibrary = [[self class] defaultAssetsLibrary];
        
        ALAssetsFilter *assetsFilter = [ALAssetsFilter allPhotos];
        
        ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            
            if ( group ) {
                //            NSLog(@"%@",[group valueForProperty:ALAssetsGroupPropertyName]);
                [group setAssetsFilter:assetsFilter];
                XFAssetsLibraryModel *model = [XFAssetsLibraryModel getModelWithData:group];
                [resultArray addObject:model];
            }else {
//                NSLog(@"停止");
                NSArray *tempArray = [resultArray copy];
                for ( XFAssetsLibraryModel *model in tempArray ) {
                    if ( model.groupPropertyType == 16 ) {
                        [resultArray removeObject:model];
                        [resultArray insertObject:model atIndex:0];
                    }
                }
                successBlock(resultArray);
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
            failBlock(error);
        };
        
        // Then all other groups
        NSUInteger type = ALAssetsGroupSavedPhotos | ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupPhotoStream;
        
        [assetsLibrary enumerateGroupsWithTypes:type usingBlock:resultsBlock failureBlock:failureBlock];
    }
}

+ (void)getAssetsWithGroup:(ALAssetsGroup *)group successBlock:(void (^)(NSArray *array))successBlock {
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
            if ( asset ) {
                if ( [[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypePhoto] ) {
                    XFAssetsModel *model = [XFAssetsModel getModelWithData:asset];
                    [resultArray addObject:model];
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    successBlock(resultArray);
                });
            }
        };
        //    //指定操作方式的，遍历。操作方式有：
        //    //NSEnumerationConcurrent：同步的方式遍历
        //    //NSEnumerationReverse：倒序的方式遍历
        //        [wself.assetsGroup enumerateAssetsUsingBlock:resultsBlock];   //最简单的方法,按默认排序
        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:resultsBlock];
    });
    
}

@end
