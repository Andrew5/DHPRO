//
//  FeedbackViewController.h
//  shiku
//
//  Created by txj on 15/5/18.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserBackend.h"
/**
 *  意见反馈
 */
@class FeedbackViewController;
@protocol FeedbackViewControllerDelegate <NSObject>
@optional
- (void)didSubmitFeedback:(FeedbackViewController *)controller;
@end
@interface FeedbackViewController : TBaseUIViewController<UITextViewDelegate>
{
    UserBackend *backend;
}
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *textEditor;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property(strong,nonatomic) id<FeedbackViewControllerDelegate> delegate;

- (IBAction)submitBtn:(id)sender;

@end
