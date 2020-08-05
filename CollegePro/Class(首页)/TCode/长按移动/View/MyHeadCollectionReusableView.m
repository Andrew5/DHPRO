//
//  MyHeadCollectionReusableView.m
//  CollegePro
//
//  Created by jabraknight on 2019/5/9.
//  Copyright © 2019 jabrknight. All rights reserved.
//

#import "MyHeadCollectionReusableView.h"
#import "UIColor+JFColor.h"

@implementation MyHeadCollectionReusableView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        UILabel *lb_bgm = [[UILabel alloc]init];
        lb_bgm.backgroundColor = [UIColor colorWithHexString:@"#f3f5f9"];
        lb_bgm.frame = CGRectMake(0, 0, self.frame.size.width, 10);
        [self addSubview:lb_bgm];
        
        _leftlabel  = [[UILabel alloc] initWithFrame:CGRectMake(10, lb_bgm.bottom+10, 80, 20)];
        _leftlabel.textColor = [UIColor blackColor];
        _leftlabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold"  size:(18.0)];
        [self addSubview:_leftlabel];
        
        _botlabel = [[UILabel alloc] initWithFrame:CGRectMake(DH_DeviceWidth-100, lb_bgm.bottom, 80, 20)];
        _botlabel.textAlignment = NSTextAlignmentCenter;
        _botlabel.textColor = [UIColor lightGrayColor];
//        _botlabel.font = Font12;
        [self addSubview:_botlabel];
        
    }
    
    return self;
}
@end
