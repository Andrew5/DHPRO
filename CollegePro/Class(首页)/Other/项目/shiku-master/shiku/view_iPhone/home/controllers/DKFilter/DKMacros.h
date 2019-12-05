//
//  DKMacros.h
//  DKFilterView
//
//  Created by Drinking on 15-1-7.
//  Copyright (c) 2015年 drinking. All rights reserved.
//

#ifndef DKFilterView_DKMacros_h
#define DKFilterView_DKMacros_h

#define RGBCOLOR(_R_, _G_, _B_) [UIColor colorWithRed:(_R_)/255.0 green: (_G_)/255.0 blue: (_B_)/255.0 alpha: 1.0]
#define stringIsEmpty(str) !(str&&str.length)
#define DK_ADD @"+"


#define DK_DEFAULT_TITLE_COLOR RGBCOLOR(87,87,87)

#define DK_NORMAL_COLOR RGBCOLOR(189,189,189)
#define DK_HL_COLOR RGBCOLOR(0,148,198)

#define DK_NOTIFICATION_PICKITEM @"DKNotificationPickItem"
#define DK_NOTIFICATION_BUTTON_CLICKED @"DKFilterButtonClicked"

#endif
