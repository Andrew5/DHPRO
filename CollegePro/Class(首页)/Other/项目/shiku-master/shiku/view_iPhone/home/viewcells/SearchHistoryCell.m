//
//  SearchHistoryCell.m
//  shiku
//
//  Created by yanglele on 15/9/16.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "SearchHistoryCell.h"

@interface SearchHistoryCell ()

@property(nonatomic ,strong)UILabel * m_Label;
@end

@implementation SearchHistoryCell

-(id)init
{
    self = [super init];
    if (self) {
        [self createLabel];
    }
    return self;
}

-(void)createLabel
{
    self.m_Label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 23)];
    self.m_Label.backgroundColor = [UIColor clearColor];
    self.m_Label.textColor = [UIColor grayColor];
    self.m_Label.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.m_Label];
}

-(void)The_Assignment:(NSString *)Title
{
    if (Title) {
        self.m_Label.text = Title;
    }

}

@end
