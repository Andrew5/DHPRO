//
//  TAlertView.h
//  btc
//
//  Created by txj on 15/1/31.
//  Copyright (c) 2015年 txj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TAlertViewStyle) {
    TAlertViewStyleNeutral = 0,
    TAlertViewStyleInformation,
    TAlertViewStyleSuccess,
    TAlertViewStyleWarning,
    TAlertViewStyleError
};

typedef NS_ENUM(NSUInteger, TAlertViewButtonsAlign) {
    TAlertViewButtonsAlignVertical = 0,
    TAlertViewButtonsAlignHorizontal
};

@interface TAlertView : UIView

@property (nonatomic, strong) UIColor   *alertBackgroundColor       UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont    *titleFont                  UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor   *messageColor               UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont    *messageFont                UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor   *buttonsTextColor           UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont    *buttonsFont                UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor   *separatorsLinesColor       UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont    *tapToCloseFont             UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor   *tapToCloseColor            UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSString  *tapToCloseText             UI_APPEARANCE_SELECTOR;

@property (assign, nonatomic) BOOL tapToClose;
@property (assign, nonatomic) CGFloat timeToClose;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *message;
@property (assign, nonatomic) TAlertViewStyle style;
@property (assign, nonatomic) TAlertViewButtonsAlign buttonsAlign;
@property (strong, nonatomic) NSArray *buttonsTexts;

-(void)setTitleColor:(UIColor*)color forAlertViewStyle:(TAlertViewStyle)style   UI_APPEARANCE_SELECTOR;
-(void)setDefaultTitle:(NSString*)defaultTitle forAlertViewStyle:(TAlertViewStyle)style   UI_APPEARANCE_SELECTOR;

+(void)hideAll;

-(id)init;
-(id)initWithTitle:(NSString*)title andMessage:(NSString*)message;
-(id)initWithTitle:(NSString*)title message:(NSString*)message buttons:(NSArray*)buttons andCallBack:(void (^)(TAlertView *alertView, NSInteger buttonIndex))callBackBlock;
-(id)initWithTitle:(NSString*)title message:(NSString*)message buttons:(NSArray*)buttons customerview:(UIView *)customerview andCallBack:(void (^)(TAlertView *alertView, NSInteger buttonIndex))callBackBlock;

-(void)show;
-(void)showAsMessage;
-(void)hide;

@end
