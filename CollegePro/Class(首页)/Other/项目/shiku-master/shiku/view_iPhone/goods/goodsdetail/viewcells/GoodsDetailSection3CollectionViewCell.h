//
//  GoodsDetailSection3CollectionViewCell.h
//  shiku
//
//  Created by txj on 15/5/19.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsDetailSection3CollectionViewCell;
@protocol GoodsDetailSection3CollectionViewCellDelegate <NSObject>
@optional
-(void)shopFavBtnTapped:(GoodsDetailSection3CollectionViewCell *)cell;
@end

/**
 *  cell模板，各属性请对照.xib文件
 */
@interface GoodsDetailSection3CollectionViewCell : TUICollectionViewCell
{
    NSMutableArray *rates;
}
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIView *starViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *favBtn;
@property (weak, nonatomic) IBOutlet UIImageView *rates1Image;
@property (weak, nonatomic) IBOutlet UIImageView *rates2Image;
@property (weak, nonatomic) IBOutlet UIImageView *rates3Image;
@property (weak, nonatomic) IBOutlet UIImageView *rates4Image;
@property (weak, nonatomic) IBOutlet UIImageView *rates5Image;

- (IBAction)favBtnTapped:(id)sender;

@property (strong, nonatomic) GOODS *goods;
@property (nonatomic, strong) id<GoodsDetailSection3CollectionViewCellDelegate> delegate;
@end
