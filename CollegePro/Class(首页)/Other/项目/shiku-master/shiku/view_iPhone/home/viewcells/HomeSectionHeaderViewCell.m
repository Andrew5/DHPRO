//
//  HomeSectionHeaderViewCell.m
//  btc
//
//  Created by txj on 15/2/5.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "HomeSectionHeaderViewCell.h"

@implementation HomeSectionHeaderViewCell
-(void)unbind
{}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width, frame.size.height)];
        self.backgroundColor=[UIColor whiteColor];
        self.label.font = FONT_MEDIUM;
        self.label.text=@"分类推荐";
        [self addSubview:self.label];
    }
    return self;
}
-(void)bind
{
//    @weakify(self)
//    [RACObserve(self, strtext) subscribeNext:^(User *user) {
//        @strongify(self);
//        [self render];
//    }];
    
    
}
-(void)render
{
    self.label.text=self.strtext;
}

@end
