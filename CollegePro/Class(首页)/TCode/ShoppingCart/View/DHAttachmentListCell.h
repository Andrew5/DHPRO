//
//  DHAttachmentListCell.h
//  CollegePro
//
//  Created by jabraknight on 2020/9/17.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "FilePickAllTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DHAttachmentListCell : UITableViewCell

@property(nonatomic,assign) PHDataType dataType;

@property(nonatomic,strong) NSString *TypeVC;

@property(nonatomic,strong) UIImageView *selectedImageView;

@property(nonatomic,strong) FilePickAllTypeModel *model;

- (void)setFileSelected:(BOOL)selected;

-(void)assignmentCellWithFileRecordModel:(FilePickAllTypeModel *)fileRecordModel;

@end

NS_ASSUME_NONNULL_END
