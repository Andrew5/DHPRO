//
//  WaveTableViewCell.m
//  LXWaveProgressDemo
//
//  Created by liuxin on 16/8/1.
//  Copyright © 2016年 liuxin. All rights reserved.
//

#import "WaveTableViewCell.h"
#import "LXWaveProgressView.h"


@implementation WaveTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self.contentView addSubview:self.progressView];
    }
    return self;
}

-(LXWaveProgressView *)progressView{
    if (!_progressView) {
        _progressView =[[LXWaveProgressView alloc] initWithFrame:CGRectMake(100, 10, 80, 80)];
        _progressView.firstWaveColor = [UIColor colorWithRed:134/255.0 green:116/255.0 blue:210/255.0 alpha:1];
        _progressView.secondWaveColor = [UIColor colorWithRed:134/255.0 green:116/255.0 blue:210/255.0 alpha:0.5];
    }
    return _progressView;
}


@end
