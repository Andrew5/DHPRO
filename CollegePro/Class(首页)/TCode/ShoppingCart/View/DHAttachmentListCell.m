//
//  DHAttachmentListCell.m
//  CollegePro
//
//  Created by jabraknight on 2020/9/17.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "DHAttachmentListCell.h"
#import <objc/message.h>

#import "DHAttachmentListCell.h"
#import "JPShopCarController.h"

#define MAINWIDTH [UIScreen mainScreen].bounds.size.width
#define CellHeight 100
#define ImageVWIDTH 70
@interface DHAttachmentListCell ()

@property(nonatomic,strong)UIImageView * leftImageV;
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UILabel * sizeLabel;

@property(nonatomic,strong)NSString * fileID;
@property(nonatomic,strong)NSString * filePath;

@end

@implementation DHAttachmentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        //image
        UIImageView * leftImageV = [[UIImageView alloc]initWithFrame:CGRectMake(50, 15, ImageVWIDTH, ImageVWIDTH)];
        leftImageV.backgroundColor = [UIColor clearColor];
        self.leftImageV= leftImageV;
        [self.contentView addSubview:leftImageV];
        
        //标题
        UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftImageV.frame)+10, 15 , MAINWIDTH-ImageVWIDTH-60, 25)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        //nameLabel.text = @"北京金和网络有限公司.doc";
        nameLabel.font = [UIFont boldSystemFontOfSize:15];
        nameLabel.textColor = [UIColor grayColor];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        
        //时间
        UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftImageV.frame)+10, CGRectGetMaxY(leftImageV.frame)-20, MAINWIDTH-ImageVWIDTH-60, 20)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        // timeLabel.text = @"高效协同 | 12-09 13:00";
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textColor = [UIColor lightGrayColor];
        self.timeLabel = timeLabel;
        [self.contentView addSubview:timeLabel];
        
        //文件大小
        UILabel * sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftImageV.frame)+10, CGRectGetMinY(timeLabel.frame)-25 , MAINWIDTH-ImageVWIDTH-60, 20)];
        sizeLabel.backgroundColor = [UIColor clearColor];
        sizeLabel.textAlignment = NSTextAlignmentLeft;
        //sizeLabel = @"30MB";
        sizeLabel.font = [UIFont systemFontOfSize:13];
        sizeLabel.textColor = [UIColor lightGrayColor];
        self.sizeLabel = sizeLabel;
        [self.contentView addSubview:sizeLabel];
        
        //删除文件按钮(暂时不用)
        UIButton * deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(MAINWIDTH-50, 10, 50, 40);
        deleteBtn.backgroundColor = [UIColor clearColor];
        [deleteBtn setImage:[UIImage imageNamed:@"JHJC6Resource.bundle/shanchu_fujian.png"] forState:UIControlStateNormal];
        deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 17);
        [deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:deleteBtn];
        
        //line
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, CellHeight-1, MAINWIDTH, 1)];
        line.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        [self.contentView addSubview:line];
        
    }
    
    return self;
}

