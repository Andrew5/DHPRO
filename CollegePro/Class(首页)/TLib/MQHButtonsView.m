//
//  MQHButtonsView.m
//  buttons
//
//  Created by Allenth on 13-9-10.
//  Copyright (c) 2013年 CBSi时尚女性群组. All rights reserved.
//

#import "MQHButtonsView.h"

#define KBUTTON_WIDTH 75.0f
#define KBUTTON_HEIGHT 90.0f

@implementation MQHButtonsView
{
    BOOL isBtn;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 2.0f;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.clipsToBounds = NO;

        [self _initData];
        [self _initSubviews:frame];
    }
    return self;
}

- (void)_initSubviews:(CGRect)sender {
    _hang = (sender.size.height / KBUTTON_HEIGHT);
    _lie = 3;
    if (!isBtn) {
        
        for (int i = 0; i < _lie; i ++) {
            
            for (int j = 0; j < _hang; j ++) {
                
                for (int z = 0; z < 9; z++) {
                    UIButton *pageOne = [[UIButton alloc]
                                         initWithFrame:
                                         CGRectMake((KBUTTON_WIDTH*3*z)+(KBUTTON_WIDTH+1) * i,
                                                    (KBUTTON_HEIGHT+1) * j,
                                                    KBUTTON_WIDTH,
                                                    KBUTTON_HEIGHT)];
                    
                    pageOne.backgroundColor = [UIColor greenColor];
                    pageOne.layer.borderColor = [UIColor whiteColor].CGColor;
                    pageOne.layer.borderWidth = 1.0f;
                    pageOne.tag = (i+1) + (j+1)*10;
                    [self addSubview:pageOne];
                    [pageOne addTarget:self action:@selector(pageOneAction:)
                      forControlEvents:UIControlEventTouchUpInside];
                    
                }
               
                
//                UIButton *pageTwo = [[UIButton alloc]
//                                     initWithFrame:
//                                     CGRectMake(300+(KBUTTON_WIDTH+1) * i,
//                                                (KBUTTON_HEIGHT+1) * j,
//                                                KBUTTON_WIDTH,
//                                                KBUTTON_HEIGHT)];
//                
//                pageTwo.backgroundColor = [UIColor greenColor];
//                pageTwo.layer.borderColor = [UIColor whiteColor].CGColor;
//                pageTwo.layer.borderWidth = 1.0f;
//                pageTwo.tag = (i+1) + 100*(j+1);
//                [self addSubview:pageTwo];
//                [pageTwo addTarget:self action:@selector(pageTwoAction:)
//                  forControlEvents:UIControlEventTouchUpInside];
//                
            }
        }
//        isBtn = YES;
    }
}

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if( [super pointInside:point withEvent:event] )
    {
        return self;
    }
    return self;
}

- (void)_initData {
    
}

- (void)layoutSubviews {
    NSLog(@"%s", __FUNCTION__);
    [super layoutSubviews];

}

- (void)pageOneAction:(UIButton *)sender {
    NSLog(@"button tag == > %d", sender.tag);
}

- (void)pageTwoAction:(UIButton *)sender {
    NSLog(@"button2 tag == > %d", sender.tag);
}

@end
