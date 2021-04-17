//  github: https://github.com/MakeZL/MLSelectPhoto
//  author: @email <120886865@qq.com>
//
//  ZLPhotoPickerCommon.h
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 14-11-19.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#ifndef MLSelectPhoto_h
#define MLSelectPhoto_h

// 图片最多显示9张，超过9张取消单击事件
static NSInteger const KPhotoShowMaxCount = 9;
// 是否开启拍照自动保存图片
static BOOL const isCameraAutoSavePhoto = YES;
// HUD提示框动画执行的秒数
static CGFloat KHUDShowDuration = 1.0;

// Navigation Color
#define DefaultNavbarTintColor UIColorFromRGB(0x2f3535)
#define DefaultNavTintColor UIColorFromRGB(0xd5d5d5)
#define DefaultNavTitleColor UIColorFromRGB(0xd5d5d5)

#define iOS7gt ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// NSNotification
static NSString *PICKER_TAKE_DONE = @"PICKER_TAKE_DONE";
static NSString *PICKER_REFRESH_DONE = @"PICKER_REFRESH_DONE";
static NSString *PICKER_PUSH_BROWSERPHOTO = @"PICKER_PUSH_BROWSERPHOTO";

// 图片路径
#define MLSelectPhotoSrcName(file) [@"MLSelectPhoto.bundle" stringByAppendingPathComponent:file]

#endif
