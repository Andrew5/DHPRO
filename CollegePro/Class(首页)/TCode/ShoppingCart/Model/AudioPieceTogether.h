//
//  AudioPieceTogether.h
//  CollegePro
//
//  Created by admin on 2020/9/11.
//  Copyright © 2020 jabrknight. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioPieceTogether : NSObject
// 1.将文件A+文件B=文件A+

// 2.文件B删除
- (BOOL)pieceFileA:(NSString *)filePathA
         withFileB:(NSString *)filePathB;
@end

NS_ASSUME_NONNULL_END
