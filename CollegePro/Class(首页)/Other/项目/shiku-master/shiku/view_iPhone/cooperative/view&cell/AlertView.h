//
//  AlertView.h
//  shiku
//
//  Created by Rilakkuma on 15/9/15.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UIView
+(instancetype)STWordAndPhraseView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *certainBtn;

@end
