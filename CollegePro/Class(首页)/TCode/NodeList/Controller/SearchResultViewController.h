//
//  SearchResultViewController.h
//  Test
//
//  Created by Rillakkuma on 2017/11/28.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LBSearchResultSelectedDelegate <NSObject>

-(void)selectPersonWithUserId:(NSString *)userId userName:(NSString *)userName photo:(NSString *)photo HX_UserID:(NSString *)hxID;

@end
@interface SearchResultViewController : BaseViewController<UISearchResultsUpdating>
@property(nonatomic,weak)id<LBSearchResultSelectedDelegate>delegate;
-(void)updateAddressBookData:(NSArray *)AddressBookDataArray;//得到数据
@end
