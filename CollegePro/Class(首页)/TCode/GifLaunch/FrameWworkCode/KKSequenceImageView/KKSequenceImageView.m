//
//  KKSequenceImage.m
//  KKShopping
//
//  Created by kevin on 2017/5/18.
//  Copyright © 2017年 kevin. All rights reserved.
//

#import "KKSequenceImageView.h"
#import <objc/runtime.h>
#include <sys/time.h>

typedef NSUInteger (^GetImageAnimationTimeBlock)(NSUInteger index,UIImage *_Nonnull image);
typedef BOOL (^CompletionBlock)(NSUInteger index);

@interface KKSequenceImageView()

@property (nonatomic, assign) BOOL isClean;
@property (nonatomic, strong) dispatch_queue_t _Nonnull queue;
@property (nonatomic, strong) UIImage *nextImage;
@property (nonatomic, assign) NSInteger currentCompletionCount;
@property (nonatomic, assign) BOOL animatingNow;

@end

@implementation KKSequenceImageView

- (void)begin
{
    self.animatingNow = YES;
    NSArray *paths = self.imagePathss;
    NSUInteger count = (int)paths.count;
    NSUInteger duration = self.durationMS;
    if (duration == 0 || count == 0) {
        return;
    }
    
    NSUInteger frameTime = duration / count;
    
    @autoreleasepool {        
        __weak typeof(self) weakSelf = self;
        [self makeKeyFrameWithContentsOfFiles:paths time:^NSUInteger(NSUInteger index, UIImage * _Nonnull image) {
            return frameTime;
        } complement:^BOOL(NSUInteger index) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if(!strongSelf){
                return NO;
            }
            
            if (index == count - 1) {
                strongSelf.currentCompletionCount += 1;
                
                if (strongSelf.repeatCount > strongSelf.currentCompletionCount) {
                    [strongSelf begin];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [strongSelf clean];
                    });
                }
            }
            
            return YES;
        }];
    };
    
}

- (void)clean
{
    self.image = nil;
    self.animatingNow = NO;
    self.isClean = YES;
    self.currentCompletionCount = 0;
    self.nextImage = nil;
    
    if ([self.delegate respondsToSelector:@selector(sequenceImageDidPlayCompeletion:)]) {
        [self.delegate sequenceImageDidPlayCompeletion:self];
    }
}

#pragma mark - access

- (dispatch_queue_t)queue {
    if (!_queue) {
        _queue = dispatch_queue_create("com.sequenceImage", NULL);
    }
    return _queue;
}

#pragma mark - other

- (void)makeKeyFrameWithContentsOfFiles:(NSArray<NSString *> *_Nonnull)imagePaths time:(GetImageAnimationTimeBlock)time complement:(CompletionBlock)complement {
    __weak typeof(self) weakSelf = self;
    self.nextImage = [UIImage imageWithContentsOfFile:imagePaths.firstObject];
    
    NSInteger count = imagePaths.count;
    dispatch_async(self.queue, ^{
        __block NSString *nextFile = nil;
        [imagePaths enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) self = weakSelf;
            if (idx+1 < count) {
                nextFile = imagePaths[idx + 1];
            } else {
                nextFile = nil;
            }
            [self makeKeyFrameWithDuration:time(idx, self.nextImage) nextContentFile:nextFile complement:^{
                BOOL continueNext = complement(idx);
                if (!continueNext){
                    *stop = YES;
                }
            }];
        }];
    });
}

- (void)makeKeyFrameWithDuration:(NSUInteger)duration nextContentFile:(NSString *)nextFileString complement:(void (^)(void))complement {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) self = weakSelf;
            self.image = self.nextImage;
            self.nextImage = [UIImage imageWithContentsOfFile:nextFileString];
        });
        NSUInteger second = duration / 1000;  //s
        NSUInteger mSencond = duration - (second * 1000);  //ms
        struct timeval timeout = {(int)second, (int)mSencond*1000};  //{s,us}
        select(0, NULL, NULL, NULL, &timeout);
        if (complement) {
            complement();
        }
    });
}

@end

