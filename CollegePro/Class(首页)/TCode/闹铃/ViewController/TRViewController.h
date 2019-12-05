//
//  TRViewController.h
//  Alarm clock
//
//  Created by shupengstar on 16/4/11.
//  Copyright © 2016年 YJH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


//@protocol ViewControllerDelegate <NSObject>
//
//-(void)ViewControllerSendTime:(NSInteger)time;
//
//@end


@interface TRViewController : BaseViewController
@property(nonatomic,strong) AVAudioPlayer * player;
@property(nonatomic,assign) NSUInteger num;
//@property(nonatomic,assign)id<ViewControllerDelegate>delegate;
@end
