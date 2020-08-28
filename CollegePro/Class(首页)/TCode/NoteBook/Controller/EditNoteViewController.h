//
//  EditNoteViewController.h
//  MusicJoy
//
//  Created by MaKai on 12-12-6.
//  Copyright (c) 2012年 MaKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
#import <AVFoundation/AVFoundation.h>
//#import "ContactCtrlDelegate.h"

@interface EditNoteViewController : UITableViewController<UITextFieldDelegate,UITextViewDelegate>
@property (assign, nonatomic) NSInteger messageIndex;
@property (retain, nonatomic) NSMutableArray *messages;
@property (retain, nonatomic) Message *message;
//@property (retain, nonatomic) id<ContactCtrlDelegate> delegate;

@property (retain, nonatomic) UIScrollView *scrollView;
@property (retain, nonatomic) UIPageControl *pageControl;
@property (retain, nonatomic) UILabel *panelTitle;
@property (retain, nonatomic) UIView *myPanelView;
@property (retain, nonatomic) UITextField *titleField;
@property (retain, nonatomic) UITextView *contentView;

@end
