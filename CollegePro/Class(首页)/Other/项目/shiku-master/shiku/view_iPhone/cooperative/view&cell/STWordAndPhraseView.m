//
//  STWordAndPhraseView.m
//  Summit
//
//  Created by apple on 15/1/4.
//  Copyright (c) 2015年 pang. All rights reserved.
//

#import "STWordAndPhraseView.h"

@implementation STWordAndPhraseView
+(instancetype)STWordAndPhraseView
{
    
    return  [[[NSBundle mainBundle] loadNibNamed:@"STWordAndPhraseView" owner:nil options:nil] lastObject];
    
}
-(void)awakeFromNib
{
    
    
}



@end
