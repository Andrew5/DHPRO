//
//  CustomerTitleModel.h
//  XLCircleProgressDemo
//
//  Created by TY on 2018/7/20.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerTitleModel : NSObject
@property (nonatomic,copy)NSString *newsTitle;
@property (nonatomic,copy)NSString *newsDocSubject;
@property (nonatomic,assign)int type;

@property (nonatomic,assign)BOOL canModify;
@property (nonatomic,assign)BOOL isSelf;
@property (nonatomic,assign)float cellHeight;

@end
