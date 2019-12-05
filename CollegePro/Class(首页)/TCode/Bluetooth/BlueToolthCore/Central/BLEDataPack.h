//
//  BaseDataPack.h
//  TCPDemo
//
//  Created by bolin on 16-4-6.
//  Copyright (c) 2016年 Trista. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 数据发送处理
 */
@interface BLEDataPack : NSObject

/**
 *  需要发送的数据
 */
@property (nonatomic,strong) NSData *sendData;

/**
 *  当前发送的分段数据
 */
@property (nonatomic,strong) NSData *currentData;

/**
 *  发送是否完成
 */
@property (nonatomic,assign) BOOL isFinished;


- (id)initWithData:(NSData *)msgData;

/**
 *  取得分段发送数据
 *
 *  @return
 */
- (NSData *)beginSendData;

/**
 *  复原前一次数据
 */
- (void)restoreLastData;

@end
