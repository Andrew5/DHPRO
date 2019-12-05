//
//  CommentsModel.h
//  Test
//
//  Created by Rillakkuma on 2017/8/11.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
@interface CommentsModel : NSObject
@property (nonatomic, copy)NSString *Id;
@property (nonatomic, strong)UserModel *User;
@property (nonatomic, strong)UserModel *ToReplyUser;
@property (nonatomic, copy)NSString *Content;
@end
