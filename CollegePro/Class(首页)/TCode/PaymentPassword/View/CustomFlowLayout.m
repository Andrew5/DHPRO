//
//  CustomFlowLayout.m
//  CollegePro
//
//  Created by jabraknight on 2020/5/3.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import "CustomFlowLayout.h"

@implementation CustomFlowLayout
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray * attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    //从第二个循环到最后一个
    for (NSInteger i = 1 ; i < attributes.count ; i ++ ){
        //当前的attribute
        UICollectionViewLayoutAttributes * currentLayoutAttributes = attributes[i];
        //上一个attribute
        UICollectionViewLayoutAttributes * prevLayoutAttributes = attributes[i - 1];
        //设置的最大间距，根绝需要修改
        CGFloat maximumSpacing = 6.0;
        //前一个cell的最右边
        CGFloat origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        //如果当前一个cell的最右边加上我们的想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
        //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有的cell的x值都被加到第一行最后一个元素的后面了
        if (origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width){
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return attributes;
}

@end
