//
//  JHDownButton.m
//  GBCheckUpLibrary
//
//  Created by jabraknight on 2019/5/24.
//  Copyright © 2019 jinher. All rights reserved.
//

#import "JHDownButton.h"

@implementation JHDownButton
-(id)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        //设置此空间固定大小
        self.width = DH_DeviceWidth;
        self.height = 49;
        //创建文本
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(0, 28 + 3, self.width, 14)];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.font = [UIFont systemFontOfSize:12.0];
        self.title.textColor = [UIColor blackColor];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.text = title;
        [self addSubview:self.title];
        //创建一个图片视图
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8, self.width, 20)];
        //设置图片
        self.imageView.image = image;
        //设置图片的拉伸方式
        //        self.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:self.imageView];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(9);
            make.centerX.equalTo(self.mas_centerX);
            make.height.mas_offset(14);
        }];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title.mas_right).offset(5);
            make.centerY.equalTo(self.title.mas_centerY);
            make.height.mas_offset(15);
            make.width.mas_offset(15);
        }];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
