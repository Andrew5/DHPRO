//
//  AdHeaderCollectionViewCell.h
//  btc
//
//  Created by txj on 15/1/20.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XZFramework/ImagePlayerView.h>
#import <XZFramework/AdItem.h>
#import "UIBindableTableViewCell.h"
/**
 *  首页最上方滚动广告，废弃食用 HomeSectionCollectionViewCell
 */
@protocol AdHeaderCollectionViewCellDelegate <NSObject>

@optional
-(void)headerImageClicked:(NSInteger *)index;
@end

@interface AdHeaderCollectionViewCell : UICollectionViewCell<UIBindableTableViewCell,ImagePlayerViewDelegate>
{
    BOOL isinit;
}
@property (strong, nonatomic) ImagePlayerView *imagePlayerView;
@property (strong, nonatomic) NSArray *AdItems;
@property(nonatomic,strong) id<AdHeaderCollectionViewCellDelegate> delegate;
@end
