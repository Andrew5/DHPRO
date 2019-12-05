//
//  GuideViews.h
//  shiku
//
//  Created by  on 15/9/13.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GuideCompleteBlock) ();

#define MAX_NUM (5)



@interface GuideViews : UIView
{
    NSInteger _imageIndex;
    UIImageView* _imageView;
    NSArray *_imageArr;
}

@property (nonatomic,copy)GuideCompleteBlock block;
- (void)makeGuideViewWithComplete:(GuideCompleteBlock)block;


@end
