//
//  ReadView.h
//  TestDemo
//
//  Created by jabraknight on 2020/11/8.
//  Copyright © 2020 黄定师. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReadView : UIView
@property (nonatomic,strong)RACSubject *btnClickSignal;

@end

NS_ASSUME_NONNULL_END
