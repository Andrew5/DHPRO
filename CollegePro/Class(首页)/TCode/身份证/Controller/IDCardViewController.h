//
//  IDCardViewController.h
//  idcard
//
//  Created by hxg on 16-4-10.
//  Copyright (c) 2016年 林英伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Capture.h"

@interface IDCardViewController : UIViewController<CaptureDelegate>
{
    Capture *_capture;
    UIView         *_cameraView;
    unsigned char* _buffer;
    
    UILabel *codeLabel; //身份证号
    UILabel *nameLabel; //姓名
    UILabel *genderLabel; //性别
    UILabel *nationLabel; //民族
    UILabel *addressLabel; //地址
    UILabel *issueLabel; //签发机关
    UILabel *validLabel; //地址
}
@property (weak, nonatomic) id<CaptureDelegate> delegate;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic)BOOL             verify;
@end
