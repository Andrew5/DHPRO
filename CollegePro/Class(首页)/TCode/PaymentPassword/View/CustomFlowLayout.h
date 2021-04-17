//
//  CustomFlowLayout.h
//  CollegePro
//
//  Created by jabraknight on 2020/5/3.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomFlowLayout : UICollectionViewFlowLayout
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect;
@end

NS_ASSUME_NONNULL_END
