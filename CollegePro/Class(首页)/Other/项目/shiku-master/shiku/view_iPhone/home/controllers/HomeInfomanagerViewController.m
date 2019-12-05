//
//  HomeInfomanagerViewController.m
//  shiku
//
//  Created by Rilakkuma on 15/7/30.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "HomeInfomanagerViewController.h"

@implementation HomeInfomanagerViewController

- (void)awakeFromNib {
//    [_imageViewGoods setContentScaleFactor:[[UIScreen mainScreen] scale]];
//    _imageViewGoods.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    _imageViewGoods.contentMode = UIViewContentModeScaleAspectFill;
//    _imageViewGoods.clipsToBounds = YES;
}
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HomeInfomanagerViewController";
    HomeInfomanagerViewController *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeInfomanagerViewController" owner:nil options:nil] lastObject];
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)loadData
{
////    if (self.imageViewGoods) {
//    NSArray *keys = _imageDic.allKeys;
//        for(int i = 1;i<keys.count;i++)
//        {
//            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(15, _imageViewGoods.frame.size.height+_imageViewGoods.frame.origin.y+200*i+10,SCREEM_W-30,200)];
//            [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"img_%d",i]] placeholderImage:nil];
////            image.image = [UIImage imageNamed:_imageArr[i]];
//            [self addSubview:image];
//        }
//    
}
@end
