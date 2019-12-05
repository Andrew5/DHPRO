//
//  GKLabel.h
//  btc
//
//  Created by txj on 15/1/25.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Strikethrough)

- (void)setStrikethrough;
@end

#pragma mark VerticalAlign
@interface UILabel(VerticalAlign)
-(void)alignTop;
-(void)alignBottom;
@end