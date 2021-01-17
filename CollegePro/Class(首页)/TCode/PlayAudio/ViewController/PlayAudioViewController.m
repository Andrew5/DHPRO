//
//  PlayAudioViewController.m
//  CollegePro
//
//  Created by jabraknight on 2021/1/17.
//  Copyright © 2021 jabrknight. All rights reserved.
//

#import "PlayAudioViewController.h"
#import "AVFoundation/AVFoundation.h"
#import "AudioPlayer.h"
#import "AudioTrim.h"
#import "AudioParam.h"
@class AudioPlayer;
@interface PlayAudioViewController ()
@property (nonatomic,retain) AudioPlayer *audioPlayer;

@end
static NSString *audioUrl = @"http://infinitinb.net/COFFdD0xMzUwOTc1NzQ3Jmk9MTI1Ljc3LjIwMi4yNDYmdT1Tb25ncy92MS9mYWludFFDLzk0LzczOWIyNGFjZTZkM2FiMTllZmE0Yzc0MDE5MzI1Yzk0Lm1wMyZtPTlkMjAxY2Y5YzQ4OGQyOGQ1NjA5YzBiMTE4MjY0M2NiJnY9bGlzdGVuJm49v8nE3MTju7mwrs7SJnM90dfRx8LaJnA9cw==.mp3";

@implementation PlayAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)buttonClick:(UIButton *)button {
    int tag = 1001;
    NSURL *url = nil;
    AVPlayer *player = nil;
    NSString *audioPath = nil;
    AudioParam *audioParam = nil;
    switch (tag) {
        case 1001:{
            url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"kaibulekou" ofType:@"mp3"]];
            self.audioPlayer = [[AudioPlayer alloc] initwithcontentsOFURL:url error:nil];
            [self.audioPlayer play];
        }
            break;
        case 2001:{
            url = [NSURL URLWithString:audioUrl];
            self.audioPlayer = [[AudioPlayer alloc] initwithcontentsOFURL:url error:nil];
            [self.audioPlayer play];
            //            [self.audioPlayer seekToTime:20.0];
        }
            break;
        case 3001:{
            // 测试音频剪切
            player = [[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"kaibulekou" ofType:@"mp3"]]];
            CMTime startTime = CMTimeMake(30, 1);
            CMTime stopTime = CMTimeMake(60, 1);
            NSString *targetPath =@"/Users/jabraknight/Desktop/test1.mp4";
            //            NSString *targetPath=[NSString stringWithFormat:@"%@/Library/Caches/movie_%@.mp4",NSHomeDirectory(), @"2020年08月14日12:47:15"];
            //            NSString *targetPath=[NSString stringWithFormat:@"%@/Library/Caches/movie_%@.mp4",NSHomeDirectory(), @"2020年08月14日12:47:15"];
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"kaibulekou" ofType:@"mp3"];
            //            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"GC0101010101_R" ofType:@"wma"];
            AudioTrim *audioTrim = [[AudioTrim alloc] init];
            [audioTrim trimAudio:filePath toFilePath:targetPath startTime:startTime stopTime:stopTime];
        }
            break;
        case 4001:{
            audioPath = [[NSBundle mainBundle] pathForResource:@"kaibulekou" ofType:@"mp3"];
            audioParam = [[AudioParam alloc] initWithAudioPath:audioPath];
            NSLog(@"audio param : %@ %@ %@ %@ %@",[audioParam title],[audioParam year],[audioParam artist],[audioParam album],[audioParam duration]);
        }
            break;
        case 5001:{
            //            [self convertMovSourceURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"GC0101010101_R" ofType:@"wma"]]];
            //            [self xinhaoliang];
            
            //                [self convertMovSourceURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"kaibulekou" ofType:@"mp3"]]];
        }
            break;
        default:
            break;
    }
}

/**mov转mp4格式*/
-(void)convertMovSourceURL:(NSURL *)sourceUrl
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
    NSArray *compatiblePresets=[AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    //NSLog(@"%@",compatiblePresets);
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession=[[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
        NSDateFormatter *formater=[[NSDateFormatter alloc] init];//用时间给文件全名
        [formater setDateFormat:@"yyyyMMddHHmmss"];
//        NSString *mp4Path=@"/Users/jabraknight";//[[NSUserDefaults standardUserDefaults] objectForKey:@"kMP4FilePath"];
        NSString *resultPath=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingFormat:@"/output_%@.mp4", [formater stringFromDate:[NSDate date]]];
//        NSString *resultPath =@"/Users/jabraknight/Desktop/test2.mp4";

        
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
             switch (exportSession.status) {
                case AVAssetExportSessionStatusCancelled:
                     NSLog(@"AVAssetExportSessionStatusCancelled");
                     break;
                 case AVAssetExportSessionStatusUnknown:
                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     break;
                 case AVAssetExportSessionStatusWaiting:
                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     break;
                 case AVAssetExportSessionStatusExporting:
                     NSLog(@"AVAssetExportSessionStatusExporting");
                     break;
                 case AVAssetExportSessionStatusCompleted:
                 {
                     NSLog(@"resultPath = %@",resultPath);
//                     UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"转换完成" preferredStyle:UIAlertControllerStyleAlert];
//                     UIAlertAction *confirm=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//                     [alert addAction:confirm];
//                     [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
//                     BOOL success=[[NSFileManager defaultManager]moveItemAtPath:resultPath toPath:[mp4Path stringByAppendingPathComponent:@"1.mp4"] error:nil];
//                     if(success)
//                     {
//                         NSArray *files=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:mp4Path error:nil];
//                         NSLog(@"%@",files);
//                         NSLog(@"success");
//                     }
                     BOOL success = [[NSFileManager defaultManager] isWritableFileAtPath:resultPath];
                     NSLog(@"success = %d",success);



                     
                     break;
                 }
                 case AVAssetExportSessionStatusFailed:
                     NSLog(@"AVAssetExportSessionStatusFailed");
                     break;
             }
         }];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
