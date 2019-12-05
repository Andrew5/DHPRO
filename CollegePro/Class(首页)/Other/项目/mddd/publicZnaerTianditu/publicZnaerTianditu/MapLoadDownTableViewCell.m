//
//  MapLoadDownTableViewCell.m
//  Znaer
//
//  Created by Jeremy on 14-6-25.
//  Copyright (c) 2014年 Jeremy. All rights reserved.
//

#import "MapLoadDownTableViewCell.h"

@implementation MapLoadDownTableViewCell

@synthesize cityName;
@synthesize progressView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    float cellWidth = self.frame.size.width;
    cityName.frame = CGRectMake(20, 3, cellWidth - 40, 15);
    progressView.frame = CGRectMake(20, 20, cellWidth - 40, 20);
    //这里只有progressView设置了frame后才能设置进度
    [self changeProgressValue:self.updateInfo];
    
}

- (void)initViews{
    cityName = [[UILabel alloc]initWithFrame:CGRectZero];
    cityName.font = [UIFont systemFontOfSize:16.0f];
    cityName.textColor = [UIColor blackColor];
    progressView = [[ZDProgressView alloc]initWithFrame:CGRectZero];
    progressView.noColor = [UIColor whiteColor];
    progressView.prsColor = [UIColor orangeColor];
    progressView.text = @"准备下载...";
    progressView.textFont = [UIFont systemFontOfSize:12.0f];
    
    [self.contentView addSubview:cityName];
    [self.contentView addSubview:progressView];
}

- (void)changeProgressValue:(TDownLoadingCity *)element{
   
    TDownLoadingStatus istatus=element.istatus;
    
    if (istatus==0) {
        progressView.text=@"等待下载";
    }
    else if (istatus==1){
        
        if (element.lDownSize==element.ltotalsize) {
            
            progressView.text=@"下载完成";
        }
        else{
            progressView.text = [NSString stringWithFormat:@"正在下载：%d%%",element.lDownSize/element.ltotalsize];
        
        }

    }
    else if (istatus==2){
        progressView.text = @"暂停下载";
    }
        
    float floatValue = element.lDownSize/element.ltotalsize / 100.0f;
    progressView.progress = floatValue;
    
}

@end
