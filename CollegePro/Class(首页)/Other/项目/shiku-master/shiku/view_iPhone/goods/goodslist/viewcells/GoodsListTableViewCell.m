//
//  UserLikeTableViewCell.m
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "GoodsListTableViewCell.h"

@implementation GoodsListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.coverImageWidth.constant=self.coverImage.frame.size.height*coverimagewidth;
    self.titleLabel1.textColor=TEXT_COLOR_DARK;
    self.titleLabel2.textColor=TEXT_COLOR_DARK;
    
    self.priceLabel.textColor=MAIN_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)unbind{}
- (void)bind
{
    @weakify(self)
    [RACObserve(self, goods)
     subscribeNext:^(id x) {
         @strongify(self);
         [self render];
     }];
}
- (void)render
{
//    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:self.goods.img.small]];
#pragma mark -更改图片
    NSString *url = [NSString string];
    if ([self.goods.img.small containsString:@".jpg"]) {
        url = [self.goods.img.small stringByReplacingOccurrencesOfString:@".jpg" withString:@"_small.jpg"];
    }
    else if ([self.goods.img.small containsString:@".JPG"]) {
        url = [self.goods.img.small stringByReplacingOccurrencesOfString:@".JPG" withString:@"_small.JPG"];
        
    }
    else if ([self.goods.img.small containsString:@".gif"]) {
        url = [self.goods.img.small stringByReplacingOccurrencesOfString:@".gif" withString:@"_middle.gif"];
    }
    else if ([self.goods.img.small containsString:@".png"]) {
        url = [self.goods.img.small stringByReplacingOccurrencesOfString:@".png" withString:@"_middle.png"];
    }
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

        if (error) {
   //http://api.shiku.com/data/upload/assets/2015/09/09/10/00/55ef92a12af6f.png这张图没有  placeholder
            [self.coverImage sd_setImageWithURL:[NSURL URLWithString:self.goods.img.small]];
        }
    }];
    
    [self.coverImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.coverImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.coverImage.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImage.clipsToBounds = YES;
    
    
    self.priceLabel.text=[NSString stringWithFormat:@"￥%.2f",[self.goods.shop_price floatValue]];
    self.titleLabel1.text=[NSString stringWithFormat:@"%@已购买",self.goods.sub_title1];
    self.titleLabel2.text=self.goods.sub_title2;
    self.titleLabel.text=self.goods.name;
    [self.titleLabel alignTop];
}

- (IBAction)btnSharedTapped:(id)sender {
    if ([self.ulDelegate respondsToSelector:@selector(didSharedBtnTapped:)]) {
        [self.ulDelegate didSharedBtnTapped:self.goods];
    }
}
@end
