//
//  HAMLogOutputWindow.m
//  HAMLogOutputWindowDemo
//
//  Created by DaiYue’s Macbook on 16/11/9.
//  Copyright © 2016年 Find the Lamp Studio. All rights reserved.
//

#import "HAMLogOutputWindow.h"


/**
 用来保存 log 的 Model 类
 */
@interface HAMLog : NSObject

/**
 log 产生的时间戳，单位为 秒
 */
@property (nonatomic, assign) double timestamp;

/**
 log 文本
 */
@property (nonatomic, strong) NSString* log;

@end

@implementation HAMLog

+ (instancetype)logWithText:(NSString*)logText {
    HAMLog* log = [HAMLog new];
    log.timestamp = [[NSDate date] timeIntervalSince1970];
    log.log = logText;
    return log;
}

@end


@interface HAMLogOutputWindow ()


@property (nonatomic, weak) UITextView* textView;

@property (atomic, strong) NSMutableArray* logs;

@end

static HAMLogOutputWindow __strong * sharedHAMLogOutputWindow = nil;

@implementation HAMLogOutputWindow

#pragma mark - SingleTon

+ (instancetype)sharedInstance {
    if (sharedHAMLogOutputWindow == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedHAMLogOutputWindow = [[HAMLogOutputWindow alloc] init];
        });
    }
    return sharedHAMLogOutputWindow;
}

+ (void)cleanUp {
    sharedHAMLogOutputWindow = nil;
}

#pragma mark - Init

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    if (self) {
        // self
        self.rootViewController = [UIViewController new]; // suppress warning
        self.windowLevel = UIWindowLevelAlert;
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
        self.userInteractionEnabled = NO;
        
        // text view
        UITextView* textView = [[UITextView alloc] initWithFrame:self.bounds];
        textView.font = [UIFont systemFontOfSize:12.0f];
        textView.backgroundColor = [UIColor clearColor];
        textView.scrollsToTop = NO;
        [self addSubview:textView];
        self.textView = textView;
        
        // string
        self.logs = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Print & Clear

+ (void)printLog:(NSString *)text {
    [[self sharedInstance] printLog:text];
}

- (void)printLog:(NSString*)newLog {
    if (newLog.length == 0) {
        return;
    }
    
    @synchronized (self) {
        newLog = [NSString stringWithFormat:@"%@\n", newLog]; // add new line
        HAMLog* log = [HAMLog logWithText:newLog];
        
        // data
        if (!log) {
            return;
        }
        [self.logs addObject:log];
        if (self.logs.count > 20) {
            [self.logs removeObjectAtIndex:0];
        }
        
        // view
        [self refreshLogDisplay];
    }
}

+ (void)clear {
    [[self sharedInstance] clear];
}

- (void)clear {
    self.textView.text = @"";
    self.logs = [NSMutableArray array];
}

#pragma mark - Display

- (void)refreshLogDisplay {
    // attributed text
    NSMutableAttributedString* attributedString = [NSMutableAttributedString new];
    
    double currentTimestamp = [[NSDate date] timeIntervalSince1970];
    for (HAMLog* log in self.logs) {
        if (log.log.length == 0) {
            return;
        }
        
        NSMutableAttributedString* logString = [[NSMutableAttributedString alloc] initWithString:log.log];
        UIColor* logColor = currentTimestamp - log.timestamp > 0.1 ? [UIColor whiteColor] : [UIColor yellowColor]; // yellow if new, white if more than 0.1 second ago
        [logString addAttribute:NSForegroundColorAttributeName value:logColor range:NSMakeRange(0, logString.length)];
        
        [attributedString appendAttributedString:logString];
    }
    
    self.textView.attributedText = attributedString;
    
    // scroll to bottom
    if(attributedString.length > 0) {
        NSRange bottom = NSMakeRange(attributedString.length - 1, 1);
        [self.textView scrollRangeToVisible:bottom];
    }
}

@end
