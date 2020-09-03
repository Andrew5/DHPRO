//
//  DataModel.h
//  Test
//
//  Created by Rillakkuma on 2017/8/11.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject
@property (nonatomic, copy)NSString *Id;
@property (nonatomic, copy)NSString *Content;
@property (nonatomic, copy)NSString *CreateTime;
@property (nonatomic, strong)NSArray *Photos;
@property (nonatomic, strong)NSArray *Comments;
@property (nonatomic, strong)NSDictionary *User;
@property (nonatomic, strong)NSDictionary *Favorters;
//- (void)teset;
@end
