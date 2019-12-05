//
//  ScanCardViewController.h
//  OCR_SavingCard
//
//  Created by linyingwei on 16/5/5.
//  Copyright © 2016年 linyingwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ResultBlock)(NSString* cardNumber, NSString *bank, UIImage *image);

@interface ScanCardViewController : UIViewController

- (void)achieveResult:(ResultBlock)block;

@end
