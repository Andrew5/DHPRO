//
//  DHTFVideoCell.m
//  CollegePro
//
//  Created by jabraknight on 2020/9/17.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHTFVideoCell.h"

@implementation DHTFVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViewUI];
    }
    return self;
}

- (void)createSubViewUI {
    [self.contentView addSubview:self.selectedImageView];
    [self.contentView addSubview:self.thumImageView];
    [self.contentView addSubview:self.videoNameLabel];
    [self.contentView addSubview:self.timeLengthLabel];
    [self.contentView addSubview:self.fileSizeLabel];
}

- (void)layoutSubviews {
    self.selectedImageView.frame = CGRectMake(10, self.frame.size.height/2-10, 20, 20);
    self.thumImageView.frame = CGRectMake(50, 10, 100, 80);
    self.videoNameLabel.frame = CGRectMake(CGRectGetMaxX(self.thumImageView.frame)+10, CGRectGetMinY(self.thumImageView.frame), DH_DeviceWidth-100-50-10-10, 20);
    self.timeLengthLabel.frame = CGRectMake(CGRectGetMaxX(self.thumImageView.frame)+10, CGRectGetMaxY(self.thumImageView.frame)-20, CGRectGetWidth(self.videoNameLabel.frame), 20);
    self.fileSizeLabel.frame = CGRectMake(CGRectGetMaxX(self.thumImageView.frame)+10, CGRectGetMinY(self.timeLengthLabel.frame)-25, CGRectGetWidth(self.videoNameLabel.frame), 15);
}

- (void)setVideoSelected:(BOOL)selected {
    if (selected) {
        self.model.isSelected = YES;
        _selectedImageView.layer.borderColor = [UIColor greenColor].CGColor;
    }else{
        self.model.isSelected = NO;
        _selectedImageView.layer.borderColor = [UIColor grayColor].CGColor;
    }
}

//赋值UI
- (void)setAsset:(PHAsset *)asset {
    if (!asset) {
        return;
    }
    _asset = asset;
    //文件名 和 缩略图
    NSString *videoName = [asset valueForKey:@"filename"];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    __weak typeof(self) weakSelf = self;
    [[PHImageManager defaultManager] requestImageForAsset:_asset
                                 targetSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
                                contentMode:PHImageContentModeAspectFill
                                    options:options
                              resultHandler:^(UIImage *result, NSDictionary *info){
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      weakSelf.thumImageView.image = result;
                                      weakSelf.videoNameLabel.text = videoName;
                                      weakSelf.model.fileName = videoName;
                                  });
                              }];
    //文件大小
    __block NSString *size;
    PHVideoRequestOptions *option = [PHVideoRequestOptions new];
    option.version = PHImageRequestOptionsVersionOriginal;//有坑 不写有些视频会崩溃
    option.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = YES;//赋值 YES ，那么允许从 iCloud 中获取图片和视频，默认是 NO。
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:option resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
         AVURLAsset *AVUrl = (AVURLAsset *)asset;
         if (AVUrl) {
             NSURL *URL = [AVUrl URL];
             // NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
             // NSLog(@"%ld",data.length);
             float M =  [self fileSizeAtPath:URL.path]/1024.0/1024.0;
             if (M<1) {
                 M =  [self fileSizeAtPath:URL.path]/1024.0;
                 size = [NSString stringWithFormat:@"%.2fKB",M];
             }else{
                 size = [NSString stringWithFormat:@"%.2fMB",M];
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 weakSelf.fileSizeLabel.text = size;
                 weakSelf.model.fileSize = size;
             });
         } else {
             dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.fileSizeLabel.text = @"0kB";
                 weakSelf.model.fileSize = @"0kB";
             });
         }
     }];
    //创建时间
    self.timeLengthLabel.text = [self getStringWithDate:asset.creationDate];
}

//计算文件大小
- (long long) fileSizeAtPath:(NSString*) filePath {
    if (filePath.length) {
        NSFileManager* manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:filePath]) {
            return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        }
    }
    return 0;
}

//- (void)selectedBtnClicked:(UIButton *)sender
//{
//    sender.selected = !sender.selected;
//}

- (UIImageView *)thumImageView {
    if (!_thumImageView) {
        _thumImageView = [[UIImageView alloc] init];
        _thumImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _thumImageView;
}

- (UILabel *)videoNameLabel {
    if (!_videoNameLabel) {
        _videoNameLabel = [[UILabel alloc] init];
        _videoNameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _videoNameLabel;
}

- (UILabel *)fileSizeLabel {
    if (!_fileSizeLabel) {
        _fileSizeLabel = [[UILabel alloc] init];
        _fileSizeLabel.textColor = [UIColor lightGrayColor];
        _fileSizeLabel.font = [UIFont systemFontOfSize:13];
    }
    return _fileSizeLabel;
}

- (UILabel *)timeLengthLabel {
    if (!_timeLengthLabel) {
        _timeLengthLabel = [[UILabel alloc] init];
        _timeLengthLabel.textColor = [UIColor lightGrayColor];
        _timeLengthLabel.font = [UIFont systemFontOfSize:13];
    }
    return _timeLengthLabel;
}

- (UIImageView *)selectedImageView {
    if (!_selectedImageView) {
        _selectedImageView = [[UIImageView alloc]init];
        _selectedImageView.layer.borderWidth = 1.0;
        [self.contentView addSubview:_selectedImageView];
    }
    return _selectedImageView;
}

//日期转字符串
- (NSString *)getStringWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [formatter stringFromDate:date];
    //    NSDate *date =[dateFormat dateFromString:@"1980-01-01 00:00:01"];//字符串转日期
    return dateStr;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
