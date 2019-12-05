//
//  GZTableViewCell.m
//  GZTimeLine
//
//  Created by xinshijie on 2017/5/31.
//  Copyright © 2017年 Mr.quan. All rights reserved.
//

#import "GZTableViewCell.h"
#import "SDAutoLayout.h"

@interface GZTableViewCell()
@property (strong, nonatomic)  UIImageView *GZIma;
@property (strong, nonatomic)  UILabel *TimeLabel;
@property (strong, nonatomic)  UILabel *ContentLabel;


@end
@implementation GZTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self sss];
    }
    return self ;
}
- (void)sss {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    _point = [[UIView alloc]init];
    _GZTopLine = [[UIView alloc]init];
    _GZBoyttomLine = [[UIView alloc]init];
    _GZIma = [[UIImageView alloc]init];
    _TimeLabel = [[UILabel alloc]init];
    _ContentLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_point];
    [self.contentView addSubview:_GZTopLine];
    [self.contentView addSubview:_GZBoyttomLine];
    [self.contentView addSubview:_GZIma];
    [self.contentView addSubview:_TimeLabel];
    [self.contentView addSubview:_ContentLabel];
    
    self.point.sd_layout.topSpaceToView(self.contentView, 20).leftSpaceToView(self.contentView, 5).widthIs(8).heightEqualToWidth();
    self.point.sd_cornerRadius = @(4);
    self.point.backgroundColor = [UIColor redColor];
    
    self.GZTopLine.sd_layout.topEqualToView(self.contentView).centerXEqualToView(self.point).widthIs(2).bottomEqualToView(self.point);
    self.GZTopLine.backgroundColor = [UIColor orangeColor];
    self.GZBoyttomLine.sd_layout.topEqualToView(self.point).centerXEqualToView(self.point).widthIs(2).bottomSpaceToView(self.contentView, 0);
    self.GZBoyttomLine.backgroundColor = [UIColor orangeColor];
    
    self.GZIma.sd_layout.topSpaceToView(self.contentView , 10).leftSpaceToView(self.point, 3).bottomSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, 10);
    _GZIma.image = [UIImage imageNamed:@"WechatIMG3"];
    // 指定为拉伸模式，伸缩后重新赋值
    
    self.GZIma.image = [self.GZIma.image stretchableImageWithLeftCapWidth:20 topCapHeight:30];
    
    self.TimeLabel.sd_layout.centerYEqualToView(self.point).leftSpaceToView(self.contentView, 35).rightSpaceToView(self.contentView, 15).heightIs(20);
    self.ContentLabel.sd_layout.topSpaceToView(self.TimeLabel, 15).leftEqualToView(self.TimeLabel).rightSpaceToView(self.contentView, 15).autoHeightRatio(0);
}

-(void)setModel:(GZTimeLineModel *)model{
    
    _model = model;
    self.ContentLabel.text=  model.title;
    self.TimeLabel.text = model.time;
    
    [self setupAutoHeightWithBottomView:self.ContentLabel bottomMargin:15];
}

@end
