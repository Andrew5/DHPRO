//
//  UICustomLineLabel.m
//  UILineLableDemo
//
//  Created by myanycam on 2014/2/25.
//  Copyright (c) 2014年 myanycam. All rights reserved.
//

#import "UICustomLineLabel.h"

@implementation UICustomLineLabel

- (void)dealloc {

    self.lineColor = nil;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:rect];

    CGSize textSize = [[self text] sizeWithFont:[self font]];
    CGFloat strikeWidth = textSize.width;
    CGRect lineRect;
    CGFloat origin_x;
    CGFloat origin_y;


    if ([self textAlignment] == NSTextAlignmentRight) {

        origin_x = rect.size.width - strikeWidth;

    } else if ([self textAlignment] == NSTextAlignmentCenter) {

        origin_x = (rect.size.width - strikeWidth) / 2;

    } else {
        origin_x = 0;
    }


    if (self.lineType == LineTypeUp) {
        origin_y = 2;
    }
    else if (self.lineType == LineTypeMiddle) {
        origin_y = rect.size.height / 2;
    } else {//下画线
        origin_y = rect.size.height - 2;
    }

    lineRect = CGRectMake(origin_x, origin_y, strikeWidth, 1);

    if (self.lineType != LineTypeNone) {

        CGContextRef context = UIGraphicsGetCurrentContext();
        CGFloat R, G, B, A;
        UIColor *uiColor = self.lineColor;
        CGColorRef color = [uiColor CGColor];
        int numComponents = (int) CGColorGetNumberOfComponents(color);

        if (numComponents == 4) {
            const CGFloat *components = CGColorGetComponents(color);
            R = components[0];
            G = components[1];
            B = components[2];
//            A = components[3];

            CGContextSetRGBFillColor(context, R, G, B, 1.0);
        }
        CGContextFillRect(context, lineRect);
    }
}


@end
