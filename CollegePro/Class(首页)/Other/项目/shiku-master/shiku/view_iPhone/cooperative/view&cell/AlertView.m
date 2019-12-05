//
//  AlertView.m
//  shiku
//
//  Created by Rilakkuma on 15/9/15.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView
+(instancetype)STWordAndPhraseView
{
    
    return  [[[NSBundle mainBundle] loadNibNamed:@"AlertView" owner:nil options:nil] lastObject];
    
}/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
