//
//  DHTFVideoCell.h
//  CollegePro
//
//  Created by jabraknight on 2020/9/17.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilePickAllTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef  void(^selectBtnBlock)(NSString *str);

@interface DHTFVideoCell : UITableViewCell

@property(nonatomic,strong) UILabel *videoNameLabel;

@property(nonatomic,strong) UILabel *fileSizeLabel;

@property(nonatomic,strong) UILabel *timeLengthLabel;

@property(nonatomic,strong) UIImageView *thumImageView;

@property (nonatomic,strong) UIImageView *selectedImageView;

@property (nonatomic,strong)PHAsset *asset;

@property(nonatomic,strong) FilePickAllTypeModel *model;

- (void)setVideoSelected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
