//
//  KeyBoardCell.h
//  CollegePro
//
//  Created by jabraknight on 2020/5/3.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyBoardModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KeyBoardCellDelegate <NSObject>

@optional
- (void)KeyBoardCellBtnClick:(NSInteger)Tag;

@end
@interface KeyBoardCell : UICollectionViewCell
@property (nonatomic,weak) id <KeyBoardCellDelegate> delegate;

@property (nonatomic,strong) UIButton * keyboardBtn;

@property (nonatomic,strong) KeyBoardModel * model;
@end

NS_ASSUME_NONNULL_END
