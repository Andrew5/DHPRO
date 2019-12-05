//
//  AdHeaderCollectionViewCell.m
//  btc
//
//  Created by txj on 15/1/20.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#define ADHEADER_HEIGHT 100.f

#import "AdHeaderCollectionViewCell.h"

@implementation AdHeaderCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=[UIColor greenColor];
    isinit=NO;
    
}
- (void)bind
{
    @weakify(self)
    [RACObserve(self, AdItems)
     subscribeNext:^(id x) {
         @strongify(self);
         if (!isinit) {
             [self performSelector:@selector(render) withObject:nil afterDelay:1.0f];
//             [self render];
         }
         
     }];
}
-(void)unbind
{
}
-(void)render
{
    if (self.AdItems.count>0) {
         isinit=YES;
        //    [self.imagePlayerView initWithImageURLs:self.AdItems placeholder:img_placehold_long delegate:self edgeInsets:UIEdgeInsetsMake(0, self.pointX, 0, self.pointX)];
        //    [self.imagePlayerView initWithCount:self.AdItems.count delegate:self];
        self.imagePlayerView=[[ImagePlayerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) withCurrentPageIndicatorTintColor:MAIN_COLOR andPageIndicatorTintColor:BG_COLOR];
        [self addSubview:self.imagePlayerView];
        //    self.imagePlayerView.backgroundColor=[UIColor redColor];
        [self.imagePlayerView initWithCount:self.AdItems.count delegate:self];
        //    @weakify(self)
        //    [self.imagePlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        @strongify(self);
        //        make.left.equalTo(@0);
        //        make.top.equalTo(@0);
        //        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, self.frame.size.width/2.0f));
        //    }];
        
        self.imagePlayerView.scrollInterval = 5.0f;
        
        // adjust pageControl position
        self.imagePlayerView.pageControlPosition = ICPageControlPosition_BottomCenter;
        
        // hide pageControl or not
        self.imagePlayerView.hidePageControl = NO;
    }
   
   
}
#pragma mark - ImagePlayerViewDelegate
- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    // recommend to use SDWebImage lib to load web image
    //    [imageView setImageWithURL:[self.imageURLs objectAtIndex:index] placeholderImage:nil];
    AdItem *item=[self.AdItems objectAtIndex:index];
    [imageView sd_setImageWithURL:url(item.url) placeholderImage:img_placehold_long];
//    imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url(item.url)]];
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(headerImageClicked:)]) {
        [self.delegate headerImageClicked:index];
    }
}

@end
