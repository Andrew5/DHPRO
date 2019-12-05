//
//  AddCarView.m
//  shiku
//
//  Created by Rilakkuma on 15/8/27.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "AddCarView.h"

@implementation AddCarView
+(AddCarView *)instanceTextView
{
//    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AddCarView" owner:nil options:nil];
//    return [nibView objectAtIndex:0];
    return [[[NSBundle mainBundle]loadNibNamed:@"AddCarView" owner:nil options:nil] lastObject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
