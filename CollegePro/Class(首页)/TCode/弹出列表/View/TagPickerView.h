//
//  TagPickerView.h
//  PackageDemo
//
//  Created by 思 彭 on 2017/4/12.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedTagBlock)(NSArray *tagsArray);

@interface TagPickerView : UIView

@property (nonatomic, copy) SelectedTagBlock selectedTagBlock;
@property (nonatomic, strong) NSArray *tagsArray;

+ (instancetype)shareInstance;
- (void)show;
- (void)dismiss;

@end
