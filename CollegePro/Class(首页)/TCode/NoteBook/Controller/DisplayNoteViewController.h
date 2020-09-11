//
//  DisplayNoteViewController.h
//  Test
//
//  Created by Rillakkuma on 2018/3/16.
//  Copyright © 2018年 Rillakkuma. All rights reserved.
//

#import "BaseViewController.h"
#import "Message.h"

@interface DisplayNoteViewController : BaseViewController
@property (assign, nonatomic) NSInteger messageIndex;
@property (retain, nonatomic) NSMutableArray *messages;
@property (retain, nonatomic) NSString *messageTitle;
@property (assign, nonatomic) BOOL isSearchResult;
@property (retain, nonatomic) Message *message;
@end
