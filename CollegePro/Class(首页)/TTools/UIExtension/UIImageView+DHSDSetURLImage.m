//
//  UIImageView+DHSDSetURLImage.m
//  CollegePro
//
//  Created by jabraknight on 2020/12/22.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "UIImageView+DHSDSetURLImage.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (DHSDSetURLImage)
//设置图片
- (void)setImageViewContent:(id)image {
    if ([image isKindOfClass:[UIImage class]]) {
        self.image = (UIImage *)image;
    } else if ([image hasPrefix:@"http://"] ||
               [image hasPrefix:@"https://"] ||
               [image rangeOfString:@"/"].location != NSNotFound) {
        [self sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"组-3"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!image) {
                [self setImage:[UIImage imageNamed:@"组-3"]];
            }
        }];
    } else if([image isKindOfClass:[NSString class]]) {
        self.image = [UIImage imageNamed:image];
    }
}
@end
