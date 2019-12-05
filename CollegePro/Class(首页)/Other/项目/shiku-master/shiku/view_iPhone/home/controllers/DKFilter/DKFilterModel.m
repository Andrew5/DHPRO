//
//  DKFilterModel.m
//  Partner
//
//  Created by Drinking on 14-12-19.
//  Copyright (c) 2014年 zhinanmao.com. All rights reserved.
//

#import "DKFilterModel.h"
#import "DKFilterCell.h"
#import "DKMacros.h"

@implementation DKFilterModel

- (instancetype)initElement:(NSArray*)array ofType:(DKFilterType)type{
    if (self = [super init]) {
        _elements = array;
        self.type = type;
        self.style = DKFilterViewDefault;
    }
    return self;
}


- (UIView *)getCustomeViewofWidth:(CGFloat)width{
    
    DKFilterCell *sv = [[DKFilterCell alloc] init:self Width:width];
    if (self.style == DKFilterViewDefault) {
        sv.buttonWidth = 62;
        sv.buttonHeight = 25;
        sv.paddingHorizontal = 17;
        sv.paddingVertical = 18;
        sv.paddingBottom = 8;
    }else if(self.style == DKFilterViewStyle1){
        sv.buttonWidth = 95;
        sv.buttonHeight = 30;
        sv.paddingHorizontal = 8;
        sv.buttonNormalColor = DK_HL_COLOR;
        sv.buttonHighlightColor = DK_HL_COLOR;
    }
    return sv;
}

- (NSArray *)getFilterResult;{
    if (self.cachedView && [self.cachedView isKindOfClass:
                            [DKFilterCell class]]){
        DKFilterCell *view = (DKFilterCell *)self.cachedView;
        return [view getSelectedValues];
    }
    return @[];
}
@end
