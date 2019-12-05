//
//  ZQVariableMenuControl.h
//  ZQVariableMenuDemo
//
//  Created by 肖兆强 on 2017/12/1.
//  Copyright © 2017年 ZQDemo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ChannelBlock)(NSArray *inUseTitles,NSArray *unUseTitles);


@interface ZQVariableMenuControl : NSObject

+(ZQVariableMenuControl*)shareControl;

-(void)showChannelViewWithInUseTitles:(NSArray*)inUseTitles unUseTitles:(NSArray*)unUseTitles fixedNum:(NSInteger)fixedNum finish:(ChannelBlock)block;



@end
