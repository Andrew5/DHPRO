//
//  GoodsDetailSection0CollectionViewCell.m
//  shiku
//
//  Created by txj on 15/5/19.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "GoodsDetailSection0CollectionViewCell.h"
@interface GoodsDetailSection0CollectionViewCell ()

@property (nonatomic ,strong) NSMutableArray * m_DataArr;

@end

@implementation GoodsDetailSection0CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
//    self.backgroundColor = ;
    
}

//有多少页
- (int)numberOfPages {
   self.m_DataArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<self.goods.pictures.count; i++) {
        NSDictionary *dict =self.goods.pictures[i];
        if ([dict[@"type"] isEqualToString:@"1"]) {
            [ self.m_DataArr addObject:dict];
            
        }
    }
    return (int) self.m_DataArr.count;
   
//    return (int) self.goods.pictures.count;
}

- (UIImage *)imageAtIndex:(int)index {
    return nil;
}

- (NSString *)imageUrlAtIndex:(int)index {
    return nil;
}


// 每页的图片
//
- (UIImageView *)imageViewAtIndex:(int)index {
    //NSString *imageName = [NSString stringWithFormat:@"1933_%d.jpg", index + 1];
    UIImageView *v = [[UIImageView alloc] initWithFrame:self.frame];
    [v setContentScaleFactor:[[UIScreen mainScreen] scale]];
    v.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    v.contentMode = UIViewContentModeScaleAspectFill;
    //    v.contentMode = UIViewContentModeScaleToFill;
    v.clipsToBounds = YES;
    NSDictionary * dict = [self.m_DataArr objectAtIndex:index];
    NSString *url = [Helper checkImgType:dict[@"img"]];
    [v sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            [v sd_setImageWithURL:[NSURL URLWithString:dict[@"img"]]];
        }
    }];
    [v setContentScaleFactor:[[UIScreen mainScreen] scale]];
    v.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    v.contentMode = UIViewContentModeScaleAspectFill;
    v.clipsToBounds = YES;
    
    return v;
}
#pragma -mark banner 图片大小
- (void)bind {
    PagePhotosView *pagePhotosView = [[PagePhotosView alloc] initWithFrame:CGRectMake(-4, 0, self.frame.size.width, self.frame.size.height) withDataSource:self];
    pagePhotosView.tag = 456789098765;
//    NSLog(@"----%lu",(unsigned long)pagePhotosView.imageViews.count);
    
    
    for (int i = 0; i<pagePhotosView.imageViews.count; i++) {
//       int indexNum =pagePhotosView.imageViews[i];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchImage:indexNum:)];
//        tap.view.tag = indexNum;
        [pagePhotosView addGestureRecognizer:tap];
    }
    
    [self addSubview:pagePhotosView];
}
-(void)touchImage:(UITapGestureRecognizer *)sender indexNum:(int)num{
//    [self showHUD:[NSString  stringWithFormat:@"%d",num] afterDelay:0.3];
    
//    SwitView *size =[SwitView instanceSizeTextView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
//    [size.backgroundView addGestureRecognizer:tap];
//    size.frame = CGRectMake(0, 0, DeviceWidth,DeviceHeight);;
//    [[UIApplication sharedApplication].keyWindow addSubview:size];
//    self.negotiate = size;
}



@end
