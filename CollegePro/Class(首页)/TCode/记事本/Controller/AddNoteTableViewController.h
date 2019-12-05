//
//  AddNoteTableViewController.h
//  Test
//
//  Created by Rillakkuma on 2018/3/16.
//  Copyright © 2018年 Rillakkuma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AddNoteTableViewController : UITableViewController
@property (retain, nonatomic) NSMutableArray *messages;
@property (retain, nonatomic) AVAudioPlayer *audioPlayer;

@end
