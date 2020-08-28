//
//  KeyBoardView.h
//  CollegePro
//
//  Created by jabraknight on 2020/5/3.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyBoardModel.h"
#import "CustomFlowLayout.h"
#import "KeyBoardCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface KeyBoardVView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,KeyBoardCellDelegate>{
    BOOL isUp;
}
@property (nonatomic,strong) UICollectionView * topView;

@property (nonatomic,strong) UICollectionView * middleView;

@property (nonatomic,strong) UICollectionView * bottomView;

@property (nonatomic,strong) UIView * inputSource;

@property (nonatomic,strong) UIButton * clearBtn;

@property (nonatomic,strong) UIButton * upBtn;

@property (nonatomic,strong) NSMutableArray * modelArray;

@property (nonatomic,strong) NSArray * letterArray;
@end

NS_ASSUME_NONNULL_END
