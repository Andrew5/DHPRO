//
//  VerifyUtil.h
//  Znaer
//
//  Created by Jeremy on 14-6-10.
//  Copyright (c) 2014年 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>
//验证帮助类
@interface VerifyUtil : NSObject
+ (BOOL) validateMobile:(NSString *)mobile;
+ (BOOL) validateEmail:(NSString *)email;
+ (BOOL) validatePassword:(NSString *)passWord;
+ (BOOL) validateNickname:(NSString *)nickname;
@end
