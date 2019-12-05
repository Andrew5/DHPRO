//
//  GoodsDetailSection3CollectionViewCell.m
//  shiku
//
//  Created by txj on 15/5/19.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "GoodsDetailSection3CollectionViewCell.h"

#define defaultImg [UIImage imageNamed:@"icon17-07.png"]
#define hilightImg [UIImage imageNamed:@"icon17-06.png"]

@implementation GoodsDetailSection3CollectionViewCell

- (void)awakeFromNib {
    rates=[[NSMutableArray alloc] initWithCapacity:5];
    [rates addObject:self.rates1Image];
    [rates addObject:self.rates2Image];
    [rates addObject:self.rates3Image];
    [rates addObject:self.rates4Image];
    [rates addObject:self.rates5Image];

    
    self.backgroundColor=WHITE_COLOR;
    // Initialization code
    self.favBtn.layer.cornerRadius=5;
    self.favBtn.backgroundColor=MAIN_COLOR;
    
    self.userNameLabel.textColor=TEXT_COLOR_DARK;
    
    self.coverImage.layer.cornerRadius=self.coverImage.frame.size.width/2;
    self.coverImage.layer.masksToBounds =YES;
}
- (IBAction)favBtnTapped:(id)sender {
    SEL selector = @selector(shopFavBtnTapped:);
    if ([self.delegate respondsToSelector:selector]) {
        [self.delegate shopFavBtnTapped:self];
    }
}
- (void)bind
{
    @weakify(self)
    [RACObserve(self, goods)
     subscribeNext:^(id x) {
         @strongify(self);
         [self render];
     }];
}

- (void)unbind
{
}
- (void)render
{
    if([self.goods.shop_collected boolValue])
    {
        [self.favBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    }
    else{
        [self.favBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
    [self.coverImage sd_setImageWithURL:url(self.goods.shop_img.small) placeholderImage:img_placehold];
    self.shopNameLabel.text=self.goods.shop_name;
//    self.userNameLabel.text=self.goods.shop_uname;
        switch ([self.goods.shop_rates integerValue]) {
            case 1:
                self.rates1Image.image=hilightImg;
                self.rates2Image.image=defaultImg;
                self.rates3Image.image=defaultImg;
                self.rates4Image.image=defaultImg;
                self.rates5Image.image=defaultImg;
                break;
            case 2:
                self.rates1Image.image=hilightImg;
                self.rates2Image.image=hilightImg;
                self.rates3Image.image=defaultImg;
                self.rates4Image.image=defaultImg;
                self.rates5Image.image=defaultImg;
                break;
            case 3:
                self.rates1Image.image=hilightImg;
                self.rates2Image.image=hilightImg;
                self.rates3Image.image=hilightImg;
                self.rates4Image.image=defaultImg;
                self.rates5Image.image=defaultImg;
                break;
            case 4:
                self.rates1Image.image=hilightImg;
                self.rates2Image.image=hilightImg;
                self.rates3Image.image=hilightImg;
                self.rates4Image.image=hilightImg;
                self.rates5Image.image=defaultImg;
                break;
    
            case 5:
                self.rates1Image.image=hilightImg;
                self.rates2Image.image=hilightImg;
                self.rates3Image.image=hilightImg;
                self.rates4Image.image=hilightImg;
                self.rates5Image.image=hilightImg;
                break;
        }

//    for (int i=0; i<5; i++) {
//        if(i<[self.goods.shop_rates integerValue])
//        {
//            UIImageView *r=[rates objectAtIndex:i];
//            r.image=hilightImg;
//        }
//        else{
//            UIImageView *r=[rates objectAtIndex:i];
//            r.image=defaultImg;
//        }
//        
//    }
}
@end
