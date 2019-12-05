//
//  STWordAndPhraseView.h
//  Summit
//
//  Created by apple on 15/1/4.
//  Copyright (c) 2015年 pang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STWordAndPhraseView : UIView
+(instancetype)STWordAndPhraseView;

@property (weak, nonatomic) IBOutlet UIView *bgVIew;
@property (nonatomic,weak)IBOutlet UITextField *text;
@property (nonatomic,weak)IBOutlet UIButton *beBtn;
@property (nonatomic,weak)IBOutlet UIImageView *imageVIew;
@end