-(void)assignmentCellWithFileRecordModel:(FilePickAllTypeModel *)fileRecordModel
{
    self.fileID = fileRecordModel.fileID;
    self.filePath = fileRecordModel.filePath;
    
    if ([fileRecordModel.filePath rangeOfString:@".doc"].location !=NSNotFound || [fileRecordModel.filePath rangeOfString:@".docx"].location !=NSNotFound)
    {
        self.leftImageV.image = [UIImage imageNamed:@"JHJC6Resource.bundle/Word_fujian.png"];
    }
    else if ([fileRecordModel.filePath rangeOfString:@".ppt"].location !=NSNotFound || [fileRecordModel.filePath rangeOfString:@".key"].location !=NSNotFound)
    {
        self.leftImageV.image = [UIImage imageNamed:@"JHJC6Resource.bundle/PPT_fujian.png"];
    }
    else if ([fileRecordModel.filePath rangeOfString:@".xlsx"].location !=NSNotFound || [fileRecordModel.filePath rangeOfString:@".xls"].location !=NSNotFound)
    {
        self.leftImageV.image = [UIImage imageNamed:@"JHJC6Resource.bundle/Excel_fujian.png"];
    }
    else if ([fileRecordModel.filePath rangeOfString:@".pdf"].location !=NSNotFound)
    {
        self.leftImageV.image = [UIImage imageNamed:@"JHJC6Resource.bundle/PDF_fujian.png"];
    }
    else if ([fileRecordModel.filePath rangeOfString:@".rar"].location !=NSNotFound || [fileRecordModel.filePath rangeOfString:@".zip"].location !=NSNotFound)
    {
        self.leftImageV.image = [UIImage imageNamed:@"JHJC6Resource.bundle/yasuo_fujian.png"];
    }
    else if ([fileRecordModel.filePath rangeOfString:@".jpg"].location !=NSNotFound)
    {
        self.leftImageV.image = [UIImage imageNamed:@"JHJC6Resource.bundle/jpg_fujian.png"];
    }
    else if ([fileRecordModel.filePath rangeOfString:@".png"].location !=NSNotFound)
    {
        self.leftImageV.image = [UIImage imageNamed:@"JHJC6Resource.bundle/png_fujian.png"];
    }
    else if ([fileRecordModel.filePath rangeOfString:@".txt"].location !=NSNotFound || [fileRecordModel.filePath rangeOfString:@".rtf"].location !=NSNotFound)
    {
        self.leftImageV.image = [UIImage imageNamed:@"JHJC6Resource.bundle/txt_fujian.png"];
    }
    else if ([fileRecordModel.filePath rangeOfString:@".mp3"].location !=NSNotFound)
    {
        self.leftImageV.image = [UIImage imageNamed:@"JHJC6Resource.bundle/mp3_fujian.png"];
    }
    else if ([fileRecordModel.filePath rangeOfString:@".mp4"].location !=NSNotFound || [fileRecordModel.filePath rangeOfString:@".avi"].location !=NSNotFound || [fileRecordModel.filePath rangeOfString:@".rmvb"].location !=NSNotFound || [fileRecordModel.filePath rangeOfString:@".MP4"].location !=NSNotFound ||
        [fileRecordModel.filePath rangeOfString:@".MOV"].location !=NSNotFound)
    {
        self.leftImageV.image = [UIImage imageNamed:@"JHJC6Resource.bundle/mp4_fujian.png"];
    }
    else
    {
        self.leftImageV.image =  [UIImage imageNamed:@"JHJC6Resource.bundle/weizhi_fujian.png"];
    }
    
    self.nameLabel.text = fileRecordModel.fileName;
    if (fileRecordModel.fileName.length==0) {
        self.nameLabel.text =@"亲，显示文件名需升级H5插件";
    }
    
    NSArray *array = [fileRecordModel.fileCreaTime componentsSeparatedByString:@"|"];
    NSString *strDate = array[1];
    NSString *newStr = [strDate stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",newStr];
    
    NSString *size;
    float M =  [self fileSizeAtPath:fileRecordModel.filePath]/1024.0/1024.0;
    if (M<1) {
        M =  [self fileSizeAtPath:fileRecordModel.filePath]/1024.0;
        NSLog(@"%.2fKB",M);
        size = [NSString stringWithFormat:@"%.2fKB",M];
    }else{
        NSLog(@"%.2fMB",M);
        size = [NSString stringWithFormat:@"%.2fMB",M];
    }
    self.sizeLabel.text = size;
    
}

- (UIImageView *)selectedImageView
{
    if (!_selectedImageView)
    {
//        _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_selectedBtn setImage:[UIImage imageNamed:@"JHFilePickResource.bundle/ic_asset_unselected"] forState:UIControlStateNormal];
//        [_selectedBtn setImage:[UIImage imageNamed:@"JHFilePickResource.bundle/ic_asset_selected"] forState:UIControlStateSelected];
//        [_selectedBtn addTarget:self action:@selector(selectedBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        _selectedBtn.frame = CGRectMake(10, CellHeight/2-10, 20, 20);
        
        _selectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, CellHeight/2-10, 20, 20)];
        _selectedImageView.image = [UIImage imageNamed:@"JHFilePickResource.bundle/ic_asset_unselected"];
        [self.contentView addSubview:_selectedImageView];
    }
    return _selectedImageView;
}

- (void)setFileSelected:(BOOL)selected
{
    if (selected) {
        self.model.isSelected = YES;
        [self.selectedImageView setImage:[UIImage imageNamed:@"JHFilePickResource.bundle/ic_asset_selected"]];
    }else{
        self.model.isSelected = NO;
        [self.selectedImageView setImage:[UIImage imageNamed:@"JHFilePickResource.bundle/ic_asset_unselected"]];
    }
    
}

//获取文件大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
